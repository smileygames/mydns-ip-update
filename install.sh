#!/bin/bash
#
# update ddns install.sh
#
# dipper

Ver="1.00"

# 以前のバージョンのアンインストール処理

# v1.00以降のインストール用
# サービスの停止
sudo systemctl stop dipper.service
sudo systemctl disable dipper.service

# スクリプトファイルダウンロード＆ファイル属性変更
wget https://github.com/smileygames/dipper/archive/refs/tags/v${Ver}.tar.gz -O - | sudo tar zxvf - -C ./
sudo mv -fv dipper-${Ver} dipper
sudo cp -rv dipper /usr/local/
sudo rm -rf dipper

sudo chmod -R 755 /usr/local/dipper/bin

# サービス作成
cat << EOS | sudo tee /etc/systemd/system/dipper.service
[Unit]
Description=ddns-ip-upper

[Service]
Type=simple
Restart=on-failure
WorkingDirectory=/usr/local/dipper/bin
ExecStart=/usr/local/dipper/bin/ip_update.sh

[Install]
WantedBy=network-online.target
EOS

# デーモンリロードをして追加したサービスを読み込ませる
sudo systemctl daemon-reload
