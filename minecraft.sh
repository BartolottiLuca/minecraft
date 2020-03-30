#!/usr/bin/env bash

set -o errexit
set -o pipefail

# for debug purpose
# set -o xtrace 

base_url="https://api.vultr.com/"

check_code () {
    code=$1
    if [[code -gt 399]]; then
        # make everything blow up, prefere
}

get () {
    url="$1"
    res=$(curl -H "API-Key: $VULTR_API_KEY" $url)
    code=$?
}


post () {
    url="$1"
    res=$(curl -H "API-Key: $VULTR_API_KEY" $url)
    code=$?
}

start_server () {
    echo "TODO"

}

stop_server () {
    echo "TODO"

}

install_minecraft_dependencies () {
    echo "TODO"

}

install_minecraft () {
    echo "TODO"

}

start_minecraft () {
    echo "TODO"

}

stop_minecraft () {
    echo "TODO"

}

pull_world () {
    echo "TODO"

}

push_world () {
    echo "TODO"

}

start () {
        echo "TODO"

}

stop () {
    echo "TODO"

}

action=$1
if [ "$action" == "start" ]; then
    echo "starting"
    #start server on Vultr

    # setup DNS

    #install all dependencies

    #install minecraft

    #pull world

    #start minecraft

    #print out IP
elif [ "$action" == "stop" ]; then
    echo "stopping"
    # stop minecraft

    # commit and push the world in the repo

    # destroy DNS

    # destroy server
else
    echo "invalid argument, valid arguments are start and stop"
fi