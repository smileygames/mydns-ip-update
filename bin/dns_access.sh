#!/bin/bash
#
# MyDNSへの通知処理
#
# MyDNS

# Include File
#FILE_DIR="/usr/local/mydns-ip-update/"
FILE_DIR="/home/hal/mydns-ip-update/"
source "${FILE_DIR}mydns-ip.conf"

ARRAY_NUM=$1
ACCESS_URL=$2

curl_accsse() {
    DNS_ACCESS="${MYDNS_ID[$ARRAY_NUM]}:${MYDNS_PASS[$ARRAY_NUM]} $ACCESS_URL"

#    timeout 20 curl --max-time 15 -sSu $DNS_ACCESS
    timeout 5 curl --max-time 15 -sSu $DNS_ACCESS
    if [ $? != 0 ]; then 
        ./err_message.sh "timeout" ${FUNCNAME[0]} "20sec: curl -u MYDNS_ID[$ARRAY_NUM]:MYDNS_PASS[$ARRAY_NUM] $ACCESS_URL"
    fi
}

# 実行スクリプト
curl_accsse
