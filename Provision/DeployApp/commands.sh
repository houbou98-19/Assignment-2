#!/bin/bash

public_ip=$1
app_name=$2
gh_user=$3

./Config/send_command_bastion.sh $public_ip "curl -o actions-runner-linux-x64-2.314.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.314.1/actions-runner-linux-x64-2.314.1.tar.gz"

./Config/send_command_bastion.sh $public_ip "tar xzf ./actions-runner-linux-x64-2.314.1.tar.gz"

token=$(./Config/github_token.sh $gh_user $app_name)

./Config/send_command_bastion.sh $public_ip "./config.sh --url https://github.com/houbou98-19/$app_name --token $token --unattended --name $app_name --work _work --labels 'self-hosted, linux'"

./Config/send_command_bastion.sh $public_ip "sudo ./svc.sh install azureuser"

./Config/send_command_bastion.sh $public_ip "sudo ./svc.sh start"

#./Config/send_command_bastion.sh $public_ip "sudo systemctl status $app_name.service"