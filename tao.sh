#!/bin/bash

# 安装 FFmpeg
if ! command -v ffmpeg &> /dev/null
then
    echo "FFmpeg could not be found, installing now..."
    sudo apt update
    sudo apt install ffmpeg
fi

# 安装 dos2unix
if ! command -v dos2unix &> /dev/null
then
    echo "dos2unix could not be found, installing now..."
    sudo apt install dos2unix
fi

# 创建视频文件夹
folder_path="/home/ubuntu/so"
if [ ! -d "$folder_path" ]
then
    echo "Creating video folder..."
    mkdir "$folder_path"
fi

# 创建推流脚本
script_path="/home/ubuntu/you.sh"
cat > "$script_path" << EOL
#!/bin/bash

# 设置视频文件夹路径
folder_path="/home/ubuntu/so"

# 输入推流服务器地址
echo "请输入你的推流服务器地址（例如：rtmp://bdy.live-push.bilivideo.com/live-bvc）："
read server_address

# 输入串流密钥
echo "请输入你的串流密钥（例如：?streamname=live_4756957_8900165&key=c86fb10b3b83d6176125de5bea4&schedule=rtmp&pflag=1）："
read stream_key

# 开始推流
while true
do
    for file in "\$folder_path"/*
    do
        if [[ \$file == *.mp4 ]] || [[ \$file == *.avi ]] || [[ \$file == *.mkv ]] || [[ \$file == *.flv ]] || [[ \$file == *.mov ]]
        then
            ffmpeg -re -i "\$file" -vcodec copy -acodec aac -b:a 192k -f flv "\$server_address/\$stream_key"
            sleep 2
        fi
    done
done
EOL

# 转换脚本格式
dos2unix "$script_path"

# 为脚本赋予可执行权限
chmod +x "$script_path"

# 开启后台运行
nohup "$script_path" &
