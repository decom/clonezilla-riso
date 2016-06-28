#!/bin/bash
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
# v1.2 2016-06-23, Samuel Fantini:
#   - Modularização das funções
# v1.3 2016-06-28, Raylander Fróis Lopes
#   - Correção de erro
function mensagem(){
  local mensagem="$1"
  dialog                \
  --title "$TITLE"      \
  --msgbox "$mensagem"  \
  0 0
}
