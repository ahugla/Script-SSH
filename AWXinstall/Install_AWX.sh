#At least 2GB of memory

# Install Dependencies
# --------------------

cd /tmp

yum install -y epel-release

yum remove python-docker-py

#yum install -y yum-utils device-mapper-persistent-data lvm2 ansible git python-devel python-pip python-docker-py vim-enhanced
#pip install cryptography
#pip install jsonschema
#pip install docker-compose~=1.23.0
#pip install docker --upgrade

yum install -y yum-utils device-mapper-persistent-data lvm2 ansible git python3-devel python3-pip python-docker-py vim-enhanced
pip3 install cryptography
pip3 install jsonschema
pip3 install docker-compose~=1.23.0
pip3 install docker --upgrade

alias python='/usr/bin/python3'


# Configure docker ce stable repository.
# -------------------------------------
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install docker-ce -y
systemctl start docker
systemctl enable docker



# Install AWX
# -----------
cd /opt

git clone https://github.com/ansible/awx.git

#Clone commercial logos
cd awx/
git clone https://github.com/ansible/awx-logos.git

#Configure AWX
cd installer/
sed -i -e '/awx_official/s/^#//' inventory   # on uncomment
sed -i -e 's/awx_official=false/awx_official=true/g' inventory   # on passe a true (false par defaut)



# create certificate and activate SSL (443)
#-------------------------------------------
## Create awx-ssl folder in /etc.
mkdir -p /etc/awx-ssl/

## Make a self-signed ssl certificate
openssl req -subj '/CN=secops.tech/O=Secops Tech/C=TR' \
	-new -newkey rsa:2048 \
	-sha256 -days 1365 \
	-nodes -x509 \
	-keyout /etc/awx-ssl/awx.key \
	-out /etc/awx-ssl//awx.crt

## Merge awx.key and awx.crt files
cat /etc/awx-ssl/awx.key /etc/awx-ssl/awx.crt > /etc/awx-ssl/awx-bundled-key.crt

## Pass the full path of awx-bundled-key.crt file to ssl_certificate variable in inventory.
sed -i -E "s|^#([[:space:]]?)ssl_certificate=|ssl_certificate=/etc/awx-ssl/awx-bundled-key.crt|g" /opt/awx/installer/inventory



#Deploy AWX
ansible-playbook -i inventory install.yml -vv

#Check the status
#docker ps -a

#AWX is ready and can be accessed from the browser.

#http://ipaddress:80/
#https://ipaddress:443/   si SSL enabled ce qu est le cas ici

#the username is “admin” and the password is “password”

