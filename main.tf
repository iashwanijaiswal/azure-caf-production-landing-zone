# =============================================================================
# Microsoft Cloud Adoption Framework (CAF) Hub & Connectivity Landing Zone
# Author: Ashwani Jaiswal
# =============================================================================

resource "azurerm_resource_group" "rg_connectivity" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# -----------------------------------------------------------------------------
# Central Connectivity Hub Virtual Network
# -----------------------------------------------------------------------------
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-prod-${var.location}-001"
  location            = azurerm_resource_group.rg_connectivity.location
  resource_group_name = azurerm_resource_group.rg_connectivity.name
  address_space       = [var.hub_address_space]
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Dedicated Gateway Subnet (for ExpressRoute & S2S VPN Gateways)
# -----------------------------------------------------------------------------
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg_connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.hub_address_space, 8, 0)] # e.g. 10.0.0.0/24
}

# -----------------------------------------------------------------------------
# Dedicated Azure Firewall Subnet
# -----------------------------------------------------------------------------
resource "azurerm_subnet" "azure_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg_connectivity.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [cidrsubnet(var.hub_address_space, 8, 1)] # e.g. 10.0.1.0/24
}

# -----------------------------------------------------------------------------
# Central Azure Firewall Public IP & Premium Firewall
# -----------------------------------------------------------------------------
resource "azurerm_public_ip" "firewall_pip" {
  name                = "pip-afw-hub-prod-001"
  location            = azurerm_resource_group.rg_connectivity.location
  resource_group_name = azurerm_resource_group.rg_connectivity.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "hub_firewall" {
  name                = "afw-hub-prod-${var.location}-001"
  location            = azurerm_resource_group.rg_connectivity.location
  resource_group_name = azurerm_resource_group.rg_connectivity.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  tags                = var.tags

  ip_configuration {
    name                 = "firewall-configuration"
    subnet_id            = azurerm_subnet.azure_firewall.id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }
}

# -----------------------------------------------------------------------------
# Route Table: Forced Tunneling 0.0.0.0/0 to Azure Firewall Private IP
# -----------------------------------------------------------------------------
resource "azurerm_route_table" "spoke_udr" {
  name                          = "rt-spoke-to-firewall-prod-001"
  location                      = azurerm_resource_group.rg_connectivity.location
  resource_group_name           = azurerm_resource_group.rg_connectivity.name
  disable_bgp_route_propagation = false
  tags                          = var.tags

  route {
    name                   = "route-default-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
  }
}
