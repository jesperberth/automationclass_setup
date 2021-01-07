# Class Setup

## Vmware

## ansible.ansible.local

Role: DNS, DHCP, Storage

Fedora 33

Minimal install

root user allow ssh

additional user: user with admin access

ip: 192.168.124.2/24

Gateway: 192.168.124.1

DNS 1.1.1.1

## esxi.ansible.local

Role: Vmware ESXi host

Vmware ESXi 6.7U3

Install on local disk

Management network

ip: 192.168.124.10/24
Gateway: 192.168.124.1
DNS: 192.168.124.2
name: esxi.ansible.local

## vcenter.ansible.local

Role: Vmware vcenter

Vmware vcenter appliance 6.7U3

ip: 192.168.124.11/24
Gateway: 192.168.124.1
DNS: 192.168.124.2
name: vcenter.ansible.local
Size: Tiny

### Setup

On ansible.ansible.local log on as root

```bash

dnf install python3-pip git python3-virtualenv libselinux-python3 -y

virtualenv ansible --system-site-packages

source ansible/bin/activate

pip install --upgrade pip

pip install ansible aiohttp

ansible-galaxy collection install vmware.vmware_rest

git clone https://github.com/jesperberth/automationclass_setup.git

cd automationclass_setup/class_room/

ansible-playbook 01_vmware_setup.yml --ask-become-pass

```

Install esxi.ansible.local

Set IP, DNS and Gateway and hostname as esxi.ansible.local

Install VCenter Appliance

You must be able to access via fqdn

Size Tiny

Set IP, DNS and Gateway and hostname as vcenter.ansible.local

Create Datacenter

Add Host esxi.ansible.local

Create Datastore

Create a folder iso - upload fedora iso

Rename esxi storage to esxi-local

Add Licens

Create Folders

\Templates
\Virtual Machines

Create a template vm

Fedora 33

```bash
Create Template
Fedora Server
+ Guest Tools
English(With Danish key)
Use /dev/sda

Add Remote User - user as admin

```

Register the _TEMP_fedora33 and place it in folder \Templates

On ansible.ansible.local log on as user

```bash


```
