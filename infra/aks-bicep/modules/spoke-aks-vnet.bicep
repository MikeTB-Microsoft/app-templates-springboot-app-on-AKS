param vnetName string
param vnetPrefix string
param aksSubnetPrefix string
param acrSubnetPrefix string
param kvSubnetPrefix string
param pgfsSubnetPrefix string
param location string = 'eastus'


resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
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
        name: 'aksSubnet'
        properties:{
          addressPrefix: aksSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
      {
        name: 'acrSubnet'
        properties:{
          addressPrefix: acrSubnetPrefix
        }
      }
      {
        name: 'kvSubnet'
        properties:{
          addressPrefix: kvSubnetPrefix
        }
      }
      {
        name: 'pgfsSubnet'
        properties:{
          addressPrefix: pgfsSubnetPrefix
        }
      }
      
    ]
    
  }
}

    

output pgfsSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'pgfsSubnet')
output kvSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'kvSubnet')
output aksSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'aksSubnet')
output acrSubnetId string = resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, 'acrSubnet')
output Id string = vnet.id
