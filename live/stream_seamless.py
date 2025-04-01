#!/usr/bin/env python3
import os
import subprocess
import time
from glob import glob
import sys
import tempfile

def log(message):
    """实时日志输出函数（核心优化点）"""
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
    sys.stdout.write(f"{timestamp} {message}\n")
    sys.stdout.flush()

def get_video_files():
    """获取排序后的视频文件列表"""
    files = sorted(glob("/videos/*.mp4"), key=lambda x: x.lower())
    log(f"发现 {len(files)} 个视频文件")
    return files

def create_concat_file(files):
    """创建临时concat文件"""
    concat_content = "".join(f"file '{f}'\n" for f in files)
    with tempfile.NamedTemporaryFile(mode='w+', suffix='.txt', delete=False) as f:
        f.write(concat_content)
        return f.name

def start_stream(stream_url, concat_file):
    """启动FFmpeg推流（带实时日志输出）"""
    ffmpeg_cmd = [
        "ffmpeg",
        "-loglevel", "warning",
        "-re",
        "-f", "concat",
        "-safe", "0",
        "-protocol_whitelist", "file,concat",
        "-i", concat_file,
        *os.getenv('FFMPEG_OPTIONS', '').split(),
        stream_url
    ]
    
    log("开始推流进程...")
    process = subprocess.Popen(
        ffmpeg_cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1
    )
    
    # 实时转发FFmpeg日志
    while True:
        line = process.stdout.readline()
        if not line and process.poll() is not None:
            break
        if line:
            sys.stdout.write(line)
            sys.stdout.flush()
    
    return process.returncode

def main():
    if not (stream_url := os.getenv("STREAM_URL")):
        log("错误：必须设置 STREAM_URL 环境变量")
        sys.exit(1)

    log("=== 推流服务启动 ===")
    log(f"Python 版本: {sys.version.split()[0]}")
    log(f"推流地址: {stream_url}")
    log(f"编码参数: {os.getenv('FFMPEG_OPTIONS')}")
    log("=====================")

    retry_count = 0
    max_retries = 5

    while True:
        try:
            files = get_video_files()
            if not files:
                log("未找到MP4文件，10秒后重试...")
                time.sleep(10)
                continue

            log("视频列表:")
            for i, f in enumerate(files, 1):
                log(f"  {i}. {os.path.basename(f)}")

            concat_file = create_concat_file(files)
            log("开始无缝推流...")
            
            return_code = start_stream(stream_url, concat_file)
            os.unlink(concat_file)
            
            if return_code != 0:
                retry_count += 1
                log(f"推流中断 (尝试 {retry_count}/{max_retries})")
                if retry_count >= max_retries:
                    log("达到最大重试次数，服务终止")
                    sys.exit(1)
                time.sleep(min(2**retry_count, 30))
            else:
                retry_count = 0

        except KeyboardInterrupt:
            log("\n用户手动停止推流")
            sys.exit(0)
        except Exception as e:
            log(f"发生未预期错误: {str(e)}")
            time.sleep(10)

if __name__ == "__main__":
    main()