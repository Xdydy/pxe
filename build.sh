#!/bin/bash

# 检查是否提供了机器编号
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <machine_number>"
    exit 1
fi

MACHINE_NUMBER=$1
VM_NAME="vm-$MACHINE_NUMBER"
IMG_DIR="./$VM_NAME"
IMG_PATH="$IMG_DIR/$VM_NAME.qcow2"
ISO_PATH="ubuntu-22.04.3-live-server-amd64.iso"
HTTP_SERVER="http://192.168.1.1" # 更改为您的HTTP服务器IP
USER_DATA_PATH="$HTTP_SERVER/autoinstall/" # 更改为autoinstall文件的路径

# 创建新的虚拟机镜像目录
if [ ! -d "$IMG_DIR" ]; then
    echo "Creating directory for $VM_NAME..."
    mkdir -p $IMG_DIR
else
    echo "VM has exists. Ignore"
    exit(1)
fi

# 创建新的虚拟机镜像
echo "Creating new virtual machine image for $VM_NAME..."
qemu-img create -f qcow2 $IMG_PATH 20G

# 检查系统是否支持KVM
KVM_SUPPORT=$(egrep -c '(vmx|svm)' /proc/cpuinfo)
QEMU_SYSTEM_CMD="qemu-system-x86_64"

if [ $KVM_SUPPORT -gt 0 ]; then
    echo "KVM is supported. Using KVM mode."
    QEMU_SYSTEM_CMD="$QEMU_SYSTEM_CMD -enable-kvm"
else
    echo "KVM is not supported. Using TCG mode."
fi

#生成user-data
echo "========================="
python3 user_data.py $VM_NAME 192.168.1.$MACHINE_NUMBER
echo "========================="

# 启动虚拟机并通过PXE进行无人值守安装
echo "Starting virtual machine $VM_NAME for autoinstall..."
$QEMU_SYSTEM_CMD \
    -name $VM_NAME \
    -smp 2 \
    -m 4G \
    -hda $IMG_PATH \
    -netdev user,id=eth0 \
    -device virtio-net-pci,netdev=eth0 \
    -netdev bridge,id=net0,br=br0,helper=/usr/lib/qemu/qemu-bridge-helper \
    -device virtio-net-pci,netdev=net0
    # -nographic \



function get_mac_addr() {
    mac=$(printf "08:00:27:%02X:%02X:E7" $1 $2)
    echo $mac
}

# 创建run.sh脚本
RUN_SCRIPT_PATH="$IMG_DIR/run.sh"
cat <<EOF > $RUN_SCRIPT_PATH
#!/bin/bash
$QEMU_SYSTEM_CMD \
    -smp 2 \
    -m 1024 \
    -hda $IMG_PATH \
    -netdev user,id=eth0 \
    -device virtio-net-pci,netdev=eth0 \
    -netdev bridge,id=net0,br=br0 \
    -device virtio-net-pci,netdev=net0 \
    -nographic
EOF

chmod +x $RUN_SCRIPT_PATH

echo "Virtual machine $VM_NAME setup completed."
