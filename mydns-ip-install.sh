#!/bin/sh
#
# update ddns install.sh
#
# MyDNS 


sudo wget -P /usr/local/etc https://github.com/smileygames/mydns-ip-update/releases/download/v1.01/mydns-ip-update.conf
sudo chown root:root /usr/local/etc/mydns-ip-update.conf
sudo chmod 644 /usr/local/etc/mydns-ip-update.conf


sudo wget -P /usr/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.01/mydns-ip-update.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh

sudo wget -P /etc/systemd/system https://github.com/smileygames/mydns-ip-update/releases/download/v1.01/mydns-ip-update.service

sudo wget -P /usr/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.01/mydns-ip-change.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh

sudo wget -P /etc/systemd/system https://github.com/smileygames/mydns-ip-update/releases/download/v1.01/mydns-ip-change.service

sudo systemctl daemon-reload
