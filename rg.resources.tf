resource "azurerm_resource_group" "id_network_rg" {

  name     = "rg-vnet-test"
  location = local.primary_region
  tags     = local.tags
}
