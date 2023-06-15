# Azure Class Setup

## Download and run deploy_lab.sh

```bash
curl -o deploy_lab.sh https://raw.githubusercontent.com/jesperberth/automationclass_setup/main/azure/deploy_lab.sh

chmod +x deploy_lab.sh

./deploy_lab.sh

```

## Build and push image

```bash

docker build -t jesperberth/automationclass:0.1 -t jesperberth/automationclass:latest .

docker push jesperberth/automationclass:0.1

docker push jesperberth/automationclass:latest

```

## Create users in azure

Open a azure cloud shell

Run in Powershell

Setup_users.ps1

Select a region

number of users to deploy

Default password for all new users

```bash

cd clouddrive

git clone https://github.com/jesperberth/automationclass_setup.git

cd automationclass_setup

connect-azuread

setup_users.ps1

```

## AWX/Tower Class

vi ~/.ansible.cfg

```bash
[defaults]
host_key_checking = False
[sudo_become_plugin]
flags = -H -S
```

```bash
ssh-keygen

change playbook to install more than 2 environments

ansible-playbook 00_azure_tower_deploy.yml

ansible-galaxy install jesperberth.el_k3s -f
ansible-galaxy install jesperberth.awx_k8s_install -f

ansible-playbook -i inventory.azure_rm.yml install_awx.yml

```

## Cleanup Azure

```bash
cd clouddrive

cd automationclass_setup

connect-azuread

cleanup.ps1

```
