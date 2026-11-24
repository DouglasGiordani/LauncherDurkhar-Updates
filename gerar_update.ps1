param(
  [Parameter(Mandatory=$true)][string]$Version,
  [string]$Notes = "Actualización del Launcher Durkhar."
)
$repo = $PSScriptRoot
$src = "C:\Users\sites2\Documents\Nova pasta\Launcher Durkhar"
$tmp = Join-Path $env:TEMP ("durkhar_pkg_" + [Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path "$tmp\CustomOverrides" | Out-Null
Copy-Item "$src\Naruto Online.exe" "$tmp\Naruto Online.exe" -Force
# O atualizador vai como .new.exe: o ActualizarLauncher.exe em uso nao pode ser sobrescrito;
# o novo se promove sozinho (e pede UAC quando o launcher esta em Program Files).
Copy-Item "$src\ActualizarLauncher.exe" "$tmp\ActualizarLauncher.new.exe" -Force
Copy-Item "$src\CustomOverrides\ninjaplugin.swf" "$tmp\CustomOverrides\ninjaplugin.swf" -Force
Copy-Item "$src\CustomOverrides\battleplugin_opt.swf" "$tmp\CustomOverrides\battleplugin_opt.swf" -Force
Copy-Item "$src\CustomOverrides\DurkharPanel.swf" "$tmp\CustomOverrides\DurkharPanel.swf" -Force
Copy-Item "$src\CustomOverrides\secretrollplugin.swf" "$tmp\CustomOverrides\secretrollplugin.swf" -Force
Copy-Item "$src\CustomOverrides\19001001_outdoor.swf" "$tmp\CustomOverrides\19001001_outdoor.swf" -Force
Copy-Item "$src\CustomOverrides\NinjaOutdoorEffectInfos.xml" "$tmp\CustomOverrides\NinjaOutdoorEffectInfos.xml" -Force
# Ciclo dia/tarde/noite pela hora do servidor + sombras dos personagens
Copy-Item "$src\CustomOverrides\mapplugin.swf" "$tmp\CustomOverrides\mapplugin.swf" -Force
# Titulo 999999 com a arte original do jogo (substitui uma versao antiga personalizada)
Copy-Item "$src\CustomOverrides\999999.swf" "$tmp\CustomOverrides\999999.swf" -Force
# Titulo 400012 com arte personalizada
Copy-Item "$src\CustomOverrides\400012.swf" "$tmp\CustomOverrides\400012.swf" -Force
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