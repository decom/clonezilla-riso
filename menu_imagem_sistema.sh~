#!/bin/bash
#------------------------------------------------------
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#        Alain André <alainandre@decom.cefetmg.br>
#		 Samuel Fantini Bra <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Função que cria uma nova imagem do sistema para o RISO
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

function menu_imagem_sistema(){
  	source carregar_particoes.sh
  	source mensagem.sh
	source carregar_discos.sh
  	local entradas_menu=""
  
  	if [ -z $(carregar_discos) ]; then 
		mensagem "Nenhum Disco encontrado"
      	return 1
  	fi
  
  	for particao in $(carregar_particoes)
  	do
    	fdisk -l 2> /dev/null | grep $particao | grep Linux  &> /dev/null
    	if [ $? -eq 0 ]; then
         	fdisk -l 2> /dev/null | grep $particao | grep swap  &> /dev/null
  	     	if [ $? -eq 1 ]; then
  	        	local entradas_menu="$entradas_menu $particao $particao"
  	     	fi
  		fi
  	done
  
  	if [ -z $entradas_menu ]; then 
		mensagem "Nenhuma partição ext4 encontrada"
		break
  	fi
  
  	while : ; do
    	local opcao=$(dialog --stdout                               \
    	--no-tags                                                   \
    	--title "Menu Criar Nova Imagem do Sistema de Recuperação"  \
    	--ok-label "Confirmar"                                      \
    	--cancel-label "Cancelar"                                   \
    	--menu "Escolha a Partição:"                                \
    	0 0 0                                                       \
    	$entradas_menu                                              \
    	)
    	if [ -z $opcao ]; then
      		break
    	fi
    	for item in $opcao
    	do
	    	nome=$(dialog --stdout --inputbox 'Digite o Nome da Nova Imagem:' 0 0)     
	    	umount /mnt 
	    	mount $item /mnt
	    	tar -cvf ${DIR_SISTEMAS}${nome} /mnt/*
			if [ $? -eq 0 ]; then 
				mensagem "Imagem criada"
				return 0
			else
	        	mensagem "Imagem não criada"
				return 1
        	fi
	    	umount /mnt
		done    
  	done
}
