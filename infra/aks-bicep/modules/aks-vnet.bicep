param vnetName string
param vnetPrefix string
param aksSubnetPrefix string
param ilbSubnetPrefix string
param bastionSubnetPrefix string
param fwSubnetPrefix string
param mgmtSubnetPrefix string
param location string = 'eastus'


resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnetName
  location: location
  properties:{
    addressSpace:{
      addressPrefixes:[
        vnetPrefix
      ]
    }
    subnets:[
      {
        name: 'aks'
        properties:{
          addressPrefix: aksSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'ilb'
        properties:{
          addressPrefix: ilbSubnetPrefix
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties:{
          addressPrefix: bastionSubnetPrefix
        }
      }
      {
        name: 'AzureFirewallSubnet'
        properties:{
          addressPrefix: fwSubnetPrefix
        }
      }
      {
        name: 'mgmt'
        properties:{
          addressPrefix: mgmtSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
        
      }
    ]
    
  }
}

    

output bastionSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'AzureBastionSubnet')
output mgmtSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'mgmt')
output aksSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'aks')
output fwSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'AzureFirewallSubnet')
output Id string = vnet.id
