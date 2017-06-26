#!/bin/bash

#Verificar parâmetros disco (ex:/dev/sda) e arquivo de particionamento (ex: HD500)
if [ $# -ne 2 ]; then
   echo "Usage: $0 [Disk] [Partition Table File]";
   exit 1;
fi

#Definir variáveis DEVICE e PARTITION a partir dos parâmetros de execução.
DEVICE=$1
PARTITION=$2

#Definir partições para o padrão utilizado no riso (Partição 1 - Recovery, Partição 5 - Dados, Partição 6 - SWAP)
RECOVERY=$DEVICE"1"
DADOS=$DEVICE"5"
SWAP=$DEVICE"6"

#Apagar início do disco
dd if=/dev/zero of=$DEVICE bs=512 count=2048

#Aplicar tabela de particionamento ao disco
sfdisk $DEVICE < $HD

#Formatar partição recovery, trocando UUID
mkfs.ext4 -Fq -O ^metadata_csum -U `cut -d '"' -f2 recoveryUUID` $RECOVERY

#Formatar partição swap, trocando UUID
mkswap -U `cut -d '"' -f2 swapUUID` $SWAP

#Formatar partição Dados
mkfs.ntfs -f -Fq -L Dados $DADOS

#Restaurar partição recovery a partido do arquivo recovey.tar
mount $RECOVERY /mnt
echo "Restaurando partição..."
tar -xf recovery.tar -C /mnt
echo "Partição restaurada."

#Instalar grub na partição recovery
grub-install --boot-directory=/mnt/boot $DEVICE
