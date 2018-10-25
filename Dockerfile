FROM arm32v6/alpine

LABEL maintainer="https://github.com/hermsi1337"

ENV SSHD_CONFIG_DIR=/etc/ssh

RUN set -xe \
  && apk --no-cache --update add openssh \
  && umask 277 \
  && mkdir -p /root/.ssh \
  && chmod -R 700 /root/.ssh \
  && ln -s /root/.ssh /data

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

WORKDIR /root
VOLUME /data

EXPOSE 22/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
