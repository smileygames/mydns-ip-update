#!/bin/bash
#
# err_message.sh
#
# Caller = この関数のコール元名

Mode=$1
Caller=$2
Message=$3

timeout_err_message() {
    Error_Message="${Caller}: Failed Timeout: ${Message}"

    echo "$Error_Message"
    logger -ip authpriv.err -t "${Caller}" "${Error_Message}"
}

no_value_err_message() {
    Error_Message="${Caller}: no value: ${Message}"

    echo "$Error_Message"
    logger -ip authpriv.err -t "${Caller}" "${Error_Message}"
}

# 実行スクリプト
case ${Mode} in
   "timeout")
        timeout_err_message
        ;;
   "no_value") 
        no_value_err_message
        ;;
    * )
        echo "[${Mode}] <- 引数エラーです"
    ;; 
esac
