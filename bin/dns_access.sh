#!/bin/bash
#
# MyDNSへの通知処理
#
# MyDNS

# Include File
FILE_DIR="/usr/local/mydns-ip-update/"
source "${FILE_DIR}mydns-ip.conf"

ARRAY_NUM=$1
ACCESS_URL=$2
DNS_ACCESS="${MYDNS_ID[$ARRAY_NUM]}:${MYDNS_PASS[$ARRAY_NUM]} $ACCESS_URL"

curl_accsse() {
    timeout 20 curl --max-time 15 -sSu $DNS_ACCESS
    if [ $? != 0 ]; then 
        err_message.sh "timeout" "20sec: curl -u MYDNS_ID[$ARRAY_NUM]:MYDNS_PASS[$ARRAY_NUM] $ACCESS_URL"
    fi
}

# 実行スクリプト
curl_accsse
