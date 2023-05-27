#!/bin/bash
#
# FUNCNAME[1] = この関数のコール元名
#
# MyDNS

MODE=$1
FUNC_NAME=$2
MESSAGE=$3

timeout_err_message() {
    ERROR_MESSAGE="${FUNC_NAME}: Failed Timeout: ${MESSAGE}"

    echo "$ERROR_MESSAGE"
    logger -ip authpriv.err -t "${FUNC_NAME}" "${ERROR_MESSAGE}"
}

# FUNCNAME[1] = この関数のコール元名
no_value_err_message() {
    ERROR_MESSAGE="${FUNC_NAME}: no value: ${MESSAGE}"

    echo "$ERROR_MESSAGE"
    logger -ip authpriv.err -t "${FUNC_NAME}" "${ERROR_MESSAGE}"
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
        echo "${MODE} <- 引数エラーです"
    ;; 
esac
