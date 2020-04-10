#!/usr/bin/env bash

set -o errexit
set -o pipefail

# for debug purpose
# set -o xtrace 

IP=`cat /tmp/server_IP` 
# kill java process

echo "yes" | ssh root@$IP "cd minecraft && git commit -am \"Automathic commit\" && git push"

curl # destroy server
