#/bin/sh

echo Get Automationclass Container

az container list --resource-group AutomationclassContainer | jq -r '.[].containers[].name'

echo "Delete Container y/n"

read deletecontainer

if [ $deletecontainer -eq  y]
then
    echo Delete Container
fi