#!/bin/sh

ARCH=$(uname -m)

./sentinelMonitor_${ARCH} --sentinel-name=${SENTINEL_NAME} \
--namespace=${NAMESPACES} \
--sentinel-addr=${SENTINEL_ADDRS} \
--sentinel-status=${SENTINEL_STATUS} \
--kubeconfig=${KUBECONFIG} \
--interval-time=${INTERVAL_TIME} \
--k8s-master-url=${K8S_API_SERVER}
