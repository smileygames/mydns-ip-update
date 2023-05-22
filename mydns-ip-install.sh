#!/bin/bash
#
# update ddns install.sh
#
# MyDNS 

sudo wget -N -P /usr/local/etc https://github.com/smileygames/mydns-ip-update/releases/download/v1.02/mydns-ip-update.conf
sudo chown root:root /usr/local/etc/mydns-ip-update.conf
sudo chmod 644 /usr/local/etc/mydns-ip-update.conf

sudo wget -N -P /usr/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.02/mydns-ip-update.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh

sudo wget -N -P /usr/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.02/mydns-ip-change.sh
sudo chown root:root /usr/bin/mydns-ip-change.sh
sudo chmod 755 /usr/bin/mydns-ip-change.sh


rm -f /etc/systemd/system/mydns-ip-update.service
sudo touch /etc/systemd/system/mydns-ip-update.service

echo '[Unit]' >> /etc/systemd/system/mydns-ip-update.service
echo 'Description=mydns-ip-update' >> /etc/systemd/system/mydns-ip-update.service
echo '' >> /etc/systemd/system/mydns-ip-update.service
echo '[Service]' >> /etc/systemd/system/mydns-ip-update.service
echo 'Type=simple' >> /etc/systemd/system/mydns-ip-update.service
echo 'ExecStart=/usr/bin/mydns-ip-update.sh' >> /etc/systemd/system/mydns-ip-update.service
echo '' >> /etc/systemd/system/mydns-ip-update.service
echo '[Install]' >> /etc/systemd/system/mydns-ip-update.service
echo 'WantedBy=network-online.target' >> /etc/systemd/system/mydns-ip-update.service

sudo chown root:root /etc/systemd/system/mydns-ip-update.service
sudo chmod 644 /etc/systemd/system/mydns-ip-update.service


rm -f /etc/systemd/system/mydns-ip-change.service
sudo touch /etc/systemd/system/mydns-ip-change.service

echo '[Unit]' >> /etc/systemd/system/mydns-ip-change.service
echo 'Description=mydns-ip-change' >> /etc/systemd/system/mydns-ip-change.service
echo '' >> /etc/systemd/system/mydns-ip-change.service
echo '[Service]' >> /etc/systemd/system/mydns-ip-change.service
echo 'Type=simple' >> /etc/systemd/system/mydns-ip-change.service
echo 'ExecStart=/usr/bin/mydns-ip-change.sh' >> /etc/systemd/system/mydns-ip-change.service
echo '' >> /etc/systemd/system/mydns-ip-change.service
echo '[Install]' >> /etc/systemd/system/mydns-ip-change.service
echo 'WantedBy=network-online.target' >> /etc/systemd/system/mydns-ip-change.service

sudo chown root:root /etc/systemd/system/mydns-ip-change.service
sudo chmod 644 /etc/systemd/system/mydns-ip-change.service


sudo systemctl daemon-reload
