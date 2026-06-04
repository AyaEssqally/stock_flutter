# Script de finalisation — ESISA stock_flutter
# Exécuter dans PowerShell depuis la racine du projet.

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

if (-not (Test-Path ".git")) { git init }

if (-not (Test-Path "android")) {
  Write-Host "Génération des dossiers plateforme..."
  flutter create . --org com.esisa.stock
}

flutter pub get
flutter doctor
Write-Host "Terminé. Voir GUIDE_FR.md pour GitHub et Firebase."
