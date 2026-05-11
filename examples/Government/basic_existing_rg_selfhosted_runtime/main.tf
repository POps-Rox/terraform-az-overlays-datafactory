# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


module "data_factory" {
  #source = "github.com/POps-Rox/terraform-az-overlays-datafactory"  
  #version = "x.x.x"  
  source = "../../.."

  depends_on = [azurerm_resource_group.datafactory_rg]

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_data_factory_resource_group = false." The location of the group 
  # will remain the same if you use the current resource.
  existing_resource_group_name = azurerm_resource_group.datafactory_rg.name
  location                     = module.mod_azure_region_lookup.location_cli
  environment                  = var.environment
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  workload_name                = var.workload_name

  # This is the configuration for the Self Hosted Integration Runtime
  # THis runtime allows private endpoints to be used for data sources
  selfhosted_integration_runtime = {}

  # This is the private endpoint configuration for the Self Hosted Integration Runtime
  # This private endpoint will create a privste dns zone and a private dns record since
  # the private dns zone is not already created.
  enable_private_endpoint       = true
  existing_virtual_network_name = azurerm_virtual_network.datafactory_vnet.name
  existing_private_subnet_name  = azurerm_subnet.datafactory_subnet.name
}
