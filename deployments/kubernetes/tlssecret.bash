#!/bin/bash
# set -e

case "$1" in
"createandapply")
    if [ "$2" = "dev" ]; then
        # kubectl create secret tls tls-secret \
        #     --cert=./localhost.pem \
        #     --key=./localhost.key \
        #     --dry-run=client -o yaml | kubectl apply -f -

        # Create the TLS secret and generate YAML representation
        kubectl create secret tls tls-secret \
            --cert=/etc/ssl/certs/localhost.pem \
            --key=/etc/ssl/private/localhost.key \
            --dry-run=client \
            -o yaml \
            --namespace=my-app >tls-secret.yaml

        # Apply the generated YAML to the cluster
        kubectl apply -f tls-secret.yaml --namespace=my-app

    elif [ "$2" = "prod" ]; then
        kubectl create secret tls tls-secret \
            --cert=/etc/ssl/certs/localhost.pem \
            --key=/etc/ssl/private/localhost.key \
            --dry-run=client \
            -o yaml \
            --namespace=my-app >tls-secret.yaml

        kubectl apply -f tls-secret.yaml --namespace=my-app

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
