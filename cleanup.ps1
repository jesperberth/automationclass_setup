# Usage
#
# Remove Users, Resourcegroups for Ansible training
#
# using native azure ad users
#
# Author: Jesper Berth, jesper.berth@arrow.com - march 2021

$azureaduser = get-azureaduser | Where-Object UserPrincipalName -Match "^user.*"

write-host -ForegroundColor Yellow "These are the users to delete"

foreach ($user in $azureaduser) {
    Write-Host $user.UserPrincipalName
}

do {
    $response = Read-Host -Prompt "Delete users y/n"
    if ($response -eq 'y') {
    #remove-azureaduser
    $response = "n"
     }
} 	until ($response -eq 'n')

#remove-azureaduser

#Get-AzureADApplication | Where-Object DisplayName -Match "*.^ansible.*" | Select-Object DisplayName

#remove-azureadapplication

#Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^user.*" | Select-Object ResourceGroupName

#Remove-AzResourceGroup

#Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^ansible.*" | Select-Object ResourceGroupName

#Remove-AzResourceGroup

#Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^webserver.*" | Select-Object ResourceGroupName

#Remove-AzResourceGroup



