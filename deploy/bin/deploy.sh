#!/bin/bash
set -euo pipefail

PHP_VERSION="8.1"
MATOMO_VERSION="${1:-}"

if [ -z "${MATOMO_VERSION}" ]; then
    echo -e "Usage:\n\t$0 matomo-version\n"
    exit 1
fi

NGINX_CONF="/etc/nginx/conf.d/default.conf"
PHP_CONF="/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf"
MATOMO_DIR="/srv/www/matomo/matomo"
MATOMO_CONF="${MATOMO_DIR}/config/config.ini.php"

RELOAD_NGINX=0
RELOAD_PHP=0

MATOMO_URL="https://builds.matomo.org"

# Update nginx confguration
function configure_nginx() {
    if ! diff -q nginx/default.conf "${NGINX_CONF}" >/dev/null ; then
        cp nginx/default.conf "${NGINX_CONF}"
        sudo /usr/sbin/nginx -t
        RELOAD_NGINX=1
    fi
}

# Update php configuration
function configure_php() {
    if ! diff -q php/www.conf "${PHP_CONF}" >/dev/null ; then
        cp php/www.conf "${PHP_CONF}"
        sudo /usr/sbin/php-fpm${PHP_VERSION} -t
        RELOAD_PHP=1
    fi
}

# download and install matomo
function install_matomo() {
    rm -f "matomo-${MATOMO_VERSION}.tar.gz.asc"
    curl -Sso matomo-${MATOMO_VERSION}.tar.gz.asc "${MATOMO_URL}/matomo-${MATOMO_VERSION}.tar.gz.asc"

    if ! diff -q "matomo-current.tar.gz.asc" "matomo-${MATOMO_VERSION}.tar.gz.asc" ; then
        gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys F529A27008477483777FC23D63BB30D0E5D2C749

        curl -Sso matomo.tar.gz "${MATOMO_URL}/matomo-${MATOMO_VERSION}.tar.gz"
        gpg --verify matomo-${MATOMO_VERSION}.tar.gz.asc matomo.tar.gz
        tar xzf matomo.tar.gz

        sudo /usr/bin/php /srv/www/matomo/matomo/console core:update --yes

        mv "matomo-${MATOMO_VERSION}.tar.gz.asc" "matomo-current.tar.gz.asc"
    fi

    if [ ! -f ${MATOMO_DIR}/misc/DBIP-City.mmdb ]; then
        sudo /usr/bin/php ${MATOMO_DIR}/console scheduled-tasks:run "Piwik\\Plugins\\GeoIp2\\GeoIP2AutoUpdater.update"
    fi
}

# Update matomo configuration
function configure_matomo() {
    if ! diff -q "matomo-config/config.ini.php" "${MATOMO_CONF}" >/dev/null ; then
        # remove config created by web frontend so we can write our own
        find ${MATOMO_DIR}/config/ -name config.ini.php -user www-data -delete

        cp matomo-config/config.ini.php "${MATOMO_CONF}"
        RELOAD_PHP=1
    fi
}

# Update file permissions
function update_file_permissions() {
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
        matomo/matomo.js

    chmod 660 \
        matomo/config/config.ini.php
}

# Reload services
function reload_services() {
    [ "${RELOAD_PHP}" -eq "0" ] || sudo /bin/systemctl reload php${PHP_VERSION}-fpm
    [ "${RELOAD_NGINX}" -eq "0" ] || sudo /bin/systemctl reload nginx
}

# main
configure_nginx
configure_php

install_matomo
configure_matomo

update_file_permissions

reload_services
