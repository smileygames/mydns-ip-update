#!/bin/bash
#
# ./dns_access.sh
#
# MyDNS

File_dir="/usr/local/mydns-ip-update/"
source "${File_dir}config/default.conf"
source "${File_dir}config/user.conf"

Mode=$1
Array_Num=$2
Access_URL=$3

curl_accsse() {
    DNS_Access="${MYDNS_ID[$Array_Num]}:${MYDNS_PASS[$Array_Num]} $Access_URL"
    Out_Time=25s
    Max_Time=21

    timeout ${Out_Time} curl --max-time ${Max_Time} -sSu $DNS_Access
    if [ $? != 0 ]; then 
        ./err_message.sh "timeout" ${FUNCNAME[0]} "${Out_Time}: curl -u MYDNS_ID[$Array_Num]:MYDNS_PASS[$Array_Num] $Access_URL"
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
