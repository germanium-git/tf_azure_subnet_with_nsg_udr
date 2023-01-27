#Declaring variable for Location
variable "location" {
  type = string
}

#Declaring variable for Resource Group
variable "rg_name" {
  type = string
}

#Declaring object for Network Security Groups with all their rules
variable "spoke_vnet_nsgs" {
  type = map(object({
    name    = string
    rg_name = string
    rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_ranges         = list(string)
      destination_port_ranges    = list(string)
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

#Declaring object for Spoke Virtual Network with all its subnets
variable "spoke_vnet_config" {
  type = map(object({
    name          = string
    address_space = list(string)
    subnets = map(object({
      name           = string
      address_prefix = string
      nsg_name       = string
      associate_rt   = string
    }))
  }))
}

#Declaring object for Route Tables with all their routes
variable "spoke_route_tables" {
  type = map(object({
    name                          = string
    rg_name                       = string
    disable_bgp_route_propagation = bool
    routes = map(object({
      name           = string
      address_prefix = string
      next_hop_type  = string
      next_hop_ip    = string
    }))
  }))

}


#Declaring tags for all applicable resources, created with this module
variable "tags" {
  type = object({
        RepositoryPath          = string
        DeploymentMethod        = string
        DeploymentContact       = string
  })
}