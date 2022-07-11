#!/bin/bash
echo "##################"
echo "# Deploy Lab kit #"
echo "##################"

echo "Enter your username for the lab:"
read username

echo "Please enter password:"
read password
count=`echo ${#password}`
if [[ $count -lt 12 ]];then
    echo "Password length should be minimum 12 characters"
    exit 1;
fi
    echo $password | grep "[A-Z]" | grep "[a-z]" | grep "[0-9]" | grep "[,.-_!@#$%^&*]"
if [[ $? -ne 0 ]];then
    echo "Password must contain atleast 1 uppercase, lowercase, digits and special characters"
    exit 2;
fi
echo Your username is $username and your password is $password

virtualenv ansible

source ansible/bin/activate

pip install ansible

ansible-galaxy collection install azure.azcollection

pip install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt

curl -o requirements.yml https://raw.githubusercontent.com/jesperberth/automationclass_setup/main/azure/requirements.yml

ansible-galaxy install -r requirements.yml

curl -o 00_azure_class_setup.yml https://raw.githubusercontent.com/jesperberth/automationclass_setup/main/azure/00_azure_class_setup.yml

ansible-playbook -e "adminUser=$username adminPassword=$password" 00_azure_class_setup.yml