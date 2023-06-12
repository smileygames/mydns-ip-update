# dipper (multi DDNS & IPv6 & multi domain対応)

旧名称：mydns-ip-update

MyDNS®JP → https://www.mydns.jp/

オブジェクト指向化しました。（独自解釈）→ https://smgjp.com/mydns-ip-update_object/

<br>

## 概要
- このスクリプトは、DDNSへの自動通知を目的としています。
- 使用する環境はAlmaLinuxで、言語はBashです。
- スクリプトは複数のファイルで構成されており、それぞれの役割や目的があります。
- `config`ディレクトリ内の設定ファイルに基づいて動作します。
- IPアドレスの更新やチェックを定期的に行います。

<br>

動作に関しては、簡易デバッグテストしかしてないので、ご了承ください。

MyDNSを使用していて固定IPの場合は、confファイルでIPV4_DDNS及びIPV6_DDNSを「off」にしておいてください。（余計な処理をしなくなる）

<br>

## ワンクリックインストールスクリプト
### インストールコマンド
```bash
bash <( curl -fsSL https://github.com/smileygames/dipper/releases/download/v1.00/install.sh )
```

<br>

▼最初に初期設定を行ってください。

installのたびにコンフィグファイルが初期値に戻ってしまうのも面倒なので
ユーザー側でコンフィグファイルを作成してもらい、上書きインストールでも変更しないようにしました。
但し、uninstallコマンドを実行すると消えます。
```bash
sudo cp -v /usr/local/dipper/config/default.conf /usr/local/dipper/config/user.conf
sudo vim /usr/local/dipper/config/user.conf
```
```bash
MYDNS_ID[1]=""
MYDNS_PASS[1]=""
MYDNS_DOMAIN[1]=""
```
をご自分のMyDNSの情報に書き換えて、先頭の#を削除してください。

編集が終わったら権限を変更しておきます。（IDとPASSを管理したファイルの為）
```bash
sudo chmod 600 /usr/local/dipper/config/user.conf
```

<br>

▼次にサービスの起動です。

```bash
sudo systemctl enable dipper.service --now
```
<br>

### アンインストールスクリプト
▼アンインストールコマンド
```bash
bash <( curl -fsSL https://github.com/smileygames/dipper/releases/download/v1.00/uninstall.sh )
```

<br>

### 設定変更時
コンフィグファイルの内容を変更した際は、
サービスを再起動しないと反映されないので注意です。
```bash
sudo systemctl restart dipper.service
```
<br>

## マニュアルインストール方法

### ダウンロード及び権限の変更

```bash
Ver="2.10"
wget https://github.com/smileygames/dipper/archive/refs/tags/v${Ver}.tar.gz -O - | sudo tar zxvf - -C ./
sudo mv -fv dipper-${Ver} dipper
sudo cp -rv dipper /usr/local/
sudo rm -rf dipper
sudo chmod -R 755 /usr/local/dipper/bin
```

### サービス作成
```bash
sudo vi /etc/systemd/system/dipper.service
```
```bash
[Unit]
Description=ddns-ip-upper

[Service]
Type=simple
Restart=on-failure
WorkingDirectory=/usr/local/dipper/bin
ExecStart=/usr/local/dipper/bin/ip_update.sh

[Install]
WantedBy=network-online.target
```

### デーモンリロードをして追加したサービスを読み込ませて起動させる
```bash
sudo systemctl daemon-reload
sudo systemctl enable dipper.service --now
```
<br>

## スクリプト構成

自分なりの解釈のオブジェクト指向もどきで作り直しました。

言語はそのままシェルスクリプトです。

機能は変わりません。

![mydns-ip-update：スクリプト構成図 (2)](https://github.com/smileygames/mydns-ip-update/assets/134200591/19b532f9-8e56-4132-a04e-c18ee4430053)
