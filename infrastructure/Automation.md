**This documentation was lifted from the main README.md - kept for posterity**

## Automated

A Jenkins job, hosted at http://schematics-jenkins.chriskelner.com:30173/ using IBM Container free-tier (see [./infrastructure](infrastructure) for details) executes when pushes are made to the [IBM Terraform fork](https://github.com/IBM-Bluemix/terraform) branch `provider/ibm-cloud` via GitHub webhook:

![webhook-screenshot](./images/webhook.png)

`./build.sh` and `./publish.sh` scripts

### Gaining Access

Contact Chris Kelner via an authenticated means (IBM channels) to get access to the Jenkins server.
