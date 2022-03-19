param prefixName string
param location string = resourceGroup().location

@description('Virtual machine admin user name')
param jumpBoxAdminUserName string

@secure()
@minLength(8)
@description('Virtual machine admin password')
param jumpBoxAdminPass string

//var environmentName = 'env-${prefixName}-${uniqueString(resourceGroup().id)}'
var environmentName = 'acaenv-${prefixName}'

module vnet 'vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
    name: 'vnet'
  }
}

module log 'log.bicep' = {
  name: 'log'
  params: {
    location: location
    environmentName: environmentName
  }
}

module environment './environment.bicep' = {
  name: 'environment'
  params: {
    location: location
    environmentName: environmentName
    controlPlaneSubnetId: vnet.outputs.controlPlaneSubnetId
    applicationsSubnetId: vnet.outputs.applocationSubnetId
    appInsightsName: log.outputs.appInsightsName
    logAnalyticsWorkspaceName: log.outputs.logAnalyticsWorkspaceName
  }
}

module acr 'acr.bicep' = {
  name: 'acr'
  params: {
    location: location
    namePrefix: prefixName
  }
}

module bastion 'bastion.bicep' = {
  name: 'bastion'
  params: {
    location: location
    namePrefix: prefixName
    bastionSubnetId: vnet.outputs.bastionSubnetId
  }
}

module nsg 'nsg.bicep' = {
  name: 'nsg'
  params: {
    location: location
    namePrefix: prefixName
  }
}

module jumpbox 'jumpbox.bicep' = {
  name: 'jumpbox'
  params: {
    location: location
    namePrefix: prefixName
    subnetId: vnet.outputs.defaultSubnetId
    networkSecurityGroupId: nsg.outputs.networkSecurityGroupId
    adminUsername: jumpBoxAdminUserName
    adminPassword: jumpBoxAdminPass
  }
}
