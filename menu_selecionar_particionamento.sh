#!/bin/bash
#------------------------------------------------------
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#        Alain André <alainandre@decom.cefetmg.br>
#
#------------------------------------------------------
# Função que exibe os arquivos de particionamentos
# disponíveis
#------------------------------------------------------
# Histórico:
# v1.0 2016-05-20, Raylander Fróis Lopes:
#  -Versão inicial
# v1.1 2016-05-23, Alain André:
#   - Modificação para exibição de título global
# v1.2 2016-06-23, Samuel Fantini:
#   - Modularização das funções
#
function menu_selecionar_particionamento(){
  source menu_aplicar_particionamento.sh
  
  local arquivos=$(ls "${DIR_PARTICIONAMENTOS}")
  local entradas_menu=""
  for arquivo in $arquivos; do
    local entradas_menu="$entradas_menu $arquivo"
  done

  while : ; do
    local opcao=$(dialog --stdout			                     \
          --no-items                                       \
          --title "Menu Selecionar Particionamento"        \
          --ok-label "Confirmar" 			                     \
          --cancel-label "Cancelar" 			                 \
          --menu "Selecione o arquivo de particionamento:" \
          0 0 0 					                                 \
	  $entradas_menu
	  )
    if [ -z $opcao ]; then 
       break
    else
       menu_aplicar_particionamento $opcao
       break
    fi
  done
}
