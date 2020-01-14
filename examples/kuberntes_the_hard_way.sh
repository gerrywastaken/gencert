#!/bin/bash

script_name=$0
script_full_path=$(dirname "$0")
echo $script_full_path

if [ "$script_full_path" != "." ]; then
  echo "This script must be run fron within the \`examples\` directory"
  exit
fi

PATH=$PATH:../bin

gencert ca /CN=KUBERNETES-CA

gencert admin /CN=admin/O=system:masters
gencert kube-controller-manager /CN=system:kube-controller-manager
gencert kube-proxy /CN=system:kube-proxy
gencert kube-scheduler /CN=system:kube-scheduler
gencert service-account /CN=service-accounts

gencert kube-apiserver /CN=kube-apiserver \
  --dns kubernetes \
  --dns kubernetes.default \
  --dns kubernetes.default.svc \
  --dns kubernetes.default.svc.cluster.local \
  --ip 10.96.0.1 \
  --ip 192.168.5.11 \
  --ip 192.168.5.12 \
  --ip 192.168.5.30 \
  --ip 127.0.0.1

gencert etcd-server /CN=etcd-server \
  --ip 192.168.5.11 \
  --ip 192.168.5.12 \
  --ip 127.0.0.1

gencert worker-1 /CN=system:node:worker-1/O=system:nodes \
  --dns worker-1 \
  --ip 192.168.5.21