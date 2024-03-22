#!/bin/bash

# Define variables
app_name="${1:-MyApp}"
app_port="${2:-5000}"
connection_string="empty"
gh_user="${3:-houbou98-19}"
token=$(./Config/github_token.sh $gh_user $app_name)

# Generate YAML content
app_yaml_content="#cloud-config

write_files:
  - path: /etc/$app_name/$app_name.env
    content: |
      AzureCosmosDBTodoService__ConnectionString=$connection_string
      AzureCosmosDBTodoService__Database="TodoDB"
      AzureCosmosDBTodoService__Collection="TodoList"

  - path: /etc/systemd/system/$app_name.service
    content: |
      [Unit]
      Description=ASP.NET Web App running on Ubuntu

      [Service]
      WorkingDirectory=/opt/$app_name
      ExecStart=/usr/bin/dotnet /opt/$app_name/$app_name.dll
      Restart=always
      RestartSec=10
      KillSignal=SIGINT
      SyslogIdentifier=$app_name
      User=www-data
      Environment=ASPNETCORE_ENVIRONMENT=Production
      Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false
      Environment="ASPNETCORE_URLS=http://*:$app_port"
      EnvironmentFile=/etc/$app_name/$app_name.env

      [Install]
      WantedBy=multi-user.target

systemd:
  units:
    - name: $app_name.service
      enabled: true


runcmd:
  - |
    declare repo_version=\$(if command -v lsb_release &> /dev/null; then lsb_release -r -s; else grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '\"'; fi)
    
    wget https://packages.microsoft.com/config/ubuntu/\$repo_version/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

    dpkg -i packages-microsoft-prod.deb

    rm packages-microsoft-prod.deb

    apt update

    apt-get update 
    
    apt-get install -y aspnetcore-runtime-8.0

    mkdir /home/azureuser/actions-runner; cd /home/azureuser/actions-runner

    curl -o actions-runner-linux-x64-2.314.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.314.1/actions-runner-linux-x64-2.314.1.tar.gz

    tar xzf ./actions-runner-linux-x64-2.314.1.tar.gz

    chown -R azureuser:azureuser /home/azureuser/actions-runner
    
    sudo -u azureuser ./config.sh --unattended --url https://github.com/$gh_user/$app_name --token $token --name $app_name

    ./svc.sh install azureuser

    ./svc.sh start

    systemctl daemon-reload
    systemctl enable $app_name.service
    systemctl start $app_name.service
"

# Save to a YAML file
echo "$app_yaml_content" > ./Deployment/cloud_init_app.yaml

