// Code generated by Wire. DO NOT EDIT.

//go:generate wire
//go:build !wireinject
// +build !wireinject

package wire

import (
	"github.com/forkbikash/chat-backend/pkg/chat"
	"github.com/forkbikash/chat-backend/pkg/common"
	"github.com/forkbikash/chat-backend/pkg/config"
	"github.com/forkbikash/chat-backend/pkg/forwarder"
	"github.com/forkbikash/chat-backend/pkg/infra"
	"github.com/forkbikash/chat-backend/pkg/match"
	"github.com/forkbikash/chat-backend/pkg/uploader"
	"github.com/forkbikash/chat-backend/pkg/user"
	"github.com/forkbikash/chat-backend/pkg/web"
)

// Injectors from wire.go:

func InitializeWebServer(name string) (*common.Server, error) {
	configConfig, err := config.NewConfig()
	if err != nil {
		return nil, err
	}
	httpLogrus, err := common.NewHttpLogrus(configConfig)
	if err != nil {
		return nil, err
	}
	engine := web.NewGinServer(name, httpLogrus)
	httpServer := web.NewHttpServer(name, httpLogrus, configConfig, engine)
	router := web.NewRouter(httpServer)
	infraCloser := web.NewInfraCloser()
	observabilityInjector := common.NewObservabilityInjector(configConfig)
	server := common.NewServer(name, router, infraCloser, observabilityInjector)
	return server, nil
}

func InitializeChatServer(name string) (*common.Server, error) {
	configConfig, err := config.NewConfig()
	if err != nil {
		return nil, err
	}
	httpLogrus, err := common.NewHttpLogrus(configConfig)
	if err != nil {
		return nil, err
	}
	engine := chat.NewGinServer(name, httpLogrus, configConfig)
	melodyChatConn := chat.NewMelodyChatConn(configConfig)
	router, err := infra.NewBrokerRouter(name)
	if err != nil {
		return nil, err
	}
	subscriber, err := infra.NewKafkaSubscriber(configConfig)
	if err != nil {
		return nil, err
	}
	messageSubscriber, err := chat.NewMessageSubscriber(name, router, configConfig, subscriber, melodyChatConn)
	if err != nil {
		return nil, err
	}
	universalClient, err := infra.NewRedisClient(configConfig)
	if err != nil {
		return nil, err
	}
	redisCacheImpl := infra.NewRedisCacheImpl(universalClient)
	session, err := infra.NewCassandraSession(configConfig)
	if err != nil {
		return nil, err
	}
	userClientConn, err := chat.NewUserClientConn(configConfig)
	if err != nil {
		return nil, err
	}
	userRepoImpl := chat.NewUserRepoImpl(session, userClientConn)
	userRepoCacheImpl := chat.NewUserRepoCacheImpl(redisCacheImpl, userRepoImpl)
	userServiceImpl := chat.NewUserServiceImpl(userRepoCacheImpl)
	publisher, err := infra.NewKafkaPublisher(configConfig)
	if err != nil {
		return nil, err
	}
	messageRepoImpl := chat.NewMessageRepoImpl(configConfig, session, publisher)
	messageRepoCacheImpl := chat.NewMessageRepoCacheImpl(messageRepoImpl)
	idGenerator, err := common.NewSonyFlake()
	if err != nil {
		return nil, err
	}
	messageServiceImpl := chat.NewMessageServiceImpl(messageRepoCacheImpl, userRepoCacheImpl, idGenerator)
	channelRepoImpl := chat.NewChannelRepoImpl(session)
	channelRepoCacheImpl := chat.NewChannelRepoCacheImpl(redisCacheImpl, channelRepoImpl)
	channelServiceImpl := chat.NewChannelServiceImpl(channelRepoCacheImpl, userRepoCacheImpl, idGenerator)
	forwarderClientConn, err := chat.NewForwarderClientConn(configConfig)
	if err != nil {
		return nil, err
	}
	forwardRepoImpl := chat.NewForwardRepoImpl(forwarderClientConn)
	forwardServiceImpl := chat.NewForwardServiceImpl(forwardRepoImpl)
	httpServer := chat.NewHttpServer(name, httpLogrus, configConfig, engine, melodyChatConn, messageSubscriber, userServiceImpl, messageServiceImpl, channelServiceImpl, forwardServiceImpl)
	grpcLogrus, err := common.NewGrpcLogrus(configConfig)
	if err != nil {
		return nil, err
	}
	grpcServer := chat.NewGrpcServer(name, grpcLogrus, configConfig, userServiceImpl, channelServiceImpl)
	chatRouter := chat.NewRouter(httpServer, grpcServer)
	infraCloser := chat.NewInfraCloser()
	observabilityInjector := common.NewObservabilityInjector(configConfig)
	server := common.NewServer(name, chatRouter, infraCloser, observabilityInjector)
	return server, nil
}

