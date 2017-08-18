#!/bin/bash

# recovery.sh - Aplica uma nova tabela de particionamento, formata completamente o disco e instala o Sistema Recovery
# Verifica parâmetros do disco (ex:/dev/sda) e arquivo de particionamento (ex: HD500)
if [ $# -ne 2 ]; then
   echo "Utilização: $0 [Disco] [Arquivo de Particionamento]";
   exit 1;
fi

# Define as variáveis DIRNAME, DEVICE e TABLE a partir dos parâmetros do disco e arquivo de particionamento.
DIRNAME=`dirname $0`
DEVICE=$1
TABLE=$2

# Define as partições para o padrão utilizado no riso (Partição 1 - Recovery, Partição 2 - Windows, Partição 3 - Linux, 
# Partição 5 - Dados, Partição 6 - SWAP)
RECOVERY=$DEVICE"1"
WINDOWS=$DEVICE"2"
LINUX=$DEVICE"3"
DADOS=$DEVICE"5"
SWAP=$DEVICE"6"

source $DIRNAME/riso.cfg

# Formata a partição windows, trocando a UUID.
mkfs.${sa_partwindows} -f -Fq  $WINDOWS
u=${partwindows^^}
echo ${u:14:2}${u:12:2}${u:10:2}${u:8:2}${u:6:2}${u:4:2}${u:2:2}${u:0:2}| xxd -r -p | dd of=$WINDOWS bs=8 count=1 seek=9

echo "Formatação da partição windows finalizada."
