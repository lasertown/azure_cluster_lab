resource "azurerm_availability_set" "nfs" {
  name                = "nfs"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  platform_fault_domain_count = "2"
}

# Create network interfaces
resource "azurerm_network_interface" "nfs-0" {
    name                      = "nfs-0"
    location                  = var.region
    resource_group_name       = azurerm_resource_group.example.name

    ip_configuration {
        name                          = "nfs-0-private"
        subnet_id                     = azurerm_subnet.example.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.0.6"
        primary                       = "true"
    }
}
resource "azurerm_network_interface" "nfs-1" {
    name                      = "nfs-1"
    location                  = var.region
    resource_group_name       = azurerm_resource_group.example.name

    ip_configuration {
        name                          = "nfs-1-private"
        subnet_id                     = azurerm_subnet.example.id
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.0.0.7"
        primary                       = "true"
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nfs-0" {
    network_interface_id      = azurerm_network_interface.nfs-0.id
    network_security_group_id = azurerm_network_security_group.ssh.id
}
resource "azurerm_network_interface_security_group_association" "nfs-1" {
    network_interface_id      = azurerm_network_interface.nfs-1.id
    network_security_group_id = azurerm_network_security_group.ssh.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "nfs-0" {
    name                  = "nfs-0"
    location              = var.region
    resource_group_name   = azurerm_resource_group.example.name
    network_interface_ids = [azurerm_network_interface.nfs-0.id]
    size                  = "Standard_DS2_v2"

    os_disk {
        name              = "nfs-0"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
        disk_size_gb      = "100"
    }

    source_image_reference {
        publisher = var.publisher
        offer     = var.offer
        sku       = var.sku
        version   = var._version
    }

    computer_name  = "nfs-0"
    availability_set_id = azurerm_availability_set.nfs.id
    admin_username = "azureadmin"
#    custom_data    = file("<path/to/file>")

    admin_ssh_key {
        username       = "azureadmin"
        public_key     = file("~/.ssh/lab_rsa.pub")
    }
}

resource "azurerm_managed_disk" "nfs-0a" {
  name                 = "${azurerm_linux_virtual_machine.nfs-0.name}-disk1a"
  location             = var.region
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}
resource "azurerm_virtual_machine_data_disk_attachment" "nfs-0a" {
  managed_disk_id    = azurerm_managed_disk.nfs-0a.id
  virtual_machine_id = azurerm_linux_virtual_machine.nfs-0.id
  lun                = "0"
  caching            = "ReadWrite"
}

resource "azurerm_managed_disk" "nfs-0b" {
  name                 = "${azurerm_linux_virtual_machine.nfs-0.name}-disk1b"
  location             = var.region
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}
resource "azurerm_virtual_machine_data_disk_attachment" "nfs-0b" {
  managed_disk_id    = azurerm_managed_disk.nfs-0b.id
  virtual_machine_id = azurerm_linux_virtual_machine.nfs-0.id
  lun                = "1"
  caching            = "ReadWrite"
}

resource "azurerm_linux_virtual_machine" "nfs-1" {
    name                  = "nfs-1"
    location              = var.region
    resource_group_name   = azurerm_resource_group.example.name
    network_interface_ids = [azurerm_network_interface.nfs-1.id]
    size                  = "Standard_DS2_v2"

    os_disk {
        name              = "nfs-1"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
        disk_size_gb      = "100"
    }

    source_image_reference {
        publisher = var.publisher
        offer     = var.offer
        sku       = var.sku
        version   = var._version
    }

    computer_name  = "nfs-1"
    availability_set_id = azurerm_availability_set.nfs.id
    admin_username = "azureadmin"
#    custom_data    = file("<path/to/file>")

    admin_ssh_key {
        username       = "azureadmin"
        public_key     = file("~/.ssh/lab_rsa.pub")
    }
}

resource "azurerm_managed_disk" "nfs-1a" {
  name                 = "${azurerm_linux_virtual_machine.nfs-1.name}-disk1a"
  location             = var.region
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}
resource "azurerm_virtual_machine_data_disk_attachment" "nfs-1a" {
  managed_disk_id    = azurerm_managed_disk.nfs-1a.id
  virtual_machine_id = azurerm_linux_virtual_machine.nfs-1.id
  lun                = "0"
  caching            = "ReadWrite"
}

resource "azurerm_managed_disk" "nfs-1b" {
  name                 = "${azurerm_linux_virtual_machine.nfs-1.name}-disk1b"
  location             = var.region
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 100
}
resource "azurerm_virtual_machine_data_disk_attachment" "nfs-1b" {
  managed_disk_id    = azurerm_managed_disk.nfs-1b.id
  virtual_machine_id = azurerm_linux_virtual_machine.nfs-1.id
  lun                = "1"
  caching            = "ReadWrite"
}