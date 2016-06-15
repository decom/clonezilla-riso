#!/bin/bash
#------------------------------------------------------
# Autor: Alain André <alainandre@decom.cefetmg.br>
#	     Samuel Fantini <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Função que cria o menu principal do clonezilla-riso,
# responsável por exibir as opções de formatação e
# criação de partições e instalação do RISO
#------------------------------------------------------
# Histórico:
# v1.0 2016-05-17, Alain André, Samuel Fantini:
#   - Versão inicial do menu principal.
# v1.1 2016-05-23, Alain André:
#   - Modificação para exibição de título global
function menu_principal(){
  while : ; do
    local opcao=$(dialog --stdout                         \
          --title "$TITLE"                                \
          --ok-label "Confirmar"                          \
          --cancel-label "Sair"                           \
          --menu "Escolha o que você deseja fazer:"       \
          0 0 0                                           \
          1 "Aplicar Nova Tabela de Particionamento"      \
          2 "Formatar Partições"                          \
          3 "Instalar Sistema de Recuperação"             \
          4 "Criar Nova Tabela de Particionamento"        \
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
function menu_selecionar_particionamento(){

  local arquivos=$(ls $DIR_PARTICIONAMENTO)
  local entradas_menu=""

  for arquivo in $arquivos; do
    local entradas_menu="$entradas_menu $arquivo"
  done

  while : ; do
    local opcao=$(dialog --stdout			                     \
          --no-items                                       \
          --title "$TITLE" 				                         \
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

#------------------------------------------------------
# Autor: Alain André <alainandre@decom.cefetmg.br>
#
#------------------------------------------------------
# Função de exibição de mensagens padrão com título do
# sistema. Recebe como parâmetro a mensagem a ser exibida
#------------------------------------------------------
# Histórico:
# v1.0 2016-05-18, Alain André:
#  - Versão inicial da função de exibição de mensagens
#  - Exibe uma msgbox com título do sistema e a mensagem.
function mensagem(){
  local mensagem="$1"
  dialog                \
  --title "$TITLE"      \
  --msgbox "$mensagem"  \
  0 0

# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#
#------------------------------------------------------
# Função para aplicar a tabela de particionamento ao
# disco rigido escolhido.
#------------------------------------------------------
# Histórico:
# v1.0 2016-06-08, Raylander Frois Lopes
#   - Versão inicial.  
#  
function menu_aplicar_particionamento(){
 arquivo_particionamento=$DIR_PARTICIONAMENTO$1
 
  discos=$(cat /proc/partitions | grep ".*[h,s]d[a-z]$" | sed -e 's/\ //g'| sed -e 's/[0-9]//g')
  dispositivosUSB=""
 
  for dispositivo in $discos
  do
    usb=$(readlink -f /sys/class/block/${dispositivo}/device | grep usb);   
    if [ ! -z "$usb" ]; then
      dispositivosUSB="$dispositivosUSB $dispositivo";   
    fi
  done
  discos_rigidos=$discos
  for dispositivo in $dispositivosUSB
  do
    discos_rigidos=$(for disco in $discos; do echo $disco; done | grep -v $dispositivo)
  done
 
  local entradas_menu=""
  for disco in $discos_rigidos
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
        sfdisk $opcao < $arquivo_particionamento
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
# v1.1 2016-05-23, Alain André:
#   - Criação de área para variáveis globais e definição
#     da variável TITLE (título global para menus).
# v1.2 2016-06-08, Raylander Frois Lopes
#   - Criação da variável global DIR_PARTICIONAMENTO  

# Variáveis Globais
TITLE="Clonezilla-RISO - v1.0"
DIR_PARTICIONAMENTO="/home/partimag/particionamento/"
# Chamada Principal do Sistema
menu_principal;

