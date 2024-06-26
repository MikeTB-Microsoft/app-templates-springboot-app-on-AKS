param aksClusterName string
param subnetId string
param adminUsername string = 'azureuser'
param adminPublicKey string
param location string = 'eastus'

param aksSettings object = {
  kubernetesVersion: null
  networkPlugin: 'azure'
  networkPolicy: 'calico'
  serviceCidr: '10.51.1.0/24' // Must be cidr not in use any where else across the Network (Azure or Peered/On-Prem).  Can safely be used in multiple clusters - presuming this range is not broadcast/advertised in route tables.
  dnsServiceIP: '172.16.0.10' // Ip Address for K8s DNS
  dockerBridgeCidr: '172.16.4.1/22' // Used for the default docker0 bridge network that is required when using Docker as the Container Runtime.  Not used by AKS or Docker and is only cluster-routable.  Cluster IP based addresses are allocated from this range.  Can be safely reused in multiple clusters.
  outboundType: 'UDR'
  loadBalancerSku: 'standard'
  sku_tier: 'Paid'				
  enableRBAC: true
  aadProfileManaged: true
  adminGroupObjectIDs: [] 
}

param defaultNodePool object = {
  name: 'systempool01'
  count: 3
  vmSize: 'Standard_D2s_v3'
  osDiskSizeGB: 50
  osDiskType: 'Ephemeral'
  vnetSubnetID: subnetId
  osType: 'Linux'
  maxCount: 6
  minCount: 2
  enableAutoScaling: true
  type: 'VirtualMachineScaleSets'
  mode: 'System'
  orchestratorVersion: null
}

// https://docs.microsoft.com/en-us/azure/templates/microsoft.containerservice/managedclusters?tabs=json#ManagedClusterAgentPoolProfile
resource aks 'Microsoft.ContainerService/managedClusters@2021-05-01' = {
  name: aksClusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Basic'
    tier: aksSettings.sku_tier
  }
  properties: {
    kubernetesVersion: aksSettings.kubernetesVersion
    dnsPrefix: aksSettings.clusterName
    linuxProfile: {
      adminUsername: adminUsername
      ssh: {
        publicKeys: [
          {
            keyData: adminPublicKey
          }
        ]
      }
    }
  
    networkProfile: {
      networkPlugin: aksSettings.networkPlugin 
      networkPolicy: aksSettings.networkPolicy 
      serviceCidr: aksSettings.serviceCidr  // Must be cidr not in use any where else across the Network (Azure or Peered/On-Prem).  Can safely be used in multiple clusters - presuming this range is not broadcast/advertised in route tables.
      dnsServiceIP: aksSettings.dnsServiceIP // Ip Address for K8s DNS
      dockerBridgeCidr: aksSettings.dockerBridgeCidr  // Used for the default docker0 bridge network that is required when using Docker as the Container Runtime.  Not used by AKS or Docker and is only cluster-routable.  Cluster IP based addresses are allocated from this range.  Can be safely reused in multiple clusters.
      outboundType: aksSettings.outboundType 
      loadBalancerSku: aksSettings.loadBalancerSku 
    }

    autoUpgradeProfile: {}

     agentPoolProfiles: [
      defaultNodePool
    ]
  }
}

output identity string = aks.identity.principalId
