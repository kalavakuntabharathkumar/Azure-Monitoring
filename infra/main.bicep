@description('Deployment region')
param location string = resourceGroup().location
@description('Globally unique storage account name, 3-24 lowercase letters/numbers')
@minLength(3)
@maxLength(24)
param storageName string
@description('App Service plan and app name prefix')
param namePrefix string = 'azmon-demo'
param skuName string = 'B1'

var workspaceName = '${namePrefix}-law'
var planName = '${namePrefix}-plan'
var appName = '${namePrefix}-app'

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: workspaceName
  location: location
  properties: {
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
  sku: { name: 'PerGB2018' }
}

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    accessTier: 'Hot'
  }
}

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: planName
  location: location
  kind: 'linux'
  sku: { name: skuName, tier: skuName == 'B1' ? 'Basic' : 'Standard' }
  properties: { reserved: true }
}

resource app 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      alwaysOn: skuName != 'F1'
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      appSettings: [
        { name: 'WEBSITE_RUN_FROM_PACKAGE', value: '1' }
        { name: 'APPINSIGHTS_PROFILERFEATURE_VERSION', value: '1.0.0' }
      ]
    }
  }
}

output workspaceId string = workspace.id
output storageAccountId string = storage.id
output appName string = app.name
output appDefaultHostName string = app.properties.defaultHostName
