# K8s Remote Access
If you want to access a k8s cluster from a pod you can follow these steps 

- Locate the `.kube` directory on your k8s machine.  
1. On linux/Unix it will be at `/root/.kube`   
2. On windows it will be at `C:/User/<username>/.kube`    
- Copy the config file from the `.kube` folder of the k8s cluster to `.kube` folder of your local machine  
- Copy: client-certificate: `/etc/cfc/conf/kubecfg.crt`  and client-key: `/etc/cfc/conf/kubecfg.key`  to `.kube` folder of your local machine.  

- Edit the config file in the `.kube` folder of your local machine and update the path of the `kubecfg.crt` and `kubecfg.key` on your local machine.  
`/etc/cfc/conf/kubecfg.crt` --> `C:\Users\<username>\.kube\kubecfg.crt`  
`/etc/cfc/conf/kubecfg.key` --> `C:\Users\<username>\.kube\kubecfg.key`  

- Now you should be able to interact with the cluster. Run 'kubectl get pods' and you will see the pods on the k8s cluster.

[Read this SO post](https://stackoverflow.com/questions/36306904/configure-kubectl-command-to-access-remote-kubernetes-cluster-on-azure)
