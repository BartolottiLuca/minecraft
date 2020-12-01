#!/usr/bin/env bash

RED='\033[0;31m'
ORANGE='\033[0;33m'
BLUE='\033[1;36m'
NC='\033[0m' # No Color

set -o errexit
set -o pipefail

os_id=387 # ubuntu 20.04
region_id=8 # london
# 401 -> 1 CPU 2GB ram HIGH FREQ
# 202 -> 1 CPU 2GB ram SSD
# 203 -> 2 CPU 4GB ram SSD
plan_id=203

echo -e "${BLUE}Trigger the Vultr server creation${NC}"
vps_id=`curl -s -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/create --data "DCID=$region_id" --data "SSHKEYID=$VULTR_SSH_KEY_ID" --data "VPSPLANID=$plan_id" --data "OSID=$os_id" | cut -d: -f2 | cut -d} -f1 | cut -d\" -f2 `
sleep 10
ready=0
i=0
while [ $ready -eq 0 ] && [ $i -le 20 ]; do
    readiness=`curl -s -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/list#SUBID=$vps_id | awk -F 'status\":' '{print $2}' | cut -d, -f1 | cut -d\" -f2`
    state=`curl -s -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/list#SUBID=$vps_id | awk -F 'server_state\":' '{print $2}' | cut -d, -f1 | cut -d\" -f2`
    if [ $readiness = "active" ] && [ $state = "ok" ]; then
        ready=1
    else
        i=$[ $i + 1 ]
        echo -e "${ORANGE}${i}: Sleep another 30 seconds${NC}"
        sleep 30
    fi
done

if [ $ready -eq 0 ]; then
    echo -e "${RED}server not ready after 6 minutes, DELETE THE MF MANUALLY${NC}"
    exit 1
fi

IP=`curl -s -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/list#SUBID=$vps_id | awk -F 'main_ip\":' '{print $2}' | cut -d, -f1 | cut -d\" -f2`
echo "IP of server $IP"
echo $vps_id > /tmp/vps_id
echo $IP > /tmp/server_IP

scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa root@$IP:/root/.ssh/
ssh -o StrictHostKeyChecking=no root@$IP "chmod 600 ~/.ssh/id_rsa"
ssh -o StrictHostKeyChecking=no root@$IP "apt-get update && apt-get install openjdk-8-jdk-headless -y"
ssh -o StrictHostKeyChecking=no root@$IP 'echo -e "Host github.com\n\tStrictHostKeyChecking" no > ~/.ssh/config'
ssh -o StrictHostKeyChecking=no root@$IP "git clone git@github.com:BartolottiLuca/minecraft.git"

echo -e "${BLUE}SERVER IP: ${RED} $IP ${NC}"

ssh -o StrictHostKeyChecking=no root@$IP "cd ~/minecraft/my-server/ && java -Xms1G -Xmx3G -jar server.jar nogui"
