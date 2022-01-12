# This Dockerfile will:
# Setup and Start (Docker | SSH) services
# Setup minikube and kubectl (Kubernetes)
# Update root user password to root
# Create new user to start minikube

# Pull base image.
FROM ubuntu:20.04

# Avoid on build interaction "noninteractive"
ARG DEBIAN_FRONTEND=noninteractive

# Set User that will start minikube
ARG USERNAME="lqss"

# Install initials
RUN \
  apt-get update && \
  apt-get install -y sudo nmap curl wget vim net-tools openssh-server inetutils-ping sshpass && \
  apt-get install -y apt-transport-https ca-certificates software-properties-common


# Install Docker
RUN \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&\
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" &&\
  apt-cache policy docker-ce &&\
  apt-get install -y docker-ce
  


# install docker-compose
RUN \
  curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
  chmod +x /usr/local/bin/docker-compose

# Install Setup Kubernetes (minikube + kubectl) 
RUN \
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
cp minikube-linux-amd64 /usr/local/bin/minikube && \
chmod +x /usr/local/bin/minikube && \
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \ 
chmod +x kubectl && \
mv kubectl /usr/local/bin/ && \
apt-get install -y conntrack



USER root

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /src/kubernetes

# Expose port for ssh
EXPOSE 22

# Updating root password
RUN echo 'root:root' | chpasswd

# Allowing root login with ssh
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Create new user for minikube start
RUN \
useradd -ms /bin/bash ${USERNAME} && \
usermod -aG docker ${USERNAME} && \
echo "${USERNAME} ALL=(ALL:ALL) ALL" >>/etc/sudoers


# start system with systemd as PID=1
CMD ["/sbin/init"]

