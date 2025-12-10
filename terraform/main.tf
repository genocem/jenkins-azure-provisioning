
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "res_group_jenkins" {
  name     = "jenkinsNew"
  location = "France Central"
}


module "jenkins_vm" {
  source              = "./modules/jenkins_vm"
  location            = azurerm_resource_group.res_group_jenkins.location
  resource_group_name = azurerm_resource_group.res_group_jenkins.name
  private_key_file_path = "~/.ssh/id_rsa"
  public_key_file_path  = "~/.ssh/id_rsa.pub"
  vm_type = "Standard_B2als_v2"
}

#for stronger machine we can use Standard_D2s_v3 or smth else
