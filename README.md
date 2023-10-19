# 循环推流无人直播


# 利用GPT写的无人直播推流脚本，适用于ubuntu系统，本人liunx小白，欢迎指导建议

#


#


#


# 一键脚本（需root身份）

创建文件夹并放入需要推流的视频```/home/ubuntu/so```


```screen -S myabc ```



```curl -sL -o /root/tao.sh https://raw.githubusercontent.com/taotao1058/B-/main/tao.sh && chmod 700 /root/tao.sh && /root/tao.sh```

推流成功
#
然后新开一个窗口输入以下命令保持后台运行

```screen -ls ``` 


```screen -d 1728.myabc```     #其中进程ID照你自己的填

#


#


# 或者自己编译脚本文件

CD到```/home/ubuntu```文件夹创建一个```so```的文件并放入需要推流的视频

CD到```/home/ubuntu```文件创建脚本文件


``` touch tao.sh ```


为脚本文件赋予可执行权限```chmod +x tao.sh```


创建新的会话


``` screen -S myabc ```

运行```bash tao.sh``` 

重新开个窗口连接到服务器输入以下命令开启后台运行

``` screen -ls ``` 

```screen -d 1728.myabc```     #其中进程ID照你自己的填

#


#


# 脚本格式如下


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
        if [[ $file == *.mp4 ]] || [[ $file == *.avi ]] || [[ $file == *.mkv ]] || [[ $file == *.flv ]] || [[ $file == *.mov ]]
        then
            # 转码以应用新的码率和帧率
            ffmpeg -re -i "$file" -vcodec libx264 -acodec aac -b:a 192k -b:v $video_bitrate -r $frame_rate -f flv "$server_address/$stream_key"
            
            exit_code=$?
            if [ $exit_code -ne 0 ]; then
                echo "推流失败，错误码: $exit_code"
                # 在出错时中断循环
                break
            fi
        fi
    done
    
    if [ $exit_code -ne 0 ]; then
        echo "由于上述错误，脚本已停止。"
        exit
    fi
done
```
