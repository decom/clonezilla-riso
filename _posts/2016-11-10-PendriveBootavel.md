---
layout: post 
title: Pendrive Bootavel
seletor: PendriveBootavel
---

## Manual de criação do pendrive bootável do Clonezilla  


- Baixe o [arquivo zip](http://clonezilla.org/downloads.php) Clonezilla.

- Para a criação de seu pendrive, é necessário que ele seja divido em duas partições. A primeira com pelo menos 300MB formatada como FAT16 ou FAT32, e a segunda formatada com EXT4. Você pode usar qualquer ferramenta de particionamento (por exemplo: gparted, parted, fdisk, cfdisk ou sfdisk). Para continuar é necessário saber o nome de sua unidade USB (exemplo: /dev/sdb1). Execute o comando: 

```shellscript 
$ sudo fdisk -l  
```  
Assim será listado o nome de sua unidade flash.

- Neste exemplo, assumimos que /dev/sdb1 tem sistema de arquivos FAT, e é automaticamente montado no dir /media/usb/. Se não for montado automaticamente, é preciso montá-lo manualmente com o comando:

``` shellscript 
$ mkdir -p /media/usb 
$ mount /dev/sdb1 /media/usb/
```

- Descompacte o arquivo zip do Clonezilla em sua unidade USB. Você pode fazer isso com o comando:
 
```shellscript 
$ unzip clonezilla-live-X.Y.Z-W-amd64.zip -d /media/usb/ 
```
- Para que sua unidade USB se torne bootável, primeiro entre na pasta "utils/linux" no diretório criado:

```shellscript 
$ cd /media/usb/utils/linux
```
Em seguida, execute: 

```shellscript 
$ sudo bash makeboot.sh /dev/sdb1
```

Substitua /dev/sdb1 com o nome do dispositivo USB flash, e siga as instruções. Poderá aparecer o seguinte erro:

`On x86-64 system, you should install libc6-i386 (for Debian/Ubuntu) or glibc.i686 (for Fedora/CentOS/OpenSuSE) package so that the required libraries to run 32-bit program /tmp/syslinux_tmp.JeNRrE/syslinux exist.`

Está solicitando a instalação do libc6-i386 no sistema. Caso esteja executando uma distribuição baseada em Debian, então basta executar o comando:

```shellscript 
$ sudo apt-get install libc6-i386
```
Agora poderá repetir o comando anterior, seguir as instruções e seu pendrive bootável com o Clonezilla estará pronto.

## Manual de criação do Clonezilla modificado com script do clonezilla-riso

- Será necessario [baixar](https://github.com/decom/clonezilla-riso/archive/feature-ocs.zip) os arquivos do clonezilla-riso que contem a custon-ocs, e extrai-los em uma pasta qualquer no HD com o comando:

```shellscript 
$ unzip clonezilla-riso-feature-ocs.zip
```

Para o processo de adição de script é necessário que os passos de criação do pendrive bootavel com o Clonezilla seja concluido.
E sera necessario executar os comandos seguintes no **terminal do Clonezilla.**


- Certifique-se de que a primeira linha do script custon-ocs seja a shebang (#!/bin/bash) para evitar um problema de "erro de formato", vamos usar como exemplo o script "clonezilla-riso.sh".

- Dê boot no pendrive e entre no "prompt command", se não for um usuario root execute o comando:

```shellscript 
$ sudo su
```

- Monte a **segunda partição do pendrive** em algum diretorio de trabalho, essa segunda partição será utilizada para salvar seu novo clonezilla modificado com o script. Utilize o seguinte comando para montar a segunda partição do pendrive assumindo que a mesma seja em /dev/sdb2 e será montado em /home/partimag : 

```shellscript 
$ mkdir -p /home/partimag
$ mount /dev/sdb2 /home/partimag
```
Assim, irá usar /dev/sdb2 como o dir trabalho.

- Copie o Script "custom-ocs" que está dentro da pasta baixada "clonezilla-riso-feature-ocs" para o diretorio criado "/home/partimag".Para a copia do arquivo (se estiver no HD) será preciso montar seu HD para ter acesso aos arquivos. Use o comando:

```shellscript 
$ fdisk -l
```
Será listado no caminho de seu HD ou unidades flash. Vamos assumir que o nome encontrado do HD é "/dev/sda1". Agora é necessário monta-lo em algum lugar, iremos ultilizar o caminho "/mnt". Execute o seguinte comando para monta-lo:

```shellscript 
$ mkdir -p /mnt
$ mount /dev/sda1 /mnt
```
Seu HD foi montado. Agora é preciso entrar no endereço "/mnt" e procurar a pasta onde seu script foi salvo. Dentro da pasta do script execute o comando para copia-lo para o diretorio criado anteriormente:

```shellscript 
$ cp custom-ocs /home/partimag
```

- Execute o seguinte comando pois será gerado um arquivo zip modificado com adição de seu script "custom-ocs", e será salvo na segunda partição de seu pendrive.

```shellscript 
$ cd /home/partimag
```

```shellscript 
$ ocs-live-dev -g en_US.UTF-8 -k NONE -s -c -m ./custom-ocs
```
- Agora acesse a pasta "clonezilla-riso-feature-ocs" no seu HD e copie a pasta clonezilla-riso que contem os scripts para /home/partimag com o seguinte comando

```shellscript 
$ cp clonezilla-riso/* /home/partimag
```

- Agora é somente seguir o "Manual de criação do pendrive bootável do Clonezilla", ignorando a formatação da segunda partição do pendrive (EXT4), formantando somente a primeira partição de 300MB (FAT32/FAT16). Substituindo o arquivo zip a ser baixado pelo novo zip gerado e salvo na segunda partição USB.


<input type='hidden' id='selectMenuManual' value='#PendriveBootavel' />