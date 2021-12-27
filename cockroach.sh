#!/bin/bash

echo "Cockroach Auto Installer by RabinsXP";
echo "";
echo "::: Rabins Cockroach DB Tools :::";
echo "1: Install Cockroach-db";
echo "2: Configure Certificates";
echo "3: Start Secure Node";
echo "4: Join Secure Node";
echo "5: Stop Secure Node";
echo "6: Create Secure User";
read action;

#install cockroach
if [ $action == "1" ]
then
# wget -o- https://binaries.cockroachdb.com/cockroach-v1.0.2.linux-amd64.tgz
wget -o- https://binaries.cockroachdb.com/cockroach-latest.linux-amd64.tgz

tar xfz cockroach-latest.linux-amd64.tgz
cp -i cockroach-v21.2.3.linux-amd64/cockroach /usr/local/bin
cockroach version
#create certs

elif [ $action == "2" ]
then
mkdir certs
mkdir safe
echo "Directorys created, genetrating certs";
cockroach cert create-ca --certs-dir=certs --ca-key=safe/ca.key
cockroach cert create-client root --certs-dir=certs --ca-key=safe/ca.key
echo "Hostname -->";
read hostname
cockroach cert create-node $hostname --certs-dir=certs --ca-key=safe/ca.key
#start node

elif [ $action == "3" ]
then
echo "Hostname -->";
read hostname;
cockroach start --certs-dir=certs --host=$hostname &
#join secure node

elif [ $action == "4" ]
then
echo "Local Hostname -->";
read lhost;
echo "Remote Hostname -->";
read rhost;
cockroach start --certs-dir=certs --host=$lhost --join=$rhost:26257 &
#stop secure node

elif [ $action == "5" ]
then
echo "Hostname -->";
read rhost;

cockroach quit --certs-dir=certs --host=$rhost

#create secure user

elif [ $action == "6" ]
then
echo "Username -->";
read username;
echo "Hostname -->";
read hostname
cockroach user set $username --certs-dir=certs --host=$hostname --password
cockroach cert create-client $username --certs-dir=certs --ca-key=safe/ca.key
fi