#!/bin/bash

config () 
{
 sed -i '/IPV6INIT/s/no/yes/g' /etc/sysconfig/network-scripts/ifcfg-ens192
 sed -i '/AUTOCONF/s/yes/no/g' /etc/sysconfig/network-scripts/ifcfg-ens192
 echo "IPV6ADDR=2409:807C:5A06:0001:0000:0000:0104:$i/120" >> /etc/sysconfig/network-scripts/ifcfg-ens192
 echo "IPV6_DEFAULTGW=2409:807C:5A06:0001:0000:0000:0104:09fe" >> /etc/sysconfig/network-scripts/ifcfg-ens192
}

ip=$(ip a | grep ens192 | grep inet | awk '{print $2}' | awk -F '/' '{print $1 }' | awk -F '.' '{print $NF}')
while read a b
do
  IP=$(echo $b)
  if [ "$IP" == "node${ip}" ];then
    i=$(echo $a | awk -F ':' '{print $NF}') && config
  else 
    continue
  fi 
done < ip6.txt
