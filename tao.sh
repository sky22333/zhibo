#!/bin/bash

# 手动输入视频文件路径和Bilibili直播流密钥
read -p "请输入视频文件路径：" VIDEO_FILE
read -p "请输入Bilibili直播流密钥：" STREAM_KEY

# 下载最新版FFmpeg
echo "正在下载最新版FFmpeg..."
wget https://ffmpeg.org/releases/ffmpeg-latest.tar.gz
tar -xf ffmpeg-latest.tar.gz
cd ffmpeg-*
./configure
make
sudo make install

# 循环不间断推流直播
while true; do
  # 使用FFmpeg推流到B站
  ffmpeg -re -i "$VIDEO_FILE" -c:v copy -c:a aac -f flv "rtmp://live-push.bilivideo.com/live-bvc/$STREAM_KEY" </dev/null >/dev/null 2>&1 &

  # 获取FFmpeg进程ID
  ffmpeg_pid=$!

  # 等待FFmpeg进程结束
  wait $ffmpeg_pid
done
