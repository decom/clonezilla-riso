function carregar_particoes(){
  local particoes=$(blkid | cut -d':' -f1)
  local dispositivosComRepetidos=$(echo $particoes | sed -e 's/[0-9]*//g')
  local dispositivosUnicosSemDev=$(for dispositivo in $dispositivosComRepetidos; do echo $dispositivo; done | uniq | sed -e 's/\/dev\///g')
  local dispositivosUSB=""
  for dispositivo in $dispositivosUnicosSemDev
  do 
  	local usb=$(readlink -f /sys/class/block/${dispositivo}/device | grep usb);   
    if [ ! -z "$usb" ]; then 
      local dispositivosUSB="$dispositivosUSB $dispositivo";   
    fi
  done
  for dispositivo in $dispositivosUSB
  do
    local particoes=$(for particao in $particoes; do echo $particao; done | grep -v $dispositivo)
  done
  echo $particoes
}
