#!/bin/bash

EI=$(/sbin/ifconfig eth0 | grep inet | awk '{ print $2}') # Get inet IP of eth0
SCAN=$(nmap $EI/24 | grep dindood)
IPS=($(echo "$SCAN" | awk '{ print $6}' | sed 's/.$//; s/^.//')) # Look for the nodes Ip addresses
NAMES=($(echo "$SCAN" | awk '{ print $5}' | cut -f1 -d"."))      # Look for the nodes Containers names

echo "host IP= $EI"
docker swarm leave -f

for i in "${!IPS[@]}"; do #loop through IP addresses found

    echo "Hostname= ${NAMES[$i]} | IP= ${IPS[$i]}"
    sshpass -p root ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@${IPS[$i]} docker swarm leave -f

done
