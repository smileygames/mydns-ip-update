#!/bin/bash
#
# update ddns install.sh
#
# MyDNS 

# サービスの停止
sudo systemctl stop mydns-ip-update.service
sudo systemctl disable mydns-ip-update.service

sudo systemctl stop mydns-ip-change.service
sudo systemctl disable mydns-ip-change.service

sudo systemctl daemon-reload

# v1.08以前用アンインストール処理
sudo rm -f /usr/local/etc/mydns-ip-update.conf
sudo rm -f /usr/bin/mydns-ip-update.sh
sudo rm -f /usr/bin/mydns-ip-change.sh
# v1.08以降用
sudo rm -rf  /usr/local/mydns-ip

# スクリプトファイルダウンロード＆ファイル属性変更
sudo wget -NP /usr/local/mydns-ip-update https://github.com/smileygames/mydns-ip-update/releases/download/v1.13/mydns-ip.conf
sudo chown root:root /usr/local/mydns-ip-update/mydns-ip.conf
sudo chmod 600 /usr/local/mydns-ip-update/mydns-ip.conf

sudo wget -NP /usr/local/mydns-ip-update/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.13/mydns-ip-update.sh
sudo chown root:root /usr/local/mydns-ip-update/bin/mydns-ip-update.sh
sudo chmod 755 /usr/local/mydns-ip-update/bin/mydns-ip-update.sh

sudo wget -NP /usr/local/mydns-ip-update/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.13/mydns-ip-change.sh
sudo chown root:root /usr/local/mydns-ip-update/bin/mydns-ip-change.sh
sudo chmod 755 /usr/local/mydns-ip-update/bin/mydns-ip-change.sh

sudo wget -NP /usr/local/mydns-ip-update/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.13/mydns-ip-common.sh
sudo chown root:root /usr/local/mydns-ip-update/bin/mydns-ip-common.sh
sudo chmod 755 /usr/local/mydns-ip-update/bin/mydns-ip-common.sh

sudo wget -NP /usr/local/mydns-ip-update/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.13/mydns-ip-install.sh
sudo chown root:root /usr/local/mydns-ip-update/bin/mydns-ip-install.sh
sudo chmod 600 /usr/local/mydns-ip-update/bin/mydns-ip-install.sh

sudo wget -NP /usr/local/mydns-ip-update/bin https://github.com/smileygames/mydns-ip-update/releases/download/v1.13/mydns-ip-uninstall.sh
sudo chown root:root /usr/local/mydns-ip-update/bin/mydns-ip-uninstall.sh
sudo chmod 600 /usr/local/mydns-ip-update/bin/mydns-ip-uninstall.sh

# サービス作成
cat << EOS | sudo tee /etc/systemd/system/mydns-ip-update.service
[Unit]
Description=mydns-ip-update

[Service]
Type=simple
ExecStart=/usr/local/mydns-ip-update/bin/mydns-ip-update.sh

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
ExecStart=/usr/local/mydns-ip-update/bin/mydns-ip-change.sh

[Install]
WantedBy=network-online.target
EOS

sudo chown root:root /etc/systemd/system/mydns-ip-change.service
sudo chmod 644 /etc/systemd/system/mydns-ip-change.service

# デーモンリロードをして追加したサービスを読み込ませる
sudo systemctl daemon-reload
