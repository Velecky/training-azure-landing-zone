param spokeResourceGroupName string
param spokeVirtualNetworkName string
param spokeNumber string


resource hubNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: 'hub'
}

resource spokeNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: spokeVirtualNetworkName
  scope: resourceGroup(spokeResourceGroupName)
}

resource peeringSpokeHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  name: 'hub-to-spoke-${spokeNumber}'
  parent: hubNetwork
  properties: {
    remoteVirtualNetwork: {
      id: spokeNetwork.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
