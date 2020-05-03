variable "prefix" {
  description = "The prefix used for all resources in this example"
}

variable "region" {
  description = "The Azure location where all resources in this example should be created"
}

################################
# publisher = "SUSE"
# offer     = "sles-sap-12-sp5"
# sku       = "gen2"
# version   = "latest"
################################
# publisher = "SUSE"
# offer     = "SLES-SAP"
# sku       = "12-sp4-gen2"
# version   = "latest"
################################
variable "publisher" {
  description = "Publisher of the image used to create VM"
}
variable "offer" {
  description = "Offer of the image used to create VM"
}
variable "sku" {
  description = "SKU of the image used to create VM"
}
variable "version" {
  description = "Version of the image used to create VM"
}