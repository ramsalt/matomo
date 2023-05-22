ARG MATOMO_VERSION="4.14"
ARG WODBY_TAG="1.53.1"

FROM wodby/matomo:${MATOMO_VERSION}-${WODBY_TAG}

# Change user for privileged actions
USER 0

RUN apk add --no-cache gettext

ARG LICENSE_KEY
ARG PLUGIN_LIST=" \
AbTesting \
CustomReports:4.1.4 \
CustomVariables:4.1.3 \
FormAnalytics:4.4.1 \
Funnels:4.1.6 \
GoogleAnalyticsImporter:4.6.1 \
HeatmapSessionRecording \
InvalidateReports:4.1.1 \
JsTrackerCustom:4.0.2 \
LogViewer:4.1.1 \
MarketingCampaignsReporting:4.1.3 \
MultiChannelConversionAttribution:4.3.1 \
SearchEngineKeywordsPerformance:4.5.3 \
UsersFlow:4.1.1 \
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
