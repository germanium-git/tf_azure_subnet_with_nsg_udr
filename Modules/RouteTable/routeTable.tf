resource "azurerm_route_table" "temc_identity_spoke_vnet_subnet_rts" {
  for_each                      = var.spoke_vnet_rt

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.rg_name
  disable_bgp_route_propagation = true

  dynamic "route" {
      for_each = each.value.routes

      content {
          name                      =   route.value.name
          address_prefix            =   route.value.address_prefix
          next_hop_type             =   "VirtualAppliance"
          next_hop_in_ip_address    =   route.value.next_hop
      }
  }

  lifecycle {
    ignore_changes = [
      location
    ]
  }

  tags = var.tags
}

output "readiness_check" {
  value = azurerm_route_table.temc_identity_spoke_vnet_subnet_rts
}