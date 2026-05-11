# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azure_region_lookup" {
  source = "github.com/POps-Rox/terraform-az-overlays-azregionslookup"

  azure_region = var.location
}

resource "azurerm_resource_group" "datafactory_rg" {
  name     = "rg-datafactory"
  location = module.mod_azure_region_lookup.location_cli
}

resource "azurerm_virtual_network" "datafactory_vnet" {
  name                = "vnet-datafactory"
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = azurerm_resource_group.datafactory_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "datafactory_subnet" {
  name                                          = "snet-datafactory"
  resource_group_name                           = azurerm_resource_group.datafactory_rg.name
  virtual_network_name                          = azurerm_virtual_network.datafactory_vnet.name
  address_prefixes                              = ["10.0.2.0/24"]
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = false
}


