#!/bin/bash
# 检查是否安装jq模块，若未安装则自动安装
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Installing jq..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y jq
    elif command -v yum &> /dev/null; then
        sudo yum install -y epel-release
        sudo yum install -y jq
    else
        echo "Error: Unable to install jq. Please install jq manually."
        exit 1
    fi
fi
# Bark Token信息
BAKR_API=replaceapi

# 获取登录信息
IP=$(echo $SSH_CONNECTION | awk '{print $1}')
TIME=$(date +"%Y年%m月%d日 %H:%M:%S")
# 查询IP地址对应的地区信息
 LOCATION=$(curl -s "http://opendata.baidu.com/api.php?query=$IP&co=&resource_id=6006&oe=utf8&format=json" | jq -r '.data[0].location')
# 获取当前用户名
 USERNAME=$(whoami)
 HOSTNAME=$(hostname)
# 发送Telegram消息
MESSAGE="ℹ️ 登录信息：
登录机器：$HOSTNAME
登录名：$USERNAME
登录IP：$IP            
登录时间：$TIME
登录地区：$LOCATION"

curl "$BAKR_API/$MESSAGE?group=SSH_Login\&sound\=choo" &
