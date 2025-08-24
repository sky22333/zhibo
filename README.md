## 循环推流无人直播脚本

### 一键脚本
- 适合推流多个视频
- 建议2核以上的配置
- 需要MP4格式的视频
- 支持所有rtmp协议的平台
- 支持Debian 11，Ubuntu 18.04，以上的系统
#### 先把需要推流的MP4视频上传到服务器
运行脚本
```
bash <(curl -sSL https://github.com/sky22333/zhibo/raw/main/ffmpeg.sh)
```

---
---

### Docker-compose
```
services:
  ffmpeg:
    image: ghcr.io/sky22333/zhibo
    container_name: ffmpeg
    restart: always
    environment:
      - STREAM_URL=rtmp://推流地址/推流密钥
    volumes:
      - ./:/videos
```

---

### 拉流直播源然后推流到指定rtmp地址
大部分地址格式都支持

#### 安装FFmpeg：

 
```
sudo apt update
```


```
sudo apt install ffmpeg -yq
```


####  前台运行（测试）
>原画质
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

#### TV直播源：
- [iptv-org/iptv](https://github.com/iptv-org/iptv/tree/master/streams)
- [Guovin/iptv-api](https://github.com/Guovin/iptv-api)
- [Free-TV/IPTV](https://github.com/Free-TV/IPTV/blob/master/playlist.m3u8)
- [影视接口](https://cn.bing.com/search?q=%E5%BD%B1%E8%A7%86%E9%87%87%E9%9B%86)

#### 前端
- [4gray/iptvnator](https://github.com/4gray/iptvnator)

#### APK
- [lizongying/my-tv-0](https://github.com/lizongying/my-tv-0)

#### 资源集合
- [dongyubin/IPTV](https://github.com/dongyubin/IPTV)

### 免责声明
- 本项目仅用于技术学习与交流，不提供任何实际资源。所有内容均来自互联网公开接口。
- 所有资源的版权归原著作权人所有，用户使用本项目产生的任何版权纠纷由用户自行承担。

---

## Stargazers over time
[![Stargazers over time](https://starchart.cc/sky22333/zhibo.svg?variant=adaptive)](https://starchart.cc/sky22333/zhibo)
