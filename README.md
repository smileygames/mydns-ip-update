## mydns-ip-update
mydnsにipを自動でupdateするシェルスクリプト

出来るだけシンプルで分かりやすく作ったので、エラーチェックが甘いところもあります。

動作に関しても、簡易チェックしかしてないので、ご了承ください。

動的IPアドレス用のスクリプトとサービスは固定IPであっても入れていて問題はない。

ただし、ConfファイルでIPV4_DDNS及びIPV6_DDNSを「off」にしておく。（余計な処理をしなくなる）

### ワンクリックインストールスクリプトを作成しました。
```
bash <( curl -fsSL https://github.com/smileygames/mydns-ip-update/releases/download/v1.01/mydns-ip-install.sh )
```
最初に初期設定を行ってください。
```
sudo vim /usr/local/etc/mydns-ip-update.conf
```
次にサービスの起動です。
```
sudo systemctl enable mydns-ip-update.service --now
```
DDNS用のサブサービスがこちら（不必要なら実行しなくてOK）
```
sudo systemctl enable mydns-ip-update.service --now
```

### マニュアルインストール方法
下記場所にそれぞれファイルを置くか、ファイルを作成して内容をコピーして、

ファイル属性をそれぞれ下記にする。

#### congig file（設定用ファイル）
```
場所：/usr/local/etc/mydns-ip-update.conf
sudo chown root:root /usr/local/etc/mydns-ip-update.conf
sudo chmod 644 /usr/local/etc/mydns-ip-update.conf
```

#### IPアドレス用のスクリプト（基本）
```
場所：/usr/bin/mydns-ip-update.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh
```

##### 基本サービスを登録する。

```
sudo vim /etc/systemd/system/mydns-ip-update.service
```
```
[Unit]
Description=mydns-ip-update

[Service]
Type=simple
ExecStart=/usr/bin/mydns-ip-update.sh

[Install]
WantedBy=network-online.target
```

##### 基本サービスの自動起動設定および起動させる。
```
sudo systemctl daemon-reload
sudo systemctl enable mydns-ip-update.service --now
```



#### 動的IPアドレス用のスクリプト（不必要ならいらない）

```
場所：/usr/bin/mydns-ip-change.sh
sudo chown root:root /usr/bin/mydns-ip-update.sh
sudo chmod 755 /usr/bin/mydns-ip-update.sh
```

##### 動的IPアドレス用サービスを登録する。（不必要ならいらない）
```
sudo vim /etc/systemd/system/mydns-ip-change.service
```
```
[Unit]
Description=mydns-ip-change

[Service]
Type=simple
ExecStart=/usr/bin/mydns-ip-change.sh

[Install]
WantedBy=network-online.target
```

##### 動的IPサービスの自動起動設定および起動させる。（不必要ならいらない）
```
sudo systemctl daemon-reload
sudo systemctl enable mydns-ip-change.service --now
```
