#!/bin/bash
#
# update ddns uninstall.sh
#
# MyDNS 

sudo systemctl stop mydns-ip-update.service
sudo systemctl disable mydns-ip-update.service

sudo systemctl stop mydns-ip-change.service
sudo systemctl disable mydns-ip-change.service

sudo systemctl daemon-reload

# v1.06以前用
sudo rm -f /usr/local/etc/mydns-ip-update.conf
sudo rm -f /usr/bin/mydns-ip-update.sh
sudo rm -f /usr/bin/mydns-ip-change.sh
# v1.08以降用
sudo rm -rf  /usr/local/mydns-ip
# v1.09以降用
sudo rm -rf  /usr/local/mydns-ip-update

# ALL バージョン用
sudo rm -f /etc/systemd/system/mydns-ip-update.service
sudo rm -f /etc/systemd/system/mydns-ip-change.service
