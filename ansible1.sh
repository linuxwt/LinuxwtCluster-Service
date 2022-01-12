#!/bin/bash

ansible all -m copy -a "src=/root/docker.sh dest=/root"

ansible all -m shell -a "chmod +x /root/docker.sh"

ansible all -m shell -a "bash /root/os.sh"
ansible all -m shell -a "bash /root/docker.sh"

ansible master -m  copy -a "src=/root/ca.pem dest=/root"
ansible master -m  copy -a "src=/root/ca-key.pem dest=/root"
ansible master -m  copy -a "src=/root/etcd.pem dest=/root"
ansible master -m  copy -a "src=/root/etcd-key.pem dest=/root"

ansible master -m copy -a "src=/root/etcd.sh dest=/root"
ansible master -m shell -a "chmod +x /root/etcd.sh"

ansible master -m shell -a "bash /root/etcd.sh"
