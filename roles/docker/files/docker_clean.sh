#!/bin/bash

docker rm $(docker ps -a -q) &>/dev/null

docker images -q --filter "dangling=true" | xargs -n1 -r docker rmi
