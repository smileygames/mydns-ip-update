#!/bin/bash
#
# ./dns_access.sh
#
# shellcheck disable=SC2086

Mode=$1
Array_Num=$2
Access_URL=$3

mydns_accsse() {
    Out_Time=25s
    Max_Time=21
    # DDNSへアクセスするがIDやパスワードがおかしい場合、対話式モードになってスタックするのでタイムアウト処理を入れている
    timeout ${Out_Time} curl --max-time ${Max_Time} -sSu ${Access_URL}
    if [ $? != 0 ]; then 
        ./err_message.sh "timeout" "${FUNCNAME[0]}" "${Out_Time}: ログイン情報 curl -u MYDNS_ID[$Array_Num]:MYDNS_PASS[$Array_Num] URL"
    fi
}

# 実行スクリプト
case ${Mode} in
   "mydns")
        mydns_accsse
        ;;
    * )
        echo "[${Mode}] <- 引数エラーです"
    ;; 
esac
