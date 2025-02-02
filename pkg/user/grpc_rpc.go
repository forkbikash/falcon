package user

import (
	"context"
	"errors"

	userpb "github.com/forkbikash/chat-backend/proto/user"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (srv *GrpcServer) GetUser(ctx context.Context, req *userpb.GetUserRequest) (*userpb.GetUserResponse, error) {
	user, err := srv.userSvc.GetUserByID(ctx, req.UserId)
	if err != nil {
		if errors.Is(err, ErrUserNotFound) {
			return &userpb.GetUserResponse{
				Exist: false,
			}, nil
		}
		srv.logger.Error(err)
		return nil, status.Error(codes.Unavailable, err.Error())
	}
	return &userpb.GetUserResponse{
		Exist: true,
		User: &userpb.User{
			Id:   user.ID,
			Name: user.Name,
		},
	}, nil
}

func (srv *GrpcServer) GetUserIdBySession(ctx context.Context, req *userpb.GetUserIdBySessionRequest) (*userpb.GetUserIdBySessionResponse, error) {
	userID, err := srv.userSvc.GetUserIDBySession(ctx, req.Sid)
	if err != nil {
		if errors.Is(err, ErrSessionNotFound) {
			return nil, status.Error(codes.NotFound, err.Error())
		}
		srv.logger.Error(err)
		return nil, status.Error(codes.Unavailable, err.Error())
	}
	return &userpb.GetUserIdBySessionResponse{
		UserId: userID,
	}, nil
}
