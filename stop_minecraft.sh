#!/usr/bin/env bash

RED='\033[0;31m'
ORANGE='\033[0;33m'
BLUE='\033[1;36m'
NC='\033[0m' # No Color

IP=`cat /tmp/server_IP` 
vps_id=`cat /tmp/vps_id`
# kill java process
echo -e "${ORANGE}Try to kill running server${NC}"
ssh -o StrictHostKeyChecking=no root@$IP "chmod +x ~/minecraft/kill_java && ~/minecraft/kill_java"

echo -e "${BLUE}Add, commit and push changes${NC}"
ssh -o StrictHostKeyChecking=no root@$IP "cd ~/minecraft && git add my-server/"
ssh -o StrictHostKeyChecking=no root@$IP "cd ~/minecraft && git commit -m \"Automatic commit\" && git push origin master"

sleep 15
echo -e "${ORANGE}Destroy Vultr instance${NC}"
curl -s -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/destroy --data "SUBID=$vps_id"
rm -Rf /tmp/server_IP /tmp/vps_id
