FROM python:3.12-alpine3.20

RUN apk add --no-cache ffmpeg && \
    pip install -U yt-dlp

WORKDIR /app

CMD ["sh", "-c", "while true; do yt-dlp -f 'bestvideo[height=1080]+bestaudio' -o - \"$YOUTUBE_URL\" | ffmpeg -i pipe:0 -c:v libx264 -preset fast -b:v 2000k -c:a aac -b:a 128k -f flv \"$RTMP_URL\"; done"]
