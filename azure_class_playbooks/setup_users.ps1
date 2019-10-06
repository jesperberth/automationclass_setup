function CreateUser {
    param (
    )
    $location = "North Europe"
    $emailStringTmp = $email -replace "@","_"
    $emailString = $emailStringTmp -replace "\.","_"
    write-host $emailString
    $rgname = $emailString
    $rgname = $rgname.substring(0,16)

    $storage = $emailString -replace "_",""

    write-host $rgname
    New-AzureADMSInvitation -InvitedUserDisplayName $name -InvitedUserEmailAddress $email -InviteRedirectURL https://portal.azure.com -SendInvitationMessage $true
    New-AzureRmResourceGroup -Name $rgname -Location $location
    #New-AzureADGroup -DisplayName $rgname -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"

    $group = Get-AzureADGroup -SearchString $rgname | Select-Object ObjectId

    New-AzureRmRoleAssignment -ObjectId $group.ObjectId -RoleDefinitionName Owner -ResourceGroupName $rgname

    New-AzureRmStorageAccount -ResourceGroupName $rgname -Name $storage -Location $location -SkuName Standard_LRS -kind StorageV2
}
$email = Read-Host -Prompt 'Input email'
$name = Read-Host -Prompt 'Input name'
CreateUser