#!/bin/bash

# 检查FFmpeg是否已安装
if ! command -v ffmpeg &> /dev/null; then
    echo "FFmpeg未安装，正在安装最新版本..."
    sudo apt update
    sudo apt install ffmpeg -y
fi

read -p "请输入直播服务器地址: " server
while [[ -z "$server" ]]; do
  echo "直播服务器地址不能为空，请重新输入。"
  read -p "请输入直播服务器地址: " server
done

read -p "请输入串流密钥: " key
while [[ -z "$key" ]]; do
  echo "串流密钥不能为空，请重新输入。"
  read -p "请输入串流密钥: " key
done

ffmpeg -re -stream_loop -1 -f concat -safe 0 -i <(find /home/ubuntu/so -name "*.mp4" -exec echo "file '{}'" \;) \
  -c:v libx264 -preset veryfast -tune zerolatency -profile:v baseline -b:v 900k -maxrate 800k -bufsize 800k \
  -c:a aac -b:a 94k -ar 44100 -f flv -r 30 "rtmp://$server/live/$key"
