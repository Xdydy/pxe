#!/bin/bash
qemu-system-x86_64 -enable-kvm     -smp 2     -m 1024     -hda ./vm-20/vm-20.qcow2     -netdev user,id=eth0     -device virtio-net-pci,netdev=eth0     -netdev bridge,id=net0,br=br0    -device virtio-net-pci,netdev=net0,mac=08:00:27:02:14:E7     -nographic
