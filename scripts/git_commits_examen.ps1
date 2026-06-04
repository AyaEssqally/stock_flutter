# Commits logiques pour l'examen (à lancer après setup_projet.ps1)
Set-Location $PSScriptRoot\..

git add pubspec.yaml analysis_options.yaml .gitignore
git commit -m "chore: initialisation projet Flutter et dépendances"

git add lib/domain lib/core/errors lib/core/tenant
git commit -m "feat(domain): entités Product, Category, Mouvement et contrats repositories"

git add lib/infrastructure
git commit -m "feat(infrastructure): Firebase Auth, Firestore multi-tenant, notifications stock bas"

git add lib/application
git commit -m "feat(application): StockService, DashboardService et providers Riverpod"

git add lib/presentation lib/core/router lib/core/providers lib/app.dart lib/main.dart lib/firebase_options.dart
git commit -m "feat(presentation): écrans auth, produits, catégories, mouvements, dashboard et GoRouter"

git add firestore.rules test
git commit -m "docs(security): règles Firestore multi-tenant et test widget de base"

git add README.md GUIDE_FR.md RAPPORT.md scripts
git commit -m "docs: README, guide dépôt GitHub/Firebase et template rapport examen"

Write-Host "Commits créés. git log --oneline pour vérifier."
