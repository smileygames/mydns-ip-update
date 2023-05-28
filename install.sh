#!/bin/bash
#
# update ddns install.sh
#
# MyDNS 

Ver="2.00"

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
sudo systemctl stop mydns-ip-change.service
sudo systemctl disable mydns-ip-change.service
sudo rm -f /etc/systemd/system/mydns-ip-change.service
sudo systemctl daemon-reload
sudo rm -f /usr/local/mydns-ip-update/mydns-ip.conf
sudo rm -f /usr/local/mydns-ip-update/bin/mydns-ip-update.sh
sudo rm -f /usr/local/mydns-ip-update/bin/mydns-ip-change.sh
sudo rm -f /usr/local/mydns-ip-update/bin/mydns-ip-common.sh

# v2.00以降のインストール用
# サービスの停止
sudo systemctl stop mydns-ip-update.service
sudo systemctl disable mydns-ip-update.service

sudo systemctl stop mydns-ip-check.service
sudo systemctl disable mydns-ip-check.service

sudo systemctl daemon-reload

# スクリプトファイルダウンロード＆ファイル属性変更
wget https://github.com/smileygames/mydns-ip-update/archive/refs/tags/v${Ver}.tar.gz -O - | sudo tar zxvf - -C ./
sudo mv -fv mydns-ip-update-${Ver} mydns-ip-update
sudo cp -rv mydns-ip-update /usr/local/
sudo rm -rf mydns-ip-update

sudo chown -R root:root /usr/local/mydns-ip-update
sudo chmod -R 755 /usr/local/mydns-ip-update/bin
sudo chmod 644 /usr/local/mydns-ip-update/config/default.conf
sudo chmod 744 /usr/local/mydns-ip-update/install.sh
sudo chmod 744 /usr/local/mydns-ip-update/uninstall.sh

# サービス作成
cat << EOS | sudo tee /etc/systemd/system/mydns-ip-update.service
[Unit]
Description=mydns-ip-update

[Service]
Type=simple
WorkingDirectory=/usr/local/mydns-ip-update/bin
ExecStart=/usr/local/mydns-ip-update/bin/mydns_ip_update.sh update

[Install]
WantedBy=network-online.target
EOS

sudo chown root:root /etc/systemd/system/mydns-ip-update.service
sudo chmod 644 /etc/systemd/system/mydns-ip-update.service

cat << EOS | sudo tee /etc/systemd/system/mydns-ip-check.service
[Unit]
Description=mydns-ip-check

[Service]
Type=simple
WorkingDirectory=/usr/local/mydns-ip-update/bin
ExecStart=/usr/local/mydns-ip-update/bin/mydns_ip_update.sh check

[Install]
WantedBy=network-online.target
EOS

sudo chown root:root /etc/systemd/system/mydns-ip-check.service
sudo chmod 644 /etc/systemd/system/mydns-ip-check.service

# デーモンリロードをして追加したサービスを読み込ませる
sudo systemctl daemon-reload
