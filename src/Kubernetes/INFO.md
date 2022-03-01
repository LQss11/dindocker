StatefulSet: used to replicate multiple db instances (pods) between multiple nodes.
DeamonSet: used for loggers or kube-proxy as an example to be deployed on each node of the cluster (if a node added a new one will be deployed) this is same as global deployment.

Kube-proxy: follow requests from pods to services (example my app pod sends to mongo-service to store data)
Kubelet: connects between container runtime and the node

In a master node we can find all these:
- Api server : get request from client and then decide what to do (should have the right credentials)
- Scheduler: Scheduel pods to start by knowing which node has most free resources then kubectl start the pod
- controller manager: get stats of each node if one is down for example it tells the scheduler to reschedule the pod
- etcd: have all data about cluster and without it none of the above would work properly

with multiple master nodes **API server** is load balanced and **etcd** storage is distributed

Once the cluster setup and ready all configs and certs are located in `/etc/kubernetes`.

Running `kubectl get node` will not give you the current nodes used in the cluster so in order to do that we will need to be authenticated through a cert or token which is located in the `/etc/kubernetes/admin.conf` which is the cluster config.

```sh
sudo kubectl get node --kubeconfig /etc/kubernetes/admin.conf
```
or you can simply setup the conf param once without having to specify it each time
```sh
export KUBECONFIG=/etc/kubernetes/admin.conf
sudo kubectl get node
```


