param name string
param location string
param addressPrefixes array = [
  '10.0.0.0/16'
]
param controlPlanePrefix string = '10.0.0.0/21'
param applicationsPrefix string = '10.0.8.0/21'
param bastionSubnetPrefix string = '10.0.16.0/24'
param defaultSubnetPrefix string = '10.0.17.0/24'

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
          addressPrefix: controlPlanePrefix
        }
      }
      {
        name: 'applications'
        properties: {
          addressPrefix: applicationsPrefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }
      {
        name: 'default'
        properties: {
          addressPrefix: defaultSubnetPrefix
        }
      }            
    ]
  }
}

output controlPlaneSubnetId string = vnet.properties.subnets[0].id
output applocationSubnetId string = vnet.properties.subnets[1].id
output bastionSubnetId string = vnet.properties.subnets[2].id
output defaultSubnetId string = vnet.properties.subnets[3].id
output bastionSubnetPrefix string = bastionSubnetPrefix
output vnetId string = vnet.id
