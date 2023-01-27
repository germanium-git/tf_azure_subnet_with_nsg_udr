#Declaring object for Route Tables with all their routes
variable "spoke_vnet_rt"    {
    type    =   map(object({
        name    =   string
        location =   string
        rg_name =   string
        routes   =   map(object({
            name            =   string
            address_prefix  =   string
            next_hop        =   string
        }))
    }))
}

#Declaring tags for all applicable resources, created with this module
variable "tags" {
    type    =   object({
        RepositoryPath          = string
        DeploymentMethod        = string
        DeploymentContact       = string
    })
}