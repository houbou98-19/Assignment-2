#!/bin/bash

#   Get the resource group name from the first parameter
resource_group=$1
app_name="${2:-MyApp}"

#   Get all file names
parameters="Deployment/parameters.json"
sshPublicKey=$(cat ~/.ssh/id_rsa.pub)
nginxCustomData=@Deployment/cloud_init_nginx.yaml
appCustomData=@Deployment/cloud_init_app.yaml
template_file="Deployment/BH_RP_APP_Template.json"

#   Get variable names
deployment_name="demo"
password="iHo4Ef36wg"


#   Create init yaml file
$(./Deployment/cloud_init_generator.sh $app_name 5000)

#   Create a deployment group
response=$(az deployment group create --resource-group $resource_group --name $deployment_name --template-file $template_file --parameters password=$password nginxCustomData=$nginxCustomData appCustomData=$appCustomData sshPublicKey="$sshPublicKey")

#   Get the name of the VM
vm_name=$(az deployment group show --resource-group $resource_group --name $deployment_name --query properties.outputs.rPname.value --output tsv)
#   Get the public IP of the BH_VM
public_ip=$(az vm show --resource-group $resource_group --name $vm_name --show-details --query [publicIps] --output tsv)

echo $public_ip