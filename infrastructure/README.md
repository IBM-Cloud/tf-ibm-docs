# Terraform IBM Docs Infrastructure

This directory provides infrastructure for the automation components required to automatically build the [IBM-Bluemix/terraform](https://github.com/IBM-Bluemix/terraform) docs from source when changes are made.

# Why

[IBM-Bluemix/terraform](https://github.com/IBM-Bluemix/terraform/) must be monitored, as it is the repository that contains the actual documentation. Therefore we cannot trigger on this repository (alternatively a schedule/timer could be set to pull the IBM-Bluemix/terraform repo periodically; Unfortunately Travis doesn't support periodic builds).

Jenkins was chosen; this was necessary because Travis was already in place as part of the OSS project [IBM-Bluemix/terraform](https://github.com/IBM-Bluemix/terraform/) as seen here: [IBM-Bluemix/terraform/.travis.yml](https://github.com/IBM-Bluemix/terraform/blob/provider/ibm-cloud/.travis.yml)). By altering the existing travis configuration it would cause complications with contributing code changes back upstream (to hashicorp).

# Setup

Steps to create necessary infrastructure for automatically building the Terraform IBM Cloud Provider docs when changes are made to [IBM-Bluemix/terraform](https://github.com/IBM-Bluemix/terraform) branch `provider/ibm-cloud`.

## Prerequisites

- Install Bluemix CLI: http://clis.ng.bluemix.net/ui/home.html
- Install Bluemix CS plugin: `bx plugin install container-service -r Bluemix`
- Install Bluemix CR plugin: `bx plugin install container-registry -r Bluemix`
- Install `kubectl` per [IBM Container Service instructions](https://console.ng.bluemix.net/docs/containers/cs_tutorials.html#cs_tutorials)

## Setup Commands

The following commands are NOT idempotent, therefore they can only be run once; where `$NAME` is your own value (in the case of running infrastructure, we've used `tf-ibm-docs-jenkins`). These closely follow https://console.ng.bluemix.net/docs/containers/cs_tutorials.html#cs_tutorials but are trimmed for brevity:

- `bx login -a https://api.ng.bluemix.net`
- `bx cs init`
- `bx cs cluster-create --name $NAME`
  - Start times vary, mine took almost an hour
  - `watch -n 10 bx cs workers $NAME` until complete
- `bx cs cluster-config $NAME`
  - Run the export command output from the above command
- Start docker, follow instructions Bluemix docs.
  - For me this was: `docker-machine start default` followed by `eval $(docker-machine env default)`.
- Now execute the docker bash script for IBM Containers: `bash ./docker.sh`
- This will start a Jenkins 2 container on IBM's cloud
- Follow the instructions under "Setting Up Jenkins 2.0" [here](https://www.cloudbees.com/blog/get-started-jenkins-20-docker)
  - For the very first step (getting the unlock password) you'll need to take the output from the last command executed by `./docker.sh` and use it in `kubectl exec $OUTPUT cat /var/jenkins_home/secrets/initialAdminPassword`

See [Gaps](#gaps) for remaining setup.

# Where

Currently Jenkins is available at http://169.48.140.31:30173/ - this is a free tier IBM Container so IP is subject to change. Currently http://schematics-jenkins.chriskelner.com:30173/ points here also.

All infrastructure is deployed to:
```
Account:        Chris Kelner's Account (2e9f8848b53515d920f2462cd08eab12)
Org:            Grid
Space:          dev
```

The intention was to deploy to:
```
Account:        Blueprint Test's Account (ffe5dd466dbb6cd5d41da5b4359161fb)
Org:            bpstest@de.ibm.com
Space:          test
```

However I ran into `You are not authorized to perform this action based on your current user role. You must have the Editor role for the cluster in IBM Bluemix Container Service. Contact the account administrator and request the required access. (E0068)` when trying to create clusters.

# Gaps

Currently the plugins, jobs, and git configuration aren't automated for the setup of Jenkins. I spent some significant time on this (several hours) without much luck. Partial to the solution is a secrets management tool (something like Chef w/ encrypted data-bags) but I am without something like it at the moment.

So it will need to be setup manually.

## First Time Admin login

You'll need to run `kubectl exec $PODNAME cat /var/jenkins_home/secrets/initialAdminPassword` - where `$PODNAME` is the name for the active pod output in `kubectl get pods`. You'll use the output from the `exec` command when you navigate your browser to http://schematics-jenkins.chriskelner.com:30173/

## Plugins

During initial setup only select these:

- `Build timeout`
- `Credentials Binding`
- `Timestamper`
- `Workspace Cleanup`
- `Git`
- `Matrix Authorization Strategy Plugin`

After setup, navigate to `Manage Jenkins > Manage Plugins > Available` and install: `GitHub Authentication`

## Configure

- `Manage Jenkins > Configure Global Security > Access Control > Github Authentication Plugin`
  - Here you'll need a custom OAuth application
  - For "Authorization" select "Matrix-based security" and type in the GitHub usernames for users that need access to Jenkins; provide them the appropriate level of permissions by checking the boxes in the table.
- `Manage Jenkins > Configure System > Git` and fill in the info

### Job

Just one job is needed to build and publish the project.

- Create a new job: http://schematics-jenkins.chriskelner.com:30173/newJob
- Make it a freestyle project and give it a name
- Check the "GitHub Project" box and input `https://github.com/IBM-Bluemix/terraform`
- Under "Source Code Management" select `Git` and input `https://github.com/IBM-Bluemix/terraform.git`
  - Under "Branches to build" change the default to `*/provider/ibm-cloud`
- Check the `GitHub hook trigger for GITScm polling` option
- Under "Build" select `Execute Shell`
  - Input: `curl https://raw.githubusercontent.com/IBM-Bluemix/tf-ibm-docs/master/jenkins.sh | bash`
