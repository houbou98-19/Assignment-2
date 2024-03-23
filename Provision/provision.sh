#!/bin/bash

app_name="Todo" # Name of the app, must match the name of the repository in github
gh_user="houbou98-19" # Github username

# Create resource_group and capture the name
resource_group=$(./ResourceGroup/resource_group_provision.sh)

# Provision the deployment and get the App IP
public_ip=$(./Deployment/deployment_provision.sh $resource_group $app_name)

# Run the Github Actions workflow
gh workflow run cicd.yaml --repo $gh_user/$app_name --ref master

echo "APP IP: $public_ip"

dotnet run watch
#run command through bastionhost
#./Config/send_command_bastion.sh $public_ip "ls"