func InitializeForwarderServer(name string) (*common.Server, error) {
	configConfig, err := config.NewConfig()
	if err != nil {
		return nil, err
	}
	grpcLogrus, err := common.NewGrpcLogrus(configConfig)
	if err != nil {
		return nil, err
	}
	universalClient, err := infra.NewRedisClient(configConfig)
	if err != nil {
		return nil, err
	}
	redisCacheImpl := infra.NewRedisCacheImpl(universalClient)
	publisher, err := infra.NewKafkaPublisher(configConfig)
	if err != nil {
		return nil, err
	}
	forwardRepoImpl := forwarder.NewForwardRepoImpl(redisCacheImpl, publisher)
	forwardServiceImpl := forwarder.NewForwardServiceImpl(forwardRepoImpl)
	router, err := infra.NewBrokerRouter(name)
	if err != nil {
		return nil, err
	}
	subscriber, err := infra.NewKafkaSubscriber(configConfig)
	if err != nil {
		return nil, err
	}
	messageSubscriber, err := forwarder.NewMessageSubscriber(name, router, subscriber, forwardServiceImpl)
	if err != nil {
		return nil, err
	}
	grpcServer := forwarder.NewGrpcServer(name, grpcLogrus, configConfig, forwardServiceImpl, messageSubscriber)
	forwarderRouter := forwarder.NewRouter(grpcServer)
	infraCloser := forwarder.NewInfraCloser()
	observabilityInjector := common.NewObservabilityInjector(configConfig)
	server := common.NewServer(name, forwarderRouter, infraCloser, observabilityInjector)
	return server, nil
}

func InitializeMatchServer(name string) (*common.Server, error) {
	configConfig, err := config.NewConfig()
	if err != nil {
		return nil, err
	}
	httpLogrus, err := common.NewHttpLogrus(configConfig)
	if err != nil {
		return nil, err
	}
	engine := match.NewGinServer(name, httpLogrus, configConfig)
	melodyMatchConn := match.NewMelodyMatchConn()
	router, err := infra.NewBrokerRouter(name)
	if err != nil {
		return nil, err
	}
	userClientConn, err := match.NewUserClientConn(configConfig)
	if err != nil {
		return nil, err
	}
	chatClientConn, err := match.NewChatClientConn(configConfig)
	if err != nil {
		return nil, err
	}
	userRepoImpl := match.NewUserRepoImpl(userClientConn, chatClientConn)
	userServiceImpl := match.NewUserServiceImpl(userRepoImpl)
	subscriber, err := infra.NewKafkaSubscriber(configConfig)
	if err != nil {
		return nil, err
	}
	matchSubscriber, err := match.NewMatchSubscriber(name, router, melodyMatchConn, userServiceImpl, subscriber)
	if err != nil {
		return nil, err
	}
	universalClient, err := infra.NewRedisClient(configConfig)
	if err != nil {
		return nil, err
	}
	redisCacheImpl := infra.NewRedisCacheImpl(universalClient)
	publisher, err := infra.NewKafkaPublisher(configConfig)
	if err != nil {
		return nil, err
	}
	matchingRepoImpl := match.NewMatchingRepoImpl(redisCacheImpl, publisher)
	channelRepoImpl := match.NewChannelRepoImpl(chatClientConn)
	matchingServiceImpl := match.NewMatchingServiceImpl(matchingRepoImpl, channelRepoImpl)
	httpServer := match.NewHttpServer(name, httpLogrus, configConfig, engine, melodyMatchConn, matchSubscriber, userServiceImpl, matchingServiceImpl)
	matchRouter := match.NewRouter(httpServer)
	infraCloser := match.NewInfraCloser()
	observabilityInjector := common.NewObservabilityInjector(configConfig)
	server := common.NewServer(name, matchRouter, infraCloser, observabilityInjector)
	return server, nil
}

func InitializeUploaderServer(name string) (*common.Server, error) {
	configConfig, err := config.NewConfig()
	if err != nil {
		return nil, err
	}
	httpLogrus, err := common.NewHttpLogrus(configConfig)
	if err != nil {
		return nil, err
	}
	engine := uploader.NewGinServer(name, httpLogrus, configConfig)
	universalClient, err := infra.NewRedisClient(configConfig)
	if err != nil {
		return nil, err
	}
	channelUploadRateLimiter := uploader.NewChannelUploadRateLimiter(universalClient, configConfig)
	httpServer := uploader.NewHttpServer(name, httpLogrus, configConfig, engine, channelUploadRateLimiter)
	router := uploader.NewRouter(httpServer)
	infraCloser := uploader.NewInfraCloser()
	observabilityInjector := common.NewObservabilityInjector(configConfig)
	server := common.NewServer(name, router, infraCloser, observabilityInjector)
	return server, nil
}

func InitializeUserServer(name string) (*common.Server, error) {
	configConfig, err := config.NewConfig()
	if err != nil {
		return nil, err
	}
	httpLogrus, err := common.NewHttpLogrus(configConfig)
	if err != nil {
		return nil, err
	}
	engine := user.NewGinServer(name, httpLogrus, configConfig)
	universalClient, err := infra.NewRedisClient(configConfig)
	if err != nil {
		return nil, err
	}
	redisCacheImpl := infra.NewRedisCacheImpl(universalClient)
	userRepoImpl := user.NewUserRepoImpl(redisCacheImpl)
	idGenerator, err := common.NewSonyFlake()
	if err != nil {
		return nil, err
	}
	userServiceImpl := user.NewUserServiceImpl(userRepoImpl, idGenerator)
	httpServer := user.NewHttpServer(name, httpLogrus, configConfig, engine, userServiceImpl)
	grpcLogrus, err := common.NewGrpcLogrus(configConfig)
	if err != nil {
		return nil, err
	}
	grpcServer := user.NewGrpcServer(name, grpcLogrus, configConfig, userServiceImpl)
	router := user.NewRouter(httpServer, grpcServer)
	infraCloser := user.NewInfraCloser()
	observabilityInjector := common.NewObservabilityInjector(configConfig)
	server := common.NewServer(name, router, infraCloser, observabilityInjector)
	return server, nil
}
