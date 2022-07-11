#!/bin/bash
echo "##################"
echo "# Deploy Lab kit #"
echo "##################"

echo "Enter your username for the lab:"
read username

echo "Please enter password:"
read password
count=`echo ${#password}`
if [[ $count -lt 12 ]];then
    echo "Password length should be minimum 12 characters"
    exit 1;
fi
    echo $password | grep "[A-Z]" | grep "[a-z]" | grep "[0-9]" | grep "[,.-_!@#$%^&*]"
if [[ $? -ne 0 ]];then
    echo "Password must contain atleast 1 uppercase, lowercase, digits and special characters"
    exit 2;
fi
echo Your username is $username and your password is $password

docker pull jesperberth/automationclass:latest