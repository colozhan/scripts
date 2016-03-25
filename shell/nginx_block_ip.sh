#!/bin/bash
#
# Filename         nginx_block_ip.sh
# By .             Thanatos.Ren
# Version          1.0
# Email            thanatos.ren@icloud.com
# Blog             http://blog.thanatos.xyz
# Description      nginx屏蔽非法ip

block_conf=/tmp/block.conf;
log_path=$your_nginx_log_path
log_file=$your_nginx_log_file
awk '/3r6y.php/' $log_path$log_file|awk '{print $1}'|sort -n|uniq>/tmp/ip.log
while read line
do
	echo "deny $line;" >>$block_conf
done </tmp/ip.log
cat $block_conf|sort -k2n|uniq>/tmp/block_conf_tmp
mv /tmp/block_conf_tmp $blcok_conf
nginx -t && echo "nginx test ok"&& nginx -s reload


