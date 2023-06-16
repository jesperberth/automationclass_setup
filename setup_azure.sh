#/bin/sh

# Usage
#
# Create users for Ansible training
#
# using native azure ad users
#
# Author: Jesper Berth, jesper.berth@arrow.com - june 2023

# LOCATION=$(az account list-locations --query '[].{Name:name,DisplayName:displayName}' | jq -s)

# for LOC in $LOCATION
#     do
#         jq -r '.[].DisplayName' $LOC
#         #echo $LOC
#     done

# echo Get Automationclass Container

# CONTAINER=$(az container list --resource-group AutomationclassContainer | jq -r '.[].containers[].name')

# echo - $CONTAINER

# echo "Delete Container y/n"

# read DELETECONTAINER


create_users () {
    echo -e "Creating $1 new users with password $2\n"
    for (( i=1 ; i<=$1 ; i++ ));
    do
        echo "Create - user$1"
    done
    #az ad user create --display-name myuser --password password --user-principal-name myuser@contoso.com
}

create_users 4