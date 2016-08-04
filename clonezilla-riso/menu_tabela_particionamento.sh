#!/bin/bash
#------------------------------------------------------
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#        Alain André <alainandre@decom.cefetmg.br>
#		 Samuel Fantini Braga <samuel.fantini.braga@hotmail.com>
#------------------------------------------------------
# Função que cria um arquivo com o particionamento
# atual da maquina
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

function menu_tabela_particionamento(){
  	source carregar_discos.sh
  	source mensagem.sh
  	local entradas_menu=""
  
  	if [ -z $(carregar_discos) ]; then 
      	mensagem "Nenhum Disco encontrado"
      	return 1
  	fi
  
  	for disco in $(carregar_discos)
  	do
  		local entradas_menu="$entradas_menu /dev/$disco /dev/$disco"
  	done
 
	while : ; do
    	opcao=$(dialog --stdout                   \
    	--no-tags                                 \
    	--title "Discos Rigidos"                  \
    	--ok-label "Confirmar"                    \
    	--cancel-label "Cancelar"                 \
    	--menu "Escolha um Disco:"                \
    	0 0 0                                     \
    	$entradas_menu                            \
    	)
    	if [ -z $opcao ]; then
        	break
		else
			nome_tabela=$(dialog --stdout --inputbox 'Digite o nome para a tabela de particionamento:' 0 0)
			sfdisk -d $opcao > $DIR_PARTICIONAMENTOS$nome_tabela
			if [ $? -eq 0 ]; then 
				mensagem "Particionamento criado"
				return 0
			else
	        	mensagem "Particionamento não criado"
				return 1
        	fi
		fi
	done
}
