#!/bin/bash  

for i in pause.tgz calico-cni.tgz calico-kube-controllers.tgz calico-node.tgz calico-pod2daemon-flexvol.tgz
do
    gunzip -c $i | docker load
done
