#/bin/sh

echo Get Automationclass Container

CONTAINER = az container list --resource-group AutomationclassContainer | jq -r '.[].containers[].name'

echo - $CONTAINER

echo "Delete Container y/n"

read DELETECONTAINER

if [ $DELETECONTAINER = "y" ];
then
    echo Delete Container $CONTAINER
fi