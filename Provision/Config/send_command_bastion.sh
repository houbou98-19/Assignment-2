#!/bin/bash

ip=$1


ssh_key_path=~/.ssh/id_rsa

eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa

command=$2

ssh -A -t -o StrictHostKeyChecking=no azureuser@$ip "ssh -o StrictHostKeyChecking=no azureuser@10.0.0.12 $command"
