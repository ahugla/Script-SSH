
cd /tmp

yum install -y nfs-utils

mkdir /nfsshare
chmod -R 755 /nfsshare


#Make it reboot persistent and start services
systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap


#Define nfs share access
# ex partage :  /nfsshare    IPclient(rw,sync,no_root_squash,no_all_squash)
# ex partage :  /nfsshare    IPclient(rw,sync,no_root_squash,no_all_squash)
# ex partage :  /nfsshare    172.17.5.*(rw,sync,no_root_squash,no_all_squash)  NO OK
echo "/nfsshare    *(rw,sync)"  >> /etc/exports


systemctl restart nfs-server


