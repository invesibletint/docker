#!/bin/sh
# Entrypoint for the automatic/* SSH images deployed to Railway.
# Reads $ROOT_PASSWORD from the environment, sets it as the root password,
# then runs sshd in the foreground.
#
# NOTE: the password must not contain ':' (chpasswd field delimiter).
# The Telegram bot already rejects ':' at input time.
set -eu

if [ -z "${ROOT_PASSWORD:-}" ]; then
  echo "ERROR: ROOT_PASSWORD environment variable is not set." >&2
  echo "The deploy bot sets it automatically via Railway service variables." >&2
  exit 1
fi

# Most base images disable root password login by default — allow it.
if [ -f /etc/ssh/sshd_config ]; then
  sed -i 's/^[# ]*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
  sed -i 's/^[# ]*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
  grep -q '^PermitRootLogin' /etc/ssh/sshd_config || echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
  grep -q '^PasswordAuthentication' /etc/ssh/sshd_config || echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
fi

echo "root:${ROOT_PASSWORD}" | chpasswd

# Generate fresh host keys on first boot (never bake them into the image,
# otherwise every VPS would share the same host keys).
[ -f /etc/ssh/ssh_host_ed25519_key ] || ssh-keygen -A >/dev/null 2>&1
mkdir -p /run/sshd

echo "sshd starting (root password taken from ROOT_PASSWORD)"
exec /usr/sbin/sshd -D -e
