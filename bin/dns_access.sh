#!/bin/bash
#
# ./dns_access.sh
#
# shellcheck disable=SC2086

Mode=$1
Func_Name=$2
Array_Num=$3
Access_URL=$4

Out_Time=25s
Max_Time=21

accsse() {
    # DDNSへアクセスするがIDやパスワードがおかしい場合、対話式モードになってスタックするのでタイムアウト処理を入れている
    timeout ${Out_Time} curl --max-time ${Max_Time} -sSu ${Access_URL}
    if [ $? != 0 ]; then 
        ./err_message.sh "timeout" "${Func_Name}" "${Out_Time}: ログイン情報 curl -u ${Mode}_ID[$Array_Num]:${Mode}_PASS[$Array_Num] URL"
    fi
}

# 実行スクリプト
accsse
