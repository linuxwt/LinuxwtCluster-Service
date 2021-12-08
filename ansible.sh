#!/bin/bash

###所有节点##########
############批量传输包到所有节点#######################
ansible all -m copy -a "src=/root/docker-19.03.9.tgz dest=/root"
ansible all -m copy -a "src=/root/kubernetes-server-linux-amd64.tar.gz dest=/root"

#############批量传输脚本到所有节点#####################
ansible all -m copy -a "src=/root/os.sh dest=/root"
ansible all -m copy -a "src=/root/docker.sh dest=/root"

ansible all -m shell -a "chmod +x /root/os.sh"
ansible all -m shell -a "chmod +x /root/docker.sh"

##############批量执行脚本##############################
ansible all -m shell -a "bash /root/os.sh"
ansible all -m shell -a "bash /root/docker.sh"

#######master节点################
################批量传输脚本到master节点#######################
ansible k8s-master -m  copy -a "src=/root/haproxy.sh dest=/root"
ansible k8s-master -m  copy -a "src=/root/keepalived.sh dest=/root"
ansible k8s-master -m shell -a "chmod +x /root/haproxy.sh"
ansible k8s-master -m shell -a "chmod +x /root/keepalived.sh"

############批量执行脚本#############################
ansible k8s-master -m shell -a "bash /root/haproxy.sh"
ansible k8s-master -m shell -a "bash /root/keepalived.sh"

#########etcd节点####################################
###########批量传输包到etcd节点########################
ansible etcd -m  copy -a "src=/root/etcd-v3.5.0-linux-amd64.tar.gz dest=/root"
ansible etcd -m  copy -a "src=/root/ca.pem dest=/root"
ansible etcd -m  copy -a "src=/root/ca-key.pem dest=/root"
ansible etcd -m  copy -a "src=/root/etcd.pem dest=/root"
ansible etcd -m  copy -a "src=/root/etcd-key.pem dest=/root"

###############批量传输脚本到etcd节点#####################
ansible etcd -m copy -a "src=/root/etcd.sh dest=/root"
ansible etcd -m shell -a "chmod +x /root/etcd.sh"

#########################批量执行脚本#################
ansible etcd -m shell -a "bash /root/etcd.sh"
