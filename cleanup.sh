#/bin/sh
YELLOW='\033[0;33m'
NC='\033[0;0m'
### Remove Automationclass Container

echo -e "###################################"
echo -e "#  ${YELLOW}Get Automationclass Container${NC}  #"
echo -e "###################################\n"

CONTAINER=$(az container list --resource-group AutomationclassContainer | jq -r '.[].containers[].name')

echo - $CONTAINER

echo -e "\n${YELLOW}Delete Container y/n${NC}"

read DELETECONTAINER

if [ $DELETECONTAINER = "y" ];
then
    echo Delete Container $CONTAINER
    az container delete --name $CONTAINER --resource-group AutomationclassContainer --yes
fi

### Remove Application Registrations

echo -e "####################################"
echo -e "#  ${YELLOW}Get ansible- app registrations${NC}  #"
echo -e "####################################\n"

az ad app list --filter "startswith(displayName,'ansible')" --query '[].displayName' | jq -r .[]

APPREG=$(az ad app list --filter "startswith(displayName,'ansible')" --query '[].displayName' | jq -r .[])

eval "APPARR=($APPREG)"

echo -e "\n${YELLOW}Delete ansible-* App Registrations y/n${NC}"

read DELETEAPPREG

if [ $DELETEAPPREG = "y" ];
then
    for A in "${APPARR[@]}"; do
    echo Delete $A Resource Group
    az ad app delete --id $A
    done
fi

echo -e "##################################"
echo -e "#  ${YELLOW}Get ansible- Resource Groups${NC}  #"
echo -e "##################################\n"

az group list --query "[?starts_with(name,'ansible-')].name" | jq -r .[]

ANSIBLERG=$(az group list --query "[?starts_with(name,'ansible-')].name" | jq -r .[])

eval "ANSIRGARR=($ANSIBLERG)"

echo -e "\n${YELLOW}Delete ansible-* Resource Groups y/n${NC}"

read DELETEANSIBLERG

if [ $DELETEANSIBLERG = "y" ];
then
    for A in "${ANSIRGARR[@]}"; do
    echo Delete $A Resource Group
    az group delete -n $A --force-deletion-types Microsoft.Compute/virtualMachines --yes --no-wait
    done
fi

### Remove user-* Resource Groups

echo -e "##############################"
echo -e "#  ${YELLOW}Get user- ResourceGroups${NC}  #"
echo -e "##############################\n"

az group list --query "[?starts_with(name,'user')].name" | jq -r .[]

USERRG=$(az group list --query "[?starts_with(name,'user')].name" | jq -r .[])
eval "USERARR=($USERRG)"

echo -e "\n${YELLOW}Delete user-** Resource Groups y/n${NC}"

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
echo -e "#  ${YELLOW}Get webserver- ResourceGroups${NC}  #"
echo -e "###################################\n"

az group list --query "[?starts_with(name,'webserver')].name" | jq -r .[]

WEBRG=$(az group list --query "[?starts_with(name,'webserver')].name" | jq -r .[])

eval "WEBARR=($WEBRG)"

echo -e "\n${YELLOW}Delete webserver-** Resource Groups y/n${NC}"

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
echo -e "#  ${YELLOW}Get TowerRG ResourceGroup${NC}  #"
echo -e "###############################\n"

az group list --query "[?starts_with(name,'TowerRG')].name" | jq -r .[]

echo -e "\n${YELLOW}Delete TowerRG y/n${NC}"

read DELETETOWER

if [ $DELETETOWER = "y" ];
then
    echo Delete ResourceGroup TowerRG
    az group delete -n TowerRG --force-deletion-types Microsoft.Compute/virtualMachines --yes --no-wait
fi

### Remove users

echo -e "########################"
echo -e "#      ${YELLOW}Get users${NC}       #"
echo -e "########################\n"

az ad user list --query "[?starts_with(displayName,'user')].userPrincipalName" | jq -r .[]

USERS=$(az ad user list --query "[?starts_with(displayName,'user')].userPrincipalName" | jq -r .[])

eval "USERARR=($USERS)"

echo -e "\n${YELLOW}Delete Users y/n${NC}"

read DELETEUSERS

if [ $DELETEUSERS = "y" ];
then
    for U in "${USERARR[@]}"; do
    echo Delete $U Resource Group
    az ad user delete --id $U
    done
fi