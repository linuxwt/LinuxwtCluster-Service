#!/bin/bash


##########apiserver################################
###################master节点######################
##################批量传输脚本到master节点#########
ansible k8s-master -m copy -a "src=/root/apiserver.sh dest=/root"

#################批量传送ca文件到master节点###########
ansible k8s-master -m copy -a "src=/root/kube-apiserver.pem  dest=/root"
ansible k8s-master -m copy -a "src=/root/kube-apiserver-key.pem  dest=/root"

###############批量执行脚本#########################
ansible k8s-master -m shell -a "chmod +x /root/apiserver.sh"
ansible k8s-master -m shell -a "bash /root/apiserver.sh"

##########kubectl################################
###################master节点######################
##################批量传输脚本到master节点#########
ansible k8s-master -m copy -a "src=/root/kubeconfig.sh dest=/root"

#################批量传送ca文件到master节点###########
ansible k8s-master -m copy -a "src=/root/admin.pem  dest=/root"
ansible k8s-master -m copy -a "src=/root/admin-key.pem  dest=/root"

###############批量执行脚本#########################
ansible k8s-master -m shell -a "chmod +x /root/kubeconfig.sh"
ansible k8s-master -m shell -a "bash /root/kubeconfig.sh"


#############controller-manager################################
###################master节点######################
##################批量传输脚本到master节点#########
ansible k8s-master -m copy -a "src=/root/controller-manager.sh dest=/root"
ansible k8s-master -m copy -a "src=/root/kubeconfig-controller-manager.sh dest=/root"

#################批量传送ca文件到master节点###########
ansible k8s-master -m copy -a "src=/root/kube-controller-manager.pem  dest=/root"
ansible k8s-master -m copy -a "src=/root/kube-controller-manager-key.pem  dest=/root"

###############批量执行脚本#########################
ansible k8s-master -m shell -a "chmod +x /root/kubeconfig-controller-manager.sh"
ansible k8s-master -m shell -a "chmod +x /root/controller-manager.sh"
ansible k8s-master -m shell -a "bash /root/kubeconfig-controller-manager.sh"
ansible k8s-master -m shell -a "bash /root/controller-manager.sh"

#############scheduler################################
###################master节点######################
##################批量传输脚本到master节点#########
ansible k8s-master -m copy -a "src=/root/scheduler.sh dest=/root"
ansible k8s-master -m copy -a "src=/root/kubeconfig-scheduler.sh dest=/root"

#################批量传送ca文件到master节点###########
ansible k8s-master -m copy -a "src=/root/kube-scheduler.pem  dest=/root"
ansible k8s-master -m copy -a "src=/root/kube-scheduler-key.pem  dest=/root"

###############批量执行脚本#########################
ansible k8s-master -m shell -a "chmod +x /root/kubeconfig-scheduler.sh"
ansible k8s-master -m shell -a "chmod +x /root/scheduler.sh"
ansible k8s-master -m shell -a "bash /root/kubeconfig-scheduler.sh"
ansible k8s-master -m shell -a "bash /root/scheduler.sh"

#############kubelet################################
###################node节点######################
##################批量传输脚本到node节点#########
ansible k8s-node -m copy -a "src=/root/kubelet.sh dest=/root"
ansible k8s-node -m copy -a "src=/root/kubelet-bootstrap.kubeconfig dest=/root"
###############批量执行脚本#########################
ansible k8s-node -m shell -a "chmod +x /root/kubelet.sh"
ansible k8s-node -m shell -a "bash /root/kubelet.sh"
ansible k8s-master -m shell -a "kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve"


#############kube-proxy################################
###################node节点######################
##################批量传输脚本到node节点#########
ansible k8s-node -m copy -a "src=/root/proxy.sh dest=/root"
ansible k8s-node -m copy -a "src=/root/kube-proxy.kubeconfig dest=/root"
###############批量执行脚本#########################
ansible k8s-node -m shell -a "chmod +x /root/proxy.sh"
ansible k8s-node -m shell -a "bash /root/proxy.sh"

################calico#################
#############all节点####################
ansible all -m copy -a "src=/root/calico-cni.tgz dest=/root"
ansible all -m copy -a "src=/root/calico-kube-controllers.tgz dest=/root"
ansible all -m copy -a "src=/root/calico-node.tgz dest=/root"
ansible all -m copy -a "src=/root/calico-pod2daemon-flexvol.tgz dest=/root"
ansible all -m copy -a "src=/root/calico.sh dest=/root"
ansible all -m shell -a "chmod +x /root/calico.sh"
ansible all -m shell -a "bash /root/calico.sh"
kubectl create -f calico.yaml

###############coredns######################
############edge节点########################
kubectl create -f coredns.yaml
