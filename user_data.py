import os
import sys

def generate_user_data(hostname, ip_address):
    user_data = f"""#cloud-config
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
    hostname: {hostname}
    password: "$6$su/nBuoLzuiZOzV2$ykU2wpa33OCv9fRBrVjxMyCEgvXElg5GmfRdu1DrY/jVfpmNCZJNaqrZG7YDme/N1O8WvaD//Av036FqUQ3eD0"
    username: user
  keyboard: {{layout: us, variant: ""}}
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
        dhcp4: no
        addresses: 
          - {ip_address}/24
        gateway4: 192.168.1.1
        nameservers:
          addresses: [8.8.8.8, 8.8.4.4]
  late-commands:
    - curl http://192.168.1.1/init/install.sh -o /target/install.sh
"""
    return user_data

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 generate_user_data.py <hostname> <ip_address>")
        sys.exit(1)

    hostname = sys.argv[1]
    ip_address = sys.argv[2]
    user_data_content = generate_user_data(hostname, ip_address)

    output_dir = "/var/www/html/autoinstall/"
    # output_dir = "./"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    with open(os.path.join(output_dir, "user-data"), "w") as file:
        file.write(user_data_content)

    print("user-data file created successfully.")

if __name__ == "__main__":
    main()
