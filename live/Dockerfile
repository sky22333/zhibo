FROM python:3.12-alpine

# 安装依赖
RUN apk add --no-cache \
    ffmpeg \
    coreutils

# 设置工作目录
WORKDIR /app

# 复制脚本
COPY stream_seamless.py ./
RUN chmod +x stream_seamless.py

# 创建视频目录
RUN mkdir -p /videos && chmod 777 /videos

# 环境变量
ENV STREAM_URL="" \
    FFMPEG_OPTIONS="-c:v libx264 -preset fast -b:v 1800k -c:a aac -b:a 92k -f flv"

CMD ["python", "stream_seamless.py"]
