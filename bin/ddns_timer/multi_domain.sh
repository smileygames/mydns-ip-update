#!/bin/bash
#
# ./ddns_timer/multi_domain.sh
#
# multi_domain.sh

Mode=$1
IP_Version=$2
DNS_Record=$3

ip_url_set() {
    if [ "$IP_Version" = 4 ]; then
        Login_URL=${MYDNS_IPV4_URL}
    elif [ "$IP_Version" = 6 ]; then
        Login_URL=${MYDNS_IPV6_URL}
    fi
}

# 配列のデータを読み込んでDDNSへアクセス
multi_domain_ip_update() {
    ip_url_set
    for i in "${!MYDNS_ID[@]}"; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            ./err_message.sh "no_value" "${FUNCNAME[0]}" "MYDNS_ID[$i] or MYDNS_PASS[$i]"
            continue
        fi
        ./dns_access.sh "MYDNS" "${FUNCNAME[0]}" "$i" "${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} ${Login_URL}"
    done
}

# 配列のデータを読み込んでアドレスをチェックし変更があった場合のみ、DDNSへアクセス
mydns_multi_domain_check() {
    IP_New=$1

    ip_url_set
    for i in "${!MYDNS_ID[@]}"; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]] || [[ ${MYDNS_DOMAIN[$i]} = "" ]]; then
            ./err_message.sh "no_value" "${FUNCNAME[0]}" "MYDNS_ID[$i] or MYDNS_PASS[$i] or MYDNS_DOMAIN[$i]"
            continue
        fi 
        IP_old=$(dig "${MYDNS_DOMAIN[$i]}" "$DNS_Record" +short)  # ドメインのアドレスを読み込む

        if [[ "$IP_New" != "$IP_old" ]]; then
            ./dns_access.sh "MYDNS" "${FUNCNAME[0]}" "$i" "${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} ${Login_URL}"
         fi
    done
}

# Googleの場合用のDDNSアクセス
google_multi_domain_check() {
    IP_New=$1

    for i in "${!GOOGLE_ID[@]}"; do
        if [[ ${GOOGLE_ID[$i]} = "" ]] || [[ ${GOOGLE_PASS[$i]} = "" ]] || [[ ${GOOGLE_DOMAIN[$i]} = "" ]]; then
            ./err_message.sh "no_value" "${FUNCNAME[0]}" "GOOGLE_ID[$i] or GOOGLE_PASS[$i] or GOOGLE_DOMAIN[$i]"
            continue
        fi 
        if [ "$IP_Version" = 4 ] && [[ ${GOOGLE_IPV6[$i]} = on ]]; then
            continue
        elif [ "$IP_Version" = 6 ] && [[ ${GOOGLE_IPV6[$i]} = off ]]; then
            continue
        fi
        IP_old=$(dig "${GOOGLE_DOMAIN[$i]}" "$DNS_Record" +short)  # ドメインのアドレスを読み込む

        if [[ "$IP_New" != "$IP_old" ]]; then
            ./dns_access.sh "GOOGLE" "${FUNCNAME[0]}" "$i" "${GOOGLE_ID[$i]}:${GOOGLE_PASS[$i]} ${GOOGLE_URL}?hostname=${GOOGLE_DOMAIN[$i]}&myip=${IP_New}"
        fi
    done
}

# 複数のDDNSサービス用
multi_ddns_check() {
    MyIP=$(dig @ident.me -"$IP_Version" +short)  # 自分のアドレスを読み込む
    if [[ $MyIP = "" ]]; then
        ./err_message.sh "no_value" "${FUNCNAME[0]}" "自分のIPアドレスを取得できなかった"
        return 1
    fi

    if [ ${#MYDNS_ID[@]} != 0 ]; then
        mydns_multi_domain_check "$MyIP" &
    fi

    # GoogleのDDNSサービスはIPv4とIPv6が排他制御のための処理
    if [ ${#GOOGLE_ID[@]} != 0 ]; then
        google_multi_domain_check "$MyIP" &
    fi
}

# 実行スクリプト
case ${Mode} in
   "update")
        multi_domain_ip_update
        ;;
   "check") 
        multi_ddns_check
        ;;
    * )
        echo "[${Mode}] <- 引数エラーです"
    ;; 
esac
