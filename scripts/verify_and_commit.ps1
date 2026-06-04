# Vérification Flutter + commits examen (à lancer localement si l'agent n'a pas de shell)
$ErrorActionPreference = "Stop"
$Flutter = "C:\src\flutter\bin\flutter.bat"
$Root = "C:\Users\ayaes\Desktop\stock_flutter"
$Log = Join-Path $Root "EXECUTION_LOG.txt"

function Log-Cmd([string]$label, [scriptblock]$block) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content $Log "`n=== $ts | $label ===`n"
    Push-Location $Root
    try {
        & $block *>&1 | Tee-Object -FilePath $Log -Append
        "EXIT: $LASTEXITCODE" | Add-Content $Log
        if ($LASTEXITCODE -ne 0) { throw "Échec: $label (exit $LASTEXITCODE)" }
    }
    finally { Pop-Location }
}

Set-Location $Root
if (-not (Test-Path "android\gradlew.bat")) {
    Log-Cmd "flutter create android" { & $Flutter create . --platforms=android }
}
Log-Cmd "flutter pub get" { & $Flutter pub get }
Log-Cmd "flutter analyze" { & $Flutter analyze }
Log-Cmd "flutter build apk --debug" { & $Flutter build apk --debug }

function Do-Commit([string]$msg, [string[]]$paths) {
    git status
    git diff --stat
    if ($paths) { git add @paths }
    git commit -m $msg
    git log -1 --oneline
}

# Ne jamais committer google-services.json
Do-Commit "fix(android): gradle et google-services" @(
    "android/app/build.gradle.kts",
    "android/settings.gradle.kts",
    "android/build.gradle.kts",
    "android/app/google-services.json.example"
)
Do-Commit "fix(firebase): options et bootstrap" @(
    "lib/firebase_options.dart",
    "lib/infrastructure/firebase/firebase_bootstrap.dart",
    "README.md"
)
Do-Commit "fix(build): corrections compile et analyze" @(
    "lib/domain/entities/product.dart",
    "lib/domain/entities/category.dart",
    "lib/domain/entities/mouvement.dart"
)

Write-Host "Terminé. Voir $Log"
