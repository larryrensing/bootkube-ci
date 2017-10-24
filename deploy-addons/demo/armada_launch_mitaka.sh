#!/bin/bash

set -x
source ../../.bootkube_env
USER=$(whoami)
sudo mv ${HOME}/.kube/config ${HOME}/

### Create Valid Kubernetes User Config:
sudo kubectl config set-cluster local --server=https://${KUBE_MASTER}:${KUBE_SVC_PORT} --certificate-authority=${BOOTKUBE_DIR}/.bootkube/tls/ca.crt
sudo kubectl config set-context default --cluster=local --user=kubelet
sudo kubectl config use-context default
sudo kubectl config set-credentials kubelet --client-certificate=${BOOTKUBE_DIR}/.bootkube/tls/kubelet.crt  --client-key=${BOOTKUBE_DIR}/.bootkube/tls/kubelet.key
sudo chown -R ${USER} ${HOME}/.kube

sudo chmod 755 $HOME/.kube/config
sudo chmod 755 $BOOTKUBE_DIR/.bootkube/tls/*

echo 'Launching OSH using Armada'

sudo docker run -d --net host \
  --name armada  \
  -v ~/.bootkube/tls:/.bootkube/tls \
  -v ~/.kube/config:/armada/.kube/config \
  -v $BOOTKUBE_DIR/bootkube-ci/deploy-addons/demo:/examples \
  -v /home/dev/.bootkube/tls:/home/dev/.bootkube/tls \
  quay.io/attcomdev/armada:latest || true

sudo docker exec armada armada tiller --status 
sudo docker exec armada armada apply /examples/mitaka-armada-osh.yaml
