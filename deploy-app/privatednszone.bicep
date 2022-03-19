@description('Private DNS Zone Name')
param dnsZoneName string
@description('location of this reosurce')
var location = 'global'
@description('virtual network id')
param vnetId string
@description('virtual network name')
param vnetName string
@description('enable auto registration for private dns')
param autoRegistration bool = false
@description('Tag information')
param tags object = {}

resource privateDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: dnsZoneName
  location: location
}

resource vnLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${dnsZoneName}/${vnetName}-link'
  location: location
  properties: {
    registrationEnabled: autoRegistration
    virtualNetwork: {
      id: vnetId
    }
  }
  dependsOn: [
    privateDns
  ]
  tags: tags
}

output id string = privateDns.id
output name string = privateDns.name
