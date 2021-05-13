## 本仓库为使用Heketi来自动配置GlusterFS复制集群作为kubernetes集群的共享存储以及kubernetes动态pv实践操作

##  [Kubernetes使用GlusterFS作集群共享存储](https://linuxwt.com/kubernetesquan-wei-zhi-nan-xue-xi-bi-ji-di-shi-pian-service/#9)

## 本仓库当初使用到的各组件版本及对应部署方式  
|组件|版本|部署方式|备注|
|:------|:------|:------|:------|   
|Kubernetes|v1.19.0|二进制|kubeadmin部署亦可|
|Docker|docker-ce 19.03.6|二进制|yum部署亦可|
|Heketi|v10.0.0|容器|yaml使用镜像为heketi/heketi:dev，该镜像已本地保存|   
|GlusterFS|v7.1|容器|yaml使用镜像为gluster/gluster-centos:latest，该镜像已本地保存|   
