#!/bin/bash

re='^[0-9]+$'

while
    echo 'select the same number of nodes u used to join for swarm?'
    read nodes
do

    if ! [[ $nodes =~ $re ]]; then
        echo "error: Not a number" >&2
        exit 1
    else
        for i in $(seq $nodes); do
            ip=$(ping -c1 dindood_cluster_agent_$i | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p')
            echo "dindood_cluster_agent_$i | $ip"
            sshpass -p root ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$ip docker swarm leave -f
        done
        docker swarm leave -f
        break
    fi
done
