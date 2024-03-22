#!/bin/bash

if [ -z "$1" ]; then
    # Get all resource groups
    resource_groups=$(az group list --query "[].name" -o tsv)

    # Calculate the new resource group name based on the count
    new_rg_number=$(( $(echo "$resource_groups" | wc -w) + 1))
    resource_group="$new_rg_number"
else
    # Use the provided parameter as the resource group name
    resource_group="$1"
fi

#echo "Creating resource group: $resource_group"

# Create a resource group
response=$(az group create --location swedencentral --name $resource_group)

# Return the resource_group variable
echo $resource_group