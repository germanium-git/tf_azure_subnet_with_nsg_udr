locals { 
    primary_region   = "westeurope" 

    tags  = {
        RepositoryPath          = "Platform/Identity"
        DeploymentMethod        = "IaC"
        DeploymentContact       = "tf_admin"
    }

    dns_servers     = []

}