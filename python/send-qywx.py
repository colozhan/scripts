#!/usr/bin/env python3
import os
import urllib
import json
import requests
import sys
import subprocess
import logging

# 配置日志设置
logging.basicConfig(filename='/tmp/wechat_bot.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

wechat_api_url = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="

corpid = "you_corpid"
corpsecret = "you_corpsecret"
agentid = "you_agentid"
send_to = sys.argv[1]
w_message = sys.argv[2]

def get_access_token():
    token_url = f"https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid={corpid}&corpsecret={corpsecret}"
    response = requests.get(token_url)
    data = response.json()
    access_token = data.get("access_token")
    logging.info(f"访问令牌: {access_token}")
    return access_token

def send_message(access_token, message, users):
    for user in users.split('|'):
    	payload = {
        	"touser": send_to,
        	"msgtype": "text",
        	"agentid": agentid,
        	"text":{
            	"content": message
        	}
    	}	

    headers = {
        "Content-Type": "application/json"
    }

    url = f"{wechat_api_url}{access_token}"
    response = requests.post(url, data=json.dumps(payload), headers=headers)
    response_data = response.json()
    if response_data.get("errcode") == 0:
        logging.info("消息发送成功！")
    else:
        logging.error(f"消息发送失败: {response_data.get('errmsg')}")
        logging.error(f"访问令牌: {access_token}")

if __name__ == "__main__":
    access_token = get_access_token()

    if access_token:
        message = w_message
        send_message(access_token, message, send_to)
    else:
        logging.error("获取访问令牌失败！")

    # 记录sys.argv[1]和sys.argv[2]参数
    logging.info(f"sys.argv[1]: {sys.argv[1]}")
    logging.info(f"sys.argv[2]: {sys.argv[2]}")
