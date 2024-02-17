#!/bin/bash
# sudo apt-get update
# sudo apt-get install \
#     ca-certificates \
#     curl \
#     gnupg --yes
# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
# sudo chmod a+r /etc/apt/keyrings/docker.gpg
# echo \
#   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#   "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --yes
# sudo docker version

# sudo apt-get update
# sudo apt-get install docker-compose-plugin
# docker compose version

# echo 'export PATH=$PATH:$HOME/go/bin:/usr/local/go/bin:$HOME/.goose/bin' >> ~/.bashrc
# echo 'export GOPATH=$HOME/go' >> ~/.bashrc
# echo 'export GOOSE_DRIVER=postgres' >> ~/.bashrc
# source ~/.bashrc

# curl -fsSL \
#     https://raw.githubusercontent.com/pressly/goose/master/install.sh |\
#     sudo sh

