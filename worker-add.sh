#!/bin/bash
for i in edge app
do
    ansible $i -m shell -a "kubeadm join 10.0.0.29:16443 --token q4u5au.w5tmhauvznpizur6 --discovery-token-ca-cert-hash \
    sha256:0e24413f7448bb602fe01585b5eafdc64b7c331b44d44a20fc05fdb4ff633f4e"
done
