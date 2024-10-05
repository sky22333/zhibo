FROM python:3.12-alpine3.20

RUN apk add --no-cache ffmpeg && \
    pip install -U yt-dlp

WORKDIR /app

# 普通画质CPU占用低，带宽占用高，大约需要2H 30M以上
CMD ["sh", "-c", "\
    while true; do \
        yt-dlp \
            -f 'bestvideo[height=1080]+bestaudio[acodec=opus]' \
            -o - \
            \"$VIDEO_URL\" | \
        ffmpeg \
            -i pipe:0 \
            -c:v libx264 \
            -preset ultrafast \
            -tune zerolatency \
            -crf 23 \
            -c:a aac \
            -b:a 96k \
            -f flv \
            \"$RTMP_URL\"; \
    done \
"]

# 高画质CPU占用高，带宽占用低，大约需要4H 10M以上
# CMD ["sh", "-c", "while true; do yt-dlp -f 'bestvideo[height=1080]+bestaudio[acodec=opus]' -o - \"$VIDEO_URL\" | ffmpeg -i pipe:0 -c:v libx264 -preset veryfast -crf 23 -c:a aac -b:a 128k -f flv \"$RTMP_URL\"; done"]
