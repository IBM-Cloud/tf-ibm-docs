
## Developing locally using the IBM Cloud Provider v0.4.x

If you want to develop locally on your system, complete the following steps:

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
