## Setup docker Swarm 
This section will help you learn more about how to set up docker swarm and manage it easily 

## Scrupts
**join.sh** will allow you to simply lookup for all other containers within the same network, create a new swarm and ssh to join all other containers (DIND) in that swarm in few seconds.

**purge.sh** will help you remove the swarm created and leave it from all other machines within same network

### Manage docker swarm (PORTAINER)
In order to manage a swarm using portainer you will first need to run **./join.sh** scrip, then once the swarm is up and ready you can verify that it has been created typing `docker node ls`, and now we are going to create the portainer services by running this command inside **/src/swarm** directory:
```sh
./join.sh && docker stack deploy -c portainer-agent-stack.yml portainer
```
this will in fact share the port 9000 from container to 9000 in DinD container then from 9000 to 3900 in host machine and now you can try to visit
```
localhost:39000
``` 