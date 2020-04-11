#!/usr/bin/env bash

set -o errexit
set -o pipefail

# for debug purpose
# set -o xtrace 

os_id=365 # ubuntu 19.04
region_id=8 # london
# 401 -> 1 CPU 2GB ram HIGH FREQ
# 202 -> 1 CPU 2GB ram SSD
# 203 -> 2 CPU 4GB ram SSD
plan_id=203

vps_id=`curl -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/create --data "DCID=$region_id" --data "SSHKEYID=$VULTR_SSH_KEY_ID" --data "VPSPLANID=$plan_id" --data "OSID=$os_id" | cut -d: -f2 | cut -d} -f1 | cut -d\" -f2 `

ready=0
i=0
while [ $ready -eq 0 ] && [ $i -le 18 ]; do
    readiness=`curl -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/list#SUBID=$vps_id | awk -F 'status\":' '{print $2}' | cut -d, -f1 | cut -d\" -f2`
    state=`curl -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/list#SUBID=$vps_id | awk -F 'server_state\":' '{print $2}' | cut -d, -f1 | cut -d\" -f2`
    if [ $readiness = "active" ] && [ $state = "ok" ]; then
        ready=1
    else
        i=$[ $i + 1 ]
        echo "sleep another 10 seconds"
        sleep 10
    fi
done

if [ $ready -eq 0 ]; then
    echo "server not ready after 3 minutes, DELETE THE MF MANUALLY"
    exit 1
fi

IP=`curl -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/list#SUBID=$vps_id | awk -F 'main_ip\":' '{print $2}' | cut -d, -f1 | cut -d\" -f2`
echo "IP of server $IP"
echo $vps_id > /tmp/vps_id
echo $IP > /tmp/server_IP

echo "SERVER IP: $IP"
scp -o StrictHostKeyChecking=no ~/.ssh/id_rsa root@$IP:/root/.ssh/ 
ssh -o StrictHostKeyChecking=no root@$IP "sudo apt-get install openjdk-8-jdk-headless -y && git clone git@github.com:BartolottiLuca/minecraft.git && cd minecraft && java -Xms1G -Xmx2G -jar server.jar nogui "
