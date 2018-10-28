FROM arm32v6/alpine

LABEL maintainer="https://github.com/hermsi1337"

RUN set -xe && \
    apk --no-cache --update add openssh && \
    umask 277 && \
    mkdir -p /root/.ssh && \
    chmod -R 700 /root/.ssh && \
    adduser -D -h /home/tunnel -s /sbin/nologin -g tunnel tunnel

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

WORKDIR /root
VOLUME /data

EXPOSE 22/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
