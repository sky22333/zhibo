## 循环推流无人直播脚本




### [Docker部署](https://github.com/sky22333/Docker-Hub/blob/main/docker/docker%20ffmpeg.md)



### 一键脚本
适用于ubuntu/debian系统

#### 先创建文件夹并放入需要推流的mp4视频
运行脚本
```
bash <(wget -qO- -o- https://github.com/sky22333/zhibo/raw/main/ffmpeg.sh)
```





---
---
---

## 拉流直播源然后推流到指定rtmp地址


#### 安装FFmpeg：

 
```
sudo apt update
```


```
sudo apt install ffmpeg -y
```


####  前台运行

```
ffmpeg -thread_queue_size 16 -i "直播源URL" -c:v libx264 -preset ultrafast -tune zerolatency -c:a aac -strict experimental -f flv "推流地址"
```

#### 后台运行

```
nohup ffmpeg -thread_queue_size 16 -i "直播源URL" -c:v libx264 -preset ultrafast -tune zerolatency -c:a aac -strict experimental -f flv "推流地址" > ffmpeg_output.log 2>&1 &
disown
```



#### 强制停止推流

```
pkill -f "ffmpeg"
```

---
---
---

##  带宽码率推荐:

| 视频清晰度    | 建议视频码率 (kbps) | 音频码率 (kbps) | 大约占用带宽 (Mbps) |
|-------------|-------------------|----------------|------------------|
| 标清 480p  | 500 - 1500        | 128            | 1 - 2     |
| 高清 720p  | 1500 - 4000       | 128            | 2 - 4      |
| 超清 1080p | 3000 - 6000       | 128            | 4 - 7      |
| 2K           | 8000 - 20000      | 128            | 9 - 20     |
| 4K           | 15000 - 50000     | 128            | 15 - 50    |



---

