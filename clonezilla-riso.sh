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
      1) ;;
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
# Autor: Samuel Fantini <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
#
#------------------------------------------------------
# Histórico:
# 
#   
function menu_formatar_particoes(){
  local particoes=$(blkid | cut -d':' -f1)
  local dispositivosComRepetidos=$(echo $particoes | sed -e 's/[0-9]*//g')
  local dispositivosUnicosSemDev=$(for dispositivo in $dispositivosComRepetidos; do echo $dispositivo; done | uniq | sed -e 's/\/dev\///g')
  local dispositivosUSB=""
  for dispositivo in $dispositivosUnicosSemDev
  do 
    local usb=$(readlink -f /sys/class/block/${dispositivo}/device | grep usb);   
    if [ ! -z "$usb" ]; then 
      local dispositivosUSB="$dispositivosUSB $dispositivo";   
    fi
  done
  for dispositivo in $dispositivosUSB
  do
    local particoes=$(for particao in $particoes; do echo $particao; done | grep -v $dispositivo)
  done

  local entradas_menu=""
  for particao in $particoes
  do
    local entradas_menu="$entradas_menu $particao on"
  done
  
  while : ; do
    local opcao=$(dialog --stdout \
    --no-items \
    --title "Menu Formatar Partições" \
    --ok-label "Confirmar" \
    --cancel-label "Cancelar" \
    --checklist "Escolha as Partições:" \
    0 0 0 \
    $entradas_menu\
    )
    if [ -z $opcao ]; then
       break
    fi
    for item in $opcao 
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
