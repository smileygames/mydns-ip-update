#!/bin/bash
#
# 共通関数置き場
#
# MyDNS

# 引数の中身は @1 = "DNS_ID:DNS_PASS Login_URL" となる
dns_accsse() {
    DNS_ACCESS=$1
    timeout 15 curl --max-time 10 -sSu $DNS_ACCESS
    if [ $? != 0 ]; then 
        echo "ERROR : $DNS_ACCESS  <- TIME OUT [15sec]"
    fi
}
