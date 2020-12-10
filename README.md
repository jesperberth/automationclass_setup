# Azure Class Setup

## Create users in azure

Open a azure cloud shell

Run in Powershell

```bash
cd clouddrive

git clone https://github.com/jesperberth/automationclass_setup.git

cd automationclass_setup

setup_users.ps1

```

# Class Setup

## Fortigate 60E

Use Wan1/Wan2 for internet access

Plug ansiblehost in port 7

Plug Wireless AP in port 6

Plug Vmware Host in port 5

## ansiblehost.ansible.local

Only for course admin

Role: DNS, DHCP, ansible for setting up classroom, Firewall, Vmware environment

Install on local VM, or laptop

Fedora 31

Minimal install

root user

additional user: xxx

ip: 10.172.10.2/24

Gateway: 10.172.10.1

DNS 1.1.1.1

## esxi.ansible.local

Role: Vmware ESXi host

Intel NUC
32GB Ram, 500Gb Nvme
Vmware ESXi 6.7U3

Install on local disk

Management network

Vlan 24

ip: 10.172.1.10/24
Gateway: 10.172.1.1
DNS: 10.172.10.2
name: esxi.ansible.local

## vcenter.ansible.local

Role: Vmware vcenter

Vmware vcenter appliance 6.7U3

ip: 10.172.10.11/24
Gateway: 10.172.10.1
DNS: 10.172.10.2
name: vcenter.ansible.local
Size: Tiny

## storage.ansible.local

Role: NFS storage server for esxi host

Fedora 31 - deployed from template

Virtual Machine running on ESXi
2 CPU
4Gb Mem
Disk 1 16Gb - Thin
Disk 2 120Gb - Thin

ip: 10.172.10.12/24
Gateway: 10.172.10.1
DNS: 10.172.10.2
name: storage.ansible.local

## ansibleserver.ansible.local

Role: Lab users ansible server

Fedora 31 - deployed from template

ip: 10.172.10.22/24
Gateway: 10.172.10.1
DNS 10.172.10.2
name: ansibleserver.ansible.local

### Setup

On ansiblehost.ansible.local log on as user

```bash

sudo dnf update -y

sudo dnf install libselinux-python -y
sudo dnf install python3-pip git -y

virtualenv ansible --system-site-packages

source ansible/bin/activate

pip install pip

pip install ansible
pip install pyvmomir
pip install fortiosapi

ssh-keygen

git clone https://github.com/jesperberth/automationclass_setup.git

cd automationclass_setup/class_room/

ansible-playbook 01_class_setup.yml --ask-become-pass

```

Install esxi.ansible.local

On esxi.ansible.local

Set Management network to 24

Deploy vcenter

Manual Configure vcenter

Make folder iso
Upload fedora_31_x86_64.iso

Upload or Create Fedora 31 Template

```bash
Create Template
Fedora Server
+ Guest Tools
English(With Danish key)
Use /dev/sda

Add Remote User - user as admin

```

Create VM Folder

\Templates
\Admin

Place vcenter.ansible.local in folder \admin
Register the _TEMP_fedora31 and place it in folder \Templates

On ansiblehost.ansible.local log on as user

Now deploy the storage server, ansible server, and make esxi configurations

```bash

ansible-playbook 02_class_setup.yml --ask-become-pass

ansible-playbook 03_class_network_setup.yml

```
