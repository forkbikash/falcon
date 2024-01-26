package forwarder

import (
	"github.com/forkbikash/chat-backend/pkg/infra"
)

type InfraCloser struct{}

func NewInfraCloser() *InfraCloser {
	return &InfraCloser{}
}

func (closer *InfraCloser) Close() error {
	return infra.RedisClient.Close()
}
