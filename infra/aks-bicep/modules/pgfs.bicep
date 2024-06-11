resource pgfsDB 'Microsoft.DBforPostgreSQL/flexibleServers@2023-03-01-preview' = {
  name: 'pgfs-cbs'
  location: 'eastus'

  sku: {
    name: 'Standard_D4s_v3'
    tier: 'Burstable'
  }
  identity: {
    type: 'none'
    userAssignedIdentities: {}
  }
  properties: {
    administratorLogin: 'pgfscbsabmin'
    administratorLoginPassword: 'pgfscbslog1234'
    authConfig: {
      activeDirectoryAuth: 'enabled'
      passwordAuth: 'enabled'
      tenantId: '449fbe1d-9c99-4509-9014-4fd5cf25b014'
    }
    availabilityZone: 'eastus'
    backup: {
      backupRetentionDays: 30
      geoRedundantBackup: 'disabled'
    }
    createMode: 'Create'
    dataEncryption: {
      geoBackupKeyURI: ''
      geoBackupUserAssignedIdentityId: ''
      primaryKeyURI: ''
      primaryUserAssignedIdentityId: ''
      type: 'SystemManaged'
    }
    highAvailability: {
      mode: 'disabled'
      standbyAvailabilityZone: ''
    }
    maintenanceWindow: {
      customWindow: 'diabled'
      dayOfWeek: 5
      startHour: 1
      startMinute: 1
    }
    network: {
      delegatedSubnetResourceId: ''
      privateDnsZoneArmResourceId: ''
    }
    pointInTimeUTC: ''
    replicationRole: 'None'
    sourceServerResourceId: ''
    storage: {
      autoGrow: 'enabled'
      storageSizeGB: 1
      tier: 'P1'
    }
    version: '15'
  }
}
