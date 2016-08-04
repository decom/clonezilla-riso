#!/bin/bash
#------------------------------------------------------
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#        Alain André <alainandre@decom.cefetmg.br>
#	 	 Samuel Fantini Bra <samuel.fantini.braga@hotmail.com>
#------------------------------------------------------
# Funçao para carregar as partições exixtentes no 
# dispositivo do computador
#------------------------------------------------------
# Histórico:
# v1.0 2016-05-18, Alain André:
#  - Versão inicial da função que carrega as partiçoes
# v1.2 2016-06-23, Samuel Fantini:
#   - Modularização das funções
# v1.3 2016-06-28, Raylander Fróis Lopes
#   - Correção de erro
function carregar_particoes(){
    local particoes=$(cat /proc/partitions | grep ".*[h,s]d[a-z][0-9]$" | sed -e 's/8  //g' | sed 's/.* //g')
	local dispositivos_com_repetidos=$(echo $particoes | sed -e 's/[0-9]*//g')
  	local dispositivos_unicos_sem_dev=$(for dispositivo in $dispositivos_com_repetidos; do echo $dispositivo; done | uniq | sed -e 's/\/dev\///g')
  	local dispositivosUSB=""
  	for dispositivo in $dispositivos_unicos_sem_dev
  	do 
  		local usb=$(readlink -f /sys/class/block/${dispositivo}/device | grep usb);   
    	if [ ! -z "$usb" ]; then 
      		local dispositivos_usb="$dispositivos_usb $dispositivo";   
    	fi
  	done
  	for dispositivo in $dispositivos_usb
  	do
    	local particoes=$(for particao in $particoes; do echo $particao; done | grep -v $dispositivo)
  	done
	
	local dev=$(blkid | cut -d'/' -f2)	
	local particoes_com_dev=""	
	for particoes_sem_dev in $particoes
	do
		particoes_com_dev="${particoes_com_dev} "/dev/${particoes_sem_dev}""
	done
  	echo $particoes_com_dev
}
