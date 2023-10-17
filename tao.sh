#!/bin/bash

# 检查FFmpeg是否已经安装
if ! command -v ffmpeg &> /dev/null
then
    echo "FFmpeg could not be found, installing now..."
    sudo apt update
    sudo apt install ffmpeg
fi

# 设置视频文件夹路径
folder_path="/home/ubuntu/so"

# 输入推流服务器地址
echo "请输入你的推流服务器地址（例如：rtmp://bdy.live-push.bilivideo.com/live-bvc）："
read server_address

# 输入串流密钥
echo "请输入你的串流密钥（例如：?streamname=live_47586957_89400165&key=c836fb100b3b83d61746125de5bea4&schedule=rtmp&pflag=1）："
read stream_key

# 开始推流
while true
do
    for file in "$folder_path"/*
    do
        if [[ $file == *.mp4 ]] || [[ $file == *.avi ]] || [[ $file == *.mkv ]] || [[ $file == *.flv ]] || [[ $file == *.mov ]]
        then
            ffmpeg -re -i "$file" -vcodec copy -acodec aac -b:a 192k -f flv "$server_address/$stream_key"
            sleep 2
        fi
    done
done
