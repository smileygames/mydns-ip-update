#!/bin/bash
#
# 共通関数置き場
#
# MyDNS

# FUNCNAME[1] = この関数のコール元名
dns_accsse() {
    ARRAY_NUM=$1
    ACCESS_URL=$2
    DNS_ACCESS="${MYDNS_ID[$ARRAY_NUM]}:${MYDNS_PASS[$ARRAY_NUM]} $ACCESS_URL"

    timeout 10 curl --max-time 5 -sSu $DNS_ACCESS
    if [ $? != 0 ]; then 
        ERROR_MESSAGE="${FUNCNAME[1]}: Failed Timeout 20sec: curl -u MYDNS_ID[$ARRAY_NUM]:MYDNS_PASS[$ARRAY_NUM] $ACCESS_URL"
        echo "$ERROR_MESSAGE"
        logger -ip authpriv.err -t "${FUNCNAME[1]}" "$ERROR_MESSAGE"
    fi
}

# FUNCNAME[1] = この関数のコール元名
no_value_err_message() {
    MESSAGE=$1
    ERROR_MESSAGE="${FUNCNAME[1]}: no value: $MESSAGE"

    echo "$ERROR_MESSAGE"
    logger -ip authpriv.err -t "${FUNCNAME[1]}" "$ERROR_MESSAGE"
}
