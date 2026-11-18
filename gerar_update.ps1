param(
  [Parameter(Mandatory=$true)][string]$Version,
  [string]$Notes = "Actualización del Launcher Durkhar."
)
$repo = $PSScriptRoot
$src = "C:\Users\sites2\Documents\Nova pasta\Launcher Durkhar"
$tmp = Join-Path $env:TEMP ("durkhar_pkg_" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path "$tmp\CustomOverrides" | Out-Null
Copy-Item "$src\Naruto Online.exe" "$tmp\Naruto Online.exe" -Force
Copy-Item "$src\CustomOverrides\ninjaplugin.swf" "$tmp\CustomOverrides\ninjaplugin.swf" -Force
Copy-Item "$src\CustomOverrides\battleplugin_opt.swf" "$tmp\CustomOverrides\battleplugin_opt.swf" -Force
Copy-Item "$src\CustomOverrides\KonohaHubPanel.swf" "$tmp\CustomOverrides\KonohaHubPanel.swf" -Force
$zipPath = Join-Path $repo "update.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($tmp, $zipPath, [System.IO.Compression.CompressionLevel]::Optimal, $false)
Remove-Item -Recurse -Force $tmp
$sha = (Get-FileHash $zipPath -Algorithm SHA256).Hash.ToLower()
$obj = [ordered]@{
  version = $Version
  notes = $Notes
  zipUrl = "https://raw.githubusercontent.com/DouglasGiordani/LauncherDurkhar-Updates/main/update.zip"
  sha256 = $sha
}
[IO.File]::WriteAllText((Join-Path $repo "version.json"), ($obj | ConvertTo-Json), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Pronto! Versao $Version empacotada em update.zip (SHA256=$sha). Agora faca Commit e Push no GitHub Desktop."