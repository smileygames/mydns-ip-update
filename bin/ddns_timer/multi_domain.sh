#!/bin/bash
#
# ./ddns_timer/multi_domain.sh
#
# MyDNS

Mode=$1
Login_URL=$2
IP_Version=$3
DNS_Record=$4

# 配列のデータを読み込んでDDNSへアクセス
multi_domain_ip_update() {
    for i in "${!MYDNS_ID[@]}"; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]]; then
            ./err_message.sh "no_value" "${FUNCNAME[0]}" "MYDNS_ID[$i] or MYDNS_PASS[$i]"
            continue
        fi
        ./dns_access.sh "mydns" "$i" "${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} ${Login_URL}"
    done
}

# 配列のデータを読み込んでアドレスをチェックし変更があった場合のみ、DDNSへアクセス
multi_domain_mydns_check() {
    for i in "${!MYDNS_ID[@]}"; do
        if [[ ${MYDNS_ID[$i]} = "" ]] || [[ ${MYDNS_PASS[$i]} = "" ]] || [[ ${MYDNS_DOMAIN[$i]} = "" ]]; then
            ./err_message.sh "no_value" "${FUNCNAME[0]}" "MYDNS_ID[$i] or MYDNS_PASS[$i] or MYDNS_DOMAIN[$i]"
            continue
        fi 
        IP_old=$(dig "${MYDNS_DOMAIN[$i]}" "$DNS_Record" +short)  # ドメインのアドレスを読み込む

        if [[ "$IP_New" != "$IP_old" ]]; then
            ./dns_access.sh "mydns" "$i" "${MYDNS_ID[$i]}:${MYDNS_PASS[$i]} ${Login_URL}"
         fi
    done
}

# 実行スクリプト
case ${Mode} in
   "update")
        multi_domain_ip_update
        ;;
   "check") 
        IP_New=$(dig @ident.me -"$IP_Version" +short)  # 自分のアドレスを読み込む
        if [[ $IP_New = "" ]]; then
            ./err_message.sh "no_value" "${FUNCNAME[0]}" "自分のIPアドレスを取得できなかった"
            return 1
        fi
        multi_domain_mydns_check
        ;;
    * )
        echo "[${Mode}] <- 引数エラーです"
    ;; 
esac
