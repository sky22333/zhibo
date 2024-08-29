import pyshark
import asyncio
from typing import Optional
import psutil
import socket
from colorama import Fore, Style, init

# 初始化colorama
init(autoreset=True)

def get_default_interface() -> Optional[str]:
    try:
        for iface, addrs in psutil.net_if_addrs().items():
            for addr in addrs:
                if addr.family == socket.AF_INET and not addr.address.startswith("127."):
                    return iface
    except Exception:
        print(Fore.YELLOW + "无法自动检测默认网卡，请手动指定。")
    return None

def filter_strings(input_str: str, target_str: str) -> Optional[str]:
    return next((word for word in input_str.split() if target_str in word), None)

class StreamInfoExtractor:
    def __init__(self, interface: str):
        self.interface = interface
        self.display_filter = '((rtmpt) && (_ws.col.info contains "connect")) || (_ws.col.info contains "releaseStream")'

    async def extract_info(self):
        capture = pyshark.LiveCapture(interface=self.interface, display_filter=self.display_filter)
        print(Fore.CYAN + f"开始在接口 {self.interface} 上提取流信息...")
        
        async for packet in capture.sniff_continuously():
            packet_str = str(packet)
            server = filter_strings(packet_str, "rtmp://")
            code = filter_strings(packet_str, "stream-")
            
            if server:
                print(f"{Fore.GREEN}服务器: {Style.RESET_ALL}{server}")
            elif code:
                print(f"{Fore.BLUE}推流码: {Style.RESET_ALL}{code[1:-1]}")  # 去除引号

async def main():
    interface = get_default_interface()
    if not interface:
        print(f"{Fore.RED}错误: 无法检测到默认网络接口。{Style.RESET_ALL}")
        return

    print(f"{Fore.YELLOW}使用网络接口: {Style.RESET_ALL}{interface}")

    extractor = StreamInfoExtractor(interface)
    try:
        await extractor.extract_info()
    except KeyboardInterrupt:
        print(f"\n{Fore.YELLOW}停止提取...{Style.RESET_ALL}")

if __name__ == "__main__":
    asyncio.run(main())
