# 循环推流无人直播


### 利用GPT写的无人直播FFmpeg推流脚本

#


#


#


### 一键脚本（ubuntu系统）

请创建文件夹并放入需要推流的mp4视频


```screen -S myabc```     #创建一个窗口会话



```curl -sL -o /root/tao.sh https://raw.githubusercontent.com/taotao1058/zhibo/main/tao.sh && chmod 700 /root/tao.sh && /root/tao.sh```

推流成功



然后新开一个终端窗口输入以下命令保持后台运行

```screen -ls```       #查看窗口会话


```screen -d 1728.myabc```     #其中进程ID照你自己的填


如果需要停止 ```screen -X -S 1728.myabc quit```       #关闭该窗口会话


#


#

###  CentOS 7 一键脚本



```curl -sL -o /root/tao.sh https://raw.githubusercontent.com/taotao1058/zhibo/main/aaatao.sh && chmod 700 /root/tao.sh && /root/tao.sh```

#


###  或者手动推流
CD到```/home```文件夹创建一个```vo```的文件并放入需要推流的视频

安装FFmpeg

 
```sudo apt update```


```sudo apt install ffmpeg -y```


然后创建新的会话窗口


``` screen -S myabc```


 推流脚本

 
```ffmpeg -re -stream_loop -1 -f concat -safe 0 -i <(find /home/vo -name "*.mp4" -exec echo "file '{}'" \;) -c:v libx264 -preset veryfast -tune zerolatency -profile:v baseline -b:v 800k -maxrate 800k -bufsize 800k -c:a aac -b:a 128k -ar 44100 -f flv -r 30 rtmp://server/live/stream```


请将 ```/home/vo``` 替换为你实际的文件夹路径

请将```rtmp://server/live/stream``` 替换为你的实际推流地址和串流密钥。



然后新开一个终端窗口输入以下命令保持后台运行

```screen -ls```       #查看会话


```screen -d 1728.myabc```     #其中进程ID照你自己的填

```screen -X -S 1728.myabc quit```       #关闭该会话窗口
