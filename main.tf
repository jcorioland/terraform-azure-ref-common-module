provider "azurerm" {
  version = "~> 1.39"
}

resource "azurerm_resource_group" "common" {
  name     = "tf-ref-common-rg"
  location = var.location
}

resource "azurerm_key_vault" "common" {
  name                        = "tf-ref-common-kv"
  location                    = azurerm_resource_group.common.location
  resource_group_name         = azurerm_resource_group.common.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id

  sku_name = "standard"
}

resource "azurerm_container_registry" "common" {
  name                = "tfrefcommonacr"
  resource_group_name = azurerm_resource_group.common.name
  location            = azurerm_resource_group.common.location
  sku                 = "Premium"
  admin_enabled       = false
}

