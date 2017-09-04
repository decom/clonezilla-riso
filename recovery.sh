#!/bin/bash

# --------------------------------------------------------------------------
# Arquivo de instalação do sistema RISO-RECOVERY MBR
# --------------------------------------------------------------------------

# Verifica parâmetros do disco (ex:/dev/sda) e arquivo de particionamento (ex: HD500)
if [ $# -ne 2 ]; then

   echo "Utilização: $0 [Disco - (ex:/dev/sda)] [Arquivo de Particionamento - (ex: HD500)]";

   exit 1;
fi

# Define as variáveis DIRNAME, DEVICE e TABLE a partir dos parâmetros do disco e arquivo de particionamento.

DIRNAME=`dirname $0`

DEVICE=$1

TABLE=$2

atualizar_recovery() {
    carregar_variaveis;

    echo "Atualizando a partição RECOVERY..."

    echo "Formatando a partição RECOVERY e atribuindo a UUID padrão"
    # Formata a partição recovery, trocando a UUID

    mkfs.${sa_partrecovery} -Fq -O ^metadata_csum -U ${partrecovery,,} -L "RECOVERY" $RECOVERY

    echo "Formatação da partição RECOVERY realizada com sucesso..."

    echo ""

    echo ""

    #Restaura a partição recovery a partir do arquivo recovey.tar.bz2 presente no pendrive na segunda partição (ex:sdb2)

    mount $RECOVERY /mnt

    echo "Restaurando partição RECOVERY..."

    tar -jxf recovery.tar.bz2 -C /mnt

    echo "Partição RECOVERY restaurada com sucesso."

    echo ""

    echo ""

    echo "Instalando e atualizando o GRUB..."
    #Instala o grub na partição montada no diretório /mnt

    mkdir -p /mnt/boot/efi

    mount $EFI /mnt/boot/efi

    for i in /sys /proc /dev; do mount --bind $i /mnt$i; done

    chroot /mnt grub-install $DEVICE

    chroot /mnt update-grub

    for i in /sys /proc /dev; do umount /mnt$i; done

    umount $EFI

    umount $RECOVERY
    echo "GRUB instalado e atualizado com sucesso..."

    echo ""

    echo ""

    echo "Atualização da partição RECOVERY finalizada com sucesso."

    echo ""

    echo ""

    echo "Retornando ao menu principal."    

    sleep 10

    menu

}



# Carrega as variáveis do arquivo riso.cfg
carregar_variaveis() {
    
    source $DIRNAME/riso.cfg
    
    return 0
}


formatar_recovery() {
    
    carregar_variaveis;
    
    echo "Formatando a partição RECOVERY e atribuindo a UUID padrão..."
    
    # Formata a partição recovery, atribuindo a UUID e rótulo
    e2fsck -f $RECOVERY -y
    
    mkfs.${sa_partrecovery} -Fq -O ^metadata_csum -U ${partrecovery,,} -L "RECOVERY" $RECOVERY
    
    echo "Formatação da partição RECOVERY concluída com sucesso"
    
    echo ""

    return 0
}

formatar_windows() {
    carregar_variaveis;
    
    echo "Formatando a partição WINDOWS e atribuindo a UUID padrão..."
    #Formata a partição windows, atribuindo a UUID e rótulo
    mkfs.${sa_partwindows} -f -Fq  -L "WINDOWS" $WINDOWS

    u=${partwindows^^}

    echo ${u:14:2}${u:12:2}${u:10:2}${u:8:2}${u:6:2}${u:4:2}${u:2:2}${u:0:2} | xxd -r -p | dd of=$WINDOWS bs=8 count=1 seek=9
    
    echo "Formatação da partição WINDOWS concluída com sucesso"
    
    echo ""

    echo ""
    
    echo "Retornando ao menu principal."    

    sleep 10

    menu
}
formatar_linux() {
    
    carregar_variaveis;
    
    echo "Formatando a partição LINUX e atribuindo a UUID padrão..."
    #Formata a partição linux, trocando a UUID e rótulo
    
    e2fsck -f $LINUX -y

    mkfs.${sa_partlinux} -Fq -O ^metadata_csum -U ${partlinux,,} -L "LINUX" $LINUX
    
    echo "Formatação da partição LINUX concluída com sucesso"
    
    echo ""

    return 0
}
formatar_dados() {
    
    carregar_variaveis;
    
    echo "Formatando a partição DADOS e atribuindo a UUID padrão..."
    #Formata a partição dados, trocando a UUID e rótulo

    mkfs.${sa_partdados} -f -Fq -L "DADOS" $DADOS

    u=${partdados^^}

    echo ${u:14:2}${u:12:2}${u:10:2}${u:8:2}${u:6:2}${u:4:2}${u:2:2}${u:0:2} | xxd -r -p | dd of=$DADOS bs=8 count=1 seek=9

    echo "Formatação da partição DADOS concluída com sucesso"
    
    echo ""

    echo ""
    
    echo "Retornando ao menu principal."    

    sleep 10

    menu
}

formatar_swap() {
    # Desliga a swap
    swapoff -a    
    
    carregar_variaveis;
    
    echo "Formatando a partição SWAP e atribuindo a UUID padrão..."
    #Formata a partição swap, trocando a UUID e rótulo
    
    mk${sa_partswap} -U ${partswap,,} -L "SWAP" $SWAP
    

    echo "Formatação da partição SWAP concluída com sucesso"
    
    echo ""

    echo ""
    
    echo "Retornando ao menu principal."    

    sleep 10

    menu
}


instalar_UUID() {
    carregar_variaveis;
    echo "Atribuindo a UUID nas partições."

    # Atribuindo a UUID na partição EFI



    # Atribuindo a UUID a partição recovery

    e2fsck -f $RECOVERY -y
    tune2fs -U ${partrecovery,,} $RECOVERY

    # Atribui a UUID na partição windows

    u=${partwindows^^}

    echo ${u:14:2}${u:12:2}${u:10:2}${u:8:2}${u:6:2}${u:4:2}${u:2:2}${u:0:2} | xxd -r -p | dd of=$WINDOWS bs=8 count=1 seek=9

    # Atribui a UUID na partição linux

    e2fsck -f $LINUX -y
    tune2fs -U ${partlinux,,} $LINUX

    # Atribui a UUID na partição dados

    u=${partdados^^}

    echo ${u:14:2}${u:12:2}${u:10:2}${u:8:2}${u:6:2}${u:4:2}${u:2:2}${u:0:2}| xxd -r -p | dd of=$DADOS bs=8 count=1 seek=9

    # Atribui a UUID na partição swap

    mk${sa_partswap} -U ${partswap,,} -L "SWAP" $SWAP


    echo "Atribuição da UUID nas partições realizada com sucesso"

    sleep 3


    echo "Montando as partições recovery, /dev, /proc, /sys e /efi  no diretorio /mnt..."

    #Monta a partição recovery presente no disco.(ex:sda1)

    mount $RECOVERY /mnt
    mount $EFI /mnt/boot/efi
    for i in /sys /proc /dev; do mount --bind $i /mnt$i; done

    echo "Partições montadas com sucesso."

    sleep 3

    echo "Instalando e atualizando o GRUB..."

    #Instala e atualiza o grub na partição montada no diretório /mnt

    chroot /mnt grub-install $DEVICE
    chroot /mnt update-grub

    echo " GRUB instalado e atualizado com sucesso"

    sleep 3

    echo "Desmontando as partições montadas no diretório /mnt..."

    # Desmonta as partições montadas no diretório /mnt
    for i in /sys /proc /dev; do umount /mnt$i; done
    umount $EFI
    umount $RECOVERY

    echo "Partições desmontadas com sucesso"

    sleep 3

    echo "Atribuição da UUID nas partições finalizada com sucesso."

    echo ""

    echo ""
    
    echo "Retornando ao menu principal."    

    sleep 10

    menu    
        
}
instalar_recovery(){

    carregar_variaveis;

    echo "Instalando o Riso Recovery e atribuindo a UUID padrão..."

    # Desliga a swap
    swapoff -a

    # Apaga o inicio do disco
    dd if=/dev/zero of=$DEVICE bs=4M count=100

    # Aplicar tabela de particionamento ao disco
    sfdisk $DEVICE < $TABLE

    # Formata a partição recovery, trocando a UUID

    mkfs.${sa_partrecovery} -Fq -O ^metadata_csum -U ${partrecovery,,} -L "RECOVERY" $RECOVERY

    #Formata a partição windows, trocando a UUID.

    mkfs.${sa_partwindows} -f -Fq  -L "WINDOWS" $WINDOWS

    u=${partwindows^^}

    echo ${u:14:2}${u:12:2}${u:10:2}${u:8:2}${u:6:2}${u:4:2}${u:2:2}${u:0:2}| xxd -r -p | dd of=$WINDOWS bs=8 count=1 seek=9

    #Formata a partição linux, trocando a UUID

    mkfs.${sa_partlinux} -Fq -O ^metadata_csum -U ${partlinux,,} -L "LINUX" $LINUX

    # Formata a partição Dados

    mkfs.${sa_partdados} -f -Fq -L "DADOS" $DADOS

    u=${partdados^^}

    echo ${u:14:2}${u:12:2}${u:10:2}${u:8:2}${u:6:2}${u:4:2}${u:2:2}${u:0:2}| xxd -r -p | dd of=$DADOS bs=8 count=1 seek=9

    # Formata a partição swap, trocando a UUID

    mk${sa_partswap} -U ${partswap,,} -L "SWAP" $SWAP

    #Restaura a partição recovery a partir do arquivo recovey.tar.bz2 presente no pendrive na segunda partição (ex:sdb2)

    mount $RECOVERY /mnt

    echo "Restaurando a partição RECOVERY..."

    tar -jxf recovery.tar.bz2 -C /mnt

    echo "Partição RECOVERY restaurada com sucesso."

    #Instala o grub na partição montada no diretório /mnt

    mkdir -p /mnt/boot/efi

    mount $EFI /mnt/boot/efi

    #alterando para uma forma mais inteligente de montar as pastas

    for i in /sys /proc /dev; do mount --bind $i /mnt$i; done

    chroot /mnt grub-install $DEVICE

    chroot /mnt update-grub

    #alterando para uma forma mais inteligente de desmontar as pastas

    for i in /sys /proc /dev; do umount /mnt$i; done

    umount $EFI

    umount $RECOVERY

    echo "Instalação do Riso Recovery finalizada com sucesso."

    echo ""

    echo ""
    
    echo "Retornando ao menu principal."    

    sleep 10

    menu
}



menu() {  

clear
echo "==========================================="
echo "Script de instalação do RISO-RECOVERY..."
echo ""
echo ""
echo "==========================================="
echo ""
echo "1) Atualizar a partição RECOVERY"
echo ""
echo "2) Formatar Partição RECOVERY"
echo ""
echo "3) Formatar Partição WINDOWS"
echo ""
echo "4) Formatar Partição LINUX"
echo ""
echo "5) Formatar Partição DADOS"
echo ""
echo "6) Instalar RISO RECOVERY"
echo ""
echo "7) Instalar UUID nas partições"
echo ""
echo "8) Sair"
echo ""
echo ""
echo "==========================================="
echo ""
echo ""
echo -n "Escolha uma das opções acima!!!"

read opcao

case $opcao in

1)
    atualizar_recovery;;

2) 
    formatar_recovery && formatar_swap;;
                                    
3)
    formatar_windows;;
                                        
4)
    formatar_linux && formatar_swap;;
                                    
5)
    formatar_dados;;
                                    
6)
    instalar_recovery;;
                            
7)
    instalar_UUID;;
                            
8)

echo "Saindo...!"

exit ;;

*) echo "Opção desconhecida... Abortando o programa!!!" 

exit;;

esac

}
          
#Verifica se usuário é o root antes de executar.
if [ $(id -u) -ne "0" ];then
	echo "Este script deve ser executado com o usuário root"
	exit 1
else
	menu
fi
