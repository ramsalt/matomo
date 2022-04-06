FROM bitnami/matomo

# Change user for privileged actions
USER 0

COPY rootfs /

# Revert to non-privileged user
USER 1001
