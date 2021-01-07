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

On ansible.ansible.local log on as user

```bash

sudo dnf update -y

sudo dnf install libselinux-python -y
sudo dnf install python3-pip git -y

virtualenv ansible --system-site-packages

source ansible/bin/activate

pip install pip

pip install ansible

ssh-keygen

git clone https://github.com/jesperberth/automationclass_setup.git

cd automationclass_setup/class_room/

ansible-playbook 01_class_setup.yml --ask-become-pass

```

Install esxi.ansible.local

On esxi.ansible.local

Make folder iso
Upload fedora_33_x86_64.iso

Upload or Create Fedora 33 Template

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

Register the _TEMP_fedora33 and place it in folder \Templates

On ansible.ansible.local log on as user

```bash

ansible-playbook 02_class_setup.yml --ask-become-pass

ansible-playbook 03_class_network_setup.yml

```
