FROM alpine:3.13

RUN apk update && \
    apk add \
    ca-certificates bash \
    tini shadow \
    nginx openssh-server openssh-sftp-server openssh-client \
    rsync

ADD [ "server-opt", "/opt" ]
RUN mkdir -p /data && \
    chmod +x /opt/*.sh && \
    cat /opt/default.conf > /etc/nginx/http.d/default.conf && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    cp /etc/ssh/sshd_config /opt/sshd_config.in && \
    ln -sf /data/ssh /etc/ssh && \
    useradd -d /data/html -G www-data -s /bin/bash -U updater && \
    passwd -d updater

EXPOSE 22
EXPOSE 80
VOLUME "/data"

