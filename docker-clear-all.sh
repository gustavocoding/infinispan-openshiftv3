#!/bin/sh

docker ps -a -q | xargs -n 1 -I {} docker rm -f {}
docker rmi $(docker images -q)
