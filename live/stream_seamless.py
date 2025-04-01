#!/usr/bin/env python3
import os
import subprocess
import time
from glob import glob
import sys

def get_video_files():
    """获取排序后的视频文件列表"""
    return sorted(glob(f"{os.getenv('VIDEO_DIR', '/videos')}/*.mp4"))

def generate_concat_list(files):
    """生成FFmpeg concat列表"""
    return "".join(f"file '{f}'\n" for f in files)

def start_stream(stream_url, concat_list):
    """启动FFmpeg推流进程"""
    ffmpeg_cmd = [
        "ffmpeg",
        "-loglevel", "info",
        "-re",
        "-f", "concat",
        "-safe", "0",
        "-i", "-",
        *os.getenv('FFMPEG_OPTIONS', '').split(),
        stream_url
    ]
    
    return subprocess.Popen(
        ffmpeg_cmd,
        stdin=subprocess.PIPE,
        text=True,
        bufsize=1,
        universal_newlines=True
    )

def main():
    stream_url = os.getenv("STREAM_URL")
    if not stream_url:
        print("错误：必须设置 STREAM_URL 环境变量")
        exit(1)

    print("=== 循环遍历推流 ===")
    print(f"Python 版本: {'.'.join(map(str, sys.version_info[:3]))}")
    print(f"推流地址: {stream_url}")
    print(f"编码参数: {os.getenv('FFMPEG_OPTIONS')}")
    print("=====================")

    while True:
        files = get_video_files()
        if not files:
            print(f"{time.strftime('%Y-%m-%d %H:%M:%S')} 未找到MP4视频文件，10秒后重试...")
            time.sleep(10)
            continue

        print(f"\n{time.strftime('%Y-%m-%d %H:%M:%S')} 发现 {len(files)} 个视频文件")
        print("即将推流的视频列表:")
        for i, f in enumerate(files, 1):
            print(f"{i}. {os.path.basename(f)}")
        
        concat_list = generate_concat_list(files)
        
        print(f"\n{time.strftime('%Y-%m-%d %H:%M:%S')} 开始无缝推流...")
        proc = start_stream(stream_url, concat_list)
        proc.communicate(input=concat_list)
        
        if proc.returncode != 0:
            print(f"{time.strftime('%Y-%m-%d %H:%M:%S')} 推流中断，10秒后重新尝试...")
            time.sleep(10)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n{time.strftime('%Y-%m-%d %H:%M:%S')} 用户手动停止推流")
        sys.exit(0)
    except Exception as e:
        print(f"\n{time.strftime('%Y-%m-%d %H:%M:%S')} 发生未预期错误: {str(e)}")
        sys.exit(1)