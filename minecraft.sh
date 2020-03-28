#!/usr/bin/env bash

set -o errexit
set -o pipefail

# for debug purpose
# set -o xtrace 

curl () {
    local url="$1"
    curl --silent --head --output /dev/null --write-out "%{http_code}\n" "$url"
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