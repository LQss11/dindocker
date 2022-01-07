#!/bin/bash

# Get list of Ip adresses of all machines created from compose.
IPS=$(docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | grep cluster | cut -d' ' -f2-)

for ip in $IPS; do
    echo "$ip"
    # leave swarm if already in one
    sshpass -p root ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$ip docker swarm leave -f
done
