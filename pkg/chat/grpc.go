package chat

import (
	"net"

	"google.golang.org/grpc"

	"github.com/forkbikash/chat-backend/pkg/common"
	"github.com/forkbikash/chat-backend/pkg/config"
	"github.com/forkbikash/chat-backend/pkg/transport"
	chatpb "github.com/forkbikash/chat-backend/proto/chat"
)

type GrpcServer struct {
	grpcPort string
	logger   common.GrpcLogrus
	s        *grpc.Server
	userSvc  UserService
	chanSvc  ChannelService
}

func NewGrpcServer(name string, logger common.GrpcLogrus, config *config.Config, userSvc UserService, chanSvc ChannelService) *GrpcServer {
	srv := &GrpcServer{
		grpcPort: config.Chat.Grpc.Server.Port,
		logger:   logger,
		userSvc:  userSvc,
		chanSvc:  chanSvc,
	}
	srv.s = transport.InitializeGrpcServer(name, srv.logger)
	return srv
}

func (srv *GrpcServer) Register() {
	chatpb.RegisterChannelServiceServer(srv.s, srv)
	chatpb.RegisterUserServiceServer(srv.s, srv)
}

func (srv *GrpcServer) Run() {
	go func() {
		addr := "0.0.0.0:" + srv.grpcPort
		srv.logger.Infoln("grpc server listening on  ", addr)
		lis, err := net.Listen("tcp", addr)
		if err != nil {
			srv.logger.Fatal(err)
		}
		if err := srv.s.Serve(lis); err != nil {
			srv.logger.Fatal(err)
		}
	}()
}

func (srv *GrpcServer) GracefulStop() error {
	srv.s.GracefulStop()
	return nil
}

var UserConn *UserClientConn

type UserClientConn struct {
	Conn *grpc.ClientConn
}

func NewUserClientConn(config *config.Config) (*UserClientConn, error) {
	conn, err := transport.InitializeGrpcClient(config.Chat.Grpc.Client.User.Endpoint)
	if err != nil {
		return nil, err
	}
	UserConn = &UserClientConn{
		Conn: conn,
	}
	return UserConn, nil
}

var ForwarderConn *ForwarderClientConn

type ForwarderClientConn struct {
	Conn *grpc.ClientConn
}

func NewForwarderClientConn(config *config.Config) (*ForwarderClientConn, error) {
	conn, err := transport.InitializeGrpcClient(config.Chat.Grpc.Client.Forwarder.Endpoint)
	if err != nil {
		return nil, err
	}
	ForwarderConn = &ForwarderClientConn{
		Conn: conn,
	}
	return ForwarderConn, nil
}
