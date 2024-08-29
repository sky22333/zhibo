import pyshark
import threading
import asyncio
import json
import os
import sys
import subprocess
from typing import Optional
import netifaces
from colorama import Fore, Style, init

# 初始化colorama
init(autoreset=True)

def get_default_interface() -> str:
    try:
        # 获取默认网关接口
        gateways = netifaces.gateways()
        default_gateway = gateways['default'][netifaces.AF_INET][1]
        return default_gateway
    except Exception:
        # 如果无法获取默认接口，返回第一个可用接口
        interfaces = netifaces.interfaces()
        for iface in interfaces:
            if iface != 'lo' and netifaces.ifaddresses(iface).get(netifaces.AF_INET):
                return iface
    return None

def check_wireshark_installation() -> bool:
    try:
        subprocess.run(["tshark", "-v"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return True
    except FileNotFoundError:
        return False

def filter_strings(input_str: str, target_str: str) -> Optional[str]:
    return next((word for word in input_str.split() if target_str in word), None)

class PacketSniffer(threading.Thread):
    def __init__(self, interface: str, display_filter: str):
        super().__init__()
        self.interface = interface
        self.display_filter = display_filter
        self.stop_event = threading.Event()

    def run(self):
        asyncio.set_event_loop(asyncio.new_event_loop())
        capture = pyshark.LiveCapture(
            interface=self.interface, 
            display_filter=self.display_filter
        )
        
        for packet in capture.sniff_continuously():
            if self.stop_event.is_set():
                break
            
            packet_str = str(packet)
            server = filter_strings(packet_str, "rtmp://")
            code = filter_strings(packet_str, "stream-")
            
            if server:
                print(f"{Fore.GREEN}服务器: {Style.RESET_ALL}{server}")
            elif code:
                print(f"{Fore.BLUE}推流码: {Style.RESET_ALL}{code[1:-1]}")  # 去除引号

    def stop(self):
        self.stop_event.set()

def main():
    if not check_wireshark_installation():
        print(f"{Fore.RED}错误: Wireshark未安装。请安装Wireshark后再运行此程序。{Style.RESET_ALL}")
        sys.exit(1)

    interface = get_default_interface()
    if not interface:
        print(f"{Fore.RED}错误: 无法检测到默认网络接口。{Style.RESET_ALL}")
        sys.exit(1)

    print(f"{Fore.YELLOW}使用网络接口: {Style.RESET_ALL}{interface}")

    display_filter = '((rtmpt) && (_ws.col.info contains "connect")) || (_ws.col.info contains "releaseStream")'

    sniffer = PacketSniffer(
        interface=interface,
        display_filter=display_filter
    )
    
    try:
        print(f"{Fore.CYAN}开始抓包...按Ctrl+C停止{Style.RESET_ALL}")
        sniffer.start()
        sniffer.join()
    except KeyboardInterrupt:
        print(f"\n{Fore.YELLOW}停止嗅探...{Style.RESET_ALL}")
        sniffer.stop()
        sniffer.join()

if __name__ == "__main__":
    main()
