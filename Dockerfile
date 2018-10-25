FROM arm32v6/alpine

LABEL maintainer="https://github.com/hermsi1337"

ENV ROOT_PASSWORD root

RUN apk --no-cache --update add openssh \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:${ROOT_PASSWORD}" | chpasswd

COPY entrypoint.sh /usr/local/bin/

EXPOSE 22

ENTRYPOINT ["entrypoint.sh"]
