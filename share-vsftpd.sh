#!/bin/bash

###########创建本地镜像共享源###############################
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
setenforce 0
mkdir -p /var/ftp/pub/redhat
cp -ar /mnt/cdrom/* /var/ftp/pub/redhat
createrepo /var/ftp/pub/redhat

############创建自获取包制作共享源################
for i in nginx ansible haproxy keepalived 

do

    mkdir -p /var/ftp/pub/$i
    cp /root/${i}dir/* /var/ftp/pub/$i
    createrepo /var/ftp/pub/$i
    mkdir -p /var/ftp/pub/redhat

##############创建共享源配置文件######################
cat <<EOF>> /root/share-vsftpd.repo
[$i]
name=$i
baseurl=ftp://192.168.0.168/pub/$i
gpgcheck=0
enabled=1    
EOF

done

cat <<EOF>> /root/share-vsftpd.repo
[redhat]
name=redhat
baseurl=ftp://192.168.0.168/pub/redhat
gpgcheck=0
enabled=1
EOF

systemctl restart vsftpd

##################批量传输共享源文件到所有节点################################
ansible all -m copy -a "src=/root/share-vsftpd.repo dest=/etc/yum.repos.d/"
ansible all -m shell -a "yum makecache"
