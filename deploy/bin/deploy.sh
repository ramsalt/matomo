#!/bin/bash
set -euo pipefail

MATOMO_VERSION="${1:-}"

if [ -z "${MATOMO_VERSION}" ]; then
    echo -e "Usage:\n\t$0 matomo-version\n"
    exit 1
fi

NGINX_CONF="/etc/nginx/conf.d/default.conf"
PHP_CONF="/etc/php/8.1/fpm/pool.d/www.conf"
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
curl -Sso matomo.tar.gz "${MATOMO_URL}/matomo-${MATOMO_VERSION}.tar.gz"
tar xvzf matomo.tar.gz

[ "${RELOAD_PHP}" -ne "0" ] && sudo /bin/systemctl reload php8.1-fpm
[ "${RELOAD_NGINX}" -ne "0" ] && sudo /bin/systemctl reload nginx
