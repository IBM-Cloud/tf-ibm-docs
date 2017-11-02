
## Documentation

The documentation presented here is the latest for the [IBM Cloud Schematics](https://console.ng.bluemix.net/docs/services/schematics/index.html) service. At this time Schematics uses version `v0.5.0`. Newer versions may be available for use locally. Please see the available versions of the documentation below.

If you are interested in using the provider with base Terraform see the "Using Terraform with the IBM Cloud Provider" section below.

### Versions
<!-- REPLACEME -->
- [v0.3-tf-v0.9.3](/tf-ibm-docs/v0.3-tf-v0.9.3)
- [tf-v0.9.3-ibm-provider-v0.2.1](/tf-ibm-docs/tf-v0.9.3-ibm-provider-v0.2.1)
- [v0.4.0](/tf-ibm-docs/v0.4.0)
- [v0.5.0](/tf-ibm-docs/v0.5.0)
- [v0.5.1](/tf-ibm-docs/v0.5.1)

## Using Terraform with the IBM Cloud Provider

If you want to run terraform locally on your system, complete the following steps:

1. <a href="https://www.terraform.io/intro/getting-started/install.html">Download and install Terraform for your system. <i class="fa fa-external-link" alt="External link icon"></i></a>

2. <a href="https://github.com/IBM-Bluemix/terraform-provider-ibm/releases">Download the Terraform binary for the IBM Cloud provider. <i class="fa fa-external-link" alt="External link icon"></i></a>

3. Create a `.terraformrc` file that points to the Terraform binary.

    In the following example, `/opt/provider/terraform-provider-ibm` is the route to the directory.

      ```
        # ~/.terraformrc
        providers {
            ibm = "/opt/provider/terraform-provider-ibm"
        }
      ```

4. Configure the plug-in provider and your IBM credentials to work with Terraform.

    To provide your credentials as environment variables, you can use the following code in your `.tf` file.

      ```hcl
        provider "ibm" {
          bluemix_api_key    = "${var.ibm_bx_api_key}"
          softlayer_username = "${var.ibm_sl_username}"
          softlayer_api_key  = "${var.ibm_sl_api_key}"
        }
      ```

    Be sure to also define these variables in your `.tf` files:

      ```hcl
        variable ibm_bx_api_key {}
        variable ibm_sl_username {}
        variable ibm_sl_api_key {}
      ```

    You can then export your credentials in your terminal, where `$VALUE` is your credential.

      ```bash
        export TF_VAR_ibm_bx_api_key="$VALUE"
        export TF_VAR_ibm_sl_username="$VALUE"
        export TF_VAR_ibm_sl_api_key="$VALUE"
      ```
