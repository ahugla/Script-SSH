#!/bin/bash

# Requires centOS 7.7+  et  >2 Go RAM

# UTILE SI DEPLOIEMENT VIA SOFTWARE COMPONENT VRA 
# On complete le path, notamment pour acceder aux commandes types 'service' (sbin)
export PATH=$PATH:/usr/local/sbin:/usr/sbin:/root/bin


cd /tmp

yum --enablerepo=extras install -y epel-release
yum groupinstall -y 'Development Tools'
yum install -y ansible
yum install -y openssl openssl-devel libffi libffi-devel git
yum install -y python python-devel python-pip
pip install cryptography
yum install -y python-cryptography pyOpenSSL.x86_64
yum install -y wget


# Activate ansible log
echo "log_path=/var/log/ansible.log" >> /etc/ansible/ansible.cfg
export ANSIBLE_LOG_PATH=/var/log/ansible.log
export ANSIBLE_DEBUG=True


wget http://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-latest.tar.gz
tar -xvzf ansible-tower-setup-latest.tar.gz


cd ansible-tower-setup-*

#rm -f inventory
#wget https://raw.githubusercontent.com/ahugla/Ansible/master/AnsibleTower_inventoryFile
#mv AnsibleTower_inventoryFile inventory

# On remplace localhost par le hostname de la VM  (recommandation d'install)
sed -i -e 's/localhost/'"$HOSTNAME"'/g'  inventory
sed -i -e "s/admin_password=''/admin_password='password'/g"  inventory
sed -i -e "s/rabbitmq_password=''/rabbitmq_password='password'/g"  inventory
sed -i -e "s/pg_password=''/pg_password='password'/g"  inventory


./setup.sh
