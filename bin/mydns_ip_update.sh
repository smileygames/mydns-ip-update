#!/bin/bash
#
# ./mydns_ip_update.sh
#
# MyDNS

File_dir="/home/hal/mydns-ip-update/"
#File_dir="/usr/local/mydns-ip-update/"
source "${File_dir}config/default.conf"
source "${File_dir}config/user.conf"

mydns_ip_update() {
    if [ "$IPV4" = on ] || [ "$IPV6" = on ]; then
        if [  "$IPV4" = on ] && [ "$IPV4_DDNS" = on ]; then
            echo "1"
            trap "kill 0" EXIT
            ./ipv_check.sh "check" &
        elif [ "$IPV6" = on ] && [ "$IPV6_DDNS" = on ]; then
            echo "2"
            trap "kill 0" EXIT
            ./ipv_check.sh "check" &
        fi
        echo "0"
       ./ipv_check.sh "update"
    fi
}

# 実行スクリプト
mydns_ip_update

