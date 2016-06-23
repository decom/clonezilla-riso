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
# v1.2 2016-06-23, Samuel Fantini:
#   - Modularização das funções

function menu_principal(){
  source $clonezilla_riso/menu_selecionar_particionamento.sh
  source $clonezilla_riso/menu_formatar_particoes.sh
  source $clonezilla_riso/menu_tabela_particionamento.sh
  source $clonezilla_riso/nova_imagem_sistema_recuperacao.sh
  source $clonezilla_riso/carregar_variaveis.sh
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
