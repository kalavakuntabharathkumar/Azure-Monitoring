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

// Additional alert definitions are deployed with the application resource ID
// and an action group supplied by the environment pipeline.
resource http5xxAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: '${alertPrefix}-http5xx'
  location: 'global'
  properties: {
    description: 'HTTP server error count exceeds the operational threshold'
    severity: 2
    enabled: true
    scopes: [appResourceId]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [{
        name: 'Http5xx'
        metricName: 'Http5xx'
        metricNamespace: 'Microsoft.Web/sites'
        operator: 'GreaterThan'
        threshold: 5
        timeAggregation: 'Total'
        criterionType: 'StaticThresholdCriterion'
      }]
    }
    actions: [{ actionGroupId: actionGroupId }]
  }
}
