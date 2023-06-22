#/bin/sh

# Usage
#
# Create AWX servers for Ansible training
#
#
# Author: Jesper Berth, jesper.berth@arrow.com - june 2023
YELLOW='\033[0;33m'
NC='\033[0;0m'

echo -e "#################################"
echo -e "#  ${YELLOW}Deploy AWX servers${NC}           #"
echo -e "#################################\n"

echo -e "How many instances?\n"
read INSTANCES

for (( i=1 ; i<=$INSTANCES ; i++ ));
    do
        echo -e "tower$i"
    done

# ansible-playbook -e "" 00_azure_tower_deploy.yml

# ansible-galaxy install jesperberth.el_k3s -f
# ansible-galaxy install jesperberth.awx_k8s_install -f

# ansible-playbook -i inventory.azure_rm.yml install_awx.yml