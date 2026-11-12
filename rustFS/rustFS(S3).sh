

# set parameters
RUSTFS_ACCESS_KEY=admin
RUSTFS_SECRET_KEY=$1


# create the volume
mkdir /data
mkdir /data/rustfs0


# install
# The script installs the binary to /usr/local/bin/rustfs, registers a rustfs systemd service, and starts it.
# By default it stores data in /data/rustfs0 and listens on port 9000 (S3 API) and 9001 (Console)
#curl -O https://rustfs.com/install_rustfs.sh && bash install_rustfs.sh
cd /tmp
curl -O https://rustfs.com/install_rustfs.sh
chmod 755 install_rustfs.sh
"MANUAL STEP : ./install_rustfs.sh"

# Update account in /etc/default/rustfs
# delete lines
sed -i '/RUSTFS_ACCESS_KEY/d' /etc/default/rustfs
sed -i '/RUSTFS_SECRET_KEY/d' /etc/default/rustfs
# add lines
echo "RUSTFS_ACCESS_KEY=$RUSTFS_ACCESS_KEY" >> /etc/default/rustfs
echo "RUSTFS_SECRET_KEY=$RUSTFS_SECRET_KEY" >> /etc/default/rustfs


# restart service
systemctl restart rustfs
systemctl enable rustfs


# Connect
# http://rustfs.labfr.com:9001/