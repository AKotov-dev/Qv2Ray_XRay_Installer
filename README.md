# Qv2Ray+XRay_Installer - safe web surfing

**Dependencies:** curl unzip wget

Graphical installer of tools for safe surfing: `XRay` - traffic encryption/obfuscation and `Qv2Ray` - professional GUI for XRay. Download the installer archive `Qv2Ray+XRay_Installer.tar.gz`, unpack it and run `qv2rayxrayinstaller` (all with the rights of an ordinary user). As a result, the following operations will be performed:

1. Loading/Unpacking GUI (Qv2Ray) to the current directory - executable file [Qv2ray-v2.7.0-linux-x64.AppImage](https://github.com/Qv2ray/Qv2ray/releases)
2. Creating a catalog `~/.config/qv2ray/vcore` and loading/unpacking a fresh one into it [XRay-Core](https://github.com/XTLS/Xray-core/releases)

How to work with Qv2Ray after installation
--
Run a file from the current folder `Qv2ray-v2.7.0-linux-x64.AppImage`

Find ready-made configurations on the Internet for `v2ray/XRay` (preferably VLESS, VMESS are sometimes not recognized), open any of them, copy the contents to the clipboard, click the `Import` button in Qv2ray, insert into the field `Share Link` and press `Import`. If the configuration is valid, it will appear on the left in the list of configurations. Before connecting, it is desirable (not necessary) to check it: `PopupMenu`-`Test Latency`. A successful test will show the response time. To connect, double-click on the configuration. Disable proxy - via the tray menu (Disconnect) or the button on the form at the top right. 

Note-1: After connecting, the global PROXY changes in the system. Resetting the system proxy - only via `Disconnect`! 

Note-2: If the system proxy does not change when connecting (you can check the location after connecting on https://whoer.net ), then turn on the `SOCKS5 Proxy` + `Sending DNS requests via proxy` in the browser manually (Address: 127.0.0.1, Port: 1089).

Note-3: During testing, the firewall can be disabled.
