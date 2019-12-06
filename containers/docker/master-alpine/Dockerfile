FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 --branch release/1.8 https://github.com/abschain-develop/go-abs && \
  (cd go-abs && make gabs) && \
  cp go-abs/build/bin/gabs /gabs && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-abs && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/gabs"]
