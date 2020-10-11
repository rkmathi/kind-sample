#!/bin/bash -u

KIND_CLUSTER_NAME='kind-cluster'
SCRIPT_PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "${SCRIPT_PWD}/.."

kubectl delete \
  -f ./k8s/deployment.yaml \
  -f ./k8s/ingress.yaml \
  -f ./k8s/service.yaml \
  -f ./k8s/service-account.yaml \
  -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml \
  -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

kind delete cluster --name=${KIND_CLUSTER_NAME}
