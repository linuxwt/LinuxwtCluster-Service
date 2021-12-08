#!/bin/bash

cp kubernetes/server/bin/kube-proxy  /usr/local/bin
ip=$(ip addr | grep ens33 | grep inet | awk '{print $2}' | awk -F '/' '{print $1}' | head -n 1)
cat <<EOF>> kube-proxy.yaml
apiVersion: kubeproxy.config.k8s.io/v1alpha1
bindAddress: ${ip}
clientConnection:
  kubeconfig: /etc/kubernetes/kube-proxy.kubeconfig
clusterCIDR: 10.244.0.0/16
healthzBindAddress: ${ip}:10256
kind: KubeProxyConfiguration
metricsBindAddress: ${ip}:10249
mode: "ipvs"
EOF

cat <<EOF>> kube-proxy.service
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/kubernetes/kubernetes
After=network.target

[Service]
WorkingDirectory=/var/lib/kube-proxy
ExecStart=/usr/local/bin/kube-proxy \
--config=/etc/kubernetes/kube-proxy.yaml \
--alsologtostderr=true \
--logtostderr=false \
--log-dir=/var/log/kubernetes \
--v=2
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /var/lib/kube-proxy
cp kube-proxy.yaml /etc/kubernetes
cp kube-proxy.service /usr/lib/systemd/system
cp kube-proxy*.pem /etc/kubernetes/ssl
cp kube-proxy.kubeconfig /etc/kubernetes

systemctl start kube-proxy && systemctl status kube-proxy && systemctl enable kube-proxy
