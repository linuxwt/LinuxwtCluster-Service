#!/bin/bash

cat <<EOF>> kube-controller-manager-csr.json
{
    "CN": "system:kube-controller-manager",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "hosts": [
      "127.0.0.1",
      "192.168.0.172"
    ],
    "names": [
      {
        "C": "CN",
        "ST": "Hubei",
        "L": "shiyan",
        "O": "system:kube-controller-manager",
        "OU": "system"
      }
    ]
}
EOF
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
