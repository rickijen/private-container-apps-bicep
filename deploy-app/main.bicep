param environmentName string
param vnetName string

@maxLength(8)
@minLength(8)
param appName string

param containerImage string
param containerPort int
param isExternalIngress bool = true
param location string = resourceGroup().location
param minReplicas int = 0
param transport string = 'auto'
param allowInsecure bool = false
param env array = []

resource environment 'Microsoft.App/managedEnvironments@2022-01-01-preview' existing = {
  name: environmentName
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
}

module containerApps 'container.bicep' = {
  name: 'containerApps'
  params: {
    location: location
    appName: appName
    containerImage: containerImage
    containerPort: containerPort
    environmentId: environment.id
    isExternalIngress: isExternalIngress
    minReplicas: minReplicas
    transport: transport
    allowInsecure: allowInsecure
    env: env
  }
}

var containerAppBaseDomain = skip(containerApps.outputs.fqdn, 8+1)

var arecords = [
  {
    name: '*'
    ipv4Address: environment.properties.staticIp
  }
]
module pdnsz 'privatednszone.bicep' = {
  name: 'pdnsz'
  params: {
    dnsZoneName: containerAppBaseDomain
    vnetName: vnet.name
    arecords: arecords
  }
}

output fqdn string = containerApps.outputs.fqdn
