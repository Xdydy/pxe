帮我写一个python脚本，用于在/var/www/html/autoinstall目录下生成一个user-data,内容为


```yaml
autoinstall:
  version: 1
  apt:
    primary:
      - arches: [default]
        uri: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
  packages:
    - net-tools
    - python3-pip
  user-data:
    timezone: Asia/Shanghai
    disable_root: true
  identity:
    hostname: # 由参数指定
    password: "$6$su/nBuoLzuiZOzV2$ykU2wpa33OCv9fRBrVjxMyCEgvXElg5GmfRdu1DrY/jVfpmNCZJNaqrZG7YDme/N1O8WvaD//Av036FqUQ3eD0"
    username: user
  keyboard: {layout: us, variant: ""}
  locale: en_US.UTF-8
  ssh:
    install-server: true
    authorized-keys:
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9r+5SiglLx072DJSF4x61+QwjnliLfIb820yf0S1st 18029544890@feishu.uestc.cn
  network:
    version: 2
    ethernets:
      ens3:
        critical: true
        dhcp-identifier: mac 
        dhcp4: true
        nameservers:
          addresses:
          - 10.0.2.3
      ens4:
        dhcp4: false
        addresses: #由参数指定
        gateway4: 192.168.1.1
        nameservers:
          addresses: [8.8.8.8, 8.8.4.4]
```

