[![Build Status](https://dev.azure.com/jcorioland-msft/terraform-azure-reference/_apis/build/status/jcorioland.terraform-azure-ref-common-module?branchName=master)](https://dev.azure.com/jcorioland-msft/terraform-azure-reference/_build/latest?definitionId=33&branchName=master)

# Common Terraform Module

This modules is responsible for deploying the common stuff required for the reference archicture for Terraform on Azure. More details can be found on the [main repository](https://github.com/jcorioland/terraform-azure-reference). 

## Usage

```hcl
module "tf-ref-common-module" {
  source                           = "../../"
  location                         = "westeurope"
}
```

## Scenarios

It is part of the reference architecture for Terraform on Azure. More details can be found on the [main repository](https://github.com/jcorioland/terraform-azure-reference). 

## Examples

You can find an example of usage [here](examples/).

## Inputs

```hcl
variable "location" {
  description = "Azure location to use"
}
```

## Outputs

```hcl
output "resource_group_name" {
  value = "${azurerm_resource_group.rg.name}"
}
```

## Run tests

### On your machine

*Note: You need to be authenticated to a valid Azure subscription (using Azure CLI) and have a service principal for the Azure Kubernetes cluster (CLIENT_ID and CLIENT_SECRET)*

```bash
dep ensure
export TF_VAR_service_principal_client_id="<CLIENT_ID>"
export TF_VAR_service_principal_client_secret="<CLIENT_SECRET>"
go test -v ./test/ -timeout 20m
```
