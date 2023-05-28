## mydns-ip-update (IPv6 & マルチドメイン対応)

mydnsにipを自動でupdateするシェルスクリプト

MyDNS®JP → https://www.mydns.jp/

<br>

DDNSサービスであるMyDNSサーバーへの負荷を極力減らしつつ、

動的IPアドレス変更時に素早く通知させる為の趣味で作った自動通知スクリプトです。

動作に関しては、簡易デバッグテストしかしてないので、ご了承ください。

<br>

動的IPアドレス用のスクリプトとサービスは固定IPであっても入れていて問題はないです。

ただし、confファイルでIPV4_DDNS及びIPV6_DDNSを「off」にしておいてください。（余計な処理をしなくなる）

<br>

### ワンクリックインストールスクリプトを作成しました。
▼インストールコマンド
```
bash <( curl -fsSL https://github.com/smileygames/mydns-ip-update/releases/download/v2.00/install.sh )
```
▼最初に初期設定を行ってください。

installのたびにコンフィグファイルが初期値に戻ってしまうのも面倒なので
ユーザー側でコンフィグファイルを作成してもらい、上書きインストールでも変更しないようにしました。
但し、uninstallコマンドを実行すると消えます。
```
sudo cp -v /usr/local/mydns-ip-update/config/default.conf /usr/local/mydns-ip-update/config/user.conf
sudo vim /usr/local/mydns-ip-update/config/user.conf
```
```
MYDNS_ID[1]=""
MYDNS_PASS[1]=""
MY_DOMAIN[1]=""
```
をご自分のMyDNSの情報に書き換えて、先頭の#を削除してください。

▼次にサービスの起動です。

2行目がDDNS用のサブサービス（不必要なら実行しなくてOK）
```
sudo systemctl enable mydns-ip-update.service --now
sudo systemctl enable mydns-ip-check.service --now
```

#### アンインストールスクリプトを作成しました。
▼アンインストールコマンド
```
bash <( curl -fsSL https://github.com/smileygames/mydns-ip-update/releases/download/v2.00/uninstall.sh )
```

<br>

#### 設定変更時
コンフィグファイルの内容を変更した際は、
サービスを再起動しないと反映されないので注意です。（2行目はDDNS用です）
```
sudo systemctl restart mydns-ip-update.service
sudo systemctl restart mydns-ip-check.service
```
<br>

### マニュアルインストール方法
```
wget https://github.com/smileygames/mydns-ip-update/archive/refs/tags/v${Ver}.tar.gz -O - | sudo tar zxvf - -C ./
sudo mv -fv mydns-ip-update-${Ver} mydns-ip-update
sudo cp -rv mydns-ip-update /usr/local/
sudo rm -rf mydns-ip-update

sudo chown -R root:root /usr/local/mydns-ip-update
sudo chmod -R 755 /usr/local/mydns-ip-update/bin
sudo chmod 644 /usr/local/mydns-ip-update/config/default.conf
sudo chmod 600 /usr/local/mydns-ip-update/install.sh
sudo chmod 600 /usr/local/mydns-ip-update/uninstall.sh
```

#### サービス作成(main)
```
sudo vi /etc/systemd/system/mydns-ip-update.service
```
```
[Unit]
Description=mydns-ip-update

[Service]
Type=simple
WorkingDirectory=/usr/local/mydns-ip-update/bin
ExecStart=/usr/local/mydns-ip-update/bin/mydns_ip_update.sh update

[Install]
WantedBy=network-online.target
```

権限変更
```
sudo chown root:root /etc/systemd/system/mydns-ip-update.service
sudo chmod 644 /etc/systemd/system/mydns-ip-update.service
```

#### サービス作成(動的アドレスチェックサービス)
```
sudo vi /etc/systemd/system/mydns-ip-check.service
```
```
[Unit]
Description=mydns-ip-check

[Service]
Type=simple
WorkingDirectory=/usr/local/mydns-ip-update/bin
ExecStart=/usr/local/mydns-ip-update/bin/mydns_ip_update.sh check

[Install]
WantedBy=network-online.target
```

権限変更
```
sudo chown root:root /etc/systemd/system/mydns-ip-check.service
sudo chmod 644 /etc/systemd/system/mydns-ip-check.service
```

#### デーモンリロードをして追加したサービスを読み込ませる
```
sudo systemctl daemon-reload
```

<br>

### スクリプト構成

自分なりの解釈のオブジェクト指向もどきで作り直しました。

言語はそのままシェルスクリプトです。

機能は変わりません。

![mydns-ip-update：スクリプト構成図](https://github.com/smileygames/mydns-ip-update/assets/134200591/a2b46e65-f84d-49ea-9794-9d8b84680d08)
