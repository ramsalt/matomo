ARG MATOMO_VERSION="5.3"
ARG WODBY_TAG="1.78.8"

FROM wodby/matomo:${MATOMO_VERSION}-${WODBY_TAG}

# Change user for privileged actions
USER 0

RUN apk add --no-cache gettext

ARG LICENSE_KEY
ARG PLUGIN_LIST=" \
AdvertisingConversionExport:5.2.3 \
BotTracker:5.2.18 \
ChatGPT:5.3.0 \
CustomReports:5.4.1 \
CustomVariables:5.0.4 \
FormAnalytics:5.1.1 \
HeatmapSessionRecording:5.2.3 \
InvalidateReports:5.0.2 \
JsTrackerCustom:5.0.2 \
LogViewer:5.0.3 \
MarketingCampaignsReporting:5.1.1 \
SearchEngineKeywordsPerformance:5.0.21 \
TrackingSpamPrevention:5.0.7 \
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
