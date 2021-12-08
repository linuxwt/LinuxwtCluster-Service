#!/bin/bash

tar zxvf etcd-v3.5.0-linux-amd64.tar.gz
cp -p etcd-v3.5.0-linux-amd64/etcd* /usr/local/bin/

ip=$(ip addr | grep ens33 | grep inet | awk '{print $2}' | awk -F '/' '{print $1}' | head -n 1) 

cat <<EOF>> etcd.conf
#[Member]
ETCD_NAME="etcd1"
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_PEER_URLS="https://${ip}:2380"
ETCD_LISTEN_CLIENT_URLS="https://${ip}:2379,http://127.0.0.1:2379"

#[Clustering]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://${ip}:2380"
ETCD_ADVERTISE_CLIENT_URLS="https://${ip}:2379"
ETCD_INITIAL_CLUSTER="etcd1=https://192.168.0.168:2380,etcd2=https://192.168.0.169:2380,etcd3=https://192.168.0.170:2380"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_INITIAL_CLUSTER_STATE="new"
EOF

if [ $ip == "192.168.0.169" ];then
    sed -i '/ETCD_NAME/s/etcd1/etcd2/g' etcd.conf
elif [ $ip == "192.168.0.170" ];then
    sed -i '/ETCD_NAME/s/etcd1/etcd3/g' etcd.conf
else
    echo "need not change."
fi

cat <<EOF>> etcd.service
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=notify
EnvironmentFile=-/etc/etcd/etcd.conf
WorkingDirectory=/var/lib/etcd/
ExecStart=/usr/local/bin/etcd \
--cert-file=/etc/etcd/ssl/etcd.pem \
--key-file=/etc/etcd/ssl/etcd-key.pem \
--trusted-ca-file=/etc/etcd/ssl/ca.pem \
--peer-cert-file=/etc/etcd/ssl/etcd.pem \
--peer-key-file=/etc/etcd/ssl/etcd-key.pem \
--peer-trusted-ca-file=/etc/etcd/ssl/ca.pem \
--peer-client-cert-auth \
--client-cert-auth
Restart=on-failure
RestartSec=5
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF


mkdir -p /etc/etcd
mkdir -p /etc/etcd/ssl
mkdir -p /var/lib/etcd/default.etcd
cp etcd.conf /etc/etcd/
cp etcd.service /usr/lib/systemd/system/
cp ca*.pem /etc/etcd/ssl
cp etcd*.pem /etc/etcd/ssl

systemctl start etcd && systemctl enable etcd && systemctl daemon-reload && systemctl status etcd
sleep 15

ETCDCTL_API=3 /usr/local/bin/etcdctl --write-out=table --cacert=/etc/etcd/ssl/ca.pem --cert=/etc/etcd/ssl/etcd.pem --key=/etc/etcd/ssl/etcd-key.pem --endpoints=https://192.168.0.168:2379,https://192.168.0.169:2379,https://192.168.0.170:2379 endpoint health
