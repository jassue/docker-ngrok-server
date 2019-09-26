#!/bin/sh

set -e

if [ "$NGROK_DOMAIN" == "**None**" ]; then
    echo "Please set the 'NGROK_DOMAIN' environment variables!"
    exit 1
fi

cd ngrok
export CERT=bin/cert

if [ ! -f "bin/ngrokd" ]; then
    echo "ngrokd has not been compiled yet,it will be compile now,please wait!"
    mkdir $CERT
    cd $CERT
    openssl genrsa -out base.key 2048
    openssl req -new -x509 -nodes -key base.key -days 10000 -subj "/CN=$NGROK_DOMAIN" -out base.pem
    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -subj "/CN=$NGROK_DOMAIN" -out server.csr
    openssl x509 -req -in server.csr -CA base.pem -CAkey base.key -CAcreateserial -days 10000 -out server.crt
    cp base.pem /go/ngrok/assets/client/tls/ngrokroot.crt
    cd /go/ngrok
    make release-server
    echo "ngrokd compiled successfully!"
fi

if [[ "$WINDOWS_32" == "1" && ! -f "bin/windows_386/ngrok.exe" ]]; then
    CGO_ENABLED=0 GOOS=windows GOARCH=386 make release-client
fi
if [[ "$WINDOWS_64" == "1" && ! -f "bin/windows_amd64/ngrok.exe" ]]; then
    CGO_ENABLED=0 GOOS=windows GOARCH=amd64 make release-client
fi
if [[ "$LINUX_32" == "1" && ! -f "bin/linux_386/ngrok" ]]; then
    CGO_ENABLED=0 GOOS=linux GOARCH=386 make release-client
fi
if [[ "$LINUX_64" == "1" && ! -f "bin/ngrok" ]]; then
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 make release-client
fi
if [[ "$LINUX_ARM" == "1" && ! -f "bin/linux_arm/ngrok" ]]; then
    CGO_ENABLED=0 GOOS=linux GOARCH=arm make release-client
fi
if [[ "$DARWIN_32" == "1" && ! -f "bin/darwin_386/ngrok" ]]; then
    CGO_ENABLED=0 GOOS=darwin GOARCH=386 make release-client
fi
if [[ "$DARWIN_64" == "1" && ! -f "bin/darwin_amd64/ngrok" ]]; then
    CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 make release-client
fi

./bin/ngrokd -tlsKey=$CERT/server.key -tlsCrt=$CERT/server.crt -domain="$NGROK_DOMAIN" -httpAddr="$HTTP_ADDR" -httpsAddr="$HTTPS_ADDR" -tunnelAddr="$TUNNEL_ADDR"
