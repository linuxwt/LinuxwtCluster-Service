#!/bin/bash

cat <<EOF>>  kube-apiserver-csr.json
{
"CN": "kubernetes",
  "hosts": [
    "127.0.0.1",
    "192.168.0.168",
    "192.168.0.169",
    "192.168.0.170",
    "192.168.0.171",
    "10.96.0.1",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Hubei",
      "L": "shiyan",
      "O": "k8s",
      "OU": "system"
    }
  ]
}
EOF

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kube-apiserver-csr.json | cfssljson -bare kube-apiserver
