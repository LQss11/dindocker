# This Dockerfile will:
# Setup and Start (SSH | Docker) services
# Update root user password to root

# Pull base image.
FROM ubuntu:20.04

# Avoid on build interaction "noninteractive"
ARG DEBIAN_FRONTEND=noninteractive

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

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /src

# Expose port for ssh
EXPOSE 22

# Updating root password
RUN echo 'root:root' | chpasswd

# Allowing root login with ssh
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Remove Cache
RUN rm -rf /var/cache/apt/*

# Start SSH  service then use bash
# Define default command.
CMD ["sh" , "-c", "service ssh restart && service docker start && bash"]