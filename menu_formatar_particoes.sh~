#!/bin/bash
#------------------------------------------------------
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#        Alain André <alainandre@decom.cefetmg.br>
#		 Samuel Fantini Bra <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Função que exibe exibe as partições para que sejam formatadas
#------------------------------------------------------
# Histórico:
# v1.0 2016-05-20, Samuel Fantini:
#  -Versão inicial
# v1.1 2016-05-23, Alain André:
#   - Modificação para exibição de título global
# v1.2 2016-06-23, Samuel Fantini:
#   - Modularização das funções
# v1.3 2016-06-28, Raylander Fróis Lopes
#   - Adição de mensagem de erro
function menu_formatar_particoes(){
  source carregar_discos.sh
  source carregar_particoes.sh
  source mensagem.sh
  
  local entradas_menu=""
  
  if [ -z $(carregar_discos) ]; then 
	mensagem "Nenhuma Partição Encontrada"
        return 1
  fi
  
  for particao in $(carregar_particoes)
  do
  	local entradas_menu="$entradas_menu $particao on"
  done
  
  while : ; do
    local opcao=$(dialog --stdout       \
    --no-items                          \
    --title "Menu Formatar Partições"   \
    --ok-label "Confirmar"              \
    --cancel-label "Cancelar"           \
    --checklist "Escolha as Partições:" \
    0 0 0                               \
    $entradas_menu                      \
    )
    if [ -z "${opcao}" ]; then
    	break
    fi
    
	error=""
	for item in $opcao
    do
	    tipo=$(blkid $item | sed 's/.*TYPE=//g' | cut -d'"' -f2)
		if [ $tipo = "ntfs" ];then						
			umount $item
			mkfs.ntfs -f $item
			if [ $? -eq 1 ];then
				error="$error $item"
			fi
		fi
	 	if [ $tipo = "ext4" ];then						
			umount $item
			mkfs.ext4 -Fq $item
			if [ $? -eq 1 ];then
				error="$error $item"
			fi
		fi  
		if [ $tipo = "swap" ];then						
			umount $item
			mkswap -U `cut -d '"' -f2 swapUUID` $item
			if [ $? -eq 1 ];then
				error="$error $item"
			fi

	   fi
	done
	if [ ! $error = "" ];then
		mensagem "Partições não formatadas: "${error}""
	else
		mensagem "Partições formatadas com sucesso"
	fi
  done
}
