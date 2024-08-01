#!/bin/bash

# 定义颜色
green='\033[0;32m'
yellow='\033[0;33m'
red='\033[0;31m'
font='\033[0m'

# 配置文件路径
CONFIG_FILE="/etc/ffmpeg_stream.conf"
LOG_FILE="/var/log/ffmpeg_stream.log"
MAX_LOG_SIZE=10M  # 日志文件最大大小
MAX_LOG_FILES=5   # 保留的日志文件数量

ffmpeg_install() {
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${yellow}正在安装 FFmpeg...${font}"
        sudo apt update && sudo apt install ffmpeg -y
        if [ $? -eq 0 ]; then
            echo -e "${green}FFmpeg 安装成功${font}"
        else
            echo -e "${red}FFmpeg 安装失败，请手动安装${font}"
            return 1
        fi
    else
        echo -e "${green}FFmpeg 已安装${font}"
    fi
}

save_config() {
    echo "RTMP_URL=$RTMP_URL" > "$CONFIG_FILE"
    echo "VIDEO_FOLDER=$VIDEO_FOLDER" >> "$CONFIG_FILE"
    echo "USE_HARDWARE_ACCEL=$USE_HARDWARE_ACCEL" >> "$CONFIG_FILE"
    echo "BITRATE=$BITRATE" >> "$CONFIG_FILE"
    echo "FRAMERATE=$FRAMERATE" >> "$CONFIG_FILE"
}

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi
}

rotate_log() {
    if [ -f "$LOG_FILE" ] && [ $(stat -c%s "$LOG_FILE") -gt $(numfmt --from=iec $MAX_LOG_SIZE) ]; then
        for i in $(seq $((MAX_LOG_FILES-1)) -1 1); do
            if [ -f "${LOG_FILE}.$i" ]; then
                mv "${LOG_FILE}.$i" "${LOG_FILE}.$((i+1))"
            fi
        done
        mv "$LOG_FILE" "${LOG_FILE}.1"
        touch "$LOG_FILE"
    fi
}

clean_old_logs() {
    find $(dirname "$LOG_FILE") -name "$(basename "$LOG_FILE")*" -type f | sort -r | tail -n +$((MAX_LOG_FILES+1)) | xargs -r rm
}

stream_start() {
    load_config

    if [ -z "$RTMP_URL" ] || [ -z "$VIDEO_FOLDER" ] || [ -z "$USE_HARDWARE_ACCEL" ] || [ -z "$BITRATE" ] || [ -z "$FRAMERATE" ]; then
        read -p "输入你的推流地址和推流码(rtmp协议): " RTMP_URL
        if [[ ! $RTMP_URL =~ ^rtmp:// ]]; then
            echo -e "${red}推流地址不合法，请重新输入！${font}"
            return 1
        fi

        read -p "输入你的视频存放目录 (格式仅支持mp4，需要绝对路径，例如/root/video): " VIDEO_FOLDER
        if [ ! -d "$VIDEO_FOLDER" ]; then
            echo -e "${red}目录不存在，请检查后重新输入！${font}"
            return 1
        fi

        read -p "是否使用硬件加速？(y/n): " use_hw
        USE_HARDWARE_ACCEL=$([ "$use_hw" = "y" ] && echo "true" || echo "false")

        read -p "输入视频比特率 (默认 1200k): " BITRATE
        BITRATE=${BITRATE:-1200k}

        read -p "输入视频帧率 (默认 30): " FRAMERATE
        FRAMERATE=${FRAMERATE:-30}

        save_config
    fi

    echo -e "${yellow}开始后台推流。使用 '状态' 选项查看状态，'停止' 选项停止推流。${font}"
    nohup bash -c '
        while true; do
            rotate_log
            clean_old_logs
            video_files=("'$VIDEO_FOLDER'"/*.mp4)
            if [ ${#video_files[@]} -eq 0 ]; then
                echo "没有找到mp4文件，等待10秒后重试..." >> "'$LOG_FILE'"
                sleep 10
                continue
            fi
            for video in "${video_files[@]}"; do
                if [ -f "$video" ]; then
                    echo "正在推流: $video" >> "'$LOG_FILE'"
                    if [ "'$USE_HARDWARE_ACCEL'" = "true" ]; then
                        ffmpeg -hwaccel auto -re -i "$video" -c:v h264_nvenc -preset p1 -tune ll -b:v '$BITRATE' -r '$FRAMERATE' -c:a aac -b:a 92k -f flv "'$RTMP_URL'" 2>> "'$LOG_FILE'" || true
                    else
                        ffmpeg -re -i "$video" -c:v libx264 -preset veryfast -tune zerolatency -b:v '$BITRATE' -r '$FRAMERATE' -c:a aac -b:a 92k -f flv "'$RTMP_URL'" 2>> "'$LOG_FILE'" || true
                    fi
                fi
            done
        done
    ' > /dev/null 2>&1 &

    echo $! > /var/run/ffmpeg_stream.pid
}

stream_stop() {
    if [ -f /var/run/ffmpeg_stream.pid ]; then
        pid=$(cat /var/run/ffmpeg_stream.pid)
        kill $pid
        rm /var/run/ffmpeg_stream.pid
        echo -e "${yellow}推流已停止${font}"
    else
        echo -e "${red}没有正在运行的推流进程${font}"
    fi
}

stream_status() {
    if [ -f /var/run/ffmpeg_stream.pid ]; then
        pid=$(cat /var/run/ffmpeg_stream.pid)
        if kill -0 $pid 2>/dev/null; then
            echo -e "${green}推流正在运行 (PID: $pid)${font}"
            echo "最近的日志:"
            tail -n 10 "$LOG_FILE"
            echo "CPU 使用率:"
            ps -p $pid -o %cpu,%mem,cmd
            echo "日志文件大小:"
            du -h "$LOG_FILE"
        else
            echo -e "${red}推流进程不存在，可能已异常退出${font}"
        fi
    else
        echo -e "${yellow}推流未运行${font}"
    fi
}

show_menu() {
    echo -e "${yellow}==== FFmpeg 无人值守循环推流脚本 ====${font}"
    echo -e "${green}1. 安装 FFmpeg${font}"
    echo -e "${green}2. 开始推流${font}"
    echo -e "${green}3. 停止推流${font}"
    echo -e "${green}4. 查看推流状态${font}"
    echo -e "${green}5. 退出${font}"
    echo -e "${yellow}=====================================${font}"
}

main() {
    while true; do
        show_menu
        read -p "请输入选项 (1-5): " choice
        case $choice in
            1)
                ffmpeg_install
                ;;
            2)
                stream_start
                ;;
            3)
                stream_stop
                ;;
            4)
                stream_status
                ;;
            5)
                echo "退出脚本"
                exit 0
                ;;
            *)
                echo -e "${red}无效的选项，请重新选择${font}"
                ;;
        esac
        echo
        read -p "按回车键继续..."
    done
}

main
