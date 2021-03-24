# Azure Class Setup

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

ansible-galaxy install jesperberth.el_k3s -force
ansible-galaxy install jesperberth.awx_k8s_install -force

ansible-playbook -i inventory.azure_rm.yml install_awx18.yml

OLD will install awx 16
ansible-galaxy install jesperberth.awx_install -force
ansible-playbook -i inventory.azure_rm.yml install_awx.yml

```

## Cleanup Azure

```bash
cd clouddrive

cd automationclass_setup

connect-azuread

cleanup.ps1

```