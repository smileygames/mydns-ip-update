#!/bin/bash
#
# update ddns uninstall.sh
#
# dipper 

# v1.00以降用
sudo systemctl stop dipper.service
sudo systemctl disable dipper.service
sudo systemctl daemon-reload
sudo rm -rf /usr/local/dipper
sudo rm -f /etc/systemd/system/dipper.service
