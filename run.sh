#!/bin/bash

# Runs the "compiled" website locally using Python
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -e
PARENT_DIR=$(pwd)

echo "*********************************************************"
echo "SITE IS AVAILABLE AT http://localhost:8000"
echo "*********************************************************"

python -m SimpleHTTPServer 8000

exit 0
