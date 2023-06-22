#/bin/sh
Yellow='\033[0;33m'
### Remove Automationclass Container

echo -e "${Yellow}###################################"
echo -e "#  Get Automationclass Container  #"
echo -e "###################################\n"

CONTAINER=$(az container list --resource-group AutomationclassContainer | jq -r '.[].containers[].name')

echo - $CONTAINER

echo "Delete Container y/n"

read DELETECONTAINER

if [ $DELETECONTAINER = "y" ];
then
    echo Delete Container $CONTAINER
    az container delete --name $CONTAINER --resource-group AutomationclassContainer --yes
fi

### Remove Application Registrations

echo -e "####################################"
echo -e "#  Get ansible- app registrations  #"
echo -e "####################################\n"

az ad app list --filter "startswith(displayName,'ansible')" --query '[].displayName' | jq -r .[]

#az ad app delete --id

echo -e "##################################"
echo -e "#  Get ansible- Resource Groups  #"
echo -e "##################################\n"

az group list --query "[?starts_with(name,'ansible-')].name" | jq -r .[]

### Remove user-* Resource Groups

echo -e "##############################"
echo -e "#  Get user- ResourceGroups  #"
echo -e "##############################\n"

az group list --query "[?starts_with(name,'user*-ansible')].name" | jq -r .[]

USERRG=$(az group list --query "[?starts_with(name,'user*-ansible')].name" | jq -r .[])
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

echo -e "###################################"
echo -e "#  Get webserver- ResourceGroups  #"
echo -e "###################################\n"

az group list --query "[?starts_with(name,'webserver')].name" | jq -r .[]

WEBRG=$(az group list --query "[?starts_with(name,'webserver')].name" | jq -r .[])

eval "WEBARR=($WEBRG)"

echo -e "Delete webserver-** Resource Groups y/n\n"

read DELETEWEBRG

if [ $DELETEWEBRG = "y" ];
then
    for W in "${WEBARR[@]}"; do
    echo Delete $W Resource Group
    az group delete -n $W --force-deletion-types Microsoft.Compute/virtualMachines --yes --no-wait
    done
fi

## Remove TowerRG Resource Group

echo -e "###############################"
echo -e "#  Get TowerRG ResourceGroup  #"
echo -e "###############################\n"

az group list --query "[?starts_with(name,'TowerRG')].name" | jq -r .[]

echo -e "Delete TowerRG y/n"

read DELETETOWER

if [ $DELETETOWER = "y" ];
then
    echo Delete ResourceGroup TowerRG
    az group delete -n TowerRG --force-deletion-types Microsoft.Compute/virtualMachines --yes --no-wait
fi

### Remove users

echo -e "########################"
echo -e "#      Get users       #"
echo -e "########################\n"

az ad user list --query "[?starts_with(displayName,'user')].userPrincipalName" | jq -r .[]

USERS=$(az ad user list --query "[?starts_with(displayName,'user')].userPrincipalName" | jq -r .[])

eval "USERARR=($USERS)"

echo -e "Delete Users y/n\n"

read DELETEUSERS

# if [ $DELETEUSERS = "y" ];
# then
#     echo Delete Users
#     for USER in $USERS
#     do
#         az ad user delete --id $USER
#     done
# fi

if [ $DELETEUSERS = "y" ];
then
    for U in "${USERARR[@]}"; do
    echo Delete $U Resource Group
    az ad user delete --id $USER
    done
fi