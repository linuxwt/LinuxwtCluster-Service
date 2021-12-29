###############关闭防火墙 #########################
systemctl stop firewalld && systemctl disable firewalld && systemctl daemon-reload && systemctl status firewalld 


############关闭swap##############################
swapoff -a
sed -i '/swap/s/^/#/g' /etc/fstab
echo "vm.swappiness = 0" >> /etc/sysctl.conf 
sysctl -p

###############禁用selinux############################
setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config

##############文件数配置###################################
ulimit -SHn 65535
cat <<EOF >> /etc/security/limits.conf
* soft nofile 655360
* hard nofile 131072
* soft nproc 655350
* hard nproc 655350
* soft memlock unlimited
* hard memlock unlimited
EOF

##################配置ipvs###############################
yum install ipvsadm ipset sysstat conntrack libseccomp -y
modprobe -- ip_vs 
modprobe -- ip_vs_rr 
modprobe -- ip_vs_wrr 
modprobe -- ip_vs_sh 
modprobe -- nf_conntrack_ipv4     

cat >/etc/modules-load.d/ipvs.conf <<EOF 
ip_vs 
ip_vs_lc 
ip_vs_wlc 
ip_vs_rr 
ip_vs_wrr 
ip_vs_lblc 
ip_vs_lblcr 
ip_vs_dh 
ip_vs_sh  
ip_vs_nq 
ip_vs_sed 
ip_vs_ftp 
ip_vs_sh 
nf_conntrack_ipv4 
ip_tables 
ip_set 
xt_set 
ipt_set 
ipt_rpfilter 
ipt_REJECT 
ipip 
EOF

systemctl enable systemd-modules-load.service && systemctl daemon-reload

########################内核优化#######################
cat <<EOF > /etc/sysctl.d/k8s.conf   
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
fs.may_detach_mounts = 1
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
fs.file-max=52706963
fs.nr_open=52706963
net.netfilter.nf_conntrack_max=2310720

net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl =15
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_max_orphans = 327680
net.ipv4.tcp_orphan_retries = 3
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.ip_conntrack_max = 131072
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_timestamps = 0
net.core.somaxconn = 16384
EOF

######################时区配置######################
echo "Asia/Shanghai" > /etc/timezone
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

##################时间同步############################
yum -y install ntpdate && ntpdate 10.0.0.34
echo "0 0,6,12,18 * * * /usr/sbin/ntpdate 10.0.0.34;/sbin/hwclock -w" >> /etc/crontab
systemctl restart crond
