package web

import (
	"context"

	"github.com/forkbikash/chat-backend/pkg/common"
)

type Router struct {
	httpServer common.HttpServer
}

func NewRouter(httpServer common.HttpServer) *Router {
	return &Router{httpServer}
}

func (r *Router) Run() {
	r.httpServer.RegisterRoutes()
	r.httpServer.Run()
}

func (r *Router) GracefulStop(ctx context.Context) error {
	return r.httpServer.GracefulStop(ctx)
}
