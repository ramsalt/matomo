ARG MATOMO_VERSION="4.8.0"

FROM bitnami/matomo:${MATOMO_VERSION}

ARG MAXMINDDB_VERSION="8.1-1.6.0-v3"

# Change user for privileged actions
USER 0

# Install maxmind geopip2
RUN curl -sSLo /tmp/maxminddb.tar.gz https://github.com/ramsalt/geoip2-php/releases/latest/download/maxminddb-${MAXMINDDB_VERSION}.tar.gz && \
    cd /tmp && tar xzf /tmp/maxminddb.tar.gz && \
    mv maxminddb.so /opt/bitnami/php/lib/php/extensions/maxminddb2.so && \
    echo "extension=maxminddb2.so" >> /opt/bitnami/php/etc/php.ini && \
    rm /tmp/maxminddb.tar.gz

# Install customized scripts
COPY rootfs /

# Revert to non-privileged user
USER 1001
