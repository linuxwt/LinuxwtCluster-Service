yum -y install keepalived

ip=$(ip addr | grep eth0 | grep inet | awk '{print $2}' | awk -F '/' '{print $1}')

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
   state MASTER    # 主节点
   interface eth0 # 网卡
   mcast_src_ip 10.0.0.30  # ip
   virtual_router_id 51  
   priority 100 # 优先级，该值越大表示优先级越强
   advert_int 2
   authentication {
       auth_type PASS
       auth_pass K8SHA_KA_AUTH
   }
   virtual_ipaddress {
       192.168.0.29 # 虚拟路由ip
   }
   track_script {
      chk_apiserver
   }
}
EOF

if [ $ip == "10.0.0.31" ];then
    sed -i 's/10.0.0.30/10.0.0.31/g' /etc/keepalived/keepalived.conf
    sed -i 's/100/99/g' /etc/keepalived/keepalived.conf
    sed -i 's/MASTER/BACKUP/g'  /etc/keepalived/keepalived.conf
elif [ $ip == "10.0.0.32" ];then
    sed -i 's/10.0.0.30/10.0.0.32/g' /etc/keepalived/keepalived.conf
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
