#!/bin/bash

# Define the IP addresses of the replica set members
NODE1_PRIVATE_IP="node1-private-ip"
NODE2_PRIVATE_IP="node2-private-ip"
NODE3_PRIVATE_IP="node3-private-ip"

# Import the MongoDB public GPG key
sudo rpm --import https://www.mongodb.org/static/pgp/server-7.0.asc

# Create a MongoDB repository file
cat <<EOF | sudo tee /etc/yum.repos.d/mongodb-enterprise.repo
[mongodb-enterprise]
name=MongoDB Enterprise Repository
baseurl=https://repo.mongodb.com/yum/amazon/2/mongodb-enterprise/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
EOF

# Install MongoDB Enterprise
sudo yum install -y mongodb-enterprise

# Create the mongod.conf file
cat <<EOF | sudo tee /etc/mongod.conf
# mongod.conf

# Where and how to store data.
storage:
  dbPath: /data/db
  journal:
    enabled: true

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0  # Listen on all IPs

# process management options
processManagement:
  fork: true  # Forks the process and run MongoDB in the background

# security settings
security:
  authorization: enabled  # Enable Role-Based Access Control (RBAC)

# replication options
replication:
  replSetName: rs0  # Name of the replica set

# Set the oplog size (optional, 50MB by default)
# replication:
#   oplogSizeMB: 1024
EOF

# Restart MongoDB to apply the configuration
sudo systemctl restart mongod

# Enable MongoDB to start on boot
sudo systemctl enable mongod

# Print MongoDB version to verify installation
mongod --version