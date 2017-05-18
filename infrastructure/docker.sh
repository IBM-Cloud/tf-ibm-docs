#!/bin/bash

# Creates IBM Cluster running Jenkins
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -ex
PARENT_DIR=$(pwd)
TIMESTAMP=$(date +%s)

# build and push image
docker build -t registry.ng.bluemix.net/tf_ibm_docs/jenkins2:$TIMESTAMP .
bx cr images
docker push registry.ng.bluemix.net/tf_ibm_docs/jenkins2:$TIMESTAMP
bx cr images

kubectl get rs

# one time setup of deployment
set +x
set +e # this can only be successful the first run
set -x

kubectl run tf-ibm-docs-deployment --image=registry.ng.bluemix.net/tf_ibm_docs/jenkins2:$TIMESTAMP
kubectl expose deployment/tf-ibm-docs-deployment --type=NodePort --port=8080 --name=tf-ibm-docs-jenkins

set +x
set -e
set -x

# update image on deployment
kubectl set image deployment/tf-ibm-docs-deployment tf-ibm-docs-deployment=registry.ng.bluemix.net/tf_ibm_docs/jenkins2:$TIMESTAMP

# show info about deploy
kubectl get deployments
kubectl get rs
kubectl describe service tf-ibm-docs-jenkins
kubectl get pods --show-labels

exit 0
