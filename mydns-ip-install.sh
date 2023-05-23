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


sudo rm -f /etc/systemd/system/mydns-ip-update.service
sudo touch /etc/systemd/system/mydns-ip-update.service

sudo echo '[Unit]' >> /etc/systemd/system/mydns-ip-update.service
sudo echo 'Description=mydns-ip-update' >> /etc/systemd/system/mydns-ip-update.service
sudo echo '' >> /etc/systemd/system/mydns-ip-update.service
sudo echo '[Service]' >> /etc/systemd/system/mydns-ip-update.service
sudo echo 'Type=simple' >> /etc/systemd/system/mydns-ip-update.service
sudo echo 'ExecStart=/usr/bin/mydns-ip-update.sh' >> /etc/systemd/system/mydns-ip-update.service
sudo echo '' >> /etc/systemd/system/mydns-ip-update.service
sudo echo '[Install]' >> /etc/systemd/system/mydns-ip-update.service
sudo echo 'WantedBy=network-online.target' >> /etc/systemd/system/mydns-ip-update.service

sudo chown root:root /etc/systemd/system/mydns-ip-update.service
sudo chmod 644 /etc/systemd/system/mydns-ip-update.service


sudo rm -f /etc/systemd/system/mydns-ip-change.service
sudo touch /etc/systemd/system/mydns-ip-change.service

sudo echo '[Unit]' >> /etc/systemd/system/mydns-ip-change.service
sudo echo 'Description=mydns-ip-change' >> /etc/systemd/system/mydns-ip-change.service
sudo echo '' >> /etc/systemd/system/mydns-ip-change.service
sudo echo '[Service]' >> /etc/systemd/system/mydns-ip-change.service
sudo echo 'Type=simple' >> /etc/systemd/system/mydns-ip-change.service
sudo echo 'ExecStart=/usr/bin/mydns-ip-change.sh' >> /etc/systemd/system/mydns-ip-change.service
sudo echo '' >> /etc/systemd/system/mydns-ip-change.service
sudo echo '[Install]' >> /etc/systemd/system/mydns-ip-change.service
sudo echo 'WantedBy=network-online.target' >> /etc/systemd/system/mydns-ip-change.service

sudo chown root:root /etc/systemd/system/mydns-ip-change.service
sudo chmod 644 /etc/systemd/system/mydns-ip-change.service


sudo systemctl daemon-reload
