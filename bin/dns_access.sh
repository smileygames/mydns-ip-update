#!/bin/bash
#
# ./dns_access.sh
#
# MyDNS

File_dir="/usr/local/mydns-ip-update/"
#File_dir="/home/hal/mydns-ip-update/"
source "${File_dir}inclde/include.sh"

Mode=$1
Array_Num=$2
Access_URL=$3

curl_accsse() {
    DNS_Access="${MYDNS_ID[$Array_Num]}:${MYDNS_PASS[$Array_Num]} $Access_URL"

#    timeout 20 curl --max-time 15 -sSu $DNS_Access
    timeout 5 curl --max-time 15 -sSu $DNS_Access
    if [ $? != 0 ]; then 
        ./err_message.sh "timeout" ${FUNCNAME[0]} "20sec: curl -u MYDNS_ID[$Array_Num]:MYDNS_PASS[$Array_Num] $Access_URL"
    fi
}

# 実行スクリプト
case ${Mode} in
   "curl")
        curl_accsse
        ;;
    * )
        echo "[${Mode}] <- 引数エラーです"
    ;; 
esac
