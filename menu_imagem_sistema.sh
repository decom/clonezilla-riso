function menu_imagem_sistema(){
  source carregar_particoes.sh

  local entradas_menu=""
  
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
  	        local entradas_menu="$entradas_menu $particao $particao"
  	     fi
  	fi
  done
  
  if [ -z $entradas_menu ]; then 
	mensagem "Nenhuma partição ext4 encontrada"
	break
  fi
  
  while : ; do
    local opcao=$(dialog --stdout                               \
    --no-tags                                                   \
    --title "Menu Criar Nova Imagem do Sistema de Recuperação"  \
    --ok-label "Confirmar"                                      \
    --cancel-label "Cancelar"                                   \
    --menu "Escolha a Partição:"                                \
    0 0 0                                                       \
    $entradas_menu                                              \
    )
    if [ -z $opcao ]; then
      break
    fi
    for item in $opcao
    do
	    nome=$(dialog --stdout --inputbox 'Digite o Nome da Nova Imagem:' 0 0)     
	    umount /mnt 
	    mount $item /mnt
	    tar -cvf $DIR_SISTEMA/${nome} /mnt/*
	    umount /mnt
	done    
  done
}
