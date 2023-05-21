# mydns-ip-update
mydnsにipを自動でupdateするシェルスクリプト

下記場所にそれぞれファイルを置くか、ファイルを作成して内容をコピーして、
ファイル属性をそれぞれ下記にする。
場所：/usr/local/etc/mydns-ip-update.conf
sudo chown root:root /usr/local/etc/mydns-ip-update.conf
sudo chmod 644 /usr/local/etc/mydns-ip-update.conf

場所：/usr/bin/mydns-ip-update.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh

場所：/usr/bin/mydns-ip-change.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh

サービスを登録する。
sudo vim /etc/systemd/system/mydns-ip-update.service
-----------------------------
[Unit]
Description=mydns-ip-update

[Service]
Type=simple
ExecStart=/usr/bin/mydns-ip-update.sh

[Install]
WantedBy=network-online.target
-----------------------------

sudo vim /etc/systemd/system/mydns-ip-change.service
-----------------------------
[Unit]
Description=mydns-ip-change

[Service]
Type=simple
ExecStart=/usr/bin/mydns-ip-change.sh

[Install]
WantedBy=network-online.target
-----------------------------

sudo systemctl daemon-reload

sudo systemctl enable mydns-ip-update.service --now
sudo systemctl enable mydns-ip-change.service --now

