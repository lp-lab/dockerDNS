#!/bin/bash
set -e

ROOT_PASSWORD=${ROOT_PASSWORD:-password}

set_root_passwd() {
  echo "root:$ROOT_PASSWORD" | chpasswd
}

update_timezone() {
  echo "$TIMEZONE" > /etc/timezone
}

# Set root password from the commandline
set_root_passwd

# Synchronize acf root password from system's one
/usr/bin/acfpasswd -s root

# Start mini_httpd to serve acf on https
/usr/sbin/mini_httpd -C /etc/mini_httpd/mini_httpd.conf

if [[ -n $TIMEZONE ]]; then
  update_timezone
fi

chown unbound /data

echo "Starting unbound..."
exec /usr/sbin/unbound
