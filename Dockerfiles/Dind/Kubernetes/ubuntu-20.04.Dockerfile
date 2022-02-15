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
ARG USERNAME=minikube

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

# Setup minikube 
RUN \
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
cp minikube-linux-amd64 /usr/local/bin/minikube && \
chmod +x /usr/local/bin/minikube && \
rm minikube-linux-amd64

# Setup kubernetes/kubeadm/kubelet 
RUN \
apt-get update && apt-get install -y apt-transport-https &&\
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - &&\
# Add Kubernetes entry list
echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list &&\
apt-get update &&\
apt-get install -y kubelet=1.22.5-00 kubeadm=1.22.5-00 kubectl=1.22.5-00


#RUN sudo usermod -aG docker $USER
#RUN sudo swapoff -a 
#RUN sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab 
#RUN sudo systemctl restart kubelet
# Set SELinux in permissive mode (effectively disabling it)
#RUN sudo setenforce 0
#RUN sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
# RUN \
  # mkdir -p $HOME/.kube && \
  # sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && \
  # sudo chown $(id -u):$(id -g) $HOME/.kube/config
#RUN kubeadm join 172.24.222.59:6443 --token fv5jwm.317ou7qrmbkrx1y7 \
#        --discovery-token-ca-cert-hash sha256:d2b8e52cec287d0e0e3ab7ff038f970530a88e4415cd42c93cb5644bf5127a67
# RUN kubeadm token create --print-join-command 

# When setting up if some issue encountered  when running kubeadm init
# you can run kubeadm reset 
# then you might want to try this https://stackoverflow.com/questions/52119985/kubeadm-init-shows-kubelet-isnt-running-or-healthy

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
useradd -ms /bin/bash -g docker ${USERNAME} && \
echo "${USERNAME} ALL=(ALL:ALL) ALL" >>/etc/sudoers
RUN echo ${USERNAME}:${USERNAME} | chpasswd

# Remove Cache
RUN rm -rf /var/cache/apt/*

# start system with systemd as PID=1
CMD [ "/sbin/init" ]