#   INSTALLATION DE MINIO SUR ROCKY9
#
#  v1.0
#
#  Alexandre Hugla
#  12 Nov 2026
#
#
#  USAGE :  install_minIO.sh [password]
#
#  ACCESS : IP:9000 avec le compte "admin"
#



# create directory data
cd /tmp
mkdir /data


# Set parameters
export MINIO_ACCESS_KEY="admin"
export MinIO_password=$1
export MINIO_VOLUMES="/data"
export MINIO_OPTS="--address :9000"
minio_FQDN=$HOSTNAME


# install packages
dnf install -y wget


#download minIO
mkdir /opt/minio
mkdir /opt/minio/bin
#wget https://dl.minio.io/server/minio/release/linux-amd64/minio -O /opt/minio/bin/minio
wget https://github.com/minio/minio/releases/download/RELEASE.2025-09-07T16-13-09Z/minio.linux-amd64.RELEASE.2025-09-07T16-13-09Z -O /opt/minio/bin/minio
chmod +x /opt/minio/bin/minio



# minIO config
cat >/opt/minio/minio.conf <<EOF
MINIO_VOLUMES="$MINIO_VOLUMES"
MINIO_OPTS="$MINIO_OPTS"
MINIO_ACCESS_KEY="$MINIO_ACCESS_KEY"
MINIO_SECRET_KEY="$MinIO_password"
EOF



# ex /opt/minio/bin/minio server --address ":9000" /data

# create service
cat >/etc/systemd/system/minio.service <<EOF
[Unit]
Description=Minio
Wants=network-online.target
After=network-online.target
AssertFileIsExecutable=/opt/minio/bin/minio

[Service]
WorkingDirectory=/root
User=root
Group=root

PermissionsStartOnly=true
EnvironmentFile=/opt/minio/minio.conf
ExecStartPre=/bin/bash -c "[ -n \"${MINIO_VOLUMES}\" ] || echo \"Variable MINIO_VOLUMES not set in /opt/minio/minio.conf\""

ExecStart=/opt/minio/bin/minio server ${MINIO_OPTS} ${MINIO_VOLUMES}

StandardOutput=journal
StandardError=inherit

# Specifies the maximum file descriptor number that can be opened by this process
LimitNOFILE=65536

# Disable timeout logic and wait until process is stopped
TimeoutStopSec=0

# SIGTERM signal is used to stop Minio
KillSignal=SIGTERM
SendSIGKILL=no
SuccessExitStatus=0

[Install]
WantedBy=multi-user.target
EOF

# Reload and start service
systemctl daemon-reload
systemctl start minio
systemctl enable minio


# Install le commande line mc, l'equivalent de kubectl pour minio
#curl https://dl.min.io/client/mc/release/linux-amd64/mc  --create-dirs -o $HOME/minio-binaries/mc
#chmod +x $HOME/minio-binaries/mc
#export PATH=$PATH:$HOME/minio-binaries/


# configurer l'alias 'local' de mc  (equivalent d'un configfile pour K8S) pour donner les droits d'acces
# local est l'alias utilisé (le contexte qui contient les credentials), il existe par defaut et pointe vers le s3 minio local
#mc alias set ALIAS URL ACCESSKEY SECRETKEY
#mc alias set local http://localhost:9000 $MINIO_ACCESS_KEY $MinIO_password  
#mc admin info local   #verification

     
#create policy   "./policyminio.json":
#cat <<EOF > ./policyminio.json
#{
# "Version": "2012-10-17",
# "Statement": [
#  {
#   "Effect": "Allow",
#   "Action": [
#    "admin:*"
#   ]
#  },
#  {
#   "Effect": "Allow",
#   "Action": [
#    "kms:*"
#   ]
#  },
#  {
#   "Effect": "Allow",
#   "Action": [
#    "s3:*"
#   ],
#   "Resource": [
#    "arn:aws:s3:::*"
#   ]
#  }
# ]
#}
#EOF



# Configuration de l'acces en HTTPS:
# ---------------------------------
# By default, the MinIO server looks for the TLS keys and certificates, mais si absent fonctionne en HTTP
# Le certif est dans  :   /root/.minio/certs

# Generate a self-signed certificate 
sleep 5 # sinon le repertoire certs n'a pas le temps d etre créé
cd /root/.minio/certs
openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -keyout private.key -out public.crt -subj "/C=XX/ST=FR/L=Paris/O=Broadcom/OU=CMPSE/CN=$minio_FQDN"
# crée : "private.key" et "public.crt"

#redemarrage de minio
systemctl restart minio



