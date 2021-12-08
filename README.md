## [ansible结合shell部署k8s二进制高可用集群](https://linuxwt.com/ansiblejie-he-shelljiao-ben-wan-zheng-bu-shu/)
### 各个脚本作用
mount.sh 挂载本地镜像、创建本地镜像源 部署yumdownloader、createrepo、vsftpd、expect、lrzsz、epel、ansible、nginx、haproxy、keepalived
sshkey.sh 批量传输公钥至所有节点 批量修改所有节点主机名 生成host解析列表
share-vsftpd.sh 创建本地镜像共享源 创建自获取包共享源 创建共享源配置文件 批量传输共享源文件到所有节点
host.sh 传输host解析列表
ntp.sh 配置时间服务器
os.sh 系统优化配置，包括本地域名解析 防火墙配置 swap配置 selinux配置 文件数配置 ipvs配置 内核优化 时区配置 时间同步
docker.sh 配置docker
haproxy.sh 配置haproxy
keepalived.sh 配置keepalived
ca.sh CA配置
etcd.sh etcd集群配置
ansible.sh 部署脚本1 
第一阶段脚本执行顺序   mount.sh sshkey.sh share-vsftpd.sh host.sh ntp.sh ca.sh ansible.sh
ca-apiserver.sh 配置apiserver证书 1
token.sh apiserver配置token 1
apiserver.sh 配置apiserver
ca-kubectl.sh 配置kubectl证书 1
kubeconfig.sh 配置kubectl
ca-controller-manager.sh 配置controller-manager证书 1
kubeconfig-controller-manager.sh 配置controller-manager
controller-manager.sh 配置controller-manager
ca-scheduler.sh 配置scheduler证书 1
kubeconfig-scheduler.sh 配置scheduler
scheduler.sh 配置scheduler
kubeconfig-kubelet.sh 配置kubelet 1
kubelet.sh 配置kubelet
ca-kube-proxy.sh 配置kube-proxy证书
kubeconfig-kube-proxy.sh 配置kube-proxy 1
proxy.sh 配置kube-proxy
calico.sh 配置calico 1
ansible-k8s.sh 部署脚本2
第二阶段脚本执行顺序  ca-apiserver.sh token.sh ca-kubectl.sh ca-controller-manager.sh ca-scheduler.sh  kubeconfig-kubelet.sh kubeconfig-kube-proxy.sh calico.sh ansible-k8s.sh
test.sh 测试集群网络脚本

# 需要上传的包
系统镜像rhel7.7或者已加载到系统中
kubernetes-server-linux-amd64.tar.gz k8s二进制包
docker-19.03.9.tgz docker二进制包
etcd-v3.5.0-linux-amd64.tar.gz etcd二进制包
cfssl-certinfo_linux-amd64 cfssljson_linux-amd64 cfssl_linux-amd64 ca自签名证书工具
calico-cni.tgz calico-kube-controllers.tgz calico-node.tgz calico-pod2daemon-flexvol.tgz calico镜像
registry.aliyuncs.com/google_containers/pause:3.2 pause镜像
tutum/dnsutils:latest 测试镜像
coredns/coredns:1.8.4 coredns镜像
epel-release-7-14.noarch.rpm epel包
lrzsz 上传工具包


