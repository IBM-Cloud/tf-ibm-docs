# Terraform IBM Docs
To pull and build the necessary IBM documentation (contributed by IBM) from https://github.com/IBM-Bluemix/terraform w/o HashiCorp intellectual property, trademark, or copyright concerns.

# Prerequisites

- `git` must be available on the workstation running the script
- XCode command line tools should be available, on OSX run `xcode-select --install`
- Ruby 2.3.0 or higher is required, I recommend using https://rvm.io/ to manage ruby versions & installation
- `bundler` must be available, on OSX run `gem install bundler` after installing Ruby

# Running locally

- Execute `bundle exec middleman server`
- Point a browser at `http://localhost:4567/`

# Building static site

- Execute the `build.sh` script
- Static file will be placed in the `./build` directory
