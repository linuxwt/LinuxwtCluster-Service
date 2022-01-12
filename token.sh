#!/bin/bash

cat <<EOF>> token.csv
$(head -c 16 /dev/urandom | od -An -t x | tr -d ' '),kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF
ansible all -m copy -a "src=/root/token.csv dest=/root"
