ARG MATOMO_VERSION="4.9"
ARG WODBY_TAG="1.42.2"

FROM wodby/matomo:${MATOMO_VERSION}-${WODBY_TAG}

# Change user for privileged actions
USER 0

RUN apk add --no-cache gettext

COPY --chown=wodby:wodby config /usr/src/matomo-config

# Revert to non-privileged user
USER 1000

COPY init /docker-entrypoint-init.d/
