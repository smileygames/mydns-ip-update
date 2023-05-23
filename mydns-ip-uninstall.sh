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

sudo rm -f /usr/local/etc/mydns-ip-update.conf
sudo rm -f /usr/bin/mydns-ip-update.sh
sudo rm -f /usr/bin/mydns-ip-change.sh
sudo rm -f /etc/systemd/system/mydns-ip-update.service
sudo rm -f /etc/systemd/system/mydns-ip-change.service
