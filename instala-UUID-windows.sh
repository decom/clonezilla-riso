#!/bin/bash

# instalar-UUID-windows.sh 
# Instala UUID no windows

# Verifica os parâmetros do disco (ex:/dev/sda) e o arquivo de particionamento (ex: HD500)

if [ $# -ne 2 ]; then
   echo "Utilização: $0 [Disco] [Arquivo de Particionamento]";
   exit 1;
fi


# Define as variáveis DIRNAME e DEVICE  a partir dos parâmetros do disco e arquivo de particionamento.

DIRNAME=`dirname $0`
DEVICE=$1


# Define as partições windows e recovery utilizadas no riso (ex: Partição 1 - Recovery, Partição 2 - Windows, Partição 3 - Linux, 
# Partição 5 - Dados, Partição 6 - SWAP)

RECOVERY=$DEVICE"1"
WINDOWS=$DEVICE"2"


# Busca a tabela de particionamento e UUID do disco no arquivo riso.cfg

source $DIRNAME/riso.cfg


echo "Atribuindo a UUID na partição windows."

# Atribui a UUID na partição windows.

u=${partwindows^^}

echo ${u:14:2}${u:12:2}${u:10:2}${u:8:2}${u:6:2}${u:4:2}${u:2:2}${u:0:2} | xxd -r -p | dd of=$WINDOWS bs=8 count=1 seek=9

echo "Atribuição da UUID na partição windows realizada com sucesso"

sleep 3


echo "Montando as partições recovery, /dev, /proc e /sys  no diretorio /mnt..."

#Monta a partição recovery presente no disco.(ex:sda1)

mount $RECOVERY /mnt
mount --bind /dev/ /mnt/dev/
mount --bind /proc/ /mnt/proc/
mount --bind /sys/ /mnt/sys/

echo "Partições montadas com sucesso."

sleep 3

echo "Instalando e atualizando o GRUB na partição montada no diretório /mnt"

#Instala e atualiza o grub na partição montada no diretório /mnt

chroot /mnt grub-install $DEVICE
chroot /mnt update-grub

echo " GRUB instalado e atualizado com sucesso"

sleep 3

echo "Desmontando as partições montadas no diretório /mnt..."

# Desmonta as partições montadas no diretório /mnt

umount /mnt/dev
umount /mnt/proc
umount /mnt/sys
umount $RECOVERY

echo "Partições desmontadas com sucesso"

sleep 3

echo "Atribuição da UUID na partição windows finalizada com sucesso."