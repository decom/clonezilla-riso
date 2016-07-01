#!/bin/bash
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#
#------------------------------------------------------
# Função para aplicar a tabela de particionamento ao
# disco rigido escolhido.
#------------------------------------------------------
# Histórico:
# v1.0 2016-06-08, Raylander Frois Lopes
#   - Versão inicial.  
##v1.2 2016-06-23, Samuel Fantini:
#   - Modularização das funções
#
function menu_aplicar_particionamento(){
  source carregar_discos.sh   
  source mensagem.sh
  
  local particionamento=$DIR_PARTICIONAMENTOS$1
  
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
    --title "Menu aplicar particionamento"    \
    --ok-label "Confirmar"                    \
    --cancel-label "Cancelar"                 \
    --menu "Escolha um Disco:"                \
    0 0 0                                     \
    $entradas_menu                            \
    )
    if [ -z $opcao ]; then
        break
    else
        sfdisk $opcao < $particionamento
        if [ $? -eq 0 ]; then 
	        mensagem "Particionamento aplicado"
	      else
	        mensagem "Particionamento não aplicado"
        fi
        break
    fi
  done
}
