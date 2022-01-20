# This Dockerfile will:
# Setup and Start (SSH) service
# Update root user password to root

# Pull base image.
FROM docker:dind

# User that will start minikube
ARG USERNAME=minikube

# Install initials
RUN \
  apk update && \
  apk add curl wget nmap net-tools iputils sshpass bash sudo

# Setup SSH Service
RUN \
    apk add openssh-server && \
    apk add openrc --no-cache && \
    rc-update add sshd && \
    rc-status && \
    touch /run/openrc/softlevel 
#
RUN \
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && \
cp minikube-linux-amd64 /usr/local/bin/minikube && \
chmod +x /usr/local/bin/minikube && \
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \ 
chmod +x kubectl && \
mv kubectl /usr/local/bin/ 

# Expose port for ssh
EXPOSE 22

# Define working directory.
WORKDIR /src

# Updating root password
RUN echo 'root:root' | chpasswd

# Allowing root login with ssh
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# Create new user for minikube start
RUN adduser -D -s /bin/bash ${USERNAME} && \
yes ${USERNAME} | passwd ${USERNAME} && \
echo "${USERNAME} ALL=(ALL:ALL) ALL" >>/etc/sudoers && \
addgroup docker && \
addgroup ${USERNAME} docker 

# Systemd PID 1
RUN nohup /sbin/init &
#ENTRYPOINT [ "dockerd-entrypoint.sh" ]
#USER minikube
#CMD [ "sh", "-c", "echo minikube | sudo -S dockerd-entrypoint.sh  && bash " ]
#ENTRYPOINT [ "echo minikube | sudo -S -u minikube -c whoami" ]
#ENTRYPOINT [ "dockerd-entrypoint.sh" ]
CMD [ "sh", "-c", "service sshd restart &&  dockerd-entrypoint.sh && bash" ]

#CMD [ "sh", "-c", "su - minikube ; minikube start && dockerd-entrypoint.sh && bash " ]

