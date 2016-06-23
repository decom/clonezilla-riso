#!/bin/bash 
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#		 Samuel Fantini Braga <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Função para carregar informações dos Discos no
# computador
#------------------------------------------------------
# Histórico: 
# v1.2 2016-06-23, Samuel Fantini:
#   - Modularização das funções
#
function carregar_discos(){ 
  source $clonezilla_riso/menu_aplicar_particionamento.sh
  source $clonezilla_riso/carregar_variaveis.sh
  
  arquivo_particionamento=$DIR_PARTICIONAMENTO$1
 
  discos=$(cat /proc/partitions | grep ".*[h,s]d[a-z]$" | sed -e 's/\ //g'| sed -e 's/[0-9]//g')
  dispositivosUSB=""
 
  for dispositivo in $discos
  do
    usb=$(readlink -f /sys/class/block/${dispositivo}/device | grep usb);   
    if [ ! -z "$usb" ]; then
      dispositivosUSB="$dispositivosUSB $dispositivo";   
    fi
  done
  discos_rigidos=$discos
  for dispositivo in $dispositivosUSB
  do
    discos_rigidos=$(for disco in $discos; do echo $disco; done | grep -v $dispositivo)
  done
      
  menu_aplicar_particionamento $discos_rigidos $arquivo_particionamento
}
