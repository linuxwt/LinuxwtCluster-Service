#!/bin/bash

ansible master -m copy -a "src=/root/apiserver.sh dest=/root"

ansible master -m copy -a "src=/root/kube-apiserver.pem  dest=/root"
ansible master -m copy -a "src=/root/kube-apiserver-key.pem  dest=/root"

ansible master -m shell -a "chmod +x /root/apiserver.sh"
ansible master -m shell -a "bash /root/apiserver.sh"

ansible master -m copy -a "src=/root/kubeconfig.sh dest=/root"

ansible master -m copy -a "src=/root/admin.pem  dest=/root"
ansible master -m copy -a "src=/root/admin-key.pem  dest=/root"

ansible master -m shell -a "chmod +x /root/kubeconfig.sh"
ansible master -m shell -a "bash /root/kubeconfig.sh"

ansible master -m copy -a "src=/root/controller-manager.sh dest=/root"
ansible master -m copy -a "src=/root/kubeconfig-controller-manager.sh dest=/root"

ansible master -m copy -a "src=/root/kube-controller-manager.pem  dest=/root"
ansible master -m copy -a "src=/root/kube-controller-manager-key.pem  dest=/root"

ansible master -m shell -a "chmod +x /root/kubeconfig-controller-manager.sh"
ansible master -m shell -a "chmod +x /root/controller-manager.sh"
ansible master -m shell -a "bash /root/kubeconfig-controller-manager.sh"
ansible master -m shell -a "bash /root/controller-manager.sh"

ansible master -m copy -a "src=/root/scheduler.sh dest=/root"
ansible master -m copy -a "src=/root/kubeconfig-scheduler.sh dest=/root"

ansible master -m copy -a "src=/root/kube-scheduler.pem  dest=/root"
ansible master -m copy -a "src=/root/kube-scheduler-key.pem  dest=/root"

ansible master -m shell -a "chmod +x /root/kubeconfig-scheduler.sh"
ansible master -m shell -a "chmod +x /root/scheduler.sh"
ansible master -m shell -a "bash /root/kubeconfig-scheduler.sh"
ansible master -m shell -a "bash /root/scheduler.sh"
!
ansible master -m shell -a "bash /root/kubeconfig-kubelet.sh"
ansible all -m copy -a "src=/root/kubelet.sh dest=/root"
ansible all -m copy -a "src=/root/kubelet-bootstrap.kubeconfig dest=/root"
ansible all -m copy -a "src=/root/ca.pem dest=/root"

ansible all -m shell -a "chmod +x /root/kubelet.sh"
ansible all -m shell -a "bash /root/kubelet.sh"
ansible master -m shell -a "kubectl get csr | grep Pending | awk '{print $1}' | xargs kubectl certificate approve"

ansible master -m shell -a "bash /root/kubeconfig-kube-proxy.sh"
ansible all -m copy -a "src=/root/proxy.sh dest=/root"
ansible all -m copy -a "src=/root/kube-proxy.kubeconfig dest=/root"

ansible all -m shell -a "chmod +x /root/proxy.sh"
ansible all -m shell -a "bash /root/proxy.sh"

#ansible all -m copy -a "src=/root/calico-cni.tgz dest=/root"
#ansible all -m copy -a "src=/root/calico-kube-controllers.tgz dest=/root"
#ansible all -m copy -a "src=/root/calico-node.tgz dest=/root"
#ansible all -m copy -a "src=/root/calico-pod2daemon-flexvol.tgz dest=/root"
#ansible all -m copy -a "src=/root/calico.sh dest=/root"
# ansible all -m shell -a "chmod +x /root/calico.sh"
# ansible all -m shell -a "bash /root/calico.sh"
kubectl create -f calico.yaml

kubectl create -f coredns.yaml
