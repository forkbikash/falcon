include ./configs/dev.env
# export $(shell sed 's/=.*//' ./configs/dev.env)
# Export specific variables from dev.env
export DOCKER_DEFAULT_PLATFORM := $(DOCKER_DEFAULT_PLATFORM)
export MINIO_ROOT_USER := $(MINIO_ROOT_USER)
export MINIO_ROOT_PASSWORD := $(MINIO_ROOT_PASSWORD)
# DOCKER_DEFAULT_PLATFORM=linux/amd64

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

docker-dev: docker-api-dev docker-web-dev docker-reverse-proxy-dev docker-scylla-manager-db-dev
docker-prod: docker-api-prod docker-web-prod docker-reverse-proxy-prod docker-scylla-manager-db-prod
docker-api-dev:
	@docker build -f ./deployments/build/Dockerfile.api --build-arg VERSION=$(VERSION) -t forkbikash/chat-api:kafka . --build-arg DOCKER_DEFAULT_PLATFORM=$(DOCKER_DEFAULT_PLATFORM)
docker-api-prod:
	@docker build -f ./deployments/build/Dockerfile.api --build-arg VERSION=$(VERSION) -t forkbikash/chat-api:kafka . --build-arg DOCKER_DEFAULT_PLATFORM=$(DOCKER_DEFAULT_PLATFORM)
docker-web-dev:
	@docker build -f ./deployments/build/Dockerfile.web --build-arg VERSION=$(VERSION) -t forkbikash/chat-web:kafka . --build-arg DOCKER_DEFAULT_PLATFORM=$(DOCKER_DEFAULT_PLATFORM)
docker-web-prod:
	@docker build -f ./deployments/build/Dockerfile.web --build-arg VERSION=$(VERSION) -t forkbikash/chat-web:kafka . --build-arg DOCKER_DEFAULT_PLATFORM=$(DOCKER_DEFAULT_PLATFORM)
docker-reverse-proxy-dev:
	@docker build -f ./deployments/build/Dockerfile.dev.nginx -t forkbikash/chat-reverse-proxy:kafka . --build-arg DOCKER_DEFAULT_PLATFORM=$(DOCKER_DEFAULT_PLATFORM)
docker-reverse-proxy-prod:
	@docker build -f ./deployments/build/Dockerfile.prod.nginx -t forkbikash/chat-reverse-proxy:kafka . --build-arg DOCKER_DEFAULT_PLATFORM=$(DOCKER_DEFAULT_PLATFORM)
docker-scylla-manager-db-dev:
	@docker build -f ./deployments/build/Dockerfile.dev.scyllamanager -t forkbikash/chat-scylla-manager-db:kafka . --build-arg DOCKER_DEFAULT_PLATFORM=$(DOCKER_DEFAULT_PLATFORM) --build-arg MINIO_ROOT_USER=$(MINIO_ROOT_USER) --build-arg MINIO_ROOT_PASSWORD=$(MINIO_ROOT_PASSWORD)
docker-scylla-manager-db-prod:
	@docker build -f ./deployments/build/Dockerfile.prod.scyllamanager -t forkbikash/chat-scylla-manager-db:kafka . --build-arg DOCKER_DEFAULT_PLATFORM=$(DOCKER_DEFAULT_PLATFORM) --build-arg MINIO_ROOT_USER=$(MINIO_ROOT_USER) --build-arg MINIO_ROOT_PASSWORD=$(MINIO_ROOT_PASSWORD)
clean:
	$(GOCLEAN)
	rm -f server
