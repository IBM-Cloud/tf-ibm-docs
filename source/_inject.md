
## Developing locally

If you want to develop locally on your system, complete the following steps:

1. <a href="https://www.terraform.io/intro/getting-started/install.html">Download and install Terraform for your system. <i class="fa fa-external-link" alt="External link icon"></i></a>

2. <a href="https://github.com/IBM-Bluemix/terraform/releases">Download the Terraform binary for the IBM Cloud provider. <i class="fa fa-external-link" alt="External link icon"></i></a>

3. Create a `.terraformrc` file that points to the Terraform binary.

    In the following example, `/opt/provider/terraform-provider-ibmcloud` is the route to the directory.

      ```
        # ~/.terraformrc
        providers {
            ibmcloud = "/opt/provider/terraform-provider-ibmcloud"
        }
      ```

4. Configure the plug-in provider and your IBM credentials to work with Terraform.

    To provide your credentials as environment variables, you can use the following code in your `.tf` file.

      ```hcl
        provider "ibmcloud" {
            ibmid = "${var.ibmid}"
            ibmid_password = "${var.ibmidpw}"
        }
      ```

    Be sure to also define these variables in your `.tf` files:

      ```hcl
        variable ibmid {}
        variable ibmidpw {}
      ```

    You can then export your credentials in your terminal, where `$VALUE` is your credential.

      ```bash
        export TF_VAR_ibmid="$VALUE"
        export TF_VAR_ibmidpw="$VALUE"
      ```
