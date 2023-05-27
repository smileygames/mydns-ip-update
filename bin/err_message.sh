#!/bin/bash
#
# FUNCNAME[1] = この関数のコール元名
#
# MyDNS

MODE=$1
MESSAGE=$2

timeout_err_message() {
    ERROR_MESSAGE="${FUNCNAME[2]}: Failed Timeout: ${MESSAGE}"

    echo "$ERROR_MESSAGE"
    logger -ip authpriv.err -t "${FUNCNAME[2]}" "${ERROR_MESSAGE}"
}

# FUNCNAME[1] = この関数のコール元名
no_value_err_message() {
    ERROR_MESSAGE="${FUNCNAME[2]}: no value: $MESSAGE"

    echo "$ERROR_MESSAGE"
    logger -ip authpriv.err -t "${FUNCNAME[2]}" "$ERROR_MESSAGE"
}

# 実行スクリプト
case ${MODE} in
   "timeout")
        timeout_err_message
        ;;
   "no_value") 
        no_value_err_message
        ;;
esac
