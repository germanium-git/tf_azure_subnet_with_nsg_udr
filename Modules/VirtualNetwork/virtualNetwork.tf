resource "azurerm_network_security_group" "identity_nsg" {
  for_each = var.spoke_vnet_nsgs

  name                = each.value.name
  location            = var.location
  resource_group_name = var.rg_name

  dynamic "security_rule" {
    for_each = each.value.rules

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_ranges         = security_rule.value.source_port_ranges
      destination_port_ranges    = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      location
    ]
  }
}


resource "azurerm_virtual_network" "identity_spoke_vnet" {
  for_each = var.spoke_vnet_config
  
  name                = each.value.name
  location            = var.location
  resource_group_name = var.rg_name
  address_space       = each.value.address_space

  dynamic "subnet" {
    for_each = each.value.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
      security_group = azurerm_network_security_group.identity_nsg[subnet.value.nsg_name].id
      }
    }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      location
    ]
  }
}



resource "azurerm_route_table" "identity_spoke_rt" {
  
    for_each = var.spoke_route_tables

      name                          = each.value.name
      location                      = var.location
      resource_group_name           = var.rg_name
      disable_bgp_route_propagation = each.value.disable_bgp_route_propagation

      dynamic "route" {
        for_each = each.value.routes

        content {
          name                   = route.value.name
          address_prefix         = route.value.address_prefix
          next_hop_type          = route.value.next_hop_type
          next_hop_in_ip_address = route.value.next_hop_ip
        }
      }

      tags = var.tags

      lifecycle {
        ignore_changes = [
          location
        ]
      }  
}



resource "azurerm_subnet_route_table_association" "identity_spoke_subnet_rts" {
  for_each = { for x in local.network_subnets: x.subnet_name => x }
    
    subnet_id = local.subnet_ids[0][each.value.subnet_name]
    route_table_id = each.value.rt_id

}


output "vnet" {
  value = azurerm_virtual_network.identity_spoke_vnet
}

output "route_table" {
  value = azurerm_route_table.identity_spoke_rt
}

output "readiness_check" {
  value = azurerm_virtual_network.identity_spoke_vnet
}

# Output - For Loop Two Inputs and Map Output with Iterator env and VNET Name
output "vnet_map_two_inputs" {
  description = "Virutal Network Name"
  value = {for env, vnet in azurerm_virtual_network.identity_spoke_vnet: env => vnet.name}
}


output "nw_subnets" {
  value = local.network_subnets
}

output "subnet_ids" {
  value = local.subnet_ids[0]
}
