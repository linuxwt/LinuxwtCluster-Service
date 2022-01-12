#!/bin/bash

cat <<EOF>> kube-scheduler.conf
KUBE_SCHEDULER_OPTS="--address=127.0.0.1 \
--kubeconfig=/etc/kubernetes/kube-scheduler.kubeconfig \
--leader-elect=true \
--alsologtostderr=true \
--logtostderr=false \
--log-dir=/var/log/kubernetes \
--v=2"
EOF

cat <<EOF>> kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
EnvironmentFile=-/etc/kubernetes/kube-scheduler.conf
ExecStart=/usr/local/bin/kube-scheduler \$KUBE_SCHEDULER_OPTS
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cp kube-scheduler.conf /etc/kubernetes
cp kube-scheduler.service /usr/lib/systemd/system
cp kube-scheduler.kubeconfig /etc/kubernetes
cp kube-scheduler*.pem /etc/kubernetes/ssl/

systemctl start kube-scheduler && systemctl status kube-scheduler && systemctl enable kube-scheduler
