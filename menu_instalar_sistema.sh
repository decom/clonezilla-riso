#!/bin/bash
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#
#------------------------------------------------------
# Função de instalação de sistema de recuperação
#------------------------------------------------------
# Histórico:
# v1.0 2016-06-27, Raylander Frois Lopes
#   - Versão inicial.  

function menu_instalar_sistema (){
	source carregar_particoes.sh
    
  local arquivos=$(ls "${DIR_SISTEMAS}")
  
  if [ -z $arquivos ]; then 
	mensagem "Diretorio vazio"
	break
  fi
  
  local entradas_menu=""
  for arquivo in $arquivos 
	do
  	local entradas_menu="$entradas_menu $arquivo"
  done

  while : ; do
  	local opcao1=$(dialog --stdout                                 \
          --no-items                                       \
          --title "Menu Selecionar Imagens de Recuperação"        \
          --ok-label "Confirmar"                                  \
          --cancel-label "Cancelar"                              \
          --menu "Selecione a imagem de recuperação:" \
          0 0 0                                                      \
      		$entradas_menu
    )
  	if [ -z $opcao1 ]; then
    	    mensagem "Nenhuma Imagem selecionada" 
    	    break
        else
            entradas_menu=""
    	    for particao in $(carregar_particoes)
            do
                fdisk -l 2> /dev/null | grep $particao | grep Linux  &> /dev/null
                if [ $? -eq 0 ]; then
                    fdisk -l 2> /dev/null | grep $particao | grep swap  &> /dev/null
        	    if [ $? -eq 1 ]; then
                        local entradas_menu="$entradas_menu $particao"
                    fi
                fi
            done
        fi
   done 
   
   if [ -z $entradas_menu ]; then 
	mensagem "Nenhuma partição ext4 encontrada"
	break
   fi
     
     while : ; do
       local opcao2=$(dialog --stdout                               \
       --no-items                                                  \
       --title "Menu Imagem do Sistema de Recuperação"  \
       --ok-label "Confirmar"                                      \
       --cancel-label "Cancelar"                                   \
       --menu "Escolha a Partição:"                                \
       0 0 0                                                       \
       $entradas_menu                                              \
       )
       
       if [ -z $opcao2 ]; then
	  mensagem "Nenhuma partição selecionada"
          break
       
       else
         umount $opcao2 2> /dev/null
         mkfs.ext4 -qF $opcao2
         mount $opcao2 /mnt
         cd /mnt
         tar -xvf $opcao1
         cd ..
         grub-install  --boot-dirertory=/mnt/boot/ $(echo $opcao2 | sed -e "s/[0-9]*//g")
         umount /mnt 2> /dev/null
       fi
     done    
}
