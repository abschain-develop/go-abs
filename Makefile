# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gabs android ios gabs-cross swarm evm all test clean
.PHONY: gabs-linux gabs-linux-386 gabs-linux-amd64 gabs-linux-mips64 gabs-linux-mips64le
.PHONY: gabs-linux-arm gabs-linux-arm-5 gabs-linux-arm-6 gabs-linux-arm-7 gabs-linux-arm64
.PHONY: gabs-darwin gabs-darwin-386 gabs-darwin-amd64
.PHONY: gabs-windows gabs-windows-386 gabs-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

gabs:
	build/env.sh go run build/ci.go install ./cmd/gabs
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gabs\" to launch gabs."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/gabs.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Gabs.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	./build/clean_go_build_cache.sh
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

swarm-devtools:
	env GOBIN= go install ./cmd/swarm/mimegen

# Cross Compilation Targets (xgo)

gabs-cross: gabs-linux gabs-darwin gabs-windows gabs-android gabs-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/gabs-*

gabs-linux: gabs-linux-386 gabs-linux-amd64 gabs-linux-arm gabs-linux-mips64 gabs-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-*

gabs-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/gabs
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep 386

gabs-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gabs
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep amd64

gabs-linux-arm: gabs-linux-arm-5 gabs-linux-arm-6 gabs-linux-arm-7 gabs-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep arm

gabs-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/gabs
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep arm-5

gabs-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/gabs
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep arm-6

gabs-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/gabs
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep arm-7

gabs-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/gabs
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep arm64

gabs-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/gabs
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep mips

gabs-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/gabs
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep mipsle

gabs-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/gabs
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep mips64

gabs-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/gabs
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/gabs-linux-* | grep mips64le

gabs-darwin: gabs-darwin-386 gabs-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/gabs-darwin-*

gabs-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/gabs
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-darwin-* | grep 386

gabs-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gabs
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-darwin-* | grep amd64

gabs-windows: gabs-windows-386 gabs-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/gabs-windows-*

gabs-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/gabs
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-windows-* | grep 386

gabs-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gabs
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gabs-windows-* | grep amd64
