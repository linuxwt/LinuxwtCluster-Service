#!/bin/bash

############## 批量传输公钥至所有节点###############################################
host1=`cat /etc/ansible/hosts | awk -F " " '{print $1}' | grep '^192' | head -n 3`

for i in $host1;

do
    password="gooalgene"
    /usr/bin/expect -c "
        spawn ssh-copy-id root@$i 
        expect {
        \"*(yes/no)\" {send \"yes\r\";exp_continue }
        \"*password\" { send \"$password\r\"; exp_continue }
        }     
expect eof"    
done


#################批量修改所有节点主机名#########################################
host2=$(cat /etc/ansible/hosts | awk '{print $1}' | grep '^192'  | head -n 3)

for p in $host2

do  
    q=$(echo $p | awk -F "." '{print $4}')
    ssh $p "hostnamectl set-hostname node${q}"    
done

####################批量添加host解析#######################################
host3=$(cat /etc/ansible/hosts | awk '{print $1}' | grep '^192'  | head -n 3)
for  m in $host3
do
    n=$(echo $m | awk -F "." '{print $4}')
    echo $m node$n >> /etc/hosts
    
done
