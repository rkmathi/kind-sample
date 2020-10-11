#!/bin/bash -u

KIND_CLUSTER_NAME='kind-cluster'
SCRIPT_PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "${SCRIPT_PWD}/.."

kind get clusters | grep ${KIND_CLUSTER_NAME}
if [ $? -ne 0 ]; then
  kind create cluster --config ./kind/cluster.yaml --name=${KIND_CLUSTER_NAME}
fi

docker build -t rackapp-image:1 .

kind load docker-image --name ${KIND_CLUSTER_NAME} rackapp-image:1

kubectl apply \
  -f ./k8s/deployment.yaml \
  -f ./k8s/ingress.yaml \
  -f ./k8s/service.yaml \
  -f ./k8s/service-account.yaml \
  -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml \
  -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin | awk '{print $1}') | grep -e '^token:' | awk '{print $2}'
