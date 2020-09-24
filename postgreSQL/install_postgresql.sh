#!/bin/bash

#-----------------------------------------------------------------
#      VERSIONING
# v1.0 - 24 septembre 2020
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      DESCRIPTION
# Installation de postgreSQL et activation acces distant depuis 
# resau 172.19.0.0/16
#-----------------------------------------------------------------

#-----------------------------------------------------------------
#      UTILISATION
# ./script.sh PASSWORD
#-----------------------------------------------------------------


# display des inputs
# ------------------
# echo "Password du compte 'postgres' : " $1


# Install de postgresql et initialisation
# ---------------------------------------
yum install -y postgresql-server postgresql-contrib
postgresql-setup initdb


# Enable client authentication
# ---------------------------
echo "host     all             all             172.19.0.0/16           trust"  >> /var/lib/pgsql/data/pg_hba.conf 


# Allow TCP/IP socket
# -------------------
echo "listen_addresses='*'" >> /var/lib/pgsql/data/postgresql.conf  


systemctl start postgresql
systemctl enable postgresql


# Lors de l'install, le compte 'posgres' est cree. il faut changer son password
echo "$1" | passwd "postgres" --stdin





