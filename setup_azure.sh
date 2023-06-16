#/bin/sh

# Usage
#
# Create users for Ansible training
#
# using native azure ad users
#
# Author: Jesper Berth, jesper.berth@arrow.com - june 2023

DOMAIN=arrowadfs.onmicrosoft.com
SUBID=$(az account list --query "[].{id:id}" -o tsv)

echo -e "How many users?\n"
read NUMBERUSERS

echo -e "Enter default password for new users\n"
read PASSWORD

create_users () {
    echo -e "Creating $1 new users with password $2\n"
    for (( i=1 ; i<=$1 ; i++ ));
    do
        echo "Create - user$1"
        az ad user create --display-name user$1 --password $2 --user-principal-name user$1@$DOMAIN
        USERID=$(az ad user show --id user$1@$DOMAIN | jq -r .id)
        az role assignment create --assignee user$1@$DOMAIN --role Owner --scope /subscriptions/$SUBID
        echo $USERID
        az rest -m post --headers "Content-Type=application/json" -u "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments" -b '{"principalId":"'+$USERID+'","roleDefinitionId":"9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3","directoryScopeId":"/"}'
    done
}

create_users $NUMBERUSERS $PASSWORD


# az ad user create --display-name user1 --password Hlk3@sdf!2 --user-principal-name user1@$DOMAIN

# az role assignment create --assignee user1@$DOMAIN --role Owner --scope /subscriptions/$SUBID


# az role assignment list --query "[?starts_with(name,'Application-')]


# $Body = @{ 
#     "roleDefinitionId" = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3"; 
#     "principalId"      = "a3c19bbf-f99a-42c7-b07f-fd54dc2409ae"; 
#     "directoryScopeId" = "/"
# } | ConvertTo-Json -Compress
    
# $Body = $Body.Replace('"', '\"')

# az rest -m post -u "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments" -b "$Body"

# az rest -m post --headers "Content-Type=application/json" -u "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments" -b {roleDefinitionId" = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3"; "principalId" = "a3c19bbf-f99a-42c7-b07f-fd54dc2409ae";"directoryScopeId" = "/"}

# az rest -m post --headers "Content-Type=application/json" -u "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments" -b {\"principalId\":\"a3c19bbf-f99a-42c7-b07f-fd54dc2409ae\",\"roleDefinitionId\":\"9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3\",\"directoryScopeId\":\"/\"}


# Works with powershell

 #az rest -m post --headers "Content-Type=application/json" -u "https://graph.microsoft.com/beta/roleManagement/directory/roleAssignments" -b '{"principalId":"$1","roleDefinitionId":"9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3","directoryScopeId":"/"}' 
