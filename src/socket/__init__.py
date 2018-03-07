# -*- coding: utf-8 -*-
# @Time    : 2018/2/10 18:24
# @Author  : 蛇崽
# @Email   : 643435675@QQ.com
# @File    : LocalIP.py
import socket

# 查看当前主机名
print('当前主机名称为 : ' + socket.gethostname())

# 根据主机名称获取当前IP
print('当前主机的IP为: ' + socket.gethostbyname(socket.gethostname()))


# 下方代码为获取当前主机IPV4 和IPV6的所有IP地址(所有系统均通用)
addrs = socket.getaddrinfo(socket.gethostname(),None)

for item in addrs:
    print(item)

# 仅获取当前IPV4地址
print('当前主机IPV4地址为:' + [item[4][0] for item in addrs if ':' not in item[4][0]][0])

# 同上仅获取当前IPV4地址
for item in addrs:
    if ':' not in item[4][0]:
        print('当前主机IPV4地址为:' + item[4][0])
        break
