// Code generated by Wire. DO NOT EDIT.

//go:generate wire
//go:build !wireinject
// +build !wireinject

package wire

import (
	"github.com/minghsu0107/go-random-chat/pkg/chat"
	"github.com/minghsu0107/go-random-chat/pkg/config"
	"github.com/minghsu0107/go-random-chat/pkg/uploader"
	"github.com/minghsu0107/go-random-chat/pkg/web"
)

// Injectors from wire.go:

func InitializeWebRouter() (*web.Router, error) {
	configConfig, err := config.NewConfig()
	if err != nil {
		return nil, err
	}
	engine := web.NewGinServer()
	router := web.NewRouter(configConfig, engine)
	return router, nil
}

func InitializeChatRouter() (*chat.Router, error) {
	configConfig, err := config.NewConfig()
	if err != nil {
		return nil, err
	}
	engine := chat.NewGinServer(configConfig)
	melodyMatchConn := chat.NewMelodyMatchConn()
	melodyChatConn := chat.NewMelodyChatConn(configConfig)
	universalClient, err := chat.NewRedisClient(configConfig)
	if err != nil {
		return nil, err
	}
	redisCache := chat.NewRedisCache(universalClient)
	userRepo := chat.NewRedisUserRepo(redisCache)
	matchSubscriber := chat.NewMatchSubscriber(configConfig, universalClient, melodyMatchConn, userRepo)
	messageSubscriber := chat.NewMessageSubscriber(configConfig, universalClient, melodyChatConn)
	idGenerator, err := chat.NewSonyFlake()
	if err != nil {
		return nil, err
	}
	userService := chat.NewUserService(userRepo, idGenerator)
	messageRepo := chat.NewRedisMessageRepo(configConfig, redisCache)
	messageService := chat.NewMessageService(messageRepo, userRepo, idGenerator)
	matchingRepo := chat.NewRedisMatchingRepo(redisCache)
	channelRepo := chat.NewRedisChannelRepo(redisCache)
	matchingService := chat.NewMatchingService(matchingRepo, channelRepo, idGenerator)
	channelService := chat.NewChannelService(channelRepo, userRepo)
	router := chat.NewRouter(configConfig, engine, melodyMatchConn, melodyChatConn, matchSubscriber, messageSubscriber, userService, messageService, matchingService, channelService)
	return router, nil
}

func InitializeUploaderRouter() (*uploader.Router, error) {
	configConfig, err := config.NewConfig()
	if err != nil {
		return nil, err
	}
	engine := uploader.NewGinServer()
	router := uploader.NewRouter(configConfig, engine)
	return router, nil
}
