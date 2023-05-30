#!/bin/bash
#
# update ddns uninstall.sh
#
# MyDNS 

# v2.03以前用
File="/etc/systemd/system/mydns-ip-check.service"
if [ -e ${File} ]; then
    sudo systemctl stop mydns-ip-check.service
    sudo systemctl disable mydns-ip-check.service
fi

# v2.00以前用
File="/etc/systemd/system/mydns-ip-change.service"
if [ -e ${File} ]; then
    sudo systemctl stop mydns-ip-change.service
    sudo systemctl disable mydns-ip-change.service
fi

# v1.06以前用
sudo rm -f /usr/local/etc/mydns-ip-update.conf
sudo rm -f /usr/bin/mydns-ip-update.sh
sudo rm -f /usr/bin/mydns-ip-change.sh
# v1.08以降用
sudo rm -rf /usr/local/mydns-ip
# v1.11以降用
sudo rm -f /etc/systemd/system/mydns-ip-change.service

# v2.03以前用
sudo rm -f /etc/systemd/system/mydns-ip-check.service

# v2.03以降用
sudo systemctl stop mydns-ip-update.service
sudo systemctl disable mydns-ip-update.service
sudo systemctl daemon-reload
sudo rm -rf /usr/local/mydns-ip-update
sudo rm -f /etc/systemd/system/mydns-ip-update.service
