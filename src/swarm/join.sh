#!/bin/bash

docker swarm init                                             # Create a docker swarm
WORKER_TOKEN=$(docker swarm join-token worker | grep token)   # get full worker token
MANAGER_TOKEN=$(docker swarm join-token manager | grep token) # get full manager token

if cat /proc/version | grep -q Alpine; then
    # We are using an alpine container
    EI=$(/sbin/ifconfig eth0 | grep inet | cut -f2 -d":" | awk '{ print $1}') # Get inet IP of eth0

else
    # We are using an Ubuntu container
    EI=$(/sbin/ifconfig eth0 | grep inet | awk '{ print $2}') # Get inet IP of eth0

fi

SCAN=$(nmap $EI/24 | grep dindocker)                             # Scan Network
IPS=($(echo "$SCAN" | awk '{ print $6}' | sed 's/.$//; s/^.//')) # Look for the nodes Ip addresses
NAMES=($(echo "$SCAN" | awk '{ print $5}' | cut -f1 -d"."))      # Look for the nodes Containers names

echo "host IP= $EI"

for i in "${!IPS[@]}"; do #loop through IP addresses found

    echo "Hostname= ${NAMES[$i]} | IP= ${IPS[$i]}"
    sshpass -p root ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${IPS[$i]} $WORKER_TOKEN

done
