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

## Docker build

```bash

docker build . -t automationclass:latest

# or

docker build . -f DockerfileWorkshop -t ansibleworkshop:latest

#docker run -d --mount type=bind,source=/home/jesper/.azure/credentials,target=/root/.azure/credentials -e username=jesper -e password= automationclass:latest

docker build . -f DockerfileNewClass -t ansiblenewclass:latest

docker build . -f DockerfileStudent -t ansiblenewclassstudent:latest

```

## Deploy labs

Requires docker installed and a local .azure/credentials file

Update users.csv file

```bash

python3 deploy_labs_new.py

```
https://github.com/microsoft/WSL/releases/download/2.3.26/wsl.2.3.26.0.x64.msi

    - name: Install Ubuntu for WSL Continued
      ansible.windows.win_shell: |
        wsl.exe -d Ubuntu-24.04 --install --root
      when: not ubuntuinstalled