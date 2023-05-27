#!/bin/bash
#
# multi domain ip access
#
# MyDNS

# Include File
#FILE_DIR="/usr/local/mydns-ip-update/"
FILE_DIR="/home/hal/mydns-ip-update/"
source "${FILE_DIR}mydns-ip.conf"

MODE=$1
LOGIN_URL=$2
IP_VERSION=$3
DNS_RECORD=$4

multi_domain_ip_update() {
    for i in ${!MYDNS_ID[@]}; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            ./err_message.sh "no_value" ${FUNCNAME[0]} "MYDNS_ID[$ARRAY_NUM] or MYDNS_PASS[$ARRAY_NUM]"
            continue
        fi 
        ./dns_access.sh $i $LOGIN_URL
    done
}

multi_domain_ip_check() {
    IP_NEW=$(curl -s ifconfig.io -"$IP_VERSION")

    if [[ $IP_NEW != "" ]]; then
        for i in ${!MYDNS_ID[@]}; do
            if [[ ${MY_DOMAIN[$i]} = "" ]] || [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
                ./err_message.sh "no_value" ${FUNCNAME[0]} "MY_DOMAIN[$ARRAY_NUM] or MYDNS_ID[$ARRAY_NUM] or MYDNS_PASS[$ARRAY_NUM]"
                continue
            fi 
            IP_OLD=$(dig "${MY_DOMAIN[i]}" $DNS_RECORD +short)

            if [[ $IP_NEW != $IP_OLD ]]; then
                ./dns_access.sh $i $LOGIN_URL
            fi
        done
    fi
}

# 実行スクリプト
case ${MODE} in
   "update")
        multi_domain_ip_update
        ;;
   "check") 
        multi_domain_ip_check
        ;;
    * )
        echo "${MODE} <- 引数エラーです"
    ;; 
esac

