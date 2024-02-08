# 循环推流无人直播


### 利用GPT写的无人直播FFmpeg推流脚本

#


[docker部署方式](https://github.com/taotao1058/Docker-Hub/blob/main/docker%20ffmpeg.md)


#


### 一键脚本（ubuntu系统）

#### 请创建文件夹并放入需要推流的mp4视频

创建一个新的会话窗口:

```
screen -S myabc
```


开始推流:

```
curl -sL -o /root/tao.sh https://raw.githubusercontent.com/taotao1058/zhibo/main/tao.sh && chmod 755 /root/tao.sh && /root/tao.sh
```

推流成功。



然后新开一个终端窗口输入以下命令保持后台运行

查看窗口会话：

```
screen -ls
```       

其中进程ID照你自己的填：

```
screen -d 1728.myabc
```     


如果需要停止：

```
screen -X -S 1728.myabc quit
```
关闭该窗口会话


#


#

###  CentOS 7 一键脚本



```
curl -sL -o /root/tao.sh https://raw.githubusercontent.com/taotao1058/zhibo/main/aaatao.sh && chmod 755 /root/tao.sh && /root/tao.sh
```

#


##  手动推流教程：
CD到```/home```文件夹创建一个```vo```的文件并放入需要推流的视频

#### 安装FFmpeg：

 
```
sudo apt update
```


```
sudo apt install ffmpeg -y
```



#### 后台运行推流命令:

 
```
nohup ffmpeg -re -stream_loop -1 -f concat -safe 0 -i <(find /home/vo -name "*.mp4" -exec echo "file '{}'" \;) -c:v copy -c:a aac -b:a 128k -ar 44100 -f flv -r 30 rtmp://server/live/stream &
disown
```


请将 ```/home/vo``` 替换为你实际的视频文件夹路径

请将```rtmp://server/live/stream``` 替换为你的实际推流地址和串流密钥。

#### 强制停止推流

```
pkill -f "ffmpeg"
```






## 拉流直播源然后推流到指定rtmp地址

####  前台运行

```
ffmpeg -thread_queue_size 16 -i "直播源URL" -c:v libx264 -preset ultrafast -tune zerolatency -c:a aac -strict experimental -f flv rtmp://your_rtmp_server/live/stream_key
```

#### 后台运行

```
nohup ffmpeg -thread_queue_size 16 -i "直播源URL" -c:v libx264 -preset ultrafast -tune zerolatency -c:a aac -strict experimental -f flv rtmp://your_rtmp_server/live/stream_key > ffmpeg_output.log 2>&1 &
disown
```

替换 `rtmp://your_rtmp_server/live/stream_key`


#### 强制停止推流

```
pkill -f "ffmpeg"
```



##  带宽码率推荐:

| 视频清晰度    | 建议视频码率 (kbps) | 音频码率 (kbps) | 大约占用带宽 (Mbps) |
|-------------|-------------------|----------------|------------------|
| 标清 480p  | 500 - 1500        | 128            | 1 - 2     |
| 高清 720p  | 1500 - 4000       | 128            | 2 - 4      |
| 超清 1080p | 3000 - 6000       | 128            | 4 - 7      |
| 2K           | 8000 - 20000      | 128            | 9 - 20     |
| 4K           | 15000 - 50000     | 128            | 15 - 50    |



---

