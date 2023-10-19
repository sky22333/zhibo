#!/bin/bash

# 检查FFmpeg是否已经安装
if ! command -v ffmpeg &> /dev/null
then
    echo "FFmpeg could not be found, installing now..."
    sudo apt update
    sudo apt install ffmpeg
fi

# 提示用户输入视频文件路径
echo "请输入视频文件夹的完整路径（例如：/home/video）："
read folder_path

# 检查输入的路径是否存在
if [ ! -d "$folder_path" ]
then
    echo "输入的路径不存在，请重新输入。"
    exit 1
fi

# 输入推流服务器地址
echo "请输入你的推流服务器地址（例如：rtmp://bdy.live-push.bilivideo.com/live-bvc）："
read server_address

# 输入串流密钥
echo "请输入你的串流密钥（例如：?streamname=live_4758957_8940165&key=c836fb1b3b861746125de5bea4&schedule=rtmp&pflag=1）："
read stream_key

# 提示用户输入他们想要的视频码率
echo "请输入你希望的视频码率（例如：2000k 或 2M）："
read video_bitrate

# 提示用户输入他们想要的帧率
echo "请输入你希望的帧率（例如：30）："
read frame_rate

# 开始推流
while true
do
    for file in "$folder_path"/*
    do
        if [ $file == *.mp4 ]
        then
            # 转码以应用新的码率和帧率
            ffmpeg -re -i "$file" -vcodec libx264 -acodec aac -b:a 128k -b:v $video_bitrate -r $frame_rate -f flv "$server_address/$stream_key"
        fi
    done
    
    # 添加延迟，避免过快无限循环
    sleep 1
done
