// Creates a Data Science Virtual Machine jumpbox.
@description('Azure region of the deployment')
param location string = resourceGroup().location

@description('Resource ID of the subnet')
param subnetId string

@description('Resource name prefix')
param namePrefix string

@description('Network Security Group Resource ID')
param networkSecurityGroupId string

@description('Virtual machine name')
var virtualMachineName = '${namePrefix}-jumpbox'

@description('Virtual machine size')
param vmSize string = 'Standard_DS3_v2'

@description('Virtual machine admin username')
param adminUsername string

@secure()
@minLength(8)
@description('Virtual machine admin password')
param adminPassword string

var aadLoginExtensionName = 'AADLoginForWindows'

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: '${virtualMachineName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroupId
    }
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
      }
      imageReference: {
        publisher: 'microsoft-dsvm'
        offer: 'dsvm-win-2019'
        sku: 'server-2019'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          enableHotpatching: false
          patchMode: 'AutomaticByOS'
        }
      }
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource virtualMachineName_aadLoginExtensionName 'Microsoft.Compute/virtualMachines/extensions@2021-03-01' = {
  name: '${virtualMachine.name}/${aadLoginExtensionName}'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: aadLoginExtensionName
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}

output dsvmId string = virtualMachine.id
