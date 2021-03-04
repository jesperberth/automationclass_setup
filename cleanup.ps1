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

$webserver = Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^webserver.*"

write-host -ForegroundColor Yellow "webserver* resourcegroups to delete"

foreach ($rg in $webserver) {
    Write-Host $rg.ResourceGroupName
}

do {
    $response = Read-Host -Prompt "Delete Resourcegroups y/n"
    if ($response -eq 'y') {
        foreach ($server in $webserver) {
            Remove-AzResourceGroup $rg.ResourceGroupName -Force
        }
    $response = "n"
     }
} 	until ($response -eq 'n')


#Remove-AzResourceGroup



