#!/bin/bash

# Shell to iteration through releases and do compile/build per release

set -ex
PARENT_DIR=$(pwd)

# Gets configuration for scripts; versions, repo, search strings, etc
source config.sh
source cleansource.sh
source compile.sh
source build.sh

function cleanbuild() {
  if [ -d "./build"]; then
    cd build
    rm tf-ibm-docs
    cd ..
  fi
  
  if [ -d "./terraform" ]; then
    rm -rf ./terraform
  fi

  if [ -d "./build" ]; then
    rm -rf ./build
  fi

  if [ -d "./deploy" ]; then
    rm -rf ./deploy
  fi

  if [ -f "./tmp_version_list.md" ]; then
    rm ./tmp_version_list.md
  fi
}

cleanbuild

if [ ! -d "./deploy" ]; then
    mkdir ./deploy
fi

for release in "${RELEASES[@]}"; do
    cleansource $release
done

for release in "${RELEASES[@]}"; do
    compile $release

    build $release
    cd $PARENT_DIR
    mv build/$release deploy

    cleansource $release
done

# set up build folder homepage

# could not get sed with read file option working in all cases so we inject version list in pieces
cp _resources/_index_1.md source/index.html.markdown
cat tmp_version_list.md >> source/index.html.markdown
cat _resources/_index_2.md >> source/index.html.markdown
build "${LATEST_VERSION}"

for release in "${RELEASES[@]}"; do
    mv deploy/$release build
done


# Small hack to make docs work locally
cd build
ln -s . tf-ibm-docs
cd ..

exit 0

