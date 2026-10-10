param location string = resourceGroup().location
param appResourceId string
param actionGroupId string
param alertPrefix string = 'azmon'

resource availabilityAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: '${alertPrefix}-availability'
  location: 'global'
  properties: {
    description: 'App Service availability below expected threshold'
    severity: 1
    enabled: true
    scopes: [appResourceId]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria'
      webTestId: appResourceId
      componentId: appResourceId
      failedLocationCount: 1
    }
    actions: [{ actionGroupId: actionGroupId }]
  }
}
