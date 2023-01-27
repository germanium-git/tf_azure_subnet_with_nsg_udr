module "identity_primary_network" {
  source = "./Modules/VirtualNetwork/"

  location = local.primary_region
  rg_name  = azurerm_resource_group.id_network_rg.name

  spoke_vnet_nsgs = {
    "nsg-01" = {
      name    = "nsg-01"
      rg_name = azurerm_resource_group.id_network_rg.name
      rules = {
        "ssh_rdp_outbound" = {
          name                       = "AllowSshRdpOutbound"
          priority                   = 100
          direction                  = "Outbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_ranges         = ["0-65535"]
          destination_port_ranges    = ["22", "3389"]
          source_address_prefix      = "*"
          destination_address_prefix = "VirtualNetwork"
        },
      }
    },
    "nsg-02" = {
      name    = "nsg-02"
      rg_name = azurerm_resource_group.id_network_rg.name
      rules   = {}
    },
  }

  spoke_vnet_config = {
    "vnet-01" = {
      name          = "vnet-01"
      address_space = ["10.20.2.0/26", ]
      subnets = {
        "snet-01" = {
          name           = "snet-01"
          address_prefix = "10.20.2.0/28"
          nsg_name       = "nsg-01"
          associate_rt   = "udr-01"
        },
        "snet-02" = {
          name           = "snet-02"
          address_prefix = "10.20.2.16/28"
          nsg_name       = "nsg-02"
          associate_rt   = "udr-01"
        },
        "snet-03" = {
          name           = "snet-03"
          address_prefix = "10.20.2.32/28"
          nsg_name       = "nsg-01"
          associate_rt   = "udr-02"
        },
        "snet-04" = {
          name           = "snet-04"
          address_prefix = "10.20.2.48/28"
          nsg_name       = "nsg-02"
          associate_rt   = "udr-02"
        },
      }
    }
  }

  spoke_route_tables = {
    udr-01 = {
      name                          = "udr-01"
      rg_name                       = azurerm_resource_group.id_network_rg.name
      disable_bgp_route_propagation = true

      routes = {
        "route_1" = {
          name           = "DefaultRoute"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "VirtualAppliance"
          next_hop_ip    = "10.20.0.132"
        },
      }
    },
    udr-02 = {
      name                          = "udr-02"
      rg_name                       = azurerm_resource_group.id_network_rg.name
      disable_bgp_route_propagation = true

      routes = {
        "route_1" = {
          name           = "DefaultRoute"
          address_prefix = "0.0.0.0/0"
          next_hop_type  = "VirtualAppliance"
          next_hop_ip    = "10.20.0.132"
        },
      }
    },
  }

  tags = local.tags

}

output "vnet_id" {
  value = module.identity_primary_network.vnet["vnet-01"].id
}

output "vnet" {
  value = module.identity_primary_network.vnet["vnet-01"]
}

output "route_table" {
  value = module.identity_primary_network.route_table["udr-01"]
}

output "subnets" {
  value = module.identity_primary_network.vnet["vnet-01"].subnet
}

output "nw_subnets" {
  value = module.identity_primary_network.nw_subnets
}

output "subnet_ids" {
  value = module.identity_primary_network.subnet_ids
}