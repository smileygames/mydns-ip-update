# mydns-ip-update (IPv6 & マルチドメイン対応)

mydnsにipを自動でupdateするシェルスクリプト

MyDNS®JP → https://www.mydns.jp/

オブジェクト指向化しました。（独自解釈）→ https://smgjp.com/mydns-ip-update_object/

<br>

DDNSサービスであるMyDNSサーバーへの負荷を極力減らしつつ、

動的IPアドレス変更時に素早く通知させる為の趣味で作った自動通知スクリプトです。

動作に関しては、簡易デバッグテストしかしてないので、ご了承ください。

<br>

固定IPの場合、confファイルでIPV4_DDNS及びIPV6_DDNSを「off」にしておいてください。（余計な処理をしなくなる）

<br>

## ワンクリックインストールスクリプト
### インストールコマンド
```bash
bash <( curl -fsSL https://github.com/smileygames/mydns-ip-update/releases/download/v2.07/install.sh )
```

<br>

▼最初に初期設定を行ってください。

installのたびにコンフィグファイルが初期値に戻ってしまうのも面倒なので
ユーザー側でコンフィグファイルを作成してもらい、上書きインストールでも変更しないようにしました。
但し、uninstallコマンドを実行すると消えます。
```bash
sudo cp -v /usr/local/mydns-ip-update/config/default.conf /usr/local/mydns-ip-update/config/user.conf
sudo vim /usr/local/mydns-ip-update/config/user.conf
```
```bash
MYDNS_ID[1]=""
MYDNS_PASS[1]=""
MYDNS_DOMAIN[1]=""
```
をご自分のMyDNSの情報に書き換えて、先頭の#を削除してください。

編集が終わったら権限を変更しておきます。（IDとPASSを管理したファイルの為）
```bash
sudo chmod 600 /usr/local/mydns-ip-update/config/user.conf
```

<br>

▼次にサービスの起動です。

```bash
sudo systemctl enable mydns-ip-update.service --now
```
<br>

### アンインストールスクリプト
▼アンインストールコマンド
```bash
bash <( curl -fsSL https://github.com/smileygames/mydns-ip-update/releases/download/v2.07/uninstall.sh )
```

<br>

### 設定変更時
コンフィグファイルの内容を変更した際は、
サービスを再起動しないと反映されないので注意です。
```bash
sudo systemctl restart mydns-ip-update.service
```
<br>

## マニュアルインストール方法

### ダウンロード及び権限の変更

```bash
Ver="2.07"
wget https://github.com/smileygames/mydns-ip-update/archive/refs/tags/v${Ver}.tar.gz -O - | sudo tar zxvf - -C ./
sudo mv -fv mydns-ip-update-${Ver} mydns-ip-update
sudo cp -rv mydns-ip-update /usr/local/
sudo rm -rf mydns-ip-update
sudo chmod -R 755 /usr/local/mydns-ip-update/bin
```

### サービス作成
```bash
sudo vi /etc/systemd/system/mydns-ip-update.service
```
```bash
[Unit]
Description=mydns-ip-update

[Service]
Type=simple
Restart=on-failure
WorkingDirectory=/usr/local/mydns-ip-update/bin
ExecStart=/usr/local/mydns-ip-update/bin/ip_update.sh

[Install]
WantedBy=network-online.target
```

### デーモンリロードをして追加したサービスを読み込ませる
```bash
sudo systemctl daemon-reload
```

<br>

## スクリプト構成

自分なりの解釈のオブジェクト指向もどきで作り直しました。

言語はそのままシェルスクリプトです。

機能は変わりません。

![mydns-ip-update：スクリプト構成図 (1)](https://github.com/smileygames/mydns-ip-update/assets/134200591/99235248-91c0-4df9-bc56-e6e4a434e454)
