FROM alpine:3.9.2

LABEL version="3.9.2"
LABEL description="监控redis是否发生切换,需要指定kubeconfig文件.必须定义变量NAMESPACES、KUBECONFIG、SENTINEL_ADDRS"
LABEL OS="alpine"
LABEL tag="monitor-20240923"
LABEL sentinelMonitor="v0.1"

WORKDIR /root

USER root

ENV TZ="Asia/Shanghai"

ENV SENTINEL_NAME="mymaster"
ENV NAMESPACES="entuc,entcmd"
ENV INTERVAL_TIME=30
ENV KUBECONFIG=""
ENV SENTINEL_ADDRS=""
ENV SENTINEL_STATUS="status.json"
ENV K8S_API_SERVER=""

COPY status.json /root
COPY entrypoint.sh /root
COPY sentinelMonitor_x86_64 /root
COPY sentinelMonitor_aarch64 /root

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    chmod +x /root/sentinelMonitor_x86_64 && \
    chmod +x /root/sentinelMonitor_aarch64 && \
    chmod +x /root/entrypoint.sh

# ENTRYPOINT ["sh", "-c", "/root/sentinelMonitor --k8s-master-url=${K8S_API_SERVER} --sentinel-name=${SENTINEL_NAME} --sentinel-addr=${SENTINEL_ADDRS} --sentinel-status=${SENTINEL_STATUS} --namespace=${NAMESPACES} --kubeconfig=${KUBECONFIG} --interval-time=${INTERVAL_TIME}"]
ENTRYPOINT "/root/entrypoint.sh"