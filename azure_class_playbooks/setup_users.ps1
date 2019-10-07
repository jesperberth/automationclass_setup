# Usage
# 
# Create users for Ansible training
# 
# ./setup_users.ps1 Will prompt you for an email and a name and create the user
# ./setup_users.ps1 -email "some@address.com" -name "Some Name" will create the user
# ./setup_users.ps1 -file somefile.csv will take all lines in a csv file and create all users
#
# CSV file format
#
# email,name
# "some@address.com","Some Name"
# "someother@address.com", "Some Other Name"
#
# Author: Jesper Berth, jesper.berth@arrow.com
param(
    $file,
    $email,
    $name
)
$tmpvar = $null
function ReadCsv{
    Param(
        [Parameter(Mandatory=$True)]
        $file
      )
    $csvuser = Import-Csv -Path $file
    foreach ($usr in $csvuser) {
        
        $email = $usr.email
        $name = $usr.name

        CreateUser -email $email -name $name
}

}
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

function promptUser{
    $email = Read-Host -Prompt 'Input email'
    $name = Read-Host -Prompt 'Input name'
    CreateUser -email $email -name $name
}


if($file){

    ReadCsv -file $file
    exit

}else{

    $tmpvar = "1"

}

if($email -and $name){

    CreateUser -email $email -name $name
    exit

}else{

    $tmpvar = "1"

}

if($tmpvar){

    promptUser
    exit
}