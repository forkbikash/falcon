package forwarder

import (
	"context"

	"github.com/forkbikash/chat-backend/pkg/common"
)

type Router struct {
	grpcServer common.GrpcServer
}

func NewRouter(grpcServer common.GrpcServer) *Router {
	return &Router{grpcServer}
}

func (r *Router) Run() {
	r.grpcServer.Register()
	r.grpcServer.Run()
}

func (r *Router) GracefulStop(ctx context.Context) error {
	return r.grpcServer.GracefulStop()
}
