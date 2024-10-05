FROM jrottenberg/ffmpeg

RUN apk add --no-cache python3 py3-pip && \
    pip3 install -U yt-dlp

CMD ["sh", "-c", "while true; do yt-dlp -f best -o - \"$YOUTUBE_URL\" | ffmpeg -re -i pipe:0 -c copy -f flv \"$RTMP_URL\"; done"]

# 编码成libx264格式，兼容某些平台
CMD ["sh", "-c", "while true; do yt-dlp -f best -o - \"$YOUTUBE_URL\" | ffmpeg -i pipe:0 -c:v libx264 -preset fast -b:v 2500k -c:a aac -b:a 128k -f flv \"$RTMP_URL\"; done"]
