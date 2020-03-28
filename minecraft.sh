#!/usr/bin/env bash

set -o errexit
set -o pipefail

# for debug purpose
# set -o xtrace 

base_url = "https://api.vultr.com/"

curl () {
    local url="$1"
    res=$('curl --silent --head --output /dev/null --write-out "%{http_code}\n" "$url"')
    return stuff 

}

start_server () {

}

stop_server () {

}

install_minecraft_dependencies () {

}

install_minecraft () {

}

start_minecraft () {

}

stop_minecraft () {

}

pull_world () {

}

push_world () {

}

start () {
    
}

stop () {

}

action=$1
if [ "$action" == "start" ]; then
    #start server on Vultr

    #install all dependencies

    #install minecraft

    #pull world

    #start minecraft

    #print out IP
