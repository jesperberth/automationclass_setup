#/bin/sh

# Usage
#
# Create users for Ansible training
#
# using native azure ad users
#
# Author: Jesper Berth, jesper.berth@arrow.com - june 2023

LOCATION=northeurope
DOMAIN=$(az rest --method get --url 'https://graph.microsoft.com/v1.0/domains?$select=id' | jq -r .value[].id)
SUBID=$(az account list --query "[].{id:id}" -o tsv)

echo -e "How many users?\n"
read NUMBERUSERS

echo -e "Enter default password for new users\n"
read PASSWORD

create_storage () {
        USER=$1
        echo -e "Creating Resource Group and storage for $USER\n"
        RANSTRING=$(echo $RANDOM | md5sum | head -c 5)
        az group create -l $LOCATION -n $USER-ansible
        STONAME="$USER"ansible
        STORAGENAME="$STONAME""$RANSTRING"
        az storage account create -n $STORAGENAME -g $USER-ansible -l $LOCATION --sku Standard_LRS
        az storage share create --account-name $STORAGENAME --name $STONAME --quota 6
}

create_users () {
    echo -e "Creating $1 new users with password $2\n"
    for (( i=1 ; i<=$1 ; i++ ));
    do
        USER=user$i
        echo "Create - $USER"
        az ad user create --display-name $USER --password $2 --user-principal-name $USER@$DOMAIN
        USERID=$(az ad user show --id $USER@$DOMAIN | jq -r .id)
        az role assignment create --assignee $USER@$DOMAIN --role Owner --scope /subscriptions/$SUBID
        echo $USERID
        az rest -m post --headers "Content-Type=application/json" -u "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments" -b '{"principalId":"'$USERID'","roleDefinitionId":"9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3","directoryScopeId":"/"}'
        create_storage $USER
    done
}

create_users $NUMBERUSERS $PASSWORD
