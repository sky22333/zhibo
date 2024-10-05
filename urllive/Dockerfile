FROM python:3.12-alpine3.20

# 安装 FFmpeg 和 yt-dlp
RUN apk add --no-cache ffmpeg && \
    pip install -U yt-dlp

WORKDIR /app

CMD ["sh", "-c", "while true; do yt-dlp -f best -o - \"$YOUTUBE_URL\" | ffmpeg -re -i pipe:0 -c copy -f flv \"$RTMP_URL\"; done"]

# 编码成libx264格式，兼容某些平台
# CMD ["sh", "-c", "while true; do yt-dlp -f 'bestvideo[height=1080]+bestaudio' -o - \"$YOUTUBE_URL\" | ffmpeg -i pipe:0 -c:v libx264 -preset fast -b:v 3000k -c:a aac -b:a 128k -f flv \"$RTMP_URL\"; done"]
