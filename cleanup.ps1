# Usage
#
# Remove Users, Resourcegroups for Ansible training
#
# using native azure ad users
#
# Author: Jesper Berth, jesper.berth@arrow.com - march 2021

get-azureaduser | Where-Object UserPrincipalName -Match "^user.*"

#remove-azureaduser

Get-AzureADApplication | Where-Object ResourceGroupName -Match "^ansible.*" | Select-Object DisplayName

#remove-azureadapplication

Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^user.*" | Select-Object ResourceGroupName

#Remove-AzResourceGroup

Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^ansible.*" | Select-Object ResourceGroupName

#Remove-AzResourceGroup

Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^webserver.*" | Select-Object ResourceGroupName

#Remove-AzResourceGroup


