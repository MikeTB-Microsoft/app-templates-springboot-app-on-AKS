resource symbolicname 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kvdemocbs'
  location: 'eastus'

  properties: {
    accessPolicies: [
      {
        applicationId: '8d35d4ea-3136-4f27-bc75-76203838c504'
        objectId: '820d1660-da50-4fc5-8a99-a5c92a6e67f4'
        permissions: {
          certificates: [
            'all'
          ]
          keys: [
            'all'
          ]
          secrets: [
            'all'
          ]
          storage: [
            'all'
          ]
        }
        tenantId: '449fbe1d-9c99-4509-9014-4fd5cf25b014'
      }
    ]
    createMode: 'default'
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'allow'
      ipRules: [
        {
          value: '10.50.3.0/24'
        }
      ]
      virtualNetworkRules: [
        {
          id: 'kvsubnet'
          ignoreMissingVnetServiceEndpoint: true
        }
      ]
    }
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'disabled'
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 30
    tenantId: '449fbe1d-9c99-4509-9014-4fd5cf25b014'
    vaultUri: ''
  }
}
