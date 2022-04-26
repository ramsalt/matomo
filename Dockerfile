ARG MATOMO_VERSION="4.8"
ARG WODBY_TAG="1.42.1"

FROM wodby/matomo:${MATOMO_VERSION}

# Change user for privileged actions
USER 0

RUN apk add --no-cache gettext

COPY --chown=wodby:wodby config /var/www/html/config

# Revert to non-privileged user
USER 1000

COPY init /docker-entrypoint-init.d/
