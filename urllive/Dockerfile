FROM python:3.12-alpine3.20

RUN apk add --no-cache ffmpeg && \
    pip install -U yt-dlp

WORKDIR /app

CMD ["sh", "-c", "while true; do yt-dlp -f 'bestvideo[height=1080]+bestaudio[acodec=opus]' -o - \"$VIDEO_URL\" | ffmpeg -i pipe:0 -c:v libx264 -preset fast -b:v 2000k -c:a aac -b:a 92k -f flv \"$RTMP_URL\"; done"]
