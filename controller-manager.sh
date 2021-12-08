#!/bin/bash

cat <<EOF>>  kube-controller-manager.conf
KUBE_CONTROLLER_MANAGER_OPTS="--port=10252 \
--secure-port=10257 \
--bind-address=127.0.0.1 \
--kubeconfig=/etc/kubernetes/kube-controller-manager.kubeconfig \
--service-cluster-ip-range=10.96.0.0/16 \
--cluster-name=kubernetes \
--cluster-signing-cert-file=/etc/kubernetes/ssl/ca.pem \
--cluster-signing-key-file=/etc/kubernetes/ssl/ca-key.pem \
--allocate-node-cidrs=true \
--cluster-cidr=10.244.0.0/16 \
--experimental-cluster-signing-duration=87600h \
--root-ca-file=/etc/kubernetes/ssl/ca.pem \
--service-account-private-key-file=/etc/kubernetes/ssl/ca-key.pem \
--leader-elect=true \
--feature-gates=RotateKubeletServerCertificate=true \
--controllers=*,bootstrapsigner,tokencleaner \
--horizontal-pod-autoscaler-use-rest-clients=true \
--horizontal-pod-autoscaler-sync-period=10s \
--tls-cert-file=/etc/kubernetes/ssl/kube-controller-manager.pem \
--tls-private-key-file=/etc/kubernetes/ssl/kube-controller-manager-key.pem \
--use-service-account-credentials=true \
--alsologtostderr=true \
--logtostderr=false \
--log-dir=/var/log/kubernetes \
--v=2"
EOF

cat <<EOF>> kube-controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
EnvironmentFile=-/etc/kubernetes/kube-controller-manager.conf
ExecStart=/usr/local/bin/kube-controller-manager \$KUBE_CONTROLLER_MANAGER_OPTS
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cp kube-controller-manager.conf /etc/kubernetes
cp kube-controller-manager.service /usr/lib/systemd/system
cp kube-controller-manager.kubeconfig /etc/kubernetes
cp kube-controller-manager*.pem /etc/kubernetes/ssl/

systemctl start kube-controller-manager && systemctl status kube-controller-manager && systemctl enable kube-controller-manager
