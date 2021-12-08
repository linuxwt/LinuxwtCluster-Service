#!/bin/bash

cat <<EOF>> example.yaml
apiVersion: v1
kind: Service
metadata:
  name: dnsutils-ds
  labels:
    app: dnsutils-ds
spec:
  type: NodePort
  selector:
    app: dnsutils-ds
  ports:
  - name: http
    port: 80
    targetPort: 80
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: dnsutils-ds
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
spec:
  selector:
    matchLabels:
      app: dnsutils-ds
  template:
    metadata:
      labels:
        app: dnsutils-ds
    spec:
      containers:
      - name: my-dnsutils
        image: tutum/dnsutils:latest
        command:
          - sleep
          - "3600"
        ports:
        - containerPort: 80
EOF

kubectl create -f example.yaml 
sleep 60
kubectl get svc,po -o wide | grep dnsutils-ds
serviceip=$(kubectl  get svc | grep dnsutils-ds | awk '{print $3}')
###########外部测试 ############
###vip测试###
ping -c 2 $serviceip
[ $? -ne 0 ] && echo "can not ping service ip" && exit 1
####podip测试#####
for i in $(kubectl  get pod -o wide | awk '{print $6}' | grep -v IP);do ping -c 2 $i;done
[ $? -ne 0 ] && echo "not all pod can ping" && exit 1
##########内部测试########################
for j in $(kubectl  get po | awk '{print $1}' | grep -v NAME);do kubectl exec  $j -- ping -c 2  192.168.0.168;done
[ $? -ne 0 ] && echo "从pod内部ping宿主机不通" && exit 1
###########域名测试####################
for j in $(kubectl  get po | awk '{print $1}' | grep -v NAME);do kubectl exec  $j -- nslookup www.baidu.com;done
