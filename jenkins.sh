#!/bin/bash

# Bootstrap script for Jenkins
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

# EXECUTED BY JENKINS AFTER CHECKING OUT https://github.com/IBM-Bluemix/terraform

set -e
PARENT_DIR=$(pwd)

# checkout yourself...
git clone https://github.com/IBM-Bluemix/tf-ibm-docs
cd tf-ibm-docs
bash build.sh
bash publish.sh

exit 0
