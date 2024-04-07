#!/bin/bash
# set -e

case "$1" in
"createandapply")
    if [ "$2" = "dev" ]; then
        # Read the .env file
        ENV_FILE="../../configs/dev.env"
        SECRET_DATA=""
        while IFS='=' read -r key value; do
            # Check if key and value are not empty
            if [[ ! -z "$key" && ! -z "$value" ]]; then
                # Convert value to Base64
                encoded_value=$(echo -n "$value" | base64)
                # Append the key-value pair to the secret data
                SECRET_DATA="$SECRET_DATA\n  $key: $encoded_value"
            fi
        done <"$ENV_FILE"

        # Create or update Kubernetes secret
        echo -e "apiVersion: v1
kind: ConfigMap
metadata:
  name: prod-config
  namespace: my-app
data:$SECRET_DATA" >prod-config.yaml

        kubectl apply -f prod-config.yaml --namespace=my-app

    elif [ "$2" = "prod" ]; then
        ENV_FILE="../../configs/prod.env"
        SECRET_DATA=""
        while IFS='=' read -r key value; do
            if [[ ! -z "$key" && ! -z "$value" ]]; then
                encoded_value=$(echo -n "$value" | base64)
                SECRET_DATA="$SECRET_DATA\n  $key: $encoded_value"
            fi
        done <"$ENV_FILE"

        echo -e "apiVersion: v1
kind: ConfigMap
metadata:
  name: prod-config
  namespace: my-app
data:$SECRET_DATA" >prod-config.yaml

        kubectl apply -f prod-config.yaml --namespace=my-app

    else
        echo "Invalid option"
        # exit 1
    fi
    ;;
*)
    echo "incorrect command"
    # exit 1;;
    ;;
esac
