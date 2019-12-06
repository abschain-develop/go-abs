.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/abschain-develop/go-abs/cmd/swarm
	go build -o bin/geth     github.com/abschain-develop/go-abs/cmd/geth
	go build -o bin/bootnode github.com/abschain-develop/go-abs/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/abschain-develop/go-abs/swarm/...
