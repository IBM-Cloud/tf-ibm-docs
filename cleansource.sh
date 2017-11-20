#!/bin/bash

# cleanup
# MIT License

set -ex

#
# $1 is version
#
function cleansource() {
  if [ -d "./source/$1" ]; then
    rm -rf ./source/$1
  fi

  if [ -d "./source/r" ]; then
    rm -r ./source/r
  fi

  if [ -d "./source/d" ]; then
    rm -r ./source/d
  fi

  if [ -f "./source/index.html.markdown" ]; then
    rm ./source/index.html.markdown
  fi

  if [ -f "./source/_versions.md" ]; then
    rm ./source/_versions.md
  fi
}
