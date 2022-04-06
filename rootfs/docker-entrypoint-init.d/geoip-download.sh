#!/bin/bash
set -uo pipefail

dbname="dbip-city-lite-$(date +%Y-%m).mmdb.gz"
tmpfile="/tmp/DBIP-City-Lite.mmdb"

curl --insecure -sSL https://download.db-ip.com/free/${dbname} | gunzip -c > "${tmpfile}"
rv="$?"
s=$(stat -c %s "${tmpfile}")

if [ "$?" == "0" -a "$s" -gt "90000000" ]; then
    mv "${tmpfile}" "/opt/bitnami/matomo/misc/DBIP-City-Lite.mmdb"
fi

exit 0
