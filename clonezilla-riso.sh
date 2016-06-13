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
      2) menu_formatar_particoes;;
      3) ;;
      4) ;;
      5) nova_imagem_sistema_recuperacao;;
      *) init 6;;
    esac

  done
  init 6
}

#------------------------------------------------------
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

menu_principal;
