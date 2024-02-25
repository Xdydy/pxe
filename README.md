# PXE 批量部署

# 问题

## 网桥问题

- 问题描述

  - 要启动虚拟机的时候需要用到 `br0` 作为网桥，使用 `helper` 参数前需要先 allow 一下 br0
  - 启动脚本访问该文件的时候需要 `root` 权限
- 解决方案

  - 编辑 `/etc/qemu/bridge.conf` 为

```bash
allow br0
```
- 为`/usr/lib/qemu/qemu-bridge-helper`添加权限
```bash
sudo chmod u+s /usr/lib/qemu/qemu-bridge-helper
```

## MAC 地址重复

- 问题描述
  - 在启动多台虚拟机后，默认的多台虚拟机的 mac 地址会有重复
- 解决方案
  - 在启动时添加一个 mac 地址的参数，其中 14 表示虚拟机 20

```bash
mac=08:00:27:02:14:E7
```

## 虚拟机之间不能ping通

- 问题描述：
	- 虚拟机可以ping通主机
	- 主机可以ping通虚拟机
	- 虚拟机之间不能互相ping通
	- 虚拟机查看`arp -n`可以看到另一台虚拟机的IP地址
	- 虚拟机之间可以通过`arping`连接

- 解决方案
	- 这种情况下大概率是主机的防火墙问题，查看了一下`iptables`，发现里头的INPUT以及OUTPUT都是ACCEPT的，但是FORWARD选项是DROP的，这样表示，输入输出都没问题，但是禁止转发，通过下列命令进行修正

```bash
sudo iptables -P FORWARD ACCEPT
```
