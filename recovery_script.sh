#!/bin/bash

#Primeira Opção - sda sdb (device)

DEVICE="/dev/"$1
HD=$2

RECOVERY=$DEVICE"1"
DADOS=$DEVICE"5"
SWAP=$DEVICE"6"

FILES="FILES"

dd if=/dev/zero of=$DEVICE bs=512 count=2048
sfdisk $DEVICE < $HD

#formatar recovery, trocando UUID
mkfs.ext4 -Fq -O ^metadata_csum -U `cut -d '"' -f2 recoveryUUID` $RECOVERY
#formatar swap, trocando UUID
mkswap -U `cut -d '"' -f2 swapUUID` $SWAP
#formatar Dados
mkfs.ntfs -f -Fq -L Dados $DADOS


mount $RECOVERY /mnt

echo "Restaurando partição..."
tar -xf recovery.tar -C /mnt
echo "Partição restaurada."

rm -Rf lost+found/

cp -R $FILES/* /mnt

grub-install --boot-directory=/mnt/boot $DEVICE

# mount --bind /dev /mnt/dev
# mount --bind /sys /mnt/sys
# mount --bind /proc /mnt/proc

# chroot /mnt "update-grub"

