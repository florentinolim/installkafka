#!/bin/bash

DEV_NAME='/dev/sdb'
PARTITION_NAME='/dev/sdb1'
VG_NAME='vg-app'
LV_NAME=aplicacoes
APP_DIR='/opt/aplicacoes'

(
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo t # change to LVM
echo 8e #choose LVM
echo w # Write changes
) | sudo fdisk $DEV_NAME

echo "show devices info"
sudo fdisk -l $DEV_NAME

echo "lvm steps"
sudo pvcreate $PARTITION_NAME 
sleep 2
sudo vgcreate $VG_NAME $PARTITION_NAME
sleep 2
sudo lvcreate -l 100%FREE -n $LV_NAME  $VG_NAME
sleep 2
sudo mkfs.xfs /dev/$VG_NAME/$LV_NAME

sudo lvs $VG_NAME $LV_NAME 

sudo mkdir $APP_DIR

sudo mount /dev/$VG_NAME/$LV_NAME $APP_DIR

echo -e "/dev/"$VG_NAME"/"$LV_NAME"\t\t"$APP_DIR"\t\txfs\tnoatime\t\t0 2" | sudo tee -a /etc/fstab > /dev/null
