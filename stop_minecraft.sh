#!/usr/bin/env bash

# lol

# set -o errexit
# set -o pipefail

# for debug purpose
# set -o xtrace 

IP=`cat /tmp/server_IP` 
vps_id=`cat /tmp/vps_id`
# kill java process
ssh -o StrictHostKeyChecking=no root@$IP "~/minecraft/kill_java"

ssh -o StrictHostKeyChecking=no root@$IP "cd ~/minecraft && tar cvzf my-server.tar my-server/"
ssh -o StrictHostKeyChecking=no root@$IP "cd ~/minecraft && git commit -am \"Automatic commit\" && git push"

sleep 15
curl -H "API-Key: $VULTR_API_KEY" https://api.vultr.com/v1/server/destroy --data "SUBID=$vps_id"
