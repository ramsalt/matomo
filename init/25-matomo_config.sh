#!/usr/bin/env bash

set -e

export MATOMO_DATABASE_HOST="${MATOMO_DATABASE_HOST:-mariadb}"
export MATOMO_DATABASE_NAME="${MATOMO_DATABASE_NAME:-matomo}"
export MATOMO_DATABASE_PASSWORD="${MATOMO_DATABASE_PASSWORD:-}"
export MATOMO_DATABASE_NAME="${MATOMO_DATABASE_NAME:-matomo}"

export MATOMO_ENABLE_DATABASE_SSL="${MATOMO_ENABLE_DATABASE_SSL:-0}"
export MATOMO_DATABASE_SSL_CA_FILE="${MATOMO_DATABASE_SSL_CA_FILE:-}"
export MATOMO_DATABASE_SSL_CERT_FILE="${MATOMO_DATABASE_SSL_CERT_FILE:-}"
export MATOMO_DATABASE_SSL_KEY_FILE="${MATOMO_DATABASE_SSL_KEY_FILE:-}"

export MATOMO_ENABLE_FORCE_SSL="${MATOMO_ENABLE_FORCE_SSL:-0}"
export MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL="${MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL:-0}"
export MATOMO_MULTI_SERVER_ENVIRONMENT="${MATOMO_MULTI_SERVER_ENVIRONMENT:-0}"
export MATOMO_ENABLE_TRUSTED_HOST_CHECK="${MATOMO_ENABLE_TRUSTED_HOST_CHECK:-1}"
export MATOMO_PROXY_CLIENT_HEADER="${MATOMO_PROXY_CLIENT_HEADER:-}"
export MATOMO_PROXY_HOST_HEADER="${MATOMO_PROXY_HOST_HEADER:-}"

activate_plugin() {
    local PLUGINS="$@"

    echo Activating plugins $PLUGINS
    ./console plugin:activate $PLUGINS || {
        echo
        echo "********************************************************"
        echo "Couldn't activate plugins. See errors above for details."
        echo
        echo "Matomo will now start regardless, but might not work as expected."
        echo "Restart the container after fixing the problem."
        echo "********************************************************"
        echo
    }
}

# Create matomo config
envsubst < "/usr/src/matomo-config/config.tpl.php" > "${APP_ROOT}/config/config.ini.php"

chown wodby:www-data "${APP_ROOT}/config/config.ini.php"
chmod 664 "${APP_ROOT}/config/config.ini.php"

# Fix permissions for tag manager
chown wodby:www-data "${APP_ROOT}/js"
chmod 775 "${APP_ROOT}/js"

# Install plugins
cp -r /usr/src/matomo-plugins/* "${APP_ROOT}/plugins"
chmod -R g+w "${APP_ROOT}/plugins"
chgrp -R www-data "${APP_ROOT}/plugins"

# Activate plugins
PLUGINS="TagManager $(find /usr/src/matomo-plugins/* -maxdepth 0 -type d -printf "%f ")"
activate_plugin $PLUGINS
