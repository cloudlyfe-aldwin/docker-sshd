#!/bin/sh

# generate host keys if not present
ssh-keygen -A
echo "tunnel:$(date | md5sum)" | chpasswd

# check wether a random root-password is provided
if [ ! -z "${ROOT_PASSWORD}" ] && [ "${ROOT_PASSWORD}" != "root" ]; then
    echo "root:${ROOT_PASSWORD}" | chpasswd
    sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config
else
    echo "root:$(date | md5sum)" | chpasswd
    sed -i s/#PermitRootLogin.*/PermitRootLogin\ prohibit-password/ /etc/ssh/sshd_config
    sed -i s/#PasswordAuthentication.*/PasswordAuthentication\ no/ /etc/ssh/sshd_config
fi

# copy root authorized_keys
if [ -f /data/authorized_keys ]; then
    mkdir -p /root/.ssh
    cp -fR /data/authorized_keys /root/.ssh/authorized_keys
fi

# copy tunnel authorized_keys
if [ -f /data/tunnel_authorized_keys ]; then
    mkdir -p /home/tunnel/.ssh
    cp -fR /data/tunnel_authorized_keys /home/tunnel/.ssh/authorized_keys
    chown -R tunnel:tunnel /home/tunnel/.ssh
    chmod -R 700 /home/tunnel/.ssh
fi

for f in /data/ssh_host_*_key; do
    file=$(basename "$f")
    if [ -e "$f" ]; then
        cp -f "$f" "/etc/ssh/$file"
        ssh-keygen -y -f "$f" > "/etc/ssh/$file.pub"
    else
        cp -f "/etc/ssh/$file" /data
        break
    fi
done


# start syslogd
syslogd -Z -S

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D "$@"
