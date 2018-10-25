#!/bin/sh

# generate host keys if not present
ssh-keygen -A

# check wether authorized_keys file exists
if [ ! -f /root/.ssh/authorized_keys  ]; then
    touch /root/.ssh/authorized_keys
fi

# check wether a random root-password is provided
if [ ! -z "${ROOT_PASSWORD}" ] && [ "${ROOT_PASSWORD}" != "root" ]; then
    echo "root:${ROOT_PASSWORD}" | chpasswd
fi

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"
