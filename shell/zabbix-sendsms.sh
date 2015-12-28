#!/bin/bash
#
# Filename         sendsms.sh
# By .             Thanatos.Ren
# Version          1.0
# Email            thanatos.ren@icloud.com
# Blog             http://blog.thanatos.xyz
# Description      zabbix短信报警脚本



#日志文件
LOGFILE="/tmp/sms.log"
:>"$LOGFILE"
exec 1>"$LOGFILE"
exec 2>&1
#TokenID
TokenID="TokenID"

#手机号码
MOBILE_NUMBER=$1
MESSAGE_UTF8=$3
XXD="/usr/bin/xxd"
CURL="/usr/bin/curl"
TIMEOUT=5

#SMSINFO
MESSAGE_ENCODE=$(echo "$MESSAGE_UTF8" | ${XXD} -ps | sed 's/\(..\)/%\1/g' | tr -d '\n')

#SMS API
URL="http://sms_api_address$MOBILE_NUMBER&FormatID$MOBILE_NUMBER&FormatID=8&Content=$MESSAGE_ENCODE&ScheduleDate=2010-1-1&TokenID=$TokenID"

#Send
set -x
${CURL} -s --connect-timeout ${TIMEOUT} "${URL}"
