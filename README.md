# kind-sample

[kind (Kubernetes IN Docker)](https://kind.sigs.k8s.io/) sample

# usage

## setup

```bash
$ cd /path/to/here

$ ./script/setup.sh
```

<details>

## create cluster

```bash
$ cd /path/to/here

$ kind create cluster --config ./kind/cluster.yaml --name=kind-cluster

# check clusters
$ kind get clusters
kind-cluster
```

## build docker image and load image into kind

```bash
$ docker build -t rackapp-image:1 .
$ kind load docker-image --name kind-cluster rackapp-image:1
```

## apply deployment, service, ingress, ingress-nginx, and wait

```bash
$ kubectl apply -f ./k8s/deployment.yaml -f ./k8s/ingress.yaml -f ./k8s/service.yaml -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

# check pods
$ kubectl get po
NAME                                  READY   STATUS    RESTARTS   AGE
rackapp-deployment-8574cb8767-cm5rx   1/1     Running   0          12m
rackapp-deployment-8574cb8767-fghbd   1/1     Running   0          12m

# check services
$ kubectl get svc
NAME              TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)           AGE
kubernetes        ClusterIP   10.96.0.1     <none>        443/TCP           12m
rackapp-service   NodePort    10.97.15.48   <none>        19292:31336/TCP   12m

# check ingresses
$ kubectl get ing
NAME              CLASS    HOSTS   ADDRESS     PORTS   AGE
rackapp-ingress   <none>   *       localhost   80      12m
```

## create service-account and start dashboard

```bash
$ kubectl apply -f ./k8s/service-account.yaml -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.4/aio/deploy/recommended.yaml

$ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin | awk '{print $1}') | grep -e '^token:' | awk '{print $2}'
eyJhbGciOiJSUzI...

$ kubectl proxy
# open http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
# enter token
```

</details>

## do request

```bash
$ curl -s localhost:50080 | jq '.uuid'
"ce0b3b91-2148-4c77-b083-3565ed99f16a"

$ curl -s localhost:50080 | jq '.uuid'
"45e80546-eb41-4b3e-b21a-1df24aaf0047"
```

## teardown

```bash
$ cd /path/to/here

$ ./script/teardown.sh
```

<details>

## delete all components

```bash
$ kubectl delete -f ./k8s/deployment.yaml -f ./k8s/ingress.yaml -f ./k8s/service.yaml -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

## delete cluster

```bash
$ kind delete cluster --name=kind-cluster
```

</details>
