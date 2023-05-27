#!/bin/bash
#
# FUNCNAME[1] = この関数のコール元名
#
# MyDNS

MODE=$1
CALLER=$2
MESSAGE=$3

timeout_err_message() {
    ERROR_MESSAGE="${CALLER}: Failed Timeout: ${MESSAGE}"

    echo "$ERROR_MESSAGE"
    logger -ip authpriv.err -t "${CALLER}" "${ERROR_MESSAGE}"
}

no_value_err_message() {
    ERROR_MESSAGE="${CALLER}: no value: ${MESSAGE}"

    echo "$ERROR_MESSAGE"
    logger -ip authpriv.err -t "${CALLER}" "${ERROR_MESSAGE}"
}

# 実行スクリプト
case ${MODE} in
   "timeout")
        timeout_err_message
        ;;
   "no_value") 
        no_value_err_message
        ;;
    * )
        echo "[${MODE}] <- 引数エラーです"
    ;; 
esac
