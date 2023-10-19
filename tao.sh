#!/bin/bash

ffmpeg_install() {
    # 检查FFmpeg是否已经安装
    if ! command -v ffmpeg &> /dev/null; then
        echo "FFmpeg could not be found, installing now..."
        sudo apt update
        sudo apt install ffmpeg
    fi
}

stream_start() {
    # 提示用户输入视频文件路径
    read -p "请输入视频文件夹的完整路径（例如：/home/video）：" folder_path

    # 检查输入的路径是否存在
    if [ ! -d "$folder_path" ]; then
        echo "输入的路径不存在，请重新输入。"
        exit 1
    fi

    # 输入推流服务器地址
    read -p "请输入你的推流服务器地址：" server_address

    # 输入串流密钥
    read -p "请输入你的串流密钥：" stream_key

    # 提示用户输入他们想要的视频码率
    read -p "请输入你希望的视频码率（例如：2000k）：" video_bitrate

    # 提示用户输入他们想要的帧率
    read -p "请输入你希望的帧率（例如：30）：" frame_rate

    # 开始推流
    echo "开始推流..."
    while true; do
        for file in "$folder_path"/*.mp4; do
            echo "开始转码文件：$file"
            # 转码以应用新的码率和帧率
            ffmpeg -re -i "$file" -vcodec libx264 -acodec aac -b:a 128k -b:v "$video_bitrate" -r "$frame_rate" -f flv "$server_address/$stream_key"
            echo "转码完成：$file"
        done

        # 添加延迟，避免过快无限循环
        sleep 1
    done
}

stream_stop() {
    # 停止推流
    echo "停止推流。"
    pkill ffmpeg
}

# 开始菜单设置
echo "一键运行 FFmpeg 推流脚本"
echo "1. 安装 FFmpeg"
echo "2. 开始推流"
echo "3. 停止推流"

start_menu() {
    read -p "请输入数字(1-3)，选择你要进行的操作：" num
    case "$num" in
        1)
            ffmpeg_install
            ;;
        2)
            stream_start
            ;;
        3)
            stream_stop
            ;;
        *)
            echo "请输入正确的数字 (1-3)"
            ;;
    esac
}

# 运行开始菜单
start_menu
