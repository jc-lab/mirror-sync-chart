#!/bin/bash

mkdir -p /run/nginx /data/ssh /data/html/.ssh

[ -e /etc/ssh/sshd_config ] || cp /opt/sshd_config.in /etc/ssh/sshd_config

KEYS=$(find /etc/ssh -name 'ssh_host_*_key')
[ -z "$KEYS" ] && ssh-keygen -A >/dev/null 2>/dev/null

cat /ssh-secret/public > /data/html/.ssh/authorized_keys
echo "" >> /data/html/.ssh/authorized_keys
chown updater:updater -R /data/html/
chmod 700 /data/html/.ssh
chmod 400 /data/html/.ssh/authorized_keys

exec /usr/sbin/sshd -D -e

