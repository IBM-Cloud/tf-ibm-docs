# Array of releases on https://github.com/IBM-Bluemix/terraform/releases
LEGACYRELEASES=( \
  #"tf-v0.9.3-ibm-provider-v0.1" \
  #"tf-v0.9.3-ibm-k8s-v0.1" \
  #"tf-v0.9.3-ibm-provider-v0.2" \
  "tf-v0.9.3-ibm-provider-v0.2.1" \
  "v0.3-tf-v0.9.3" \
)

RELEASES=( \
  "v0.4.0" \
)

# The version of the provider that schematics is using
SCHEMATICS_VERSION="v0.4.0"

# The repos that contains the terraform docs
LEGACYREPO="https://github.com/IBM-Bluemix/terraform"
REPO="https://github.com/IBM-Bluemix/terraform-provider-ibm"

# String from terraform docs where we inject new markdown
INJECT_STRING="Use the navigation menu on the left to read about the available resources"
