# ansible-with-docker
This repository helps you get hands on ansible easily with docker containers.
## Working environment  
In order to help you understand the working environment you will first need to learn the difference between **dind** and **dood**:
- `DinD` includes a whole **Docker installation inside** of it.
- `DooD` uses its underlying host’s Docker installation by **bind-mounting the Docker socket**.

You can see that we have only one DooD Container and at the same time we could have multiple DinD containers running, that would in fact create a **cluster-like** environment. 

**Environment template**  
<p align="center">
  <img src="https://raw.githubusercontent.com/LQss11/dindood/master/env.png" title="environment ">
</p> 

### DinD Configuration
1. Pull a linux Distribution Docker Image.
1. Install few packages that we might need (curl wget..).
1. Install docker and docker-compose.
1. Install OpenSSH.
1. Expose port 22 for ssh.
1. Change root password and update ssh as root permission.
1. Start Dcoker and OpenSSH services.
### Dood Configuration
The configuration is basically the same except that we don't need to install docker or docker compose because simply we have a `/var/run/docker.sock` bind mount.
