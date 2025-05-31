#!/bin/bash
set -e

# Initialize NSS-DB if not already present
if [ ! -f /etc/corosync/qnetd/nssdb/cert9.db ]; then
  echo "Initializing NSS database..."
  mkdir -p /etc/corosync/qnetd/nssdb
  chmod 700 /etc/corosync/qnetd/nssdb
  certutil -N -d sql:/etc/corosync/qnetd/nssdb --empty-password || {
    echo "Error initializing NSS database."
    exit 1
  }
else
  echo "NSS database already exists, skipping initialization."
fi

# Initialize authorized_keys if not already present
if [ ! -f ~/.ssh/authorized_keys ]; then
  echo "Initializing authorized_keys..."
  if [ -f ~/authorized_keys.old ]; then
    cp ~/authorized_keys.old ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
  else
    echo "⚠️Warning⚠️: No authorized keys!"
  fi
else
  echo "authorized_keys already exists, skipping initialization."
fi

exec /usr/bin/supervisord -c /etc/supervisord.conf
