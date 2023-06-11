#!/bin/bash
#
# ./err_message.sh
#
# Caller = この関数のコール元名
:<< facility
code	facility	対象ログ
0	    kern    	カーネル
1	    user    	ユーザープロセス
2	    mail    	メールサービス
3	    daemon  	各種デーモン
4	    auth    	認証（非推奨、authprivが推奨）
4	    security	認証（非推奨、authprivが推奨）
5	    syslog  	syslog内部メッセージ
6	    lpr     	プリンタサービス
7	    news    	ニュースサービス
8	    uucp    	uucp転送を行うプログラム
9	    cron    	cron
10	    authpriv	認証
11	    ftp	ftp
16	    local0	    任意の用途
17	    local1	    任意の用途
18	    local2	    任意の用途
19	    local3	    任意の用途
20	    local4	    任意の用途
21	    local5	    任意の用途
22	    local6	    任意の用途
23	    local7	    任意の用途

priority
code	priority	内容
0   	panic	    非常に重大なメッセージ、
0   	emerg	    システムが落ちるような状態
1   	alert	    緊急に対処すべきエラー
2   	crit	    致命的なエラー
3   	err	        一般的なエラー
4   	warn	    警告
5   	notice	    通知
6   	info	    情報
7   	debug	    デバッグ情報
facility

Mode=$1
Caller=$2
Message=$3

# タイムアウトエラー
timeout_err_message() {
    Error_Message="${Caller}: Failed Timeout: ${Message}"
    logger -ip authpriv.err -t "${Caller}" "${Error_Message}"
}

# データがないエラー
no_value_err_message() {
    Error_Message="${Caller}: no value: ${Message}"
    logger -ip authpriv.err -t "${Caller}" "${Error_Message}"
}

# バックグラウンドプロセスエラー
process_err_message() {
    Error_Message="${Caller}: abend error : ${Message}"
    logger -ip daemon.err -t "${Caller}" "${Error_Message}"
}

# 実行スクリプト
case ${Mode} in
   "timeout")
        timeout_err_message
        ;;
   "no_value") 
        no_value_err_message
        ;;
   "process")
        process_err_message
        ;;
    * )
        echo "[${Mode}] <- 引数エラーです"
    ;; 
esac
