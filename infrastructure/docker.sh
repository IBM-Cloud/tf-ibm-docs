#!/bin/bash

# Creates IBM Cluster running Jenkins
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -e
PARENT_DIR=$(pwd)

docker build -t registry.ng.bluemix.net/tf_ibm_docs/jenkins_data -f Dockerfile-data .
docker build -t registry.ng.bluemix.net/tf_ibm_docs/jenkins2 .
docker push registry.ng.bluemix.net/tf_ibm_docs/jenkins_data
docker push registry.ng.bluemix.net/tf_ibm_docs/jenkins2
bx cr images
kubectl run tf-ibm-docs-deployment --image=registry.ng.bluemix.net/tf_ibm_docs/jenkins2
kubectl expose deployment/tf-ibm-docs-deployment --type=NodePort --port=8080 --name=tf-ibm-docs-jenkins
kubectl describe service tf-ibm-docs-jenkins
kubectl get pods

# local
# docker run --name=jenkins-data jenkins-data
# docker run -p 8080:8080 -p 50000:50000 --name=jenkins-master --volumes-from=jenkins-data -d jenkins2

exit 0
