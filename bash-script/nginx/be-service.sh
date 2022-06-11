#!/bin/bash

# Create a new project directory:
cd var/
# var/projects/ := { be, fe }
sudo mkdir projects
# Change project owner to be the ec2-user:
sudo chown ec2-user:ec2-user projects/

# Copy recursive, update, verbose source code to the destination file:
rsync -ruv --rsh 'ssh -p 443' source_code centos@11:11:11:11:/home/centos/

# Install nginx:
sudo amazon-linux-extras install nginx1
# Config for nginx can be automatically started the server:
sudo systemctl enable nginx.service
mv ~/fe-service.conf ~/etc/nginx/conf.d

# Install Java:
sudo amazon-linux-extras install java-openjdk11
# Run BE like a service:
mv ~/be.service ~/etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable be.service
sudo systemctl start be.service
