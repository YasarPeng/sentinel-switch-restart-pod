# 功能介绍
监控哨兵状态，每隔一定时间内抓取redis master IP。如果检查与上一次记录的masterIP不一致。
则重启namespace下所有的deployment服务。

# 参数介绍
|参数|默认值|是否必须|描述|
|----|----|----|----|
|--kubeconfig|~/.kube/config|*|指定kubeconfig文件，一般是/etc/kubernetes/admin.comf|
|--k8s-master-url| | * |指定kube-apiserver的地址，用于连接到k8s集群。如：https://192.168.10.51:6443|
|--sentinel-address| | * | sentinel地址连接池。以,分割。如: 192.168.10.1:26379,192.168.10.2:26379|
|--namespace|entuc,entcmd| |指定要重启的命名空间，以,分割。如: entuc,entcmd|
|--sentinel-name|mymaster| | 哨兵集群名称|
|--sentinel-status|status.json| | 记录节点状态的json文件|
|--interval-time|30| | 探测的间隔时长，单位为s|

# k8s启动说明：
## 修改地方Deployment如下,只需要启动一个副本即可：
Image: 这里应该修改为localhost:5000/registry.cn-beijing.aliyuncs.com/laiye-rpa/sentinel:monitor_arm64
NAMESPACES: 默认即可
K8S_API_SERVER: 这里应该修改为k8s的api地址和端口
INTERVAL_TIME：间隔时长，单位为s。
SENTINEL_ADDRS：这里应该修改为实际的哨兵地址，以,分割
## 启动服务
kubectl apply -f sentinel_monitor.Deployment.yaml
## 启动完成后，使用命令检查服务是否正常运行
kubectl get deployment sentinel-monitor
## 检查服务运行日志
kubectl logs -f --tail 1 deployment/sentinel-monitor
##正常情况下会每隔30s打印日志出以下日志:
2024/09/23 07:57:27 Before: 192.168.10.104 Current: 192.168.10.104
