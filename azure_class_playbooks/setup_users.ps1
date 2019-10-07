function CreateUser {
    Param(
        [Parameter(Mandatory=$True)]
        $email,
        [Parameter(Mandatory=$True)]
        $name
      )
    $location = "North Europe"
    $emailStringTmp = $email -replace "@","_"
    $emailString = $emailStringTmp -replace "\.","_"
    $rgname = $emailString
    if ($rgname.length -gt 90) {
        $rgname = $rgname.substring(0,90)
    }

    $storage = $emailString -replace "_",""

    if ($storage.length -gt 16) {
        $storage = $storage.substring(0,16)
    }    
 
    $subId = (Get-AzureRmContext).Subscription
    New-AzureADMSInvitation -InvitedUserDisplayName $name -InvitedUserEmailAddress $email -InviteRedirectURL https://portal.azure.com -SendInvitationMessage $true
    New-AzureRmResourceGroup -Name $rgname -Location $location
    
    start-sleep -s 30

    $user = (Get-AzureADUser -Filter "DisplayName eq '$name'").ObjectId
    write-host $user
    write-host "Check"
    New-AzureRmRoleAssignment -ObjectId $user -RoleDefinitionName Owner -Scope "/subscriptions/$subId"

    New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $storage -Location $location -SkuName Standard_LRS -kind StorageV2
}
$email = Read-Host -Prompt 'Input email'
$name = Read-Host -Prompt 'Input name'
CreateUser -email $email -name $name