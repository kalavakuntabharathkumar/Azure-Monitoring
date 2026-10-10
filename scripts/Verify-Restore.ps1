[CmdletBinding()]
param(
  [Parameter(Mandatory)] [string] $SourcePath,
  [Parameter(Mandatory)] [string] $RestoredPath
)
$ErrorActionPreference = 'Stop'
function Get-TreeManifest([string] $Path) {
  Get-ChildItem -LiteralPath $Path -File -Recurse | ForEach-Object {
    [PSCustomObject]@{
      RelativePath = $_.FullName.Substring($Path.TrimEnd('\').Length).TrimStart('\')
      SHA256 = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    }
  } | Sort-Object RelativePath
}
$source = @(Get-TreeManifest $SourcePath)
$restored = @(Get-TreeManifest $RestoredPath)
$diff = Compare-Object $source $restored -Property RelativePath, SHA256
if ($diff) {
  $diff | Format-Table | Out-String | Write-Error
  throw "Restore verification failed: file set or checksum mismatch."
}
Write-Output "Restore verified: $($source.Count) files match by relative path and SHA-256."
