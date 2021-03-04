# Usage
#
# Remove Users, Resourcegroups for Ansible training
#
# using native azure ad users
#
# Author: Jesper Berth, jesper.berth@arrow.com - march 2021

# Begin User Cleanup

$azureaduser = get-azureaduser | Where-Object UserPrincipalName -Match "^user.*"

write-host -ForegroundColor Yellow "These are the users to delete"

foreach ($user in $azureaduser) {
    Write-Host $user.UserPrincipalName
}

do {
    $response = Read-Host -Prompt "Delete users y/n"
    if ($response -eq 'y') {
        foreach ($user in $azureaduser) {
            remove-azureaduser $user.UserPrincipalName -force
        }
    $response = "n"
     }
} 	until ($response -eq 'n')

write-host "Remaining Users"
get-azureaduser | Select-Object UserPrincipalName

# End User Cleanup

# Begin app Cleanup

$azureapp = Get-AzureADApplication #| Where-Object DisplayName -Match "^ansible*"

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

write-host "Remaining App registrations"
Get-AzureADApplication | Select-Object DisplayName

# End App Cleanup

 # Begin RG User

$user = Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^user.*"

write-host -ForegroundColor Yellow "user* resourcegroups to delete"

foreach ($usr in $user) {
    Write-Host $usr.ResourceGroupName
}

do {
    $response = Read-Host -Prompt "Delete Resourcegroups y/n"
    if ($response -eq 'y') {
        foreach ($usr in $user) {
            Remove-AzResourceGroup $usr.ResourceGroupName -Force -AsJob
        }
    $response = "n"
     }
} 	until ($response -eq 'n')

# End RG User

# Begin RG Webserver

$webserver = Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^webserver.*"
write-host -ForegroundColor Yellow "webserver* resourcegroups to delete"

foreach ($rg in $webserver) {
    Write-Host $rg.ResourceGroupName
}

do {
    $response = Read-Host -Prompt "Delete Resourcegroups y/n"
    if ($response -eq 'y') {
        foreach ($rg in $webserver) {
            Remove-AzResourceGroup $rg.ResourceGroupName -Force -AsJob
        }
    $response = "n"
     }
} 	until ($response -eq 'n')

# End RG Webserver

# Begin RG ansible

$ansible = Get-AzResourceGroup | Where-Object ResourceGroupName -Match "^ansible.*"

write-host -ForegroundColor Yellow "webserver* resourcegroups to delete"

foreach ($rg in $ansible) {
    Write-Host $rg.ResourceGroupName
}

do {
    $response = Read-Host -Prompt "Delete Resourcegroups y/n"
    if ($response -eq 'y') {
        foreach ($rg in $ansible) {
            Remove-AzResourceGroup $rg.ResourceGroupName -Force -AsJob
        }
    $response = "n"
     }
} 	until ($response -eq 'n')

# End RG ansible

write-host "Remaining resource groups"
Get-AzResourceGroup | Select-Object ResourceGroupName