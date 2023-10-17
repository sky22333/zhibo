# B站循环推流无人直播


# 利用GPT写的B站无人直播推流脚本，适用于乌班图系统，本人liunx小白，欢迎指导


请将需要推流的视频上传到你服务器的```/home/ubuntu/so```文件下，如果没有请创建一个这样的文件


CD到脚本文件路径，为脚本文件赋予可执行权限```chmod +x 脚本文件名```


开启后台运行```nohup 脚本文件路径 &```


# 脚本格式如下，需.sh的格式


```
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
```
