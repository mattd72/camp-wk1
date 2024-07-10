#!/bin/bash

# Import the MongoDB public GPG key
sudo rpm --import https://www.mongodb.org/static/pgp/server-7.0.asc

# Create a MongoDB repository file
cat <<EOF | sudo tee /etc/yum.repos.d/mongodb-enterprise.repo
[mongodb-enterprise-7.0]
name=MongoDB Enterprise Repository
baseurl=https://repo.mongodb.com/yum/amazon/2/mongodb-enterprise/7.0/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-7.0.asc
EOF

# Install MongoDB Enterprise
sudo yum install -y mongodb-enterprise

# Start MongoDB
sudo systemctl start mongod

# Enable MongoDB to start on boot
sudo systemctl enable mongod

# Print MongoDB version to verify installation
mongod --version
