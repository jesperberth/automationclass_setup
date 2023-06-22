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

LIST=""
VAR=""
SERVERS=""
PRE=tower
POST="\n"

for (( i=1 ; i<=$INSTANCES ; i++ ));
    do
        LIST+=$PRE$i$POST
    done
#echo $LIST
VAR=$(printf $LIST)
echo $VAR
SERVERS=$(jq -n -c -M --arg var "$VAR" '{"servers": ($var|split("\n"))}')
TOWER=\'$SERVERS\'
ansible-playbook -e $TOWER 0_azure_tower_deploy.yml

# ansible-galaxy install jesperberth.el_k3s -f
# ansible-galaxy install jesperberth.awx_k8s_install -f

# ansible-playbook -i inventory.azure_rm.yml install_awx.yml

# LIST="tower1\ntower2\ntower3\n"


# VAR=$(printf $LIST)
# SERVERS=$(jq -n -c -M --arg var "$VAR" '{"servers": ($var|split("\n"))}')
# echo \'$SERVERS\'



