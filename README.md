# Terraform IBM Docs
To pull and build the necessary IBM documentation (contributed by IBM) from https://github.com/IBM-Bluemix/terraform w/o HashiCorp intellectual property, trademark, or copyright concerns. See https://ibm-bluemix.github.io/tf-ibm-docs/

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
- Successful output will look something like:
```
$ bash build.sh
Cloning into 'terraform'...
remote: Counting objects: 152445, done.
remote: Compressing objects: 100% (76/76), done.
remote: Total 152445 (delta 56), reused 12 (delta 12), pack-reused 152357
Receiving objects: 100% (152445/152445), 97.79 MiB | 9.88 MiB/s, done.
Resolving deltas: 100% (95222/95222), done.
Checking connectivity... done.
Branch provider/ibm-cloud set up to track remote branch provider/ibm-cloud from origin.
Switched to a new branch 'provider/ibm-cloud'
Using concurrent-ruby 1.0.5
Using i18n 0.7.0
...
Using middleman-syntax 2.1.0
Bundle complete! 7 Gemfile dependencies, 46 gems now installed.
== Activating: file_watcher
== Activating: front_matter
...
== Building files
== Request: /d/cf_service_instance.html
...
== Finishing Request: d/cf_account.html (0.01s)
      create  build/d/cf_account.html
Project built successfully.
```
- Static file will be placed in the `./build` directory
- The `./build` directory will be copied to `./docs` for publishing on GitHub pages (this may be temporary)
