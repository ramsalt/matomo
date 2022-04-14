ARG MATOMO_VERSION="4.9.0"

FROM bitnami/matomo:${MATOMO_VERSION}

# Change user for privileged actions
USER 0

COPY rootfs /

# Revert to non-privileged user
USER 1001
