#!/bin/bash

###########禁用###############################
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
setenforce 0

############创建自获取包制作共享源################
for i in ansible expect ipvs ntp nginx

do

    mkdir -p /usr/share/nginx/html/$i
    cp LinuxwtLocal-Yum/yumserver/${i}dir/* /usr/share/nginx/html/$i
    createrepo /usr/share/nginx/html/$i

##############创建共享源配置文件######################
cat <<EOF>> /etc/yum.repos.d/nginx-share.repo
[$i]
name=$i
baseurl=http://192.168.0.172/$i
gpgcheck=0
enabled=1    
EOF

done

chmod -R 775 /usr/share/nginx/html

systemctl restart nginx && systemctl enable nginx && systemctl daemon-reload

yum makecache && yum -y install ansible expect ntp ntpdate
