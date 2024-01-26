#!/bin/sh
# common envs
# for linux
export DOCKER_DEFAULT_PLATFORM=linux/amd64

# export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8

export REDIS_PASSWORD=pass.123
export JWT_SECRET=mysecret
export USER_OAUTH_GOOGLE_CLIENTID=xxx.apps.googleusercontent.com
export USER_OAUTH_GOOGLE_CLIENTSECRET=xxx


addHost() {
    if grep -q "minio" /etc/hosts; then
        echo "Minio exists in /etc/hosts"
    else
        sudo -- sh -c -e "echo '127.0.0.1   minio' >> /etc/hosts"
    fi
}

case "$1" in
    "add-host")
        addHost;;
    "start")
        # docker-compose up --scale chat-backend=3;;
        docker-compose up;;
    "stop")
        docker-compose stop;;
    "clean")
        docker-compose down -v;;
    *)
        echo "command should be 'add-host', 'start', 'stop', or 'clean'"
        exit 1;;
esac