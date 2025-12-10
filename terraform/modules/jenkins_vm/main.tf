resource "azurerm_virtual_network" "jenkinsVN" {
  name                = "jenkins-network"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_subnet" "jenkinsSubnet" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.jenkinsVN.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_jenkins_ip" {
  name                = "jenkins_public_ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "jenkinsNetworkInterface" {
  name                = "jenkins-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jenkinsSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_jenkins_ip.id
  }
}


resource "azurerm_network_security_group" "jenkins_security_group" {
  name                = "acceptanceTestSecurityGroup1"
  resource_group_name = var.resource_group_name
  location            = var.location

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowJenkinsEntry"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "197.238.0.0/16"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}
resource "azurerm_network_interface_security_group_association" "jenkins_interface_securitygroup_association" {
  network_interface_id      = azurerm_network_interface.jenkinsNetworkInterface.id
  network_security_group_id = azurerm_network_security_group.jenkins_security_group.id
}

resource "azurerm_linux_virtual_machine" "jenkinsVM" {
  name                = "jenkins-machine"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_type
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.jenkinsNetworkInterface.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.public_key_file_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

# this here will try to connect to the machine over ssh
  connection {
    type        = "ssh"
    host        = self.public_ip_address
    user        = "adminuser"
    private_key = file(var.private_key_file_path)
  }
# when the previous step succeeds we go here and now we're ready to run our playbook
  provisioner "remote-exec" {
    inline = ["echo 'VM is ready'"]
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip_address},' ../ansible/playbook.yaml -u adminuser --private-key '${var.private_key_file_path}' --vault-password-file ../ansible/.vault_pass"
  }
}
