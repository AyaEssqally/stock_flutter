# Complète le squelette Android (gradle wrapper, icônes) sans écraser lib/
$ErrorActionPreference = "Stop"
$Project = "C:\Users\ayaes\Desktop\stock_flutter"
$Flutter = "C:\src\flutter\bin\flutter.bat"
$AppId = "com.esisa.stock.stock_flutter"

Set-Location $Project
& $Flutter create . --platforms=android

$gradle = "android\app\build.gradle.kts"
$text = Get-Content $gradle -Raw
if ($text -notmatch [regex]::Escape($AppId)) {
    $text = $text -replace 'applicationId\s*=\s*"[^"]+"', "applicationId = `"$AppId`""
    $text = $text -replace 'namespace\s*=\s*"[^"]+"', "namespace = `"$AppId`""
    if ($text -notmatch "google-services") {
        $text = $text -replace 'id\("dev.flutter.flutter-gradle-plugin"\)', "id(`"dev.flutter.flutter-gradle-plugin`")`n    id(`"com.google.gms.google-services`")"
    }
    Set-Content $gradle $text -NoNewline
}

& $Flutter pub get
& $Flutter build apk --debug
Write-Host "Done. Vérifiez google-services.json dans android/app/"
