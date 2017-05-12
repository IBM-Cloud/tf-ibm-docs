---
layout: "ibmcloud"
page_title: "Provider: IBM Cloud"
sidebar_current: "docs-ibmcloud-index"
description: |-
  The IBM Cloud provider is used to interact with IBM Cloud resources.
---

# IBM Cloud Provider

The IBM Cloud provider is used to manage IBM Cloud resources. The provider needs to be configured with the proper credentials before it can be used.

Use the navigation menu on the left to read about the available resources.


## Example Usage

Here is an example that sets up the following resources:

+ An SSH key.
+ A virtual server that uses an existing SSH key.
+ A virtual server that uses an existing SSH key and a Terraform-managed SSH key (created as `test_key_1` in the example below).

Add the following code to a file called `sl.tf` and run the `terraform` command from the same directory:

```hcl
# Configure the IBM Cloud Provider
provider "ibmcloud" {
    ibmid = "${var.ibmcloud_bmx_user}"
    ibmid_password = "${var.ibmcloud_bmx_pass}"
}

# Create an SSH key. The SSH key surfaces in the SoftLayer console under Devices > Manage > SSH Keys.
resource "ibmcloud_infra_ssh_key" "test_key_1" {
    label = "test_key_1"
    public_key = "${file(\"~/.ssh/id_rsa_test_key_1.pub\")}"
    # Windows example:
    # public_key = "${file(\"C:\ssh\keys\path\id_rsa_test_key_1.pub\")}"
}

# Virtual server created with existing SSH key in SoftLayer \
# Inventory not created using this Terraform template.
resource "ibmcloud_infra_virtual_guest" "my_server_1" {
    hostname = "host-a.example.com"
    domain = "example.com"
    ssh_key_ids = [123456]
    os_reference_code = "DEBIAN_7_64"
    datacenter = "ams01"
    network_speed = 10
    cores = 1
    memory = 1024
}

# Virtual server created with both previously-existing and \
# Terraform-managed resources.
resource "ibmcloud_infra_virtual_guest" "my_server_2" {
    hostname = "host-b.example.com"
    domain = "example.com"
    ssh_keys = [123456, "${ibmcloud_infra_ssh_key.test_key_1.id}"]
    os_reference_code = "CENTOS_6_64"
    datacenter = "ams01"
    network_speed = 10
    cores = 1
    memory = 1024
}
```

## Authentication

The IBM Cloud provider offers a flexible means of providing credentials for authentication. The following methods are supported, in this order, and explained below:

- Static credentials
- Environment variables

### Static credentials ###

Static credentials can be provided by adding an `ibmid` and `ibmid_password` in-line in the IBM Cloud provider block:

Usage:

```
provider "ibmcloud" {
    ibmid = ""
    ibmid_password = ""
}
```


### Environment variables

You can provide your credentials via the `IBMID` and `IBMID_PASSWORD` environment variables, representing your IBM ID, IBM ID password respectively.  

```
provider "ibmcloud" {}
```

Usage:

```
$ export IBMID="ibmid"
$ export IBMID_PASSWORD="password"
$ terraform plan
```

## Argument Reference

The following arguments are supported in the `provider` block:

* `ibmid` - (Optional) The IBM ID used to log into IBM services and applications. The IBM ID must be provided, but it can also be sourced from the `IBMID` environment variable.

* `ibmid_password` - (Optional) The password for the IBM ID. The password must be provided, but it can also be sourced from the `IBMID_PASSWORD` environment variable.

* `region` - (Optional) The Bluemix region. It can also be sourced from the `BM_REGION` or `BLUEMIX_REGION` environment variable. The former variable has higher precedence. Default value: `us-south`.

* `softlayer_timeout` - (Optional) The timeout, expressed in seconds, for the SoftLayer API. It can also be sourced from the `SL_TIMEOUT`  or `SOFTLAYER_TIMEOUT` environment variable. The former variable has higher precedence. Default value: `60`.

* `bluemix_timeout` - (Optional) The timeout, expressed in seconds, for the Bluemix API. It can also be sourced from the `BM_TIMEOUT`  or `BLUEMIX_TIMEOUT` environment variable. The former variable has higher precedence. Default value: `60`.

* `softlayer_account_number` - (Optional) The SoftLayer account number. It can also be sourced from the `SL_ACCOUNT_NUMBER`  or `SOFTLAYER_ACCOUNT_NUMBER` environment variable. The former variable has higher precedence.
Currently, the provider accepts only account numbers for which 2FA is not enabled.
If the account number is not provided, the provider works with the default SoftLayer account number and resources are created with the same default account.
