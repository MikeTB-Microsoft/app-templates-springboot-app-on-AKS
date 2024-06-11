targetScope='subscription'
//
// resource group parameters
param rgName string = 'petclinicaks-rg'
param location string = 'eastus'

// vnet parameters
param hubvnetName string = 'hubvnet-aks'
param spokevnetName string = 'spokevnet-aks'
param hubvnetPrefix string = '10.50.0.0/16'
param ilbSubnetPrefix string = '10.50.1.0/24'
param bastionSubnetPrefix string = '10.50.2.0/24'
param fwSubnetPrefix string = '10.50.3.0/24'
param mgmtSubnetPrefix string = '10.50.4.0/24'
param spokevnetPrefix string = '10.51.0.0/16'
param aksSubnetPrefix string = '10.51.1.0/24'
param acrSubnetPrefix string = '10.50.2.0/24'
param kvSubnetPrefix string = '10.50.3.0/24'
param pgfsdbSubnetPrefix string = '10.50.4.0/24'

// jumpbox parameters 
param vmName string = 'aks-vm'
@secure()
param adminPassword string 

// aks parameters
param aksClusterName string = 'aks-cluster'
param k8sVersion string = '1.29.2'
param adminPublicKey string
param adminGroupObjectIDs array = []
@allowed([
  'Free'
  'Paid'
])
param aksSkuTier string = 'Free'
param aksVmSize string = 'Standard_D2s_v3'
param aksNodes int = 1

@allowed([
  'azure'
  'calico'
])
param aksNetworkPolicy string = 'calico'

// fw parameters
param fwName string = 'aks-fw'

// acr parameters
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param acrSku string = 'Basic'
param acrName string = 'petclinicaksacr23'

// kv parameters
param kvName string = 'kvdemocbs'

// pgfs parameters
param pgfsName string = 'pgfs-cbs'

// pgfs parameters
param vnetPeeringName string = 'vnetPeering/'

// create resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgName
  location: location
}

module hubvnet 'modules/aks-vnet.bicep' = {
  name: hubvnetName
  scope: rg
  params: {
    location: location
    vnetName: hubvnetName
    vnetPrefix: hubvnetPrefix
    ilbSubnetPrefix: ilbSubnetPrefix
    bastionSubnetPrefix: bastionSubnetPrefix
    fwSubnetPrefix: fwSubnetPrefix
    mgmtSubnetPrefix: mgmtSubnetPrefix
  }
}
module spokevnet 'modules/spoke-aks-vnet.bicep' = {
  name: spokevnetName
  scope: rg
  params: {
    location: location
    vnetName: spokevnetName
    vnetPrefix: spokevnetPrefix
    aksSubnetPrefix: aksSubnetPrefix
    acrSubnetPrefix: acrSubnetPrefix
    kvSubnetPrefix: kvSubnetPrefix
    pgfsSubnetPrefix: pgfsdbSubnetPrefix
  }
}
module vm 'modules/jump-box.bicep' = {
  name: vmName
  scope: rg
  params:{
    location: location
    vmName: vmName
    subnetId: hubvnet.outputs.mgmtSubnetId
   adminPassword: adminPassword
  }
}

module fw 'modules/azfw.bicep' = {
  name: fwName
  scope: rg
  params: {
    location: location
    fwName: fwName
    fwSubnetId: hubvnet.outputs.fwSubnetId
  }
}

module aks 'modules/aks-cluster.bicep' = {
  name: aksClusterName
  scope: rg
  params: {    
    location: location
    aksClusterName: aksClusterName
    subnetId: spokevnet.outputs.aksSubnetId
    adminPublicKey: adminPublicKey

    aksSettings: {
      clusterName: aksClusterName
      identity: 'SystemAssigned'
      kubernetesVersion: k8sVersion
      networkPlugin: 'azure'
      networkPolicy: aksNetworkPolicy
      serviceCidr: '10.51.1.0/24' // can be reused in multiple clusters; no overlap with other IP ranges
      dnsServiceIP: '172.16.0.10'
      dockerBridgeCidr: '172.16.4.1/22'
      outboundType: 'loadBalancer'
      loadBalancerSku: 'standard'
      sku_tier: aksSkuTier			
      enableRBAC: true
      aadProfileManaged: true
      adminGroupObjectIDs: adminGroupObjectIDs 
    }

    defaultNodePool: {
      name: 'pool01'
      count: aksNodes
      vmSize: aksVmSize
      osDiskSizeGB: 50
      osDiskType: 'Ephemeral'
      vnetSubnetID: spokevnet.outputs.aksSubnetId
      osType: 'Linux'
      type: 'VirtualMachineScaleSets'
      mode: 'System'
    }    
  }
}

module acr 'modules/acr.bicep' = {
  name: acrName
  scope: rg
  params:{
    location: location
    acrName: acrName
    acrSku: acrSku
  }
}
module kv 'modules/key-vault.bicep' = {
  name: kvName
  scope: rg
}

module pgfs 'modules/pgfs.bicep' = {
  name: pgfsName
  scope: rg
}
