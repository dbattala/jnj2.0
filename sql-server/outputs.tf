output "domain_name_primary" {
  value = azurerm_sql_server.sql_server_primary.fully_qualified_domain_name
}

output "domain_name_secondary" {
  value = azurerm_sql_server.sql_server_secondary.fully_qualified_domain_name
}