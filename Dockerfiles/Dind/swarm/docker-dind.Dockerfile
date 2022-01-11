# This Dockerfile will:
# Setup and Start (SSH) service
# Update root user password to root

# Pull base image.
FROM docker:dind

# Install initials
RUN \
  apk update && \
  apk add curl wget nmap net-tools iputils sshpass bash

# Setup SSH Service
RUN \
    apk add openssh-server && \
    apk add openrc --no-cache && \
    rc-update add sshd && \
    rc-status && \
    touch /run/openrc/softlevel 

# Expose port for ssh
EXPOSE 22

# Define working directory.
WORKDIR /src/swarm

# Updating root password
RUN echo 'root:root' | chpasswd

# Allowing root login with ssh
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Start SSH Service & Run the entrypoint script
CMD [ "sh", "-c", "service sshd restart &&  dockerd-entrypoint.sh && bash" ]
