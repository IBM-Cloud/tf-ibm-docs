#!/bin/bash

# Bootstrap script for Jenkins
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

# EXECUTED BY JENKINS AFTER CHECKING OUT https://github.com/IBM-Bluemix/terraform

set -ex
PARENT_DIR=$(pwd)

# checkout yourself...
if [ ! -d "tf-ibm-docs" ]; then
  git clone https://github.com/IBM-Bluemix/tf-ibm-docs
fi

cd tf-ibm-docs
git pull

bash build.sh
bash publish.sh

exit 0
