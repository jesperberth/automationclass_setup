#/bin/sh

echo Get Automationclass Container

az container list --resource-group AutomationclassContainer | jq -r '.[].containers[].name'

echo "Delete Container y/n"

read DELETECONTAINER

if [ $DELETECONTAINER = "y"];
then
    echo Delete Container
fi