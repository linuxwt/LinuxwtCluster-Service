#!/bin/bash

ip=$(ip addr | grep ens192 | grep inet | awk '{print $2}' | awk -F '/' '{print $1}')

cat >/etc/keepalived/keepalived.conf<<"EOF"
! Configuration File for keepalived
global_defs {
   router_id LVS_DEVEL
script_user root
   enable_script_security
}
vrrp_script chk_apiserver {
   script "/etc/keepalived/check_apiserver.sh"
   interval 5
   weight -5
   fall 2 
rise 1
}
vrrp_instance VI_1 {
   state MASTER    
   interface ens192 
   mcast_src_ip 10.235.9.61
   virtual_router_id 51  
   priority 100 
   advert_int 2
   authentication {
       auth_type PASS
       auth_pass K8SHA_KA_AUTH
   }
   virtual_ipaddress {
       10.235.9.68
       2409:807C:5A06:0001:0000:0000:0104:xxxx
   }
   track_script {
      chk_apiserver
   }
}
EOF

if [ $ip == "10.235.9.62" ];then
    sed -i 's/10.235.9.61/10.235.9.62/g' /etc/keepalived/keepalived.conf
    sed -i 's/100/99/g' /etc/keepalived/keepalived.conf
    sed -i 's/MASTER/BACKUP/g'  /etc/keepalived/keepalived.conf
elif [ $ip == "10.235.9.63" ];then
    sed -i 's/10.235.9.61/10.235.9.63/g' /etc/keepalived/keepalived.conf
    sed -i 's/100/98/g' /etc/keepalived/keepalived.conf
    sed -i 's/MASTER/BACKUP/g'  /etc/keepalived/keepalived.conf
else
    echo "need not change."
fi

cat <<EOF>> /etc/keepalived/check_apiserver.sh
err=0
for k in $(seq 1 3)
do
   check_code=$(pgrep haproxy)
   if [[ $check_code == "" ]]; then
       err=$(expr $err + 1)
       sleep 1
       continue
   else
       err=0
       break
   fi
done

if [[ $err != "0" ]]; then
   echo "systemctl stop keepalived"
   /usr/bin/systemctl stop keepalived
   exit 1
else
   exit 0
fi
EOF

systemctl start keepalived && systemctl status keepalived && systemctl enable keepalived
