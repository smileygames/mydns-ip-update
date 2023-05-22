#!/bin/bash
#
# update IP address
#
# MyDNS

# Config File ロード
FILE_DIR="/usr/local/etc/"
source "${FILE_DIR}mydns-ip-update.conf"

mydns_update() {
# ipv4用
  if [ "$IPV4" = on ]; then
    for ((i=0 ; i<${#MYDNS_IP[@]}; i++)) do
      curl -s -u ${MYDNS_IP[i]}:${MYDNS_PASS[i]} https://ipv4.mydns.jp/login.html
    done
  fi
# ipv6用
  if [ "$IPV6" = on ]; then
    for ((i=0 ; i<${#MYDNS_IP[@]}; i++)) do
      curl -s -u ${MYDNS_IP[i]}:${MYDNS_PASS[i]} https://ipv6.mydns.jp/login.html
    done
  fi
}

# 実行スクリプト（タイマー処理）
sleep 5m;mydns_update
while true;do
  sleep $UPDATE_TIME;mydns_update
done
