#!/bin/bash
#
# 共通関数置き場
#
# MyDNS

# 引数の中身は @1 = "DNS_ID:DNS_PASS Login_URL" となる
dns_accsse() {
    DNS_ACCESS=$1

    timeout 20 curl --max-time 15 -sSu $DNS_ACCESS
    if [ $? != 0 ]; then 
        ERROR_MESSAGE="Failed Timeout 20sec: curl -u $DNS_ACCESS"
        echo "$ERROR_MESSAGE"
        logger -ip authpriv.err -t mydns-ip-dns_accsse "mydns-ip-dns_accsse: $ERROR_MESSAGE"
    fi
}
