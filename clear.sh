#!/bin/sh

docker ps -a -q | xargs -n 1 -I {} docker rm -f {}

