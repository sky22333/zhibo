#!/usr/bin/env python3
import os
import subprocess
import time
from glob import glob
import sys
import tempfile

def get_video_files():
    """获取排序后的视频文件列表"""
    return sorted(glob("/videos/*.mp4"), key=lambda x: x.lower())

def create_concat_file(files):
    """创建临时concat文件"""
    with tempfile.NamedTemporaryFile(mode='w+', suffix='.txt', delete=False) as f:
        f.write("".join(f"file '{f}'\n" for f in files))
        return f.name

def start_stream(stream_url, concat_file):
    """启动FFmpeg推流"""
    process = subprocess.Popen(
        [
            "ffmpeg",
            "-loglevel", "warning",
            "-re",
            "-f", "concat",
            "-safe", "0",
            "-protocol_whitelist", "file,concat",
            "-i", concat_file,
            *os.getenv('FFMPEG_OPTIONS', '').split(),
            stream_url
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    return process.wait()

def main():
    if not os.getenv("STREAM_URL"):
        sys.exit(1)

    while True:
        try:
            files = get_video_files()
            if not files:
                time.sleep(10)
                continue

            concat_file = create_concat_file(files)
            return_code = start_stream(os.getenv("STREAM_URL"), concat_file)
            os.unlink(concat_file)
            
            if return_code != 0:
                time.sleep(10)

        except KeyboardInterrupt:
            sys.exit(0)
        except:
            time.sleep(10)

if __name__ == "__main__":
    main()
