# Terraform IBM Docs
IBM Cloud Terraform (tm) Provider documentation. See https://ibm-bluemix.github.io/tf-ibm-docs/

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Objective](#objective)
- [Current Release Targets](#current-release-targets)
- [Adding Release Targets](#adding-release-targets)
- [Resource Categories in Side Navigation](#resource-categories-in-side-navigation)
- [Injected Content](#injected-content)
- [Building and Publishing](#building-and-publishing)
  - [Prerequisites](#prerequisites)
  - [Testing locally](#testing-locally)
  - [Building static site](#building-static-site)
  - [Publishing the static site](#publishing-the-static-site)
    - [Automatically](#automatically)
    - [Manually](#manually)
- [Cleanup](#cleanup)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Objective

To provide an alternative theme for the [IBM Terraform fork](https://github.com/IBM-Bluemix/terraform) static site and to automatically generate multiple static sites for all release targets.

# Current Release Targets

The documentation landing page (what is shown when you https://ibm-bluemix.github.io/tf-ibm-docs/) presents the documentation for the latest version of the IBM Cloud Provider.

From https://github.com/IBM-Bluemix/terraform-provider-ibm

# Adding Release Targets

- Modify the [`config.sh`](./config.sh) script `RELEASES` array with the new values.
- Update [`.gitignore`](.gitignore) with the `./source/$VERSION` directory, where `$VERSION` is the value you've added to `config.sh`
- To change the landing page version (what version Schematics uses):
  - Update [`./source/layouts/topnav.erb`](./source/layouts/topnav.erb) variable `LANDING_PAGE_VERSION` at the top of the template.
- Update [`./source/_inject-schematics.md`](./source/_inject-schematics.md) to indicate which version Schematics is using and is being presented to the user on the landing page.

# Resource Categories in Side Navigation

The side navigation contains "categories" or "headings" which group together resources. Items such as "Cloud Foundry Resources" and "Container Data Sources". These categories **ARE NOT** dynamic and must be manually created, updated, or deleted. The code for doing this is contained in [`./source/layouts/sidenav.erb`](./source/layouts/sidenav.erb). Both the inline code block at the top and the array loops inside the HTML will need to be updated.

If a resource doesn't match a defined category, then it will simply be placed under an "Other" heading until one is added.

# Injected Content

For the landing page of each version (including the default as seen at `/index.html`) some content is injected.

For the default landing page this is a "Documentation" section as defined by [`./source/_inject-schematics.md`](./source/_inject-schematics.md) with some additional dynamic markdown generated by `build.sh` at "compile" time.

For the `/<version>/<index>.html` landing pages, this also includes a section about "Developing Locally" as defined by [`./source/_inject-v1.md`](./source/_inject-v1.md).

This can be fraught with failure because of string matching and the underlying documentation changing. Previously we supported two versions, one for the internal provider as the string was different, and one for the external. The string search value, `INJECT_STRING` can be updated in `config.sh`.

# Building and Publishing

The docs are manually built and deployed from a local workstation by executing the [Building static site](#building-static-site) and [Publishing the static site](#publishing-the-static-site) sections. The workstation that meets the requirements in the [Prerequisites](#prerequisites) section.

## Prerequisites

- `git` must be available on the workstation running the script
- `git` must be configured to checkout from both github.com and github.ibm.com (for older documentation)
- `git` must be able to push to https://github.com/IBM-Bluemix/tf-ibm-docs
- For OSX XCode command line tools should be available, on OSX run `xcode-select --install`
- Ruby `2.3.3` or higher is required, I recommend using https://rvm.io/ to manage ruby versions & installation
- `bundler` must be available, on OSX run `gem install bundler` after installing Ruby
- Python `2.7.x` or higher is required to run a local webserver for testing

## Testing locally

- Execute the `./build.sh` script
- Change into the build directory: `cd build`
- Execute `./run.sh` which will start a web server in the build directory
  - Run your favorite lightweight web server, I prefer Python's: `python -m SimpleHTTPServer 8000` but any web server will do
  - You cannot use `bundle exec middleman server` from the parent directory; it will not be inclusive of a number of actions take by the `build.sh` script
- Point a browser at `http://localhost:8000/` or if you ran your own web server connect to it at the appropriate address.
- ctrl+c to kill `./run.sh` when you are done

## Building static site

- Execute the `build.sh` script
- Successful output will look something like:
- Static file will be placed in the `./build` directory
- The `./build` directory will be copied to `./docs` for publishing on GitHub pages (this may be temporary)

## Publishing the static site

### Automatically

Execute the `/.publish.sh` script - this will push everything in the `build` directory to the GitHub branch `gh-pages` on the root directory automatically using your locally configured git credentials.

### Manually

To stage changes or simply to publish manually follow these steps:

- Remove the hack for local development from the build directory: `rm ./build/tf-ibm-docs`
- Copy the `build` directory somewhere outside of the repo, e.g. `cp -R ./build/. ~/tmp/docs`
- Switch to the `gh-pages` branch, or a branch you've started from `gh-pages`; `git checkout gh-pages`
- Copy the copy of the build directory back into the repo at root, e.g. `cp -R ~/tmp/docs/. ./`
- Commit and push your changes

# Cleanup

Each of the scripts cleans up after itself where necessary. However they do leave some artifacts in place for quicker execution on subsequent runs. To insure a fresh and clean build, execute [`cleanup.sh`](./cleanup.sh) prior to execution of `build.sh`.
