ARG MATOMO_VERSION="4.13"
ARG WODBY_TAG="1.50.5"

FROM wodby/matomo:${MATOMO_VERSION}-${WODBY_TAG}

# Change user for privileged actions
USER 0

RUN apk add --no-cache gettext

ARG LICENSE_KEY
ARG PLUGIN_LIST=" \
AbTesting \
CustomReports \
CustomVariables \
FormAnalytics \
Funnels \
GoogleAnalyticsImporter \
HeatmapSessionRecording \
InvalidateReports \
JsTrackerCustom \
MarketingCampaignsReporting \
MultiChannelConversionAttribution \
SearchEngineKeywordsPerformance \
UsersFlow \
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

COPY init /docker-entrypoint-init.d/
