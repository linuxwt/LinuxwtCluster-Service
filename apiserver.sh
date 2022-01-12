#!/bin/bash

tar -xvf kubernetes-server-linux-amd64.tar.gz
cp kubernetes/server/bin/kube-apiserver /usr/local/bin

ip=$(ip addr | grep ens33 | grep inet | awk '{print $2}' | awk -F '/' '{print $1}' | head -n 1)

cat <<EOF>> kube-apiserver.conf
KUBE_APISERVER_OPTS="--enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \
--anonymous-auth=false \
--bind-address=$ip \
--secure-port=6443 \
--advertise-address=$ip \
--insecure-port=0 \
--authorization-mode=Node,RBAC \
--runtime-config=api/all=true \
--enable-bootstrap-token-auth \
--service-cluster-ip-range=10.96.0.0/16 \
--token-auth-file=/etc/kubernetes/token.csv \
--service-node-port-range=30000-50000 \
--tls-cert-file=/etc/kubernetes/ssl/kube-apiserver.pem  \
--tls-private-key-file=/etc/kubernetes/ssl/kube-apiserver-key.pem \
--client-ca-file=/etc/kubernetes/ssl/ca.pem \
--kubelet-client-certificate=/etc/kubernetes/ssl/kube-apiserver.pem \
--kubelet-client-key=/etc/kubernetes/ssl/kube-apiserver-key.pem \
--service-account-key-file=/etc/kubernetes/ssl/ca-key.pem \
--service-account-signing-key-file=/etc/kubernetes/ssl/ca-key.pem  \
--service-account-issuer=api \
--etcd-cafile=/etc/etcd/ssl/ca.pem \
--etcd-certfile=/etc/etcd/ssl/etcd.pem \
--etcd-keyfile=/etc/etcd/ssl/etcd-key.pem \
--etcd-servers=https://192.168.0.172:2379 \
--enable-swagger-ui=true \
--allow-privileged=true \
--apiserver-count=3 \
--audit-log-maxage=30 \
--audit-log-maxbackup=3 \
--audit-log-maxsize=100 \
--audit-log-path=/var/log/kube-apiserver-audit.log \
--event-ttl=1h \
--alsologtostderr=true \
--logtostderr=false \
--log-dir=/var/log/kubernetes \
--v=4"
EOF

cat <<EOF>> kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes
After=etcd.service
Wants=etcd.service

[Service]
EnvironmentFile=-/etc/kubernetes/kube-apiserver.conf
ExecStart=/usr/local/bin/kube-apiserver \$KUBE_APISERVER_OPTS
Restart=on-failure
RestartSec=5
Type=notify
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /etc/kubernetes/
mkdir -p /etc/kubernetes/ssl
mkdir -p /var/log/kubernetes
cp kube-apiserver.conf /etc/kubernetes
cp kube-apiserver.service /usr/lib/systemd/system/
cp kube-apiserver*.pem /etc/kubernetes/ssl
cp ca*.pem /etc/kubernetes/ssl
cp token.csv /etc/kubernetes

systemctl start kube-apiserver && systemctl status kube-apiserver && systemctl enable kube-apiserver && systemctl daemon-reload
