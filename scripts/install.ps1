<#
.SYNOPSIS
  Copia as skills deste repositório para uma pasta de skills do Claude Code.
.PARAMETER Destino
  Pasta de destino. Padrão: $HOME\.claude\skills (instalação global).
.PARAMETER Skills
  Nomes das skills a instalar. Padrão: todas as pastas em skills\.
.EXAMPLE
  .\scripts\install.ps1
.EXAMPLE
  .\scripts\install.ps1 -Destino "C:\projetos\app\.claude\skills" -Skills mobile-ui-ux,mobile-accessibility
#>
param(
  [string]$Destino = (Join-Path $HOME ".claude\skills"),
  [string[]]$Skills
)
$ErrorActionPreference = "Stop"

$origem = Join-Path (Split-Path -Parent $PSScriptRoot) "skills"
if (-not $Skills) {
  $Skills = Get-ChildItem -Path $origem -Directory | Select-Object -ExpandProperty Name
}

New-Item -ItemType Directory -Force -Path $Destino | Out-Null

foreach ($nome in $Skills) {
  $de = Join-Path $origem $nome
  if (-not (Test-Path (Join-Path $de "SKILL.md"))) {
    Write-Warning "Ignorada: '$nome' não existe em skills\ ou não tem SKILL.md"
    continue
  }
  Copy-Item -Path $de -Destination $Destino -Recurse -Force
  Write-Host "Instalada: $nome -> $(Join-Path $Destino $nome)"
}
