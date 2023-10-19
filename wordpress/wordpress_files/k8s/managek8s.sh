#!/bin/bash

#export KUBECONFIG=kube_config_cluster.yml #copy this file from k8s cluster into the jenkins agent, eg: KUBECONFIG=kube_config_cluster.yml

for file in namespace.yml dbsvc.yml deployment.yml service.yml ingress.yml
do 
    kubectl apply -f $file
done