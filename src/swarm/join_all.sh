#!/bin/bash

# Get list of Ip adresses of all machines created from compose.
IPS=$(docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | grep agent | cut -d' ' -f2-)

docker swarm init --advertise-addr 192.168.65.3
WORKER_TOKEN=$(docker swarm join-token worker | grep token)   # get full worker token
MANAGER_TOKEN=$(docker swarm join-token manager | grep token) # get full manager token

for ip in $IPS; do
    echo "$ip"
    # leave swarm if already in one
    sshpass -p root ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$ip $WORKER_TOKEN
done
