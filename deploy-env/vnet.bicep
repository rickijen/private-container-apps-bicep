param name string
param location string
param addressPrefixes array = [
  '10.0.0.0/16'
]
param controlPlane string = '10.0.0.0/21'
param applications string = '10.0.8.0/21'
param bastionSubnet string = '10.0.16.0/24'
param defaultSubnet string = '10.0.17.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [
      {
        name: 'control-plane'
        properties: {
          addressPrefix: controlPlane
        }
      }
      {
        name: 'applications'
        properties: {
          addressPrefix: applications
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnet
        }
      }
      {
        name: 'default'
        properties: {
          addressPrefix: defaultSubnet
        }
      }            
    ]
  }
}

output controlPlaneSubnetId string = vnet.properties.subnets[0].id
output applocationSubnetId string = vnet.properties.subnets[1].id
output bastionSubnetId string = vnet.properties.subnets[2].id
output defaultSubnetId string = vnet.properties.subnets[3].id

output bastionSubnetPrefix string = bastionSubnet
