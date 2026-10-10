[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string] $ResourceGroup,
  [Parameter(Mandatory)] [string] $VaultName,
  [Parameter(Mandatory)] [string] $StorageAccountName,
  [Parameter(Mandatory)] [string] $FileShareName,
  [string] $PolicyName = 'DailyFiles-30DayRetention'
)
$ErrorActionPreference = 'Stop'
$vault = Get-AzRecoveryServicesVault -Name $VaultName -ResourceGroupName $ResourceGroup
if (-not $vault) { throw "Recovery Services vault '$VaultName' was not found." }
Set-AzRecoveryServicesVaultContext -Vault $vault
$policy = Get-AzRecoveryServicesBackupProtectionPolicy -Name $PolicyName -ErrorAction SilentlyContinue
if (-not $policy) {
  $policy = Get-AzRecoveryServicesBackupProtectionPolicy -WorkloadType AzureFiles
}
Enable-AzRecoveryServicesBackupProtection `
  -StorageAccountName $StorageAccountName `
  -Name $FileShareName `
  -Policy $policy
Write-Output "Backup protection request submitted for $StorageAccountName/$FileShareName."
