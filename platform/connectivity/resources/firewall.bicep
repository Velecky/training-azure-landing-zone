param location string
param virtualNetworkName string
param subnetName string

resource publicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: 'firewall-ip'
  sku: {
    name: 'Standard'
  }
  properties:{
    publicIPAllocationMethod: 'Static'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: virtualNetworkName

  resource subnet 'subnets@2024-05-01' existing = {
    name: subnetName
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2024-05-01' = {
  name: 'firewall'
  location: location
  properties: {
    ipConfigurations: [{
      name: 'ipConfiguration'
      properties: {
        subnet: {
          id: virtualNetwork::subnet.id
        }
        publicIPAddress: {
          id: publicIP.id
        }
      }
    }]
  }
}

var name = 'central-log-analytics'

@description('central logs')
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces/dataSources@2023-09-01' existing = {
  name: name
  scope: resourceGroup('management')
}

resource firewallDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'allLogs_to_logAnalyticsWorkspace'
  scope: firewall
  properties:{
    logs: [{
      category: 'allLogs'
      enabled: true
    }]
    logAnalyticsDestinationType: 'Dedicated'
    workspaceId: logAnalyticsWorkspace.id
  }
}
