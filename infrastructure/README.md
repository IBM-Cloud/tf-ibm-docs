# Terraform IBM Docs Infrastructure

This directory provides infrastructure for the automation components required to automatically build the [IBM-Bluemix/terraform](https://github.com/IBM-Bluemix/terraform) docs from source.

# Why

Unfortunately this was required because Travis was already in place as part of the OSS project (see here: [IBM-Bluemix/terraform/.travis.yml](https://github.com/IBM-Bluemix/terraform/blob/provider/ibm-cloud/.travis.yml)). By altering the existing travis configuration it would cause complications with contributing code changes back upstream (to hashicorp).

# Prerequisites

- Install Bluemix CLI: http://clis.ng.bluemix.net/ui/home.html
- Install Bluemix CS plugin: `bx plugin install container-service -r Bluemix`
- Install Bluemix CR plugin: `bx plugin install container-registry -r Bluemix`
- Install `kubectl` per [IBM Container Service instructions](https://console.ng.bluemix.net/docs/containers/cs_tutorials.html#cs_tutorials)

# How

The following commands are NOT idempotent, therefore they can only be run once; where `$NAME` is your own value. These closely follow https://console.ng.bluemix.net/docs/containers/cs_tutorials.html#cs_tutorials but are trimmed for brevity:

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

# Where

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
