#!/bin/bash

yum -y install haproxy keepalived


cat >/etc/haproxy/haproxy.cfg<<"EOF"
global
 maxconn 2000
 ulimit-n 16384
 log 127.0.0.1 local0 err
 stats timeout 30s

defaults
 log global
 mode http
 option httplog
 timeout connect 5000
 timeout client 50000
 timeout server 50000
 timeout http-request 15s
 timeout http-keep-alive 15s

frontend monitor-in
 bind *:33305
 mode http
 option httplog
 monitor-uri /monitor

frontend k8s-master
 bind 0.0.0.0:16443
 bind 127.0.0.1:16443
 mode tcp
 option tcplog
 tcp-request inspect-delay 5s
 default_backend k8s-master

backend k8s-master
 mode tcp
 option tcplog
 option tcp-check
 balance roundrobin
 default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100
 server  node61  10.235.9.61:6443 check
 server  node62  10.235.9.62:6443 check
 server  node63  10.235.9.63:6443 check
 server  node61_IPv6  2409:807C:5A06:0001:0000:0000:0104:xxxx:6443 check
 server  node62_IPv6  2409:807C:5A06:0001:0000:0000:0104:xxxx:6443 check
 server  node63_IPv6  2409:807C:5A06:0001:0000:0000:0104:xxxx:6443 check
EOF

systemctl start haproxy && systemctl status haproxy && systemctl enable haproxy
