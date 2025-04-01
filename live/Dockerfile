FROM python:3.12-alpine

# 安装必要组件
RUN apk add --no-cache \
    ffmpeg \
    && pip install --no-cache-dir psutil

# 设置工作目录
WORKDIR /app

# 复制推流脚本
COPY . .

# 创建视频目录
RUN mkdir -p /videos

# 环境变量
ENV STREAM_URL="" \
    VIDEO_DIR="/videos" \
    FFMPEG_OPTIONS="-c:v libx264 -preset veryfast -b:v 1500k -c:a aac -b:a 92k -f flv"

# 设置启动命令
CMD ["python", "stream_seamless.py"]
