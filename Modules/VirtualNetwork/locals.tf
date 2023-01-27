locals { 
    network_subnets = flatten([
        for network_key, network in var.spoke_vnet_config: [
            for subnet_key, subnet in network.subnets: {
                network_key     = network_key
                subnet_key      = subnet_key
                subnet_name     = subnet.name
                subnet_prefix   = subnet.address_prefix
                #subnet_id       = azurerm_virtual_network.identity_spoke_vnet[network_key].subnet
                nsg_name        = subnet.nsg_name
                nsg_id          = azurerm_network_security_group.identity_nsg[subnet.nsg_name].id
                associate_rt    = subnet.associate_rt
                rt_id           = azurerm_route_table.identity_spoke_rt[subnet.associate_rt].id
            }
        ]
    ])

    subnet_ids = flatten([
        for network_key, network in var.spoke_vnet_config: {
            for subnet in azurerm_virtual_network.identity_spoke_vnet[network_key].subnet: subnet.name => subnet.id
        }
    ])

}

