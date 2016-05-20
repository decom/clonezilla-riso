#!/bin/bash
#------------------------------------------------------
# Autor: Alain André <alainandre@decom.cefetmg.br>
#	 Samuel Fantini <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Função que cria o menu principal do clonezilla-riso,
# responsável por exibir as opções de formatação e
# criação de partições e instalação do RISO
#------------------------------------------------------
# Histórico:
# v1.0 2016-05-17, Alain André, Samuel Fantini:
#   - Versão inicial do menu principal.
function menu_principal(){
  while : ; do
    local opcao=$(dialog --stdout \
          --title "Clonezilla" \
          --ok-label "Confirmar" \
          --cancel-label "Sair" \
          --menu "Escolha o que você deseja fazer:" \
          0 0 0 \
          1 "Aplicar Nova Tabela de Particionamento" \
          2 "Formatar Partições" \
          3 "Instalar Sistema de Recuperação" \
          4 "Criar Nova Tabela de Particionamento" \
          5 "Criar Nova Imagem do Sistema de Recuperação"
          )

    case $opcao in
      1) menu_selecionar_particionamento;;
      2) ;;
      3) ;;
      4) ;;
      5) ;;
      *) init 6;;
    esac

  done
  init 6
}

#------------------------------------------------------
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#
#------------------------------------------------------
# Função que exibe os arquivos de particionamentos
# disponíveis
#------------------------------------------------------
# Histórico: 
# v1.0 2016-05-20, Raylander Fróis Lopes:
#  -Versão inicial
function menu_selecionar_particionamento(){

local arquivos=$(ls /home/partimag/clonezilla-riso/particionamentos/)
local count=1
local entradas_menu=""

for arquivo in $arquivos; do
local entradas_menu="$entradas_menu $count $arquivo"
local count=$(($count + 1))
done
  
  while : ; do
    local opcao=$(dialog --stdout			   \
          --title "Clonezilla" 				   \
          --ok-label "Confirmar" 			   \
          --cancel-label "Cancelar" 			   \
          --menu "Selecione o arquivo de particionamento:" \
          0 0 0 					   \
	  $entradas_menu
	  )
    if [ -z $opcao ]; then 
       break
    fi

  done

}


#------------------------------------------------------
# Autor: Alain André <alainandre@decom.cefetmg.br>
#
#------------------------------------------------------
# Definição de variáveis globais e chamada do menu
# principal do clonezilla-riso
#------------------------------------------------------
# Histórico:
# v1.0 2016-05-18, Alain André:
#  - Chamada do menu principal do clonezilla-riso

menu_principal;

