#!/bin/bash

# update.sh - Instala o Sistema Recovery sem formatar as partições Windows e Linux
# Verifica parâmetros do disco (ex:/dev/sda) e arquivo de particionamento (ex: HD500)
if [ $# -ne 1 ]; then
   echo "Utilização: $0 [Disco]";
   exit 1;
fi

# Define as variáveis DIRNAME, DEVICE e TABLE a partir dos parâmetros do disco e arquivo de particionamento.
DIRNAME=`dirname $0`
DEVICE=$1

# Define as partições para o padrão utilizado no riso (Partição 1 - Recovery, Partição 4 - Dados, Partição 5 - SWAP, Partição 6 - EFI)
RECOVERY=$DEVICE"1"
WINDOWS=$DEVICE"2"
LINUX=$DEVICE"3"
DADOS=$DEVICE"5"
SWAP=$DEVICE"6"

# Carrega as variáveis do arquivo riso.cfg
source $DIRNAME/riso.cfg

# Desliga a swap
swapoff -a

# Formata a partição recovery, trocando a UUID
mkfs.${sa_partrecovery} -Fq -O ^metadata_csum -U ${partrecovery,,} $RECOVERY

# Formata a partição Dados
mkfs.${sa_partdados} -f -Fq -L Dados $DADOS
u=${partdados^^}
echo ${u:14:2}${u:12:2}${u:10:2}${u:8:2}${u:6:2}${u:4:2}${u:2:2}${u:0:2}| xxd -r -p | dd of=$DADOS bs=8 count=1 seek=9

# Formata a partição swap, trocando a UUID
mk${sa_partswap} -U ${partswap,,} $SWAP

# Restaura a partição recovery a partir do arquivo recovey.tar.bz2 presente no pendrive na segunda partição (ex:sdb2)
mount $RECOVERY /mnt
echo "Restaurando partição RECOVERY..."
tar -jxf recovery.tar.bz2 -C /mnt
echo "Partição RECOVERY restaurada."

# Instala o grub na partição montada no diretório /mnt
mount --bind /dev/ /mnt/dev/
mount --bind /proc/ /mnt/proc/
mount --bind /sys/ /mnt/sys/

chroot /mnt grub-install $DEVICE
chroot /mnt update-grub

umount /mnt/dev
umount /mnt/proc
umount /mnt/sys
umount $RECOVERY

echo "Script finalizado."
