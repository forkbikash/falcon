package common

import (
	"errors"
	"strings"

	"github.com/sony/sonyflake"
)

// IDGenerator is the inteface for generatring unique ID
type IDGenerator interface {
	NextID() (uint64, error)
}

func NewSonyFlake() (IDGenerator, error) {
	var st sonyflake.Settings
	// todo:later : internet is required for sony flake
	sf := sonyflake.NewSonyflake(st)
	if sf == nil {
		return nil, errors.New("sonyflake not created")
	}
	return sf, nil
}

func GetServerAddrs(addrs string) []string {
	return strings.Split(addrs, ",")
}

func Join(strs ...string) string {
	var sb strings.Builder
	for _, str := range strs {
		sb.WriteString(str)
	}
	return sb.String()
}
