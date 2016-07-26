function menu_tabela_particionamento(){
  source carregar_discos.sh
  source mensagem.sh
  local entradas_menu=""
  
  if [ -z $(carregar_discos) ]; then 
      mensagem "Nenhum Disco encontrado"
      return 1
  fi
  
  for disco in $(carregar_discos)
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
    	 sfdisk -d $opcao > $DIR_PARTICIONAMENTOS$nome_tabela
    	 break
    fi
  done
}