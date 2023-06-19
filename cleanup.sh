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

### Remove user-* Resource Groups

echo -e "########################"
echo -e "Get user- ResourceGroups"
echo -e "########################\n"

az group list --query "[?starts_with(name,'user')].name" | jq -r .[]

USERRG=$(az group list --query "[?starts_with(name,'user')].name" | jq -r .[])
eval "USERARR=($USERRG)"

echo -e "Delete user-** Resource Groups y/n"

read DELETEUSERRG

if [ $DELETEUSERRG = "y" ];
then
    for U in "${USERARR[@]}"; do 
    echo Delete $U Resource Group
    az group delete -n $U --force-deletion-types Microsoft.Compute/virtualMachines --yes --no-wait
    done
fi

### Remove webserver_* Resource Groups

echo Get webserver- ResourceGroups

az group list --query "[?starts_with(name,'webserver')].name" | jq -r .[]

echo Get TowerRG ResourceGroup\n

az group list --query "[?starts_with(name,'TowerRG')].name" | jq -r .[]

echo -e "Delete TowerRG y/n"

read DELETETOWER

if [ $DELETETOWER = "y" ];
then
    echo Delete ResourceGroup TowerRG
    az group delete -n TowerRG --force-deletion-types Microsoft.Compute/virtualMachines --yes --no-wait
fi

echo -e Get users\n

USERS=$(az ad user list --query "[?starts_with(displayName,'user')].userPrincipalName" | jq -r .[])

echo $USERS

echo -e "Delete Users y/n"\n

read DELETEUSERS

if [ $DELETEUSERS = "y" ];
then
    echo Delete Users
    for USER in $USERS
    do
        az ad user delete --id $USER
    done
fi