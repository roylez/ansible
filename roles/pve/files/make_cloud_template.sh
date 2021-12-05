#!/bin/bash
# Usage
# ./make_cloud_template.sh <id> <download_url>
#
# ./make_cloud_template.sh \
#    8886 https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img

id=$1
url=$2
image=${url//*\//}
release=${image/%-*/}

set -x

# download the image
wget $url || exit

# create a new VM
qm create $id --memory 2048 --net0 virtio,bridge=vmbr0 -name c.$release

# import the downloaded disk to local-lvm storage
qm importdisk $id $image local-lvm

# finally attach the new disk to the VM as scsi drive
qm set $id --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-$id-disk-0

qm set $id --ide2 local-lvm:cloudinit

qm set $id --boot c --bootdisk scsi0

qm set $id --serial0 socket --vga serial0

qm template $id
