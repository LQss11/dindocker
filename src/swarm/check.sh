#!/bin/bash

check_swarm() {
    docker node ls &>/dev/null
    if [ $? -eq 0 ]; then
        echo "already in a swarm"
        join_machines
    else
        create_swarm
    fi

}

create_swarm() {
    read -p "Node is not a part of a swarm, Would you like to create a new docker swarm (y)es/(n)o [0 if done]" cr_swarm
    case "$cr_swarm" in
    y)
        docker swarm init &>/dev/null
        if [ $? -eq 0 ]; then
            echo "Swarm created successfully"
            join_machines
        else
            echo "Something wrong"
        fi
        ;;
    n)
        exit
        ;;
    esac
}

join_machines() {
    WORKER_TOKEN=$(docker swarm join-token worker | grep token)   # get full worker token
    MANAGER_TOKEN=$(docker swarm join-token manager | grep token) # get full manager token

    #echo "Please Enter the IP address and the user of the machine"
    while read -p "Would you like to join a machine (y)es/(n)o" answer; do

        if [[ $answer == y ]]; then
            # List containers IP addresses (machines)
            docker ps -q | xargs -n 1 docker inspect --format '{{ .Name }} {{range .NetworkSettings.Networks}} {{.IPAddress}}{{end}}' | grep agent | sed 's#^/##'
            echo "Enter the IP address?"
            read machine_ip
            echo "Enter the machine User?"
            read machine_user
            echo "Enter the User Password?"
            read machine_password
            echo "(m)anager or (w)orker node?"
            read answer
            if [[ $answer == m ]]; then
                sshpass -p $machine_password ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $machine_user@$machine_ip $MANAGER_TOKEN
            elif [[ $answer == w ]]; then
                sshpass -p $machine_password ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $machine_user@$machine_ip $WORKER_TOKEN
            fi

        elif [[ $answer == n ]]; then
            break
        else
            echo "Wrong input!"
        fi
    done

}

create_swarm2() {
    while read -p "Node is not a part of a swarm, Would you like to create a new docker swarm (y)es/(n)o [0 if done]" cr_swarm; do
        case "$cr_swarm" in
        Yes)
            docker swarm init &>/dev/null
            if [ $? -eq 0 ]; then
                echo "Swarm created successfully, would you like to join nodes to the swarm? (Yes/No)"

            else
                echo "Something wrong"
            fi
            ;;
        No)
            ls
            ;;
        0)
            echo "nice"
            break
            ;;
        esac
    done
}

main() {
    check_swarm
}

main "$@"
