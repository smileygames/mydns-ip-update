#!/bin/bash
#
# ./multi_domain/ip_set.sh
#
# MyDNS

Mode=$1
Login_URL=$2
IP_Version=$3
DNS_Record=$4

multi_domain_ip_update() {
    for i in ${!MYDNS_ID[@]}; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            ./err_message.sh "no_value" ${FUNCNAME[0]} "MYDNS_ID[$i] or MYDNS_PASS[$i]"
            continue
        fi 
        . ./dns_access.sh "curl" $i $Login_URL
    done
}

multi_domain_ip_check() {
    IP_New=$(curl -s ifconfig.io -"$IP_Version")

    if [[ $IP_New = "" ]]; then
        ./err_message.sh "no_value" ${FUNCNAME[0]} "自分のIPアドレスを取得できなかった"
        return 1
    fi

    for i in ${!MYDNS_ID[@]}; do
        if [[ ${MY_DOMAIN[$i]} = "" ]] || [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            ./err_message.sh "no_value" ${FUNCNAME[0]} "MY_DOMAIN[$i] or MYDNS_ID[$i] or MYDNS_PASS[$i]"
            continue
        fi 
        IP_old=$(dig "${MY_DOMAIN[i]}" $DNS_Record +short)

        if [[ $IP_New != $IP_old ]]; then
            . ./dns_access.sh "curl" $i $Login_URL
            exit 1  # debug
        fi
    done
}

# 実行スクリプト
case ${Mode} in
   "update")
        multi_domain_ip_update
        ;;
   "check") 
        multi_domain_ip_check
        ;;
    * )
        echo "[${Mode}] <- 引数エラーです"
    ;; 
esac

