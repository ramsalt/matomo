ARG MATOMO_VERSION="5.0"
ARG WODBY_TAG="1.66.0"

FROM wodby/matomo:${MATOMO_VERSION}-${WODBY_TAG}

# Change user for privileged actions
USER 0

RUN apk add --no-cache gettext

ARG LICENSE_KEY
ARG PLUGIN_LIST=" \
AbTesting:5.0.6 \
CustomReports:5.0.11 \
CustomVariables:5.0.2 \
FormAnalytics:5.0.6 \
Funnels:5.0.4 \
GoogleAnalyticsImporter:5.0.9 \
HeatmapSessionRecording:5.0.10 \
InvalidateReports:5.0.0 \
JsTrackerCustom:5.0.0 \
LogViewer:5.0.1 \
MarketingCampaignsReporting:5.0.2 \
MultiChannelConversionAttribution:5.0.2 \
SearchEngineKeywordsPerformance:5.0.10 \
UsersFlow:5.0.2 \
"

WORKDIR /usr/src/matomo-plugins
RUN set -e && \
    for PLUGIN in $PLUGIN_LIST; do \
        IFS=':' read PLUGIN_NAME PLUGIN_VERSION < <(echo $PLUGIN) && \
        curl -f -sS --output $PLUGIN_NAME.zip --data "access_token=$LICENSE_KEY" "https://plugins.matomo.org/api/2.0/plugins/$PLUGIN_NAME/download/${PLUGIN_VERSION:-latest}?matomo=$MATOMO_VERSION" && \
        unzip $PLUGIN_NAME.zip && \
        rm $PLUGIN_NAME.zip || exit 1; \
    done

WORKDIR /var/www/html
COPY --chown=wodby:wodby config /usr/src/matomo-config

# Revert to non-privileged user
USER 1000

COPY bin /usr/local/bin/
COPY init /docker-entrypoint-init.d/
