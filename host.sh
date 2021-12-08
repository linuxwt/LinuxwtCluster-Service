#!/bin/bash

host=$(cat /etc/ansible/hosts | awk '{print $1}' | grep '^192' | head -n 3)

for i in $host
do
    j=$(echo $i | awk -F '.' '{print $4}')
    echo $i node$j >> host.txt
done

ansible all -m copy -a "src=/root/host.txt dest=/root"
