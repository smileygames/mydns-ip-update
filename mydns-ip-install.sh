#!/bin/bash
#
# update ddns install.sh
#
# MyDNS 

sudo wget -N -P /usr/local/etc https://github.com/smileygames/mydns-ip-update/releases/download/v1.02/mydns-ip-update.conf
sudo chown root:root /usr/local/etc/mydns-ip-update.conf
sudo chmod 600 /usr/local/etc/mydns-ip-update.conf

sudo wget -N -P /usr/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.02/mydns-ip-update.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh

sudo wget -N -P /usr/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.02/mydns-ip-change.sh
sudo chown root:root /usr/bin/mydns-ip-change.sh
sudo chmod 755 /usr/bin/mydns-ip-change.sh

cat << EOS | sudo tee /etc/systemd/system/mydns-ip-update.service
[Unit]
Description=mydns-ip-update

[Service]
Type=simple
ExecStart=/usr/bin/mydns-ip-update.sh

[Install]
WantedBy=network-online.target
EOS

sudo chown root:root /etc/systemd/system/mydns-ip-update.service
sudo chmod 644 /etc/systemd/system/mydns-ip-update.service

cat << EOS | sudo tee /etc/systemd/system/mydns-ip-change.service
[Unit]
Description=mydns-ip-change

[Service]
Type=simple
ExecStart=/usr/bin/mydns-ip-change.sh

[Install]
WantedBy=network-online.target
EOS

sudo chown root:root /etc/systemd/system/mydns-ip-change.service
sudo chmod 644 /etc/systemd/system/mydns-ip-change.service

sudo systemctl daemon-reload
