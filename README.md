# 循环推流无人直播


### 利用GPT写的无人直播FFmpeg推流脚本，适用于ubuntu系统

#


#


#


### 一键脚本（需root身份）

CD到```/home/ubuntu```文件夹创建一个```so```的文件并放入需要推流的视频


```screen -S myabc ```



```curl -sL -o /root/tao.sh https://raw.githubusercontent.com/taotao1058/B-/main/tao.sh && chmod 700 /root/tao.sh && /root/tao.sh```

推流成功



然后新开一个窗口输入以下命令保持后台运行

```screen -ls ``` 


```screen -d 1728.myabc```     #其中进程ID照你自己的填

#


#

###  低性能便宜服务器使用这个方案


一键脚本

```curl -sL -o /root/tao.sh https://raw.githubusercontent.com/taotao1058/B-/main/aaatao.sh && chmod 700 /root/tao.sh && /root/tao.sh```

#


###  或者
CD到```/home/ubuntu```文件夹创建一个```so```的文件并放入需要推流的视频

安装FFmpeg

 
```sudo apt update```


```sudo apt install ffmpeg -y```


然后创建新的会话


``` screen -S myabc ```


 推流脚本

 
```ffmpeg -re -stream_loop -1 -f concat -safe 0 -i <(find /home/ubuntu/so -name "*.mp4" -exec echo "file '{}'" \;) -c:v libx264 -preset veryfast -tune zerolatency -profile:v baseline -b:v 800k -maxrate 800k -bufsize 800k -c:a aac -b:a 128k -ar 44100 -f flv -r 30 rtmp://server/live/stream```


请将 ```/home/ubuntu/so``` 替换为你实际的文件夹路径```rtmp://server/live/stream``` 替换为你的实际推流地址和串流密钥。



然后新开一个窗口输入以下命令保持后台运行

```screen -ls ``` 


```screen -d 1728.myabc```     #其中进程ID照你自己的填

```screen -X -S 1728.myabc quit```       #停止该会话
