package match

import (
	"context"
	"net/http"

	"github.com/forkbikash/chat-backend/pkg/common"
	"github.com/forkbikash/chat-backend/pkg/config"
	"github.com/gin-gonic/gin"
	metrics "github.com/slok/go-http-metrics/metrics/prometheus"
	prommiddleware "github.com/slok/go-http-metrics/middleware"
	ginmiddleware "github.com/slok/go-http-metrics/middleware/gin"
	"gopkg.in/olahol/melody.v1"
)

var (
	sessUidKey  = "sessuid"
	MelodyMatch MelodyMatchConn
)

type MelodyMatchConn struct {
	*melody.Melody
}

type HttpServer struct {
	name            string
	logger          common.HttpLogrus
	svr             *gin.Engine
	mm              MelodyMatchConn
	httpPort        string
	httpServer      *http.Server
	matchSubscriber *MatchSubscriber
	userSvc         UserService
	matchSvc        MatchingService
}

func NewMelodyMatchConn() MelodyMatchConn {
	MelodyMatch = MelodyMatchConn{
		melody.New(),
	}
	return MelodyMatch
}

func NewGinServer(name string, logger common.HttpLogrus, config *config.Config) *gin.Engine {
	svr := gin.New()
	svr.Use(gin.Recovery())
	svr.Use(common.CorsMiddleware())
	svr.Use(common.LoggingMiddleware(logger))
	svr.Use(common.MaxAllowed(config.Match.Http.Server.MaxConn))

	mdlw := prommiddleware.New(prommiddleware.Config{
		Recorder: metrics.NewRecorder(metrics.Config{
			Prefix: name,
		}),
	})
	svr.Use(ginmiddleware.Handler("", mdlw))
	return svr
}

func NewHttpServer(name string, logger common.HttpLogrus, config *config.Config, svr *gin.Engine, mm MelodyMatchConn, matchSubscriber *MatchSubscriber, userSvc UserService, matchSvc MatchingService) *HttpServer {
	return &HttpServer{
		name:            name,
		logger:          logger,
		svr:             svr,
		mm:              mm,
		httpPort:        config.Match.Http.Server.Port,
		matchSubscriber: matchSubscriber,
		userSvc:         userSvc,
		matchSvc:        matchSvc,
	}
}

func (r *HttpServer) CookieAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		sid, err := common.GetCookie(c, common.SessionIdCookieName)
		if err != nil {
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}
		userID, err := r.userSvc.GetUserIDBySession(c.Request.Context(), sid)
		if err != nil {
			c.AbortWithStatus(http.StatusUnauthorized)
			return
		}
		c.Request = c.Request.WithContext(context.WithValue(c.Request.Context(), common.UserKey, userID))
		c.Next()
	}
}

func (r *HttpServer) RegisterRoutes() {
	r.matchSubscriber.RegisterHandler()

	matchGroup := r.svr.Group("/api/match")
	{
		cookieAuthGroup := matchGroup.Group("")
		cookieAuthGroup.Use(r.CookieAuth())
		cookieAuthGroup.GET("", r.Match)
	}

	r.mm.HandleConnect(r.HandleMatchOnConnect)
	r.mm.HandleClose(r.HandleMatchOnClose)
}

func (r *HttpServer) Run() {
	go func() {
		addr := ":" + r.httpPort
		r.httpServer = &http.Server{
			Addr:    addr,
			Handler: common.NewOtelHttpHandler(r.svr, r.name+"_http"),
		}
		r.logger.Infoln("http server listening on ", addr)
		err := r.httpServer.ListenAndServe()
		if err != nil && err != http.ErrServerClosed {
			r.logger.Fatal(err)
		}
	}()
	go func() {
		err := r.matchSubscriber.Run()
		if err != nil {
			r.logger.Fatal(err)
		}
	}()
}

func (r *HttpServer) GracefulStop(ctx context.Context) error {
	err := MelodyMatch.Close()
	if err != nil {
		return err
	}
	err = r.httpServer.Shutdown(ctx)
	if err != nil {
		return err
	}
	err = r.matchSubscriber.GracefulStop()
	if err != nil {
		return err
	}
	return nil
}

func response(c *gin.Context, httpCode int, err error) {
	message := err.Error()
	c.JSON(httpCode, common.ErrResponse{
		Message: message,
	})
}
