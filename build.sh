#!/bin/bash

set -ex

function build() {
  export IBM_CLOUD_PROVIDER_VERSION=$1
  
  bundle install
  bundle exec middleman build --clean --verbose
}
