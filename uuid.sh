#!le/bin/bash

config () 
{
  echo "$b /data/docker  xfs defaults 0 0" >> /etc/fstab
}

ip=$(ip a | grep ens192 | grep inet | awk '{print $2}' | awk -F '/' '{print $1 }' | head -n 1)
while read a b
do
  IP=$(echo $a)
  if [ "$IP" == "${ip}" ];then
    config
  else 
    continue
  fi 
done < u3.txt
