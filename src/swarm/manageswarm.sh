#!/bin/bash

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

echo "#############################################"
echo "Your container Host IP address is: $EI"
echo "#############################################"

echo "The Network contains these with the following hostnames and the IP address:"
echo "#############################################"

for i in "${!IPS[@]}"; do #loop through IP addresses found
    echo "Hostname= ${NAMES[$i]} | IP= ${IPS[$i]}"
done
echo "#############################################"

while read -p "Would you like to add or remove a machine from the swarm [a]dd/[r]emove:" answer; do
    docker node ls &>/dev/null
    if [ $? -eq 0 ]; then
        echo "Swarm already created."
        echo "#############################################"
        echo 'Machines already in swarm'
        docker node ls -q | xargs -n 1 docker node inspect --format '{{ .Description.Hostname}} {{ .Status.Addr}} {{ .Spec.Role }} {{ .Status.State}}'
        echo "#############################################"

    else
        echo "Creating swarm..."
        docker swarm init
    fi

    if [[ $answer == a ]]; then
        while read -p "Choose between [w]orker or [m]anager:" join; do
            echo "Enter the IP address?"
            read machine_ip
            echo "Enter the machine Username? (permissions required)"
            read machine_user
            echo "Enter the Username Password?"
            read machine_password
            if [[ $join == m ]]; then
                echo "Adding manager node to the swarm..."
                MANAGER_TOKEN=$(docker swarm join-token manager | grep token) # get full worker token
                sshpass -p $machine_password ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $machine_user@$machine_ip $MANAGER_TOKEN
            elif [[ $join == w ]]; then
                echo "Adding worker node to the swarm..."
                WORKER_TOKEN=$(docker swarm join-token worker | grep token) # get full worker token
                sshpass -p $machine_password ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $machine_user@$machine_ip $WORKER_TOKEN
            else
                break
            fi

        done

    elif [[ $answer == r ]]; then
        echo "Enter the IP address?"
        read machine_ip
        echo "Enter the machine Username? (permissions required)"
        read machine_user
        echo "Enter the Username Password?"
        read machine_password
        
        echo "Removing node from the swarm..."
        sshpass -p $machine_password ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $machine_user@$machine_ip docker swarm leave -f
        docker node rm -f $(sshpass -p $machine_password ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $machine_user@$machine_ip hostname)
    else
        echo "Wrong input!"
    fi
done
