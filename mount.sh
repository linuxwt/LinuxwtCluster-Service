#!/bin/bash

####################挂载本地镜像介质##############
mkdir -p /mnt/cdrom && mount /dev/cdrom /mnt/cdrom
df -h
sleep 5

####################创建本地镜像源文件###########
cat <<EOF>> /etc/yum.repos.d/rhel7.repo
[control]
name=control
gpgcheck=0
enabled=1
baseurl=file:///mnt/cdrom
EOF
yum makecache

######################部署yumdownloader###########################
yum install yum-utils -y && rpm -ql yum-utils | grep yumdownloader
[ $? -ne 0 ] && exit 1
#####################部署createrepo#################
yum -y install createrepo
#####################部署vsftpd######################
yum -y install vsftpd
#####################部署expect######################
yum -y install expect
#####################部署lrzsz########################
yum -y install lrzsz
#####################部署epel###########################
rpm -ivh epel-release-7-14.noarch.rpm
####################部署ansible##########################
yum -y install ansible
####################获取ansible的包#####################################
yumdownloader --resolve --destdir=ansibledir ansible PyYAML libyaml python-babel python-cffi python-enum34 python-idna python-jinja2 python-markupsafe python-paramiko python-ply python-pycparser python2-cryptography python2-httplib2 python2-jmespath python2-pyasn1 sshpass
###################部署nginx##############################################
yum -y install nginx
####################获取nginx的包########################################
yumdownloader --resolve --destdir=nginxdir nginx gperftools-libs nginx-filesystem openssl11-libs redhat-indexhtml
######################部署haproxy############################################
yum -y install haproxy
yumdownloader --resolve --destdir=haproxydir haproxy
######################部署keepalived##########################################
yum -y install keepalived
########################获取keepalived的包####################################
yumdownloader --resolve --destdir=keepaliveddir keepalived lm_sensors-libs net-snmp-agent-libs net-snmp-libs perl perl-Carp perl-Encode perl-Exporter perl-File-Path perl-File-Temp perl-Filter perl-Getopt-Long perl-HTTP-Tiny perl-PathTools perl-Pod-Escapes perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Storable perl-Text-ParseWords perl-Time-HiRes perl-constant perl-Time-Local perl-libs perl-macros perl-parent perl-podlators perl-threads perl-threads-shared

