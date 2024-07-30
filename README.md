# README

## Setup Requirements

* 3 Amazon Linux 2023 EC2 instances.  If using AL2 then you will need to change the mongodb-enterprise-7.0 repo to match that in the install guide.
** Note - baseurl explicitly includes the the architecture, in this case x86_64, because $basearch is not resolved when running in bash

* 3 EBS volumes, each attached to one of the EC2 instances above.  Tested on gp2 volumes.

* Create a keyfile
  * KEYFILE_CONTENT=$(openssl rand -base64 756)
  * echo KEYFILE_CONTENT >> /opt/mongo-keyfile
  * chmod 600 /opt/mongo-keyfile
  * copy keyfile to each node, make sure permissions and ownership are set per above

* what did I miss?

## Files

* mongoinstall.sh
  * create mongod user
  * change ownership of keyfile to mongod user
  * mount the attached ebs volume, create the data filesystem
  * create /data/db director
  * create the mongod-enterprise-7.0 repo file
  * install mongodb
  * replace the /etc/mongod.conf
  * change ownership of mongod.conf to mongod user
  * create service file to disable transparent huge pages
  * reload daemons
  * start disable-transparent-huge-pages service
  * restart mongod service
  * print out mongod version

* mongosetup.sh
  * start mongosh to run setupreplset.js
  * pull down sample dataset
  * run mongorestore against the sample dataset directory
 
* setupreplset.js
  * Set up the replicaset
    * NOTE - Update the script with the node IP addresses or domain names
  * Wait for 120 s for replset to be initialized
  * create the admin password
 
 ## Troubleshooting

 * SSL error starting mongosh
   * mongosh: OpenSSL configuration error: 001908B0DC7F0000:error:030000A9:digital envelope routines
   * Do the following:
     * sudo yum remove mongodb-mongosh
     * sudo yum install mongodb-mongosh-shared-openssl3
     * sudo yum install mongodb-mongosh
