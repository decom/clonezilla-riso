function carregar_particoes(){
  local particoes=$(blkid | cut -d':' -f1)
  local dispositivosComRepetidos=$(echo $particoes | sed -e 's/[0-9]*//g')
  local dispositivosUnicosSemDev=$(for dispositivo in $dispositivos_com_repetidos; do echo $dispositivo; done | uniq | sed -e 's/\/dev\///g')
  local dispositivosUSB=""
  for dispositivo in $dispositivos_unicos_sem_dev
  do 
  	local usb=$(readlink -f /sys/class/block/${dispositivo}/device | grep usb);   
    if [ ! -z "$usb" ]; then 
      local dispositivosUSB="$dispositivos_usb $dispositivo";   
    fi
  done
  for dispositivo in $dispositivos_usb
  do
    local particoes=$(for particao in $particoes; do echo $particao; done | grep -v $dispositivo)
  done
  echo $particoes
}
