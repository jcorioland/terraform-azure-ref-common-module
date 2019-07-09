provider "azuread" {
  version = "~> 0.4"
}

provider "azurerm" {
  version = "~> 1.31"
}

resource "azurerm_resource_group" "rg" {
  name     = "tf-ref-common-rg"
  location = "${var.location}"
}
