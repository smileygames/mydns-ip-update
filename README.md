## mydns-ip-update (IPv6 & マルチドメイン対応)
mydnsにipを自動でupdateするシェルスクリプト

MyDNS®JP → https://www.mydns.jp/

<br>

DDNSサービスであるMyDNSサーバーへの負荷を極力減らしつつ、

動的IPアドレス変更時に素早く通知させる為の趣味で作った自動通知スクリプトです。

出来るだけシンプルで分かりやすく作ったつもりが段々複雑化してきました。。。

動作に関しては、簡易デバッグテストしかしてないので、ご了承ください。

<br>

動的IPアドレス用のスクリプトとサービスは固定IPであっても入れていて問題はないです。

ただし、confファイルでIPV4_DDNS及びIPV6_DDNSを「off」にしておいてください。（余計な処理をしなくなる）

<br>

### ワンクリックインストールスクリプトを作成しました。
▼インストールコマンド

上書きインストールにも対応しています。その場合は更新されなかったファイルは上書きされません。
```
bash <( curl -fsSL https://github.com/smileygames/mydns-ip-update/releases/download/v1.05/mydns-ip-install.sh )
```
▼最初に初期設定を行ってください。
```
sudo vim /usr/local/etc/mydns-ip-update.conf
```
▼次にサービスの起動です。

2行目がDDNS用のサブサービス（不必要なら実行しなくてOK）
```
sudo systemctl enable mydns-ip-update.service --now
sudo systemctl enable mydns-ip-change.service --now
```

#### アンインストールスクリプトを作成しました。
▼アンインストールコマンド
```
bash <( curl -fsSL https://github.com/smileygames/mydns-ip-update/releases/download/v1.05/mydns-ip-uninstall.sh )
```

<br>

#### 設定変更時
コンフィグファイルの内容を変更した際は、
サービスを再起動しないと反映されないので注意です。（2行目はDDNS用です）
```
sudo systemctl restart mydns-ip-update.service
sudo systemctl restart mydns-ip-change.service
```

<br>

### マニュアルインストール方法
下記場所にそれぞれファイルを置くか、ファイルを作成して内容をコピーして、

ファイル属性をそれぞれ下記にする。

#### congig file（設定用ファイル）
```
場所：/usr/local/etc/mydns-ip-update.conf
sudo chown root:root /usr/local/etc/mydns-ip-update.conf
sudo chmod 600 /usr/local/etc/mydns-ip-update.conf
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

<br>

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
