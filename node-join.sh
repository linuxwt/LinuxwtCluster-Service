#!/bin/bash

ipv4=`ip a |grep "10.235" |tr "\t" " "|tr -s " "|cut -d ' ' -f3|cut -d/ -f1`
ipv6=`ip a |grep "2409:807c" |tr "\t" " "|tr -s " "|cut -d ' ' -f3|cut -d/ -f1`

cat > kubeadm-join-config.yaml << EOF
apiVersion: kubeadm.k8s.io/v1beta2
kind: JoinConfiguration
discovery:
  bootstrapToken:
    apiServerEndpoint: 10.235.9.68:16444
    token: "wgryo1.v3vyetikaskv5w2z"
    caCertHashes:
    - "sha256:b70e894cf9273fae73d6b0a8b3d33603a599e2259fa280f6c5efb2366ffaf86d"
nodeRegistration:
  kubeletExtraArgs:
    node-ip: ${ipv4},${ipv6}
EOF
