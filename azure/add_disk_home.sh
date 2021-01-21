#!/bin/bash
echo "Extend Home"
pvcreate /dev/sdc
vgextend rootvg /dev/sdc
lvm lvextend -l +100%FREE /dev/rootvg/homelv
resize2fs -p /dev/mapper/rootvg-homelv