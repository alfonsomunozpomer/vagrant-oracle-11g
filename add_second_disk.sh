#!/bin/bash
set -e
set -x

if [ -f /usr/tmp/disk_added_date ]
then
   echo "Disk already added so exiting."
   exit 0
fi


sudo fdisk -u /dev/sdb <<EOF
n
p
1


t
8e
w
EOF

pvcreate /dev/sdb1
vgextend linux /dev/sdb1
lvextend /dev/linux/root /dev/sdb1
resize2fs /dev/linux/root
echo "Disk Added, Done resizing"

date > /usr/tmp/disk_added_date
exit 0