FROM golang:1.7-alpine
MAINTAINER jassue

ENV NGROK_DOMAIN=**None** \
    TUNNEL_ADDR=:8443 \
    HTTP_ADDR=:80 \
    HTTPS_ADDR=:443 \
    WINDOWS_32=0 \
    WINDOWS_64=1 \
    LINUX_32=0 \
    LINUX_64=1 \
    LINUX_ARM=0 \
    DARWIN_32=0 \
    DARWIN_64=1

ADD run.sh ./

RUN apk add --no-cache git make openssl \
    && git clone https://github.com/inconshreveable/ngrok.git \
    && chmod a+x run.sh

EXPOSE 80
EXPOSE 443
EXPOSE 8443

VOLUME ["/go/ngrok/bin"]

CMD ["/bin/sh", "run.sh"]
