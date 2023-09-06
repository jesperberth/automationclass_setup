#!/bin/bash
YELLOW='\033[0;33m'
NC='\033[0;0m'

echo -e "####################"
echo -e "#  ${YELLOW}Deploy Lab kit${NC}  #"
echo -e "####################"

echo "Enter your username for the lab:"
read username

echo "Please type password:"
read password

echo "Please re-type password:"
read password2


count=`echo ${#password}`
if [[ $count -lt 12 ]];then
    echo "Password length should be minimum 12 characters"
    exit 1;
fi

if [ "$password" != "$password2" ]; then
  echo "Passwords dosn't match"
  exit 1
else
  echo "Passwords Match"
fi

result="$(cracklib-check <<<"$password")"

okay="$(awk -F': ' '{ print $2}' <<<"$result")"
if [[ "$okay" == "OK" ]]
then
        echo "Password OK"
else
        echo "Your password was rejected - $result"
        exit 1
fi

echo Your username is $username and your password is $password

python3 -m venv ansible

source ansible/bin/activate

pip install ansible

ansible-galaxy collection install azure.azcollection --force

pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

curl -o requirements.yml https://raw.githubusercontent.com/jesperberth/automationclass_setup/main/azure/requirements.yml

ansible-galaxy install -r requirements.yml

curl -o 00_azure_class_setup.yml https://raw.githubusercontent.com/jesperberth/automationclass_setup/main/azure/00_azure_class_setup.yml

ansible-playbook -e "adminUser=$username adminPassword=$password" 00_azure_class_setup.yml