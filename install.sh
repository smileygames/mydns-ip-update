#!/bin/bash
#
# update ddns install.sh
#
# MyDNS 

Ver="2.01_db"

# 以前のバージョンのアンインストール処理
# v1.08以前用
sudo rm -f /usr/local/etc/mydns-ip-update.conf
sudo rm -f /usr/bin/mydns-ip-update.sh
sudo rm -f /usr/bin/mydns-ip-change.sh
# v1.08以降用
sudo rm -rf  /usr/local/mydns-ip
# v1.13以降用
sudo rm -f /usr/local/mydns-ip-update/bin/mydns-ip-install.sh
sudo rm -f /usr/local/mydns-ip-update/bin/mydns-ip-uninstall.sh
# v2.00以前用
File="/usr/local/mydns-ip-update/bin/mydns-ip-change.sh"
if [ -e ${File} ]; then
    sudo rm -f /etc/systemd/system/mydns-ip-change.service
    sudo systemctl stop mydns-ip-change.service
    sudo systemctl disable mydns-ip-change.service
fi
sudo rm -f /usr/local/mydns-ip-update/mydns-ip.conf
sudo rm -f /usr/local/mydns-ip-update/bin
# v2.03 以前用
File="/etc/systemd/system/mydns-ip-check.service"
if [ -e ${File} ]; then
    sudo rm -f /etc/systemd/system/mydns-ip-check.service
    sudo systemctl stop mydns-ip-check.service
    sudo systemctl disable mydns-ip-check.service
fi

# v2.03以降のインストール用
# サービスの停止
sudo systemctl stop mydns-ip-update.service
sudo systemctl disable mydns-ip-update.service

# スクリプトファイルダウンロード＆ファイル属性変更
wget https://github.com/smileygames/mydns-ip-update/archive/refs/tags/v${Ver}.tar.gz -O - | sudo tar zxvf - -C ./
sudo mv -fv mydns-ip-update-${Ver} mydns-ip-update
sudo cp -rv mydns-ip-update /usr/local/
sudo rm -rf mydns-ip-update

sudo chown -R root:root /usr/local/mydns-ip-update
sudo chmod -R 755 /usr/local/mydns-ip-update/bin
sudo chmod 644 /usr/local/mydns-ip-update/config/default.conf
sudo chmod 644 /usr/local/mydns-ip-update/install.sh
sudo chmod 644 /usr/local/mydns-ip-update/uninstall.sh

# サービス作成
cat << EOS | sudo tee /etc/systemd/system/mydns-ip-update.service
[Unit]
Description=mydns-ip-update

[Service]
Type=simple
WorkingDirectory=/usr/local/mydns-ip-update/bin
ExecStart=/usr/local/mydns-ip-update/bin/mydns_ip_update.sh

[Install]
WantedBy=network-online.target
EOS

sudo chown root:root /etc/systemd/system/mydns-ip-update.service
sudo chmod 644 /etc/systemd/system/mydns-ip-update.service

# デーモンリロードをして追加したサービスを読み込ませる
sudo systemctl daemon-reload
