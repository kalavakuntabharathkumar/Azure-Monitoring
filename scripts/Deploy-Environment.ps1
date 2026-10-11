[CmdletBinding()]
param(
  [Parameter(Mandatory)] [ValidateSet('dev','test')] [string] $Environment,
  [Parameter(Mandatory)] [string] $ResourceGroup
)
$ErrorActionPreference = 'Stop'
$template = Join-Path $PSScriptRoot '..\infra\main.bicep'
$params = Join-Path $PSScriptRoot "..\infra\parameters.$Environment.json"
az deployment group validate --resource-group $ResourceGroup --template-file $template --parameters "@$params"
if ($LASTEXITCODE -ne 0) { throw "Template validation failed." }
az deployment group create --resource-group $ResourceGroup --template-file $template --parameters "@$params"
if ($LASTEXITCODE -ne 0) { throw "Deployment failed." }
