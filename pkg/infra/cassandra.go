package infra

import (
	"time"

	"github.com/forkbikash/chat-backend/pkg/common"
	"github.com/forkbikash/chat-backend/pkg/config"
	"github.com/gocql/gocql"
)

var CassandraSession *gocql.Session

func NewCassandraSession(config *config.Config) (*gocql.Session, error) {
	cluster := gocql.NewCluster(common.GetServerAddrs(config.Cassandra.Hosts)...)
	// cluster.Port = config.Cassandra.Port
	cluster.Keyspace = config.Cassandra.Keyspace
	cluster.Consistency = gocql.Quorum
	cluster.RetryPolicy = &gocql.SimpleRetryPolicy{
		NumRetries: 3,
	}
	// todo:later
	// cluster.Authenticator = gocql.PasswordAuthenticator{
	// 	Username: config.Cassandra.User,
	// 	Password: config.Cassandra.Password,
	// }
	cluster.DefaultIdempotence = false
	// number of connections per host
	cluster.NumConns = 3
	CassandraSession, err := cluster.CreateSession()
	return CassandraSession, err
}

// taken from https://github.com/scylladb/scylla-code-samples/blob/master/mms/go/internal/scylla/cluster.go
// for reference
func createCluster(consistency gocql.Consistency, keyspace string, hosts ...string) *gocql.ClusterConfig {
	retryPolicy := &gocql.ExponentialBackoffRetryPolicy{
		Min:        time.Second,
		Max:        10 * time.Second,
		NumRetries: 5,
	}
	cluster := gocql.NewCluster(hosts...)
	cluster.Keyspace = keyspace
	cluster.Timeout = 5 * time.Second
	cluster.RetryPolicy = retryPolicy
	cluster.Consistency = consistency
	cluster.PoolConfig.HostSelectionPolicy = gocql.TokenAwareHostPolicy(gocql.RoundRobinHostPolicy())
	return cluster
}
