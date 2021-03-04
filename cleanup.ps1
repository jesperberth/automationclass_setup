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
        foreach ($user in $azureaduser) {
            remove-azureaduser $user.UserPrincipalName
        }
    $response = "n"
     }
} 	until ($response -eq 'n')

$azureapp = Get-AzureADApplication | Where-Object DisplayName -Match "*.^ansible.*"

write-host -ForegroundColor Yellow "These are the app registrations to delete"
foreach ($app in $azureapp) {
    Write-Host $app.DisplayName
}

do {
    $response = Read-Host -Prompt "Delete appregistration y/n"
    if ($response -eq 'y') {
        foreach ($app in $azureapp) {
            remove-azureadapplication $app.DisplayName
        }
    $response = "n"
     }
} 	until ($response -eq 'n')

#remove-azureadapplication

$webserver = Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^webserver.*"
$ansible = Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^ansible.*"
$user = Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^user.*"

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



