#!/bin/bash

#Verificar parâmetros disco (ex:/dev/sda) e arquivo de particionamento (ex: HD500)
if [ $# -ne 2 ]; then
   echo "Usage: $0 [Disk] [Partition Table File]";
   exit 1;
fi

#Definir variáveis DEVICE e TABLE a partir dos parâmetros de execução.
DEVICE=$1
TABLE=$2

#Definir partições para o padrão utilizado no riso (Partição 5 - Dados, Partição 6 - SWAP)
DADOS=$DEVICE"5"
SWAP=$DEVICE"6"

#Aplicar tabela de particionamento ao disco
sfdisk $DEVICE < $TABLE

#Formatar partição swap, trocando UUID
mkswap -U `cut -d '"' -f2 swapUUID` $SWAP

#Formatar partição Dados
mkfs.ntfs -f -Fq -L Dados $DADOS
