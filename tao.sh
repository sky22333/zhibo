#!/bin/bash

# 检查是否已经安装了 yum
if ! command -v yum &> /dev/null
then
    echo "yum 未安装，退出..."
    exit 1
fi

# 检查是否已经安装了 FFmpeg
if ! command -v ffmpeg &> /dev/null
then
    echo "FFmpeg 未安装，开始安装..."
    yum install -y epel-release
    rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
    rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
    yum install -y ffmpeg ffmpeg-devel
else
    echo "FFmpeg 已安装"
fi

stream_start(){
    # 定义推流地址和推流码
    read -p "输入你的推流地址和推流码(rtmp协议):" rtmp

    # 判断用户输入的地址是否合法
    if [[ $rtmp =~ "rtmp://" ]];then
        echo "推流地址输入正确,程序将进行下一步操作."
        sleep 2
    else  
        echo "你输入的地址不合法,请重新运行程序并输入!"
        exit 1
    fi 

    # 定义视频存放目录
    read -p "输入你的视频存放目录 (格式仅支持mp4,并且要绝对路径,例如/opt/video):" folder

    # 循环
    while true
    do
        cd $folder
        for video in $(ls *.mp4)
        do
            ffmpeg -re -i "$video" -c:v copy -c:a aac -b:a 192k -strict -2 -f flv ${rtmp}
        done
    done
}

# 开始菜单设置
echo "CentOS7 X86_64 FFmpeg无人值守循环推流"
echo "1.开始无人值守循环推流"
start_menu(){
    read -p "请输入数字(1),选择你要进行的操作:" num
    case "$num" in
        1)
        stream_start
        ;;
        *)
        echo "请输入正确的数字 (1)"
        ;;
    esac
}
start_menu
