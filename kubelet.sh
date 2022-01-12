cp kubernetes/server/bin/kubelet  /usr/local/bin
ip=$(ip addr | grep ens33 | grep inet | awk '{print $2}' | awk -F '/' '{print $1}' | head -n 1)

cat <<EOF>>  kubelet.json
{
  "kind": "KubeletConfiguration",
  "apiVersion": "kubelet.config.k8s.io/v1beta1",
  "authentication": {
    "x509": {
      "clientCAFile": "/etc/kubernetes/ssl/ca.pem"
    },
    "webhook": {
      "enabled": true,
      "cacheTTL": "2m0s"
    },
    "anonymous": {
      "enabled": false
    }
  },
  "authorization": {
    "mode": "Webhook",
    "webhook": {
      "cacheAuthorizedTTL": "5m0s",
      "cacheUnauthorizedTTL": "30s"
    }
  },
  "address": "${ip}",
  "port": 10250,
  "readOnlyPort": 10255,
  "cgroupDriver": "systemd",                    
  "hairpinMode": "promiscuous-bridge",
  "serializeImagePulls": false,
  "clusterDomain": "cluster.local.",
  "clusterDNS": ["10.96.0.2"]
}
EOF

cat <<EOF>> kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/var/lib/kubelet
ExecStart=/usr/local/bin/kubelet \\
--bootstrap-kubeconfig=/etc/kubernetes/kubelet-bootstrap.kubeconfig \
--cert-dir=/etc/kubernetes/ssl \
--kubeconfig=/etc/kubernetes/kubelet.kubeconfig \
--config=/etc/kubernetes/kubelet.json \
--network-plugin=cni \
--rotate-certificates \
--pod-infra-container-image=registry.aliyuncs.com/google_containers/pause:3.2 \
--alsologtostderr=true \
--logtostderr=false \
--log-dir=/var/log/kubernetes \
--v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /var/lib/kubelet
mkdir -p /etc/kubernetes
mkdir -p /etc/kubernetes/ssl
cp kubelet.json /etc/kubernetes
cp kubelet.service /usr/lib/systemd/system
cp kubelet-bootstrap.kubeconfig /etc/kubernetes
cp ca.pem /etc/kubernetes/ssl

systemctl start kubelet && systemctl status kubelet && systemctl enable kubelet
