@description('Private DNS Zone Name')
param dnsZoneName string
@description('location of this reosurce')
var location = 'global'
@description('virtual network name')
param vnetName string
@description('enable auto registration for private dns')
param autoRegistration bool = false
@description('Tag information')
param tags object = {}
@description('DNS A records array')
param arecords array


resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
}

resource privateDns 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: toLower(dnsZoneName)
  location: location
}

resource vnLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${dnsZoneName}/${vnet.name}-link'
  location: location
  properties: {
    registrationEnabled: autoRegistration
    virtualNetwork: {
      id: vnet.id
    }
  }
  dependsOn: [
    privateDns
  ]
  tags: tags
}

resource DNSARecords 'Microsoft.Network/privateDnsZones/A@2020-06-01' = [for arecord in arecords: {
  name: toLower(arecord.name)
  parent: privateDns
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: arecord.ipv4Address
      }
      
    ]
  }
}]

output id string = privateDns.id
output name string = privateDns.name
