#------------------------------------------------------
# Autor: Samuel Fantini <samuel.fantini.braga@hotmail.com>
#
#------------------------------------------------------
# Função que cria o menu com as partições para formatar
#usando o clonezilla-riso,
# responsável por exibir as opções de partição
#------------------------------------------------------
# Histórico:
#   v1.0 2016-05-24, Alain André, Samuel Fantini:
#   - Versão inicial do menu de formatação.
#   
function menu_formatar_particoes(){
    
    #Carrega as variaveis e verifica quais são dispositivos e quais são
    #dipositivos removiveis
    dispositivoComDev=($(sfdisk -l | grep Disco | grep /dev | cut -d' ' -f2))
    dispositivoSemDev=($(echo ${dispositivoComDev[@]:0} | sed -e 's/://dispositivoComDev' | sed -e 's/\/dev\///g'))
    count1=0
    count2=1
    for i in ${dispositivoSemDev[@]:0};
    do
        readlink -f /sys/class/block/${dispositivoSemDev[@]:$count1:$count2}/device | grep usb
        if [ $? -eq 1 ]; then
            dispositivosSemUsb=(${dispositivoSemDev[@]:$count1:$count2})
        fi
        count1=$(($count1+1))
        count2=$(($count2+1))
    done

    #A partir do metodo anterior conseguimos guardar os dipositivos do computador
    #em um vetor e agora adicionaremos /dev nele para podermos pegar suas partições com o blkid
    dispositivoComDev=($(sfdisk -l | grep Disco | grep /dev | cut -d' ' -f2))
    count1=0
    for i in ${dispositivosSemUsb[@]:0}
    do
        count1=$(($count1+1))
    done
    count2=0
    count3=0
    count4=1
    while [ $count2 -lt $count1 ];
    do
        dispositivosSemUsbSemPontos=($(echo ${dispositivosSemUsb[@]:$count3:$count4} | sed -e 's/://g'))
        todasAsPrticoesFormataveis=($(blkid | grep ${dispositivosSemUsbSemPontos[@]:$count3:$count4} | cut -d':' -f1))
        count3=$(($count3+1))
        count4=$(($count4+1))
        count2=$(($count2+1))
    done

    #Agora com as variaveis carregadas podemos implementar o menu de escolha das partições
    local count1=1
    local entradas_menu=""


    for dispositivos in ${todasAsPrticoesFormataveis[@]:0};
    do
        local entradas_menu="$entradas_menu $count1 $dispositivos on"
        local contador=$(($count1+1))
    done
    while : ; do
        local opcao=$(dialog --stdout \
        --cr-wrap \
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
    done
}
