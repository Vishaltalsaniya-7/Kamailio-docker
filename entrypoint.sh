#!/bin/bash

set -e

echo "======================================"
echo "Kamailio Docker"
echo "Version : ${KAMAILIO_VERSION}"
echo "DB Host : ${DBHOST}"
echo "DB Name : ${DBNAME}"
echo "DB User : ${DBRWUSER}"
echo "======================================"

# --------------------------------------------------
# Generate database URL
# --------------------------------------------------

export DBURL="postgres://${DBRWUSER}:${DBRWPW}@${DBHOST}:${DBPORT}/${DBNAME}"

echo "Database URL configured."

# --------------------------------------------------
# Start Kamailio
# --------------------------------------------------

exec /usr/local/sbin/kamailio \
    -DD \
    -E \
    -f /usr/local/etc/kamailio/kamailio.cfg
