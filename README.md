# mydns-ip-update
mydnsにipを自動でupdateするシェルスクリプト
動的IPアドレス用のスクリプトとサービスは固定IPであっても入れていて問題はない。
ただし、ConfファイルでIPV4_DDNS及びIPV6_DDNSを「off」にしておく。（余計な処理をしなくなる）

下記場所にそれぞれファイルを置くか、ファイルを作成して内容をコピーして、
ファイル属性をそれぞれ下記にする。
場所：/usr/local/etc/mydns-ip-update.conf
sudo chown root:root /usr/local/etc/mydns-ip-update.conf
sudo chmod 644 /usr/local/etc/mydns-ip-update.conf

場所：/usr/bin/mydns-ip-update.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh

# 動的IPアドレス用のスクリプト（不必要ならいらない）
場所：/usr/bin/mydns-ip-change.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh

# 基本サービスを登録する。
sudo vim /etc/systemd/system/mydns-ip-change.service

-----------------------------
[Unit]
Description=mydns-ip-update

[Service]
Type=simple
ExecStart=/usr/bin/mydns-ip-update.sh

[Install]
WantedBy=network-online.target

-----------------------------

# サービスを登録する。（動的IPアドレス用。不必要ならいらない）
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

