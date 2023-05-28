#!/bin/bash
#
# ./mydns_ip_update.sh
#
# MyDNS

File_dir="/usr/local/mydns-ip-update/"
source "${File_dir}config/default.conf"
source "${File_dir}config/user.conf"

Mode=$1

ipv_ddns_check() {
    if [ "$IPV4" = on ]; then
        if [ "$IPV4_DDNS" = on ]; then
            ./multi_domain/ip_set.sh "check" "$MYDNS_IPV4_URL" "4" "A" 
        fi
        ./multi_domain/ip_set.sh "update" "$MYDNS_IPV4_URL"
    fi

    if [ "$IPV6" = on ]; then
        if [ "$IPV6_DDNS" = on ]; then
            ./multi_domain/ip_set.sh "check" "$MYDNS_IPV6_URL" "6" "AAAA"
        fi
        ./multi_domain/ip_set.sh "update" "$MYDNS_IPV6_URL"
    fi
}

# 実行スクリプト
ipv_ddns_check
