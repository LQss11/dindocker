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

