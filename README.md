## 循环推流无人直播脚本




 [Docker部署](https://github.com/sky22333/Docker-Hub/blob/main/docker/docker%20ffmpeg.md) 适合推流单个视频



### 一键脚本
- 适合推流多个视频
- 建议2核以上的配置
- 需要MP4格式的视频
- 支持所有rtmp协议的平台
- 支持Debian 11，Ubuntu 18.04，CentOS 7，以上的系统
#### 先把需要推流的MP4视频上传到服务器
运行脚本
```
bash <(wget -qO- https://github.com/sky22333/zhibo/raw/main/ffmpeg.sh)
```





---
---
---

### 拉流直播源然后推流到指定rtmp地址


#### 安装FFmpeg：

 
```
sudo apt update
```


```
sudo apt install ffmpeg -yq
```


####  前台运行（测试）

原画质
```
ffmpeg -thread_queue_size 64 -i "直播源URL" -c:v copy -c:a aac -b:a 128k -f flv "推流地址和推流码"
```




#### 后台运行

```
nohup ffmpeg -thread_queue_size 64 -i "直播源URL" -c:v copy -c:a aac -b:a 128k -f flv "推流地址和推流码" > /dev/null 2>&1 &
```



#### 强制停止推流

```
pkill -f "ffmpeg"
```

---

#### 较高画质
```
nohup ffmpeg -thread_queue_size 64 -i "直播源URL" -c:v libx264 -preset medium -crf 18 -tune film -c:a aac -b:a 128k -f flv "推流地址和推流码" > /dev/null 2>&1 &
```





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

