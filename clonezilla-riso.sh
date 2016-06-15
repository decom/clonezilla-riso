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
      2) menu_formatar_particoes;;
      3) ;;
      4) menu_tabela_particionamento;;
      5) nova_imagem_sistema_recuperacao;;
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
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#
#------------------------------------------------------
# Função exibe os discos rigidos disponiveis e cria
# a tabela de particionamento do disco.
#------------------------------------------------------
# Histórico:
# v1.0 2016-06-09, Raylander Fróis Lopes:
#  - Versao Inicial
function menu_tabela_particionamento(){
  discos=$(cat /proc/partitions | grep ".*[h,s]d[a-z]$" | sed -e 's/\ //g'| sed -e 's/[0-9]//g')
  dispositivosUSB=""
 
  for dispositivo in $discos
  do
    usb=$(readlink -f /sys/class/block/${dispositivo}/device | grep usb);   
    if [ ! -z "$usb" ]; then
      dispositivosUSB="$dispositivosUSB $dispositivo";   
    fi
  done
  
  local discos_rigidos=$discos
  
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
    	 sfdisk -d $opcao > $DIR_TABELA$nome_tabela
    	 break
    fi
done
}

# Autor: Samuel Fantini <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Menu em formato checklist, para que o usuario selecione
# as partições que gostaria de formatar, estas partições
# são testadas para saber se são removiveis ou não
# o menu armazena tais
# partições e testa o tipo que ela esta (ext4, ntfs, swap)
# e faz a formatação
#------------------------------------------------------
# Histórico: v1.0 7/06/2016, Samuel Fantini Braga, Alain André:
#            -Menu que testa quais partições são removiveis ou não,
#          e apartir da escolha do usuario seleciona a melhor formatação
#
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
    do
	    tipo=$(blkid $item | sed 's/.*TYPE=//g' | cut -d'"' -f2)
	    if [ $tipo -eq "ntfs" ]; then
	      umount $item
	      mkfs.ntfs -Fq $item
	    fi
	    if [ $tipo -eq "ext4" ]; then
	      umount $item
	      mkfs.ext4 -Fq $item
	    fi
	    if [ $tipo -eq "swap" ]; then
	      umount $item
	      mkswap $item
	    fi
	done    
  done
}

#------------------------------------------------------
# Autor: Samuel Fantini <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Menu para criar imagem linux do sistema de recuepração,
# o menu contem apenas partições do formato ext4 e que
# fazem parte do Disco, o usuario tem que colar o nome da imagem
# que sera salva no diretorio /home/partimag/clonezilla-riso/sistemas/
#------------------------------------------------------
# Histórico: v1.0 13/06/2016, Samuel Fantini Braga, Alain André:
#            -Menu para criar imagem do sistema de recuperação que contem
#           apenas partições do formato ext4 e que não são removiveis
#          

function nova_imagem_sistema_recuperacao(){
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
    fdisk -l | grep $particao | grep Linux > /dev/null
    if [ $? -eq 0 ]; then
         fdisk -l | grep $particao | grep swap > /dev/null
  	     if [ $? -eq 1 ]; then
  	        local entradas_menu="$entradas_menu $particao $particao"
  	     fi
  	fi
  done
  
  while : ; do
    local opcao=$(dialog --stdout \
    --no-tags \
    --title "Menu Criar Nova Imagem do Sistema de Recuperação" \
    --ok-label "Confirmar" \
    --cancel-label "Cancelar" \
    --menu "Escolha a Partição:" \
    0 0 0 \
    $entradas_menu\
    )
    if [ -z $opcao ]; then
      break
    fi
    for item in $opcao
    do
	    nome=$(dialog --stdout --inputbox 'Digite o Nome da Nova Imagem:' 0 0)     
	    umount /mnt
	    mount $item /mnt
	    tar -cvf /home/partimag/clonezilla-riso/sistemas/${nome} /mnt *
	    umount /mnt
	done    
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
# v1.3 2016-06-09, Raylander Frois Lopes
#   - Criação da variável global DIR_TABELA    

# Variáveis Globais
TITLE="Clonezilla-RISO - v1.0"
DIR_PARTICIONAMENTO="/home/partimag/particionamento/"
DIR_TABELA=" /home/partimag/clonezilla-riso/particionamentos/"
# Chamada Principal do Sistema
menu_principal;

