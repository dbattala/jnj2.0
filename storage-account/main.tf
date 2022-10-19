resource "azurerm_storage_account" "storage_account" {
  name                     = var.name 
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}