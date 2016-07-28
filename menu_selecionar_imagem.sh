#!/bin/bash
#------------------------------------------------------
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#        Alain André <alainandre@decom.cefetmg.br>
#		 Samuel Fantini Bra <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Função que seleciona a imagem do sistema RISO a ser instalada
#------------------------------------------------------
# Histórico:
# v1.0 2016-05-20, Raylander Fróis Lopes:
#  -Versão inicial
# v1.1 2016-05-23, Alain André:
#   - Modificação para exibição de título global
# v1.2 2016-06-23, Samuel Fantini:
#   - Modularização das funções
# v1.3 2016-06-28, Raylander Fróis Lopes
#   - Adição de mensagem de erro
function menu_selecionar_imagem (){
	source carregar_discos.sh
  	source mensagem.sh
	source carregar_particoes.sh
	source menu_instalar_sistema.sh

	FILES=/media/clonezilla-riso/FILES/
    
  	local arquivos="$(ls "${DIR_SISTEMAS}")"
  
  	if [ -z $arquivos ]; then 
		mensagem "Diretorio vazio"
	return 1
  	fi
  
  	local entradas_menu=""
  	for arquivo in $arquivos 
	do
  		local entradas_menu="$entradas_menu $arquivo"
  	done
	while : ; do
   		local opcao1=$(dialog --stdout                          \
		--no-items                                       	    \
		--title "Menu Selecionar Imagens de Recuperação"        \
		--ok-label "Confirmar"                                  \
		--cancel-label "Cancelar"                               \
		--menu "Selecione a imagem de recuperação:" 	    	\
		0 0 0                                                   \
		$entradas_menu
    	)
  		if [ -z $opcao1 ]; then
    	    break
    	else
			menu_instalar_sistema $opcao1
			break
		fi
	done
}
