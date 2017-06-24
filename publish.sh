#!/bin/bash

# Publishes the output from ./build.sh to GitHub pages
# @Author: Chris Kelner
# Copyright (c) 2017 IBM under MIT License

set -e
PARENT_DIR=$(pwd)
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# remove hack for local docs
if [ -d "./build/tf-ibm-docs" ]; then
  rm ./build/tf-ibm-docs
fi

# need to move to the gh-pages branch
if [ ! -d "~/tmp" ]; then
  mkdir -p ~/tmp
fi
cp -R ./build/. ~/tmp/docs

# switch to gh-pages branch
git checkout gh-pages
# copy docs into parent directory
cp -R ~/tmp/docs/. ./

# push to gh-pages
set +e # allow to continue on error (git exits non-zero when no changes)
git add -A
git commit -m "latest docs"
git push
set -e

# switch back branch
git checkout $GIT_BRANCH

# cleanup
rm -r ~/tmp/docs

# restore small hack to make docs work locally
cd build
ln -s . tf-ibm-docs

exit 0
