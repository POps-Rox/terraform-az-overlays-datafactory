mock_provider "azurerm" {
  mock_data "azurerm_resource_group" {
    defaults = {
      id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing"
      name     = "rg-existing"
      location = "eastus"
    }
  }

  mock_data "azurerm_virtual_network" {
    defaults = {
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Network/virtualNetworks/vnet-existing"
      name = "vnet-existing"
    }
  }

  mock_data "azurerm_subnet" {
    defaults = {
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Network/virtualNetworks/vnet-existing/subnets/snet-private"
      name = "snet-private"
    }
  }

  mock_data "azurerm_private_endpoint_connection" {
    defaults = {
      private_service_connection = [
        {
          private_ip_address = "10.1.2.3"
        }
      ]
    }
  }

  mock_data "azurerm_private_dns_zone" {
    defaults = {
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Network/privateDnsZones/existing.datafactory.azure.net"
      name = "existing.datafactory.azure.net"
    }
  }

  mock_resource "azurerm_private_dns_zone" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Network/privateDnsZones/generated.datafactory.azure.net"
    }
  }

  mock_resource "azurerm_data_factory" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.DataFactory/factories/generated-adf"
    }
  }
}

mock_provider "popsrox" {
  mock_data "popsrox_resource_name" {
    defaults = {
      result = "Generated-Adf"
    }
  }
}

mock_provider "azapi" {}

run "custom_data_factory_name_overrides_generated_name" {
  command = plan

  variables {
    location                     = "eastus"
    environment                  = "public"
    deploy_environment           = "dev"
    workload_name                = "data"
    org_name                     = "contoso"
    existing_resource_group_name = "rg-existing"
    custom_data_factory_name     = "custom-adf"
    identity_type                = null
  }

  assert {
    condition     = azurerm_data_factory.main_data_factory.name == "custom-adf"
    error_message = "custom_data_factory_name must take precedence over the generated provider name."
  }
}

run "empty_custom_data_factory_name_falls_back_to_generated_name" {
  command = plan

  variables {
    location                     = "eastus"
    environment                  = "public"
    deploy_environment           = "dev"
    workload_name                = "data"
    org_name                     = "contoso"
    existing_resource_group_name = "rg-existing"
    custom_data_factory_name     = ""
    identity_type                = null
  }

  assert {
    condition     = azurerm_data_factory.main_data_factory.name == "generated-adf"
    error_message = "An empty custom_data_factory_name must fall through to the generated lowercase name."
  }
}

run "data_factory_location_and_tags_are_applied" {
  command = plan

  variables {
    location                     = "eastus"
    environment                  = "public"
    deploy_environment           = "dev"
    workload_name                = "data"
    org_name                     = "contoso"
    existing_resource_group_name = "rg-existing"
    add_tags = {
      owner      = "platform"
      costCenter = "1234"
    }
    identity_type = null
  }

  assert {
    condition     = azurerm_data_factory.main_data_factory.location == "eastus"
    error_message = "Data Factory location must pass through the resolved resource-group location."
  }

  assert {
    condition     = azurerm_data_factory.main_data_factory.tags["deployedBy"] == "AzureNoOpsTF [default]" && azurerm_data_factory.main_data_factory.tags["env"] == "dev" && azurerm_data_factory.main_data_factory.tags["workload"] == "data" && azurerm_data_factory.main_data_factory.tags["owner"] == "platform" && azurerm_data_factory.main_data_factory.tags["costCenter"] == "1234"
    error_message = "Data Factory tags must merge default tags with caller-supplied add_tags."
  }
}

run "optional_resources_are_disabled_by_default" {
  command = plan

  variables {
    location                     = "eastus"
    environment                  = "public"
    deploy_environment           = "dev"
    workload_name                = "data"
    org_name                     = "contoso"
    existing_resource_group_name = "rg-existing"
    identity_type                = null
  }

  assert {
    condition     = length(azurerm_private_endpoint.pep) == 0 && length(azurerm_private_dns_zone.dns_zone) == 0 && length(azurerm_private_dns_zone_virtual_network_link.vnet_link) == 0 && length(azurerm_private_dns_a_record.a_rec) == 0
    error_message = "Private endpoint resources must not be planned when enable_private_endpoint is false."
  }

  assert {
    condition     = length(azurerm_management_lock.resource_group_level_lock) == 0 && length(azurerm_management_lock.data_factory_level_lock) == 0
    error_message = "Management locks must not be planned when enable_resource_locks is false."
  }
}

run "optional_resources_are_enabled_when_requested" {
  command = apply

  variables {
    location                      = "eastus"
    environment                   = "public"
    deploy_environment            = "dev"
    workload_name                 = "data"
    org_name                      = "contoso"
    existing_resource_group_name  = "rg-existing"
    enable_private_endpoint       = true
    existing_virtual_network_name = "vnet-existing"
    existing_private_subnet_name  = "snet-private"
    enable_resource_locks         = true
    identity_type                 = null
  }

  assert {
    condition     = length(azurerm_private_endpoint.pep) == 1 && length(azurerm_private_dns_zone.dns_zone) == 1 && length(azurerm_private_dns_zone_virtual_network_link.vnet_link) == 1 && length(azurerm_private_dns_a_record.a_rec) == 1
    error_message = "Private endpoint resources must be planned when enable_private_endpoint is true."
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.vnet_link[0].private_dns_zone_id == azurerm_private_dns_zone.dns_zone[0].id && azurerm_private_dns_a_record.a_rec[0].private_dns_zone_id == azurerm_private_dns_zone.dns_zone[0].id
    error_message = "Private DNS link and A record must use azurerm 5.x private_dns_zone_id values."
  }

  assert {
    condition     = length(azurerm_management_lock.resource_group_level_lock) == 1 && length(azurerm_management_lock.data_factory_level_lock) == 1
    error_message = "Management locks must be planned when enable_resource_locks is true."
  }
}
