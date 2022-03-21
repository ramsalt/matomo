#!/bin/bash
set -euo pipefail

MATOMO_VERSION="${1:-}"

if [ -z "${MATOMO_VERSION}" ]; then
    echo -e "Usage:\n\t$0 matomo-version\n"
    exit 1
fi

NGINX_CONF="/etc/nginx/conf.d/default.conf"
PHP_CONF="/etc/php/8.1/fpm/pool.d/www.conf"
MATOMO_CONF="/srv/www/matomo/matomo/config/config.ini.php"

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

# download and install matomo
rm -f "matomo-${MATOMO_VERSION}.tar.gz.asc"
curl -Sso matomo-${MATOMO_VERSION}.tar.gz.asc "${MATOMO_URL}/matomo-${MATOMO_VERSION}.tar.gz.asc"

if ! diff -q "matomo-current.tar.gz.asc" "matomo-${MATOMO_VERSION}.tar.gz.asc" ; then
    gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys F529A27008477483777FC23D63BB30D0E5D2C749

    curl -Sso matomo.tar.gz "${MATOMO_URL}/matomo-${MATOMO_VERSION}.tar.gz"
    gpg --verify matomo-${MATOMO_VERSION}.tar.gz.asc matomo.tar.gz
    tar xzf matomo.tar.gz

    mv "matomo-${MATOMO_VERSION}.tar.gz.asc" "matomo-current.tar.gz.asc"
fi

# Update matomo configuration
if ! diff -q "matomo-config/config.ini.php" "${MATOMO_CONF}" >/dev/null ; then
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

[ "${RELOAD_PHP}" -eq "0" ] || sudo /bin/systemctl reload php8.1-fpm
[ "${RELOAD_NGINX}" -eq "0" ] || sudo /bin/systemctl reload nginx
