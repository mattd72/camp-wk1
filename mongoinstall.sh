#!/bin/bash

# Define the IP addresses of the replica set members
NODE1_PRIVATE_IP="node1-private-ip"
NODE2_PRIVATE_IP="node2-private-ip"
NODE3_PRIVATE_IP="node3-private-ip"

sudo adduser mongod

sudo mkfs -t xfs /dev/xvdb
sudo mkdir /data
sudo mount /dev/xvdb /data
mkdir /data/db
chown mongod:mongod /data/db

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
# Changed in 6.1 MongoDB always enables journaling. As a result, MongoDB removes the storage.journal.enabled option
#  journal:
#    enabled: true

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

sudo chown mongod:mongod /etc/mongod.conf

cat << EOF | /etc/systemd/system/disable-transparent-huge-pages.service
[Unit]
Description=Disable Transparent Huge Pages (THP)
DefaultDependencies=no
After=sysinit.target local-fs.target
Before=mongod.service

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo never | tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null'

[Install]
WantedBy=basic.target
EOF

sudo systemctl daemon-reload
sudo systemctl start disable-transparent-huge-pages

# Restart MongoDB to apply the configuration
sudo systemctl restart mongod

# Enable MongoDB to start on boot
sudo systemctl enable mongod

# Print MongoDB version to verify installation
mongod --version
