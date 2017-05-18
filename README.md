# Terraform IBM Docs
IBM Cloud Terraform (tm) Provider documentation. See https://ibm-bluemix.github.io/tf-ibm-docs/

# Objective

To provide an alternative theme for the [IBM Terraform fork](https://github.com/IBM-Bluemix/terraform) static site and to automatically generate the static site when there are changes to the fork in the `provider/ibm-cloud` branch.

# Execution
## Manual

The docs can be manually built and deployed by executing the [Building static site](#building-static-site) and [Publishing the static site](#publishing-the-static-site) sections found in this Readme. Must be done from a workstation that meets the requirements in the [Prerequisites](#prerequisites) section.

## Prerequisites

- `git` must be available on the workstation running the script
- `git` must be configured to checkout from both github.com and github.ibm.com (for older documentation)
- `git` must be able to push to https://github.com/IBM-Bluemix/tf-ibm-docs
- For OSX XCode command line tools should be available, on OSX run `xcode-select --install`
- Ruby 2.3.0 or higher is required, I recommend using https://rvm.io/ to manage ruby versions & installation
- `bundler` must be available, on OSX run `gem install bundler` after installing Ruby

## Running locally

- Execute the `./build.sh` script
- Execute `bundle exec middleman server`
- Point a browser at `http://localhost:4567/`

### Building static site

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

### Publishing the static site

- Execute the `/.publish.sh` script - this will push to GitHub
- Successful output will look similar to:
```
Switched to branch 'gh-pages'
Your branch is up-to-date with 'origin/gh-pages'.
[gh-pages c6dbf0e] latest docs
 2 files changed, 60 insertions(+)
 create mode 100644 _inject_developing-locally.md
Counting objects: 4, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 1.15 KiB | 0 bytes/s, done.
Total 4 (delta 3), reused 0 (delta 0)
remote: Resolving deltas: 100% (3/3), completed with 2 local objects.
To https://github.com/IBM-Bluemix/tf-ibm-docs.git
   ca2dec0..c6dbf0e  gh-pages -> gh-pages
Switched to branch 'master'
Your branch is up-to-date with 'origin/master'.
```
