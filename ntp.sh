#!/bin/bash

# 安装ntp服务
yum -y install ntp ntpdate
ntpdate ntp1.aliyun.com
ntpdate ntp2.aliyun.com

# 备份ntp配置文件
[ -f "/etc/ntp.conf" ] && mv /etc/ntp.conf /etc/ntp.confbak

# 配置ntp.conf
cat <<EOF>> /etc/ntp.conf
restrict default nomodify notrap noquery
 
restrict 127.0.0.1
restrict 192.168.0.0 mask 255.255.255.0 nomodify    
#只允许$net网段的客户机进行时间同步。如果允许任何IP的客户机都可以进行时间同步，就修改为"restrict default nomodify"
 
server ntp1.aliyun.com
server ntp2.aliyun.com
server time1.aliyun.com
server time2.aliyun.com
server time-a.nist.gov
server time-b.nist.gov
 
server  127.127.1.0     
# local clock
fudge   127.127.1.0 stratum 10
 
driftfile /var/lib/ntp/drift
broadcastdelay  0.008
keys            /etc/ntp/keys
EOF
# 启动服务
systemctl restart ntpd
systemctl enable ntpd
systemctl daemon-reload
