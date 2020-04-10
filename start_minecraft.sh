#!/usr/bin/env bash

set -o errexit
set -o pipefail

# for debug purpose
# set -o xtrace 

os_id=365 # ubuntu 19.04
region_id=8 # london
plan_id=401 # 1 CPU 2 GB ram
shh_key_id=5e8770952ec41 # luca_xps key

vps_id=`curl -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/create --data "DCID=$region_id" --data "SSHKEYID=$shh_key_id" --data "VPSPLANID=$plan_id" --data "OSID=$os_id" | cut -d: -f2 | cut -d} -f1 | cut -d\" -f2 `
sleep 60

IP=`curl -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/list#SUBID=$vps_id | awk -F 'main_ip\":' '{print $2}' | cut -d, -f1 | cut -d\" -f2`
ehco "IP of server $IP"
echo $IP > /tmp/server_IP

echo "yes" | scp ~/.ssh/id_rsa root@$IP:/root/.ssh/ 
echo "yes" | ssh root@$IP "sudo apt-get install openjdk-8-jdk-headless -y && git clone git@github.com:BartolottiLuca/minecraft.git && cd minecraft && java -Xms1G -Xmx1G -jar server.jar nogui "
