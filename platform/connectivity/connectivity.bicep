param location string

var vnetName = 'hub'
var firewallSubnetName = 'AzureFirewallSubnet'
var bastionSubnetName = 'AzureBastionSubnet'


module virualNetworkDeployment 'resources/virtual-networks.bicep' = {
  name: 'virualNetworkDeployment'
  params: {
    location: location
    bastionSubnetName: bastionSubnetName
    firewallSubnetName: firewallSubnetName
    vnetName: vnetName
  }
}

module bastionDeployment 'resources/bastion.bicep' = {
  name: 'bastionDeployment'
  params: {
    location: location
    subnetName: bastionSubnetName
    virtualNetworkName: vnetName
  }
  dependsOn: [ virualNetworkDeployment ]
}

module firewallDeployment 'resources/firewall.bicep' = {
  name: 'firewallDeployment'
  params: {
    location: location 
    subnetName: firewallSubnetName
    virtualNetworkName: vnetName
  }
}
