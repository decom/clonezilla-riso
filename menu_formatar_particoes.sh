function menu_formatar_particoes(){
  source carregar_particoes.sh
  source mensagem.sh
  
  local entradas_menu=""
  
  if [ -z $(carregar_discos) ]; then 
	mensagem "Nenhuma Partição Encontrada"
        break
  fi
  
  for particao in $(carregar_particoes)
  do
  	local entradas_menu="$entradas_menu $particao on"
  done
  
  while : ; do
    local opcao=$(dialog --stdout       \
    --no-items                          \
    --title "Menu Formatar Partições"   \
    --ok-label "Confirmar"              \
    --cancel-label "Cancelar"           \
    --checklist "Escolha as Partições:" \
    0 0 0                               \
    $entradas_menu                      \
    )
    if [ -z $opcao ]; then
      mensagem "Nenhuma Partição selecionado" 
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
		if [ $? -eq 0]; then
      mensagem "Formatado com sucesso" 
		else
			mensagem "Formatado sem sucesso"
    fi
  done
}
