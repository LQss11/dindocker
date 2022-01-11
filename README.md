# dindocker
`DinDocker` helps you play around with a cluster of nodes as docker containers.
## Working environment  
In order to help you understand the working environment you will first need to learn the difference between **dind** and **dood**:
- `DinD` includes a whole **Docker installation inside** of it.
- `DooD` uses its underlying host’s Docker installation by **bind-mounting the Docker socket**.

You can see that we have only one DooD Container and at the same time we could have multiple DinD containers running, that would in fact create a **cluster-like** environment. 

**Environment template**  
<p align="center">
  <img src="https://raw.githubusercontent.com/LQss11/dindocker/master/env.png" title="environment ">
</p> 

### DinD Configuration
1. Pull a linux Distribution Docker Image.
1. Install few packages that we might need (curl wget..).
1. Install docker and docker-compose.
1. Install OpenSSH.
1. Expose port 22 for ssh.
1. Change root password and update ssh as root permission.
1. Start Dcoker and OpenSSH services.
Also one of the important things about it is that all the containers created as dind share the same images through the docker compose configuration through a volume called docker-storage.
### Dood Configuration
The configuration is basically the same except that we don't need to install docker or docker compose because simply we have a `/var/run/docker.sock` bind mount.
## Quick Start
In order to create your cluster with one **controller (DooD)** and multiple **agents (DinD)** as you can specify the number of agents you need, you can run:
```sh
docker-compose -p dindocker_cluster up -d --scale agent=2 --build
```
Now that you have your cluster up you can rescale the number of agents by running the same command with `--no-recreate` flag that will avoid recreating old containers (nodes):
```sh
docker-compose -p dindocker_cluster up -d --scale agent=4 --no-recreate
```
Once you are done with the cluster you can stop it by running:
```sh
docker-compose -p dindocker_cluster down
```
### Expose ports
In order to work with containers inside containers and get their output on your web browser for example you will need first to expose some ports, let's say for example you are using `nginx` container where it exposes port **80** so first in the dind configuration in the docker file you can map ports or just specify a range of maps like this:
```yaml
    ports:
      - "30080-30099:80-99" 
```
OR dynamic mapping:
```yaml
    ports:
      - "80-99" 
```
This will help you get ports mapped one by one if you are willing to work with multiple applications inside the Dind containers
>If you need to expose more ports from a container you can add `expose ` followed by the ports you want your container to expose so then you could map them later.
#### Set Up Portainer
Now that you once all your environment is running and you are willing to manage docker env easily from your web browser make sure to:
- have enough ports to map from the container inside the container in this example we have these ports host machine docker engine available
```yaml
    ports:
      - "30080-30081:80-81" # on host machine 30080 30081 is listening to the port 80 and 81 from container
```
- Get inside the dind container (eg controller as dind), then run these commands to create portainer volume then run container and attach its ports to your host machine:
```sh
docker exec -it dindocker_cluster_controller_1 sh -c "docker volume create portainer_data && docker run -d -p 80:8000 -p 81:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce"
```
  - dind will pull portainer image then run container and map ports as mentioned and now you can manage Dind from your host machine: localhost:30081