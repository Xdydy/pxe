#!/bin/bash
qemu-system-x86_64 -enable-kvm     -smp 2     -m 1024     -hda ./vm-10/vm-10.qcow2     -netdev user,id=eth0     -device virtio-net-pci,netdev=eth0     -netdev bridge,id=net0,br=br0     -device virtio-net-pci,netdev=net0     -nographic
