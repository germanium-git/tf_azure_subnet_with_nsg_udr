# Azure subnets having NSG and UDR assigned by terraform

## Use-case

In case, when there's a policy in Azure requiring an NSG must be assigned to each subnet the deployment may fail.

If both resources **azurerm_virtual_network** and **azurerm_subnet_network_security_group_association** are created separately then it may happen that the policy prevents the subnet from being created and the deploymnet fails even before it would continue with creating the NSG association.

With the code from this repository both vnet and respective subnets are created within the resource called **azurerm_virtual_network**.
