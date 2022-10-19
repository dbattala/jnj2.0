resource "azurerm_sql_server" "sql_server_primary" {
  name                         = var.name
  location                     = var.resource_group.location
  resource_group_name          = var.resource_group.name
  version                      = "12.0"
  administrator_login          = var.login
  administrator_login_password = var.password

}

resource "azurerm_sql_elasticpool" "elastic_pool-primary" {
  name                = var.elastic_pool_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  server_name         = azurerm_sql_server.sql_server_primary.name
  edition             = "Standard"
  dtu                 = 200
}

resource "azurerm_sql_server" "sql_server_secondary" {
  name                         = "${var.name}-secondary"
  location                     = var.secondary_location
  resource_group_name          = var.resource_group.name
  version                      = "12.0"
  administrator_login          = var.login
  administrator_login_password = var.password

}

resource "azurerm_sql_elasticpool" "elastic_pool-secondary" {
  name                = "${var.elastic_pool_name}-secondary"
  resource_group_name = var.resource_group.name
  location            = var.secondary_location
  server_name         = azurerm_sql_server.sql_server_secondary.name
  edition             = "Standard"
  dtu                 = 200
}

resource "azurerm_sql_failover_group" "failover_group" {
  name                = var.failover_group_name
  resource_group_name = azurerm_sql_server.sql_server_primary.resource_group_name
  server_name         = azurerm_sql_server.sql_server_primary.name
  databases           = []
  partner_servers {
    id = azurerm_sql_server.sql_server_secondary.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 60
  }
}