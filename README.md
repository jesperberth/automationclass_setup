# Azure Class Setup

## Download and run deploy_lab.sh

```bash
curl -o deploy_lab.sh https://raw.githubusercontent.com/jesperberth/automationclass_setup/main/azure/deploy_lab.sh

chmod +x deploy_lab.sh

./deploy_lab.sh

```

## Create users in azure

Open a azure cloud shell

Run in Bash

./setup_azure.sh

number of users to deploy

Default password for all new users

```bash

cd clouddrive

git clone https://github.com/jesperberth/automationclass_setup.git

cd automationclass_setup

./setup_azure.sh

```

## AWX/Tower Class

vi ~/.ansible.cfg

```bash
./deploy_tower.sh

```

## Cleanup Azure

```bash
cd clouddrive

cd automationclass_setup

./cleanup.sh

```
