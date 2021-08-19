FROM alpine:3.13

RUN apk update && \
    apk add \
    ca-certificates bash \
    openssh-client rsync jq yq

ADD [ "syncer-opt", "/opt/" ]
RUN chmod +x /opt/*.sh

CMD [ "/opt/run.sh" ]

