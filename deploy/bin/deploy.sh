#!/bin/bash
set -euo pipefail

PHP_VERSION="8.1"
MAXMINDDB_VERSION="${PHP_VERSION}-1.6.0-v2"
MATOMO_VERSION="${1:-}"

if [ -z "${MATOMO_VERSION}" ]; then
    echo -e "Usage:\n\t$0 matomo-version\n"
    exit 1
fi

NGINX_CONF="/etc/nginx/conf.d/default.conf"
PHP_CONF="/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"
MATOMO_CON="/srv/www/matomo/matomo/config/config.ini.php"

PHP_EXT_DIR="$(php-config --extension-dir)"
PHP_BASE_DIR="$(dirname $(php-config --ini-path))"

RELOAD_NGINX=0
RELOAD_PHP=0

MATOMO_URL="https://builds.matomo.org"

# Update nginx confguration
if ! diff -q nginx/default.conf "${NGINX_CONF}" >/dev/null ; then
    cp nginx/default.conf "${NGINX_CONF}"
    RELOAD_NGINX=1
fi

# Update php configuration
if ! diff -q php/www.conf "${PHP_CONF}" >/dev/null ; then
    cp php/www.conf "${PHP_CONF}"
    RELOAD_PHP=1
fi

# Install geoip2
if [ ! -f ${PHP_EXT_DIR}/maxminddb.so -o ! -f $PHP_BASE_DIR/fpm/conf.d/*maxminddb.ini ] ; then
    curl -Sso "maxminddb-${MAXMINDDB_VERSION}.tar.gz" "https://github.com/ramsalt/geoip2-php/releases/download/v2/maxminddb-${MAXMINDDB_VERSION}.tar.gz"
    tar -C "${PHP_EXT_DIR}" -xzf "maxminddb-${MAXMINDDB_VERSION}.tar.gz"

    echo "extension=maxminddb.so" > $PHP_BASE_DIR/mods-available/maxminddb.ini
    ln -s $PHP_BASE_DIR/mods-available/maxminddb.ini $PHP_BASE_DIR/fpm/conf.d/50-maxminddb.ini

    RELOAD_PHP=1
fi

# download and install matomo
curl -Sso matomo.tar.gz "${MATOMO_URL}/matomo-${MATOMO_VERSION}.tar.gz"
tar xzf matomo.tar.gz

# Update matomo configuration
if ! diff -q matomo-config/config.ini.php "${MATOMO_CONF}" >/dev/null ; then
    # remove config created by web frontend so we can write our own
    find /srv/www/matomo/matomo/config/ -name config.ini.php -user www-data -delete

    cp matomo-config/config.ini.php "${MATOMO_CONF}"
    RELOAD_PHP=1
fi

chgrp www-data \
    matomo/tmp \
    matomo/config \
    matomo/misc \
    matomo/matomo.js \
    matomo/config/config.ini.php

chmod 775 \
    matomo/tmp \
    matomo/config \
    matomo/misc

chmod 664 \
    matomo/matomo.js \
    matomo/config/config.ini.php

[ "${RELOAD_PHP}" -eq "0" ] || sudo /bin/systemctl reload php${PHP_VERSION}-fpm
[ "${RELOAD_NGINX}" -eq "0" ] || sudo /bin/systemctl reload nginx
