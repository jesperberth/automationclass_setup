#/bin/sh

echo Get Automationclass Container

CONTAINER=$(az container list --resource-group AutomationclassContainer | jq -r '.[].containers[].name')

echo - $CONTAINER

echo "Delete Container y/n"

read DELETECONTAINER

if [ $DELETECONTAINER = "y" ];
then
    echo Delete Container $CONTAINER
    az container delete --name $CONTAINER --resource-group AutomationclassContainer --yes
fi

echo Get Application Registrations

az ad app list --filter "startswith(displayName,'ansible')" --query '[].displayName' | jq -r .[]

az ad app delete --id

echo Get ansible- ResourceGroups

az group list --query "[?starts_with(name,'ansible-')].name" | jq -r .[]

echo Get user- ResourceGroups

az group list --query "[?starts_with(name,'user')].name" | jq -r .[]

echo Get webserver- ResourceGroups

az group list --query "[?starts_with(name,'webserver')].name" | jq -r .[]

echo Get TowerRG ResourceGroup\n

az group list --query "[?starts_with(name,'TowerRG')].name" | jq -r .[]

echo "Delete TowerRG y/n"

read DELETETOWER

if [ $DELETETOWER = "y" ];
then
    echo Delete ResourceGroup TowerRG
    az group delete -n TowerRG --force-deletion-types Microsoft.Compute/virtualMachines --yes --no-wait
fi

echo Get users\n

USERS=$(az ad user list --query "[?starts_with(displayName,'user')].userPrincipalName" | jq -r .[])

echo $USERS

echo "Delete Users y/n"\n

read DELETEUSERS

if [ $DELETEUSERS = "y" ];
then
    echo Delete Users
    for USER in $USERS
    do
        az ad user delete --id $USER
    done
fi