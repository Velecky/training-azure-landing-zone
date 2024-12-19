targetScope = 'subscription'

param location string
param productName string
param spokeNumber string

resource spokeResourceGroup 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: 'lz-${spokeNumber}-${productName}'
  location: location
}

module spokeResourceDeployment 'default-landing-zone/landing-zone.bicep' = {
  scope: spokeResourceGroup
  name: 'spokeResourceDeployment'
  params: {
    location: location
    productName: productName
    spokeNumber: spokeNumber
  }
}
