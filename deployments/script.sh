#!/bin/sh
export DOCKER_DEFAULT_PLATFORM=linux/amd64
# export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8

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
        if [ "$2" = "dev" ]; then
            docker-compose -f ./docker-compose.dev.yaml up
        elif [ "$2" = "prod" ]; then
            # docker-compose -f ./docker-compose.prod.yaml up --scale chat-backend=3;;
            docker-compose -f ./docker-compose.prod.yaml up
        else
            echo "Invalid option for 'start'. Use 'dev' or 'prod'."
            # exit 1
        fi
        ;;
    "stop")
        if [ "$2" = "dev" ]; then
            docker-compose -f ./docker-compose.dev.yaml stop
        elif [ "$2" = "prod" ]; then
            docker-compose -f ./docker-compose.prod.yaml stop
        else
            echo "Invalid option for 'stop'. Use 'dev' or 'prod'."
            # exit 1
        fi
        ;;
    "clean")
        if [ "$2" = "dev" ]; then
            docker-compose -f ./docker-compose.dev.yaml down -v
        elif [ "$2" = "prod" ]; then
            docker-compose -f ./docker-compose.prod.yaml down -v
        else
            echo "Invalid option for 'clean'. Use 'dev' or 'prod'."
            # exit 1
        fi
        ;;
    *)
        echo "command should be 'add-host', 'start', 'stop', or 'clean'"
        # exit 1;;
esac
