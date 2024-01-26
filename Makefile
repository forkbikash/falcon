# Go parameters
GOCMD=go
GOTEST=$(GOCMD) test
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOINSTALL=$(GOCMD) install

SVCS=chat match uploader user

VERSION=v0.0.0

.PHONY: proto

all: build test
test:
	$(GOTEST) -gcflags=-l -v -cover -coverpkg=./... -coverprofile=cover.out ./...
build: dep
	$(GOBUILD) -ldflags="-X github.com/forkbikash/chat-backend/cmd.Version=$(VERSION) -w -s" -o server ./chatbackend.go

dep: wire
	$(shell $(GOCMD) env GOPATH)/bin/wire ./internal/wire
proto:
	protoc proto/*/*.proto --go_out=plugins=grpc:.

wire:
	GO111MODULE=on $(GOINSTALL) github.com/google/wire/cmd/wire@v0.4.0

docker: docker-api docker-web docker-reverse-proxy
docker-api:
	@docker build -f ./deployments/build/Dockerfile.api --build-arg VERSION=$(VERSION) -t forkbikash/chat-api:kafka .
docker-web:
	@docker build -f ./deployments/build/Dockerfile.web --build-arg VERSION=$(VERSION) -t forkbikash/chat-web:kafka .
docker-reverse-proxy:
	@docker build -f ./deployments/build/Dockerfile.nginx -t forkbikash/chat-reverse-proxy:kafka .
clean:
	$(GOCLEAN)
	rm -f server
