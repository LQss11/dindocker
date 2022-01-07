#!/bin/bash

re='^[0-9]+$'

while
    echo 'how many nodes you want to join to the swarm?'
    read nodes
do

    if ! [[ $nodes =~ $re ]]; then
        echo "error: Not a number" >&2
        exit 1
    else
        docker swarm init                                             # Create a docker swarm
        WORKER_TOKEN=$(docker swarm join-token worker | grep token)   # get full worker token
        MANAGER_TOKEN=$(docker swarm join-token manager | grep token) # get full manager token
        for i in $(seq $nodes); do
            ip=$(ping -c1 dindood_cluster_agent_$i | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p')
            echo "dindood_cluster_agent_$i | $ip"

            sshpass -p root ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$ip $WORKER_TOKEN
        done
        break
    fi
done
