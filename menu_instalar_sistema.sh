#!/bin/bash
#------------------------------------------------------
# Autor: Raylander Fróis Lopes <raylanderlopes@hotmail.com>
#        Alain André <alainandre@decom.cefetmg.br>
#		 Samuel Fantini Bra <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Função que instala a imagem já selecionada pelo usario
# na partição que ele selecionará no menu desta função
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

function menu_instalar_sistema (){ 
	source carregar_discos.sh
  	source mensagem.sh
	source carregar_particoes.sh

	entradas_menu=""
	if [ -z $(carregar_discos) ]; then 
		mensagem "Nenhum Disco encontrado"
		return 1
	fi
    	    
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
   	
	if [ -z $entradas_menu ]; then 
		mensagem "Nenhuma partição ext4 encontrada"
		break
   	fi
     
	while : ; do
		local opcao2=$(dialog --stdout                              \
       	--no-items                                                  \
       	--title "Menu Imagem do Sistema de Recuperação"      	    \
       	--ok-label "Confirmar"                                      \
       	--cancel-label "Cancelar"                                   \
       	--menu "Escolha a Partição:"                                \
       	0 0 0                                                       \
       	$entradas_menu                                              \
       	)
       
       	if [ -z $opcao2 ]; then    
      		break       
       	else
			umount $opcao2 2> /dev/null
			mkfs.ext4 -Fq -O ^metadata_csum -U `cut -d '"' -f2 recoveryUUID` $opcao2        
			mount $opcao2 /mnt
			cd /mnt
			tar -xf ${DIR_SISTEMAS}$1 -C /mnt
			if [ $? -eq 0 ]; then
				mensagem "Instalado com sucesso"
			else
	        		mensagem "Instalado sem sucesso"
        		fi
			rm -Rf lost+found/
			cp -R $FILES/* /mnt
			cd ..
			grub-install  --boot-directory=/mnt/boot/ $(echo $opcao2 | sed -e "s/[0-9]*//g") &> /dev/null
 			umount /mnt 2> /dev/null
		fi
	done
	break    
}
