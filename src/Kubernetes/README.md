## Setup minikube
Once the containers starts all you need to do is:

Login as the newly created user:
```sh
su - ${USERNAME}
```

then to give it permissions so it wouldn't download minikube image each time:
```sh
sudo chown -R ${USERNAME} /home/${USERNAME}/.minikube; chmod -R u+wrx /home/${USERNAME}/.minikube
```
then run:
```sh
minikube start
```

in case there s an error while starting run `minikube delete` then `minikube start`

Now to setup let's say for example minikube dashboard and map it at port 80 (make sure port enabled in the dockerfile mapping):
```sh
nohup kubectl proxy --address='0.0.0.0' --port=80 --disable-filter=true &
minikube dashboard --port='80'
```
once everything is done you can visit this url on your host machine to see that container's minikube dashboard through browser:
```
http://127.0.0.1:30080/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=default
```
>As you can see we are going to visit port 30080 which we have already mapped to port 80 as you can refer to through our **docker-compose.yaml** file

## FULL COMMAND
```sh
USERNAME=user
su - ${USERNAME}
USERNAME=lqss &&\
sudo chown -R ${USERNAME} /home/${USERNAME}/.minikube; chmod -R u+wrx /home/${USERNAME}/.minikube &&\
minikube delete &&\
minikube start &&\
nohup kubectl proxy --address='0.0.0.0' --port=81 --disable-filter=true & &&
nohup minikube dashboard --port='81' &
```