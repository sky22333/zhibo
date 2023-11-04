#!/bin/bash

ffmpeg_install() {
    # 安装FFMPEG
    read -p "你的机器内是否已经安装过FFmpeg 4.x? (yes/no): " choose
    if [ "$choose" = "yes" ]; then
        sudo apt-get update
        sudo apt-get install ffmpeg
    elif [ "$choose" = "no" ]; then
        echo -e "${yellow}你选择不安装FFmpeg，请确定你的机器内已经自行安装过FFmpeg，否则程序无法正常工作！${font}"
        sleep 2
    fi
}

stream_start() {
    # 定义推流地址和推流码
    read -p "输入你的推流地址和推流码(rtmp协议): " rtmp

    # 判断用户输入的地址是否合法
    if [[ $rtmp =~ "rtmp://" ]]; then
        echo -e "${green}推流地址输入正确，程序将进行下一步操作。${font}"
        sleep 2
    else
        echo -e "${red}你输入的地址不合法，请重新运行程序并输入！${font}"
        exit 1
    fi

    # 定义视频存放目录
    read -p "输入你的视频存放目录 (格式仅支持mp4，并且要绝对路径，例如/opt/video): " folder

    echo -e "${yellow}程序将开始推流。按 Ctrl+C 停止推流。${font}"
    while true; do
        # 使用 find 命令查找指定目录下的所有 .mp4 文件，并逐个推流
        find "$folder" -type f -name "*.mp4" -exec ffmpeg -re -i {} -c:v libx264 -preset veryfast -tune zerolatency -b:v 1200k -r 30 -c:a aac -b:a 92k -strict -2 -f flv "$rtmp" \;
    done
}

stream_stop() {
    # 停止推流
    echo -e "${yellow}停止推流。${font}"
    pkill ffmpeg
}

# 开始菜单设置
echo -e "${yellow}Ubuntu FFmpeg无人值守循环推流 For LALA.IM${font}"
echo -e "${red}请确定此脚本目前是在screen窗口内运行的！${font}"
echo -e "${green}1.安装FFmpeg（机器要安装FFmpeg才能正常推流）${font}"
echo -e "${green}2.开始无人值守循环推流${font}"
echo -e "${green}3.停止推流${font}"

start_menu() {
    read -p "请输入数字(1-3)，选择你要进行的操作: " num
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
            echo -e "${red}请输入正确的数字 (1-3)${font}"
            ;;
    esac
}

# 运行开始菜单
start_menu
