#!/bin/sh
#
# update IP address
#
# MyDNS

# Config File ロード
FILE_DIR="/usr/local/etc/"
source "${FILE_DIR}mydns-ip-update.conf"

#<<debug
mydns_update() {
# ipv4用
  if [ "$IPV4" = on ]; then
#    curl -s -u $MYDNS_IP:$MYDNS_PASS https://ipv4.mydns.jp/login.html
    echo "IPV4 update"  # debug
  fi
# ipv6用
  if [ "$IPV6" = on ]; then
#    curl -s -u $MYDNS_IP:$MYDNS_PASS https://ipv6.mydns.jp/login.html
    echo "IPV6 update"  # debug
  fi
}
#debug

mydns_update
while true;do
  echo "time = $UPDATE_TIME"  # debug
  sleep $UPDATE_TIME;mydns_update
done
