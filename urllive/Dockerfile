FROM alpine:latest

RUN apk add --no-cache ffmpeg

ENV SOURCE_URL=""
ENV STREAM_URL=""

CMD ["sh", "-c", "ffmpeg -thread_queue_size 64 -i \"$SOURCE_URL\" -c:v copy -c:a aac -b:a 128k -f flv \"$STREAM_URL\""]
