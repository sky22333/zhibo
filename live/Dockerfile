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

# 推流参数环境变量（不转码）
ENV STREAM_URL="" \
    FFMPEG_OPTIONS="-c:v copy -c:a copy -f flv \
    -flvflags no_duration_filesize+no_sequence_end \
    -fflags +genpts+discardcorrupt \
    -avoid_negative_ts make_zero \
    -vsync passthrough \
    -movflags faststart"

CMD ["python", "stream_seamless.py"]