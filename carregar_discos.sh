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
  source mensagem.sh

  local discos=$(cat /proc/partitions | grep ".*[h,s]d[a-z]$" | sed -e 's/\ //g'| sed -e 's/[0-9]//g')
  local dispositivos_usb=""
  
  for dispositivo in $discos
  do
    local usb=$(readlink -f /sys/class/block/${dispositivo}/device | grep usb)   
    if [ ! -z "$usb" ]; then
      local dispositivos_usb="$dispositivos_usb $dispositivo"   
    fi
  done
  
  for dispositivo in $dispositivos_usb
  do
    local discos=$(echo $discos | sed -e "s/${dispositivo}//g")
  done
  if [ -z $discos ]; then 
	mensagem "Nenhum Disco encontrado"
        break
  fi
  echo $discos
}
