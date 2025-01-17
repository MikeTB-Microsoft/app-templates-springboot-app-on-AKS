// The template to create an Azure Cache for Redis

param name string = 'redis_${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location
param skuName string = 'Basic'
param SkuFamily string = 'C'
param SkuCapacity int = 0
param allowIps array = []
param principalIds array = []
param roleDefinitionId string = 'e0f68234-74aa-48ed-b826-c38b57376e17'  // redis cache contributor role
param keyVaultName string = ''
param secretName string = 'myvault/mysecret'


// create redis cache
resource redis 'Microsoft.Cache/redis@2023-08-01' = {
	name: name
	location: location
	properties: {
		sku: {
			name: skuName
			family: SkuFamily
			capacity: SkuCapacity
		}
	}
}

// create firewall rules
resource redisFirewall 'Microsoft.Cache/redis/firewallRules@2023-08-01' = [for ip in allowIps : {
	name: uniqueString(ip)
	parent: redis
	properties: {
		endIP: ip
		startIP: ip
	}
}]

// create role assignments for the specified principalIds
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for principalId in principalIds: {
	scope: redis
	name: guid(name, principalId)
	properties: {
		roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
		principalId: principalId
	}
}]

// create key vault and secret if keyVaultName is specified
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = if (keyVaultName != ''){
	name: keyVaultName
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = if (keyVaultName != ''){
	name: secretName
	parent: keyVault
	properties: {
		attributes: {
			enabled: true
		}
		contentType: 'string'
		value: redis.listKeys().primaryKey
	}
}


output id string = redis.id
output hostName string = redis.properties.hostName
output sslPort string = string(redis.properties.sslPort)
output keyVaultSecretUri string = (keyVaultName != '' ? keyVaultSecret.properties.secretUriWithVersion : '')
