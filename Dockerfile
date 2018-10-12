FROM alpine:3.8
LABEL Maintainer="Scott Bardua <sbardua@gmail.com>" \
      Description="Lightweight CFSSL image based on Alpine Linux."

RUN set -xe && \
    apk update && \
    apk add --no-cache --purge -uU ca-certificates go git gcc libc-dev libltdl libtool libgcc && \
    export GOPATH=/go && \
    go get -u github.com/cloudflare/cfssl/cmd/... && \
    apk del go git gcc libc-dev libtool libgcc && \
    mv /go/bin/* /bin/ && \
    rm -rf /go/src/golang.org && \
    rm -rf /go/src/github.com/GeertJohan && \
    rm -rf /go/src/github.com/daaku && \
    rm -rf /go/src/github.com/dgryski && \
    rm -rf /go/src/github.com/kardianos && \
    rm -rf /go/src/github.com/miekg

VOLUME [ "/etc/cfssl" ]

WORKDIR /etc/cfssl

EXPOSE 8888

ENTRYPOINT ["/bin/cfssl"]
