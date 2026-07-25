param(
    [string]$Config = (Join-Path $PSScriptRoot 'server.json')
)

$ErrorActionPreference = 'Stop'

function Resolve-ConfigPath([string]$path) {
    $path = [Environment]::ExpandEnvironmentVariables($path)
    if ([IO.Path]::IsPathRooted($path)) { return $path }
    return [IO.Path]::GetFullPath((Join-Path $PSScriptRoot $path))
}

function Get-AndroidBuildTools([string]$configuredPath) {
    if (-not [string]::IsNullOrWhiteSpace($configuredPath)) {
        $resolvedPath = Resolve-ConfigPath $configuredPath
        if (Test-Path (Join-Path $resolvedPath 'zipalign.exe')) { return $resolvedPath }
        throw "AndroidBuildTools invalide : $resolvedPath"
    }

    $sdkRoots = @($env:ANDROID_SDK_ROOT, $env:ANDROID_HOME, (Join-Path $env:LOCALAPPDATA 'Android\Sdk')) |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and (Test-Path $_) }
    foreach ($sdkRoot in $sdkRoots) {
        $buildToolsRoot = Join-Path $sdkRoot 'build-tools'
        $candidate = Get-ChildItem $buildToolsRoot -Directory -ErrorAction SilentlyContinue |
            Sort-Object Name -Descending |
            Where-Object { Test-Path (Join-Path $_.FullName 'zipalign.exe') } |
            Select-Object -First 1
        if ($candidate) { return $candidate.FullName }
    }
    throw 'Android Build-Tools introuvable. Définis ANDROID_SDK_ROOT ou AndroidBuildTools dans server.json.'
}

function Get-Keytool([string]$configuredJavaHome) {
    $javaHomes = @($env:JAVA_HOME, $configuredJavaHome) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    foreach ($javaHome in $javaHomes) {
        $candidate = Join-Path (Resolve-ConfigPath $javaHome) 'bin\keytool.exe'
        if (Test-Path $candidate) { return $candidate }
    }
    $keytoolCommand = Get-Command keytool.exe -ErrorAction SilentlyContinue
    if ($keytoolCommand) { return $keytoolCommand.Source }
    throw 'keytool introuvable. Définis JAVA_HOME ou JavaHome dans server.json.'
}

function Find-Bytes([byte[]]$data, [byte[]]$needle) {
    for ($i = 0; $i -le $data.Length - $needle.Length; $i++) {
        $matches = $true
        for ($j = 0; $j -lt $needle.Length; $j++) {
            if ($data[$i + $j] -ne $needle[$j]) { $matches = $false; break }
        }
        if ($matches) { $i }
    }
}

function Replace-Bytes([byte[]]$data, [byte[]]$from, [byte[]]$to) {
    if ($from.Length -ne $to.Length) { throw 'La substitution binaire doit garder exactement la même taille.' }
    $positions = @(Find-Bytes $data $from)
    foreach ($position in $positions) { [Array]::Copy($to, 0, $data, $position, $to.Length) }
    return $positions.Count
}

if (-not (Test-Path $Config)) { throw "Config introuvable : $Config. Copie server.example.json vers server.json." }
$settings = Get-Content -Raw $Config | ConvertFrom-Json
$sourceApk = Resolve-ConfigPath $settings.SourceApk
$workDirectory = Resolve-ConfigPath $settings.WorkDirectory
$outputApk = Resolve-ConfigPath $settings.OutputApk
$keystore = Resolve-ConfigPath $settings.Keystore
$buildTools = Get-AndroidBuildTools $settings.AndroidBuildTools
$apktool = $settings.Apktool
$zipalign = Join-Path $buildTools 'zipalign.exe'
$apksigner = Join-Path $buildTools 'apksigner.bat'
$keytool = Get-Keytool $settings.JavaHome

foreach ($file in @($sourceApk, $zipalign, $apksigner, $keytool)) {
    if (-not (Test-Path $file)) { throw "Prérequis introuvable : $file" }
}
if (-not (Get-Command $apktool -ErrorAction SilentlyContinue) -and -not (Test-Path $apktool)) { throw "APKTool introuvable : $apktool" }

$serverIp = [string]$settings.ServerIp
$publicPort = [int]$settings.PublicPort
$nativePort = [int]$settings.NativePort
if ($nativePort -ne 80) { throw 'NativePort doit rester 80 : le client natif historique utilise ce port.' }
if ($serverIp -notmatch '^\d{1,3}(\.\d{1,3}){3}$') { throw 'ServerIp doit être une IPv4, par exemple 192.168.1.94.' }
$publicBaseUrl = "http://${serverIp}:$publicPort"
$nativeHost = $serverIp
if ($nativeHost.Length -gt 15) { throw "${nativeHost} est trop long pour la chaîne native de 15 caractères. Choisis une IPv4 plus courte ou modifie le binaire manuellement." }
$nativeHost = $nativeHost.PadRight(15, '/')

Remove-Item -Recurse -Force $workDirectory -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $workDirectory | Out-Null
$decoded = Join-Path $workDirectory 'decoded'
$unsignedApk = Join-Path $workDirectory 'unsigned.apk'
$alignedApk = Join-Path $workDirectory 'aligned.apk'

Write-Host "Décompilation de $sourceApk"
& $apktool d -f $sourceApk -o $decoded
if ($LASTEXITCODE -ne 0) { throw 'APKTool n’a pas pu décompiler l’APK.' }

# HSP / bootstrap URLs stored as text resources.
$zoneFile = Join-Path $decoded 'res\xml\hsp_launching_zone.xml'
$launchFile = Join-Path $decoded 'assets\getLaunchingInfos.json'
if (-not (Test-Path $zoneFile) -or -not (Test-Path $launchFile)) { throw 'Structure d’APK inattendue : fichiers HSP introuvables.' }
$zone = Get-Content -Raw $zoneFile
$zone = [regex]::Replace($zone, 'https?://[^"<]+/hsp', "$publicBaseUrl/hsp")
Set-Content -NoNewline -Encoding UTF8 $zoneFile $zone
$launch = Get-Content -Raw $launchFile
$launch = $launch.Replace('http://youtube.com', $publicBaseUrl)
Set-Content -NoNewline -Encoding UTF8 $launchFile $launch

# Native fallback host: exact in-place replacement of wibwob.ddns.net (15 bytes).
$ascii = [Text.Encoding]::ASCII
$oldHost = $ascii.GetBytes('wibwob.ddns.net')
$newHost = $ascii.GetBytes($nativeHost)
$oldHttps = $ascii.GetBytes('https://')
$newHttp = $ascii.GetBytes("http://`0")
$nativeFiles = Get-ChildItem (Join-Path $decoded 'lib') -Recurse -File -Filter 'libSGF.so*'
if (-not $nativeFiles) { throw 'libSGF.so introuvable.' }
$totalHostChanges = 0
foreach ($nativeFile in $nativeFiles) {
    $bytes = [IO.File]::ReadAllBytes($nativeFile.FullName)
    $hostChanges = Replace-Bytes $bytes $oldHost $newHost
    if ($hostChanges -eq 0) {
        Write-Host "$($nativeFile.FullName) : ignoré (hôte WibWob absent)."
        continue
    }
    $httpsChanges = Replace-Bytes $bytes $oldHttps $newHttp
    [IO.File]::WriteAllBytes($nativeFile.FullName, $bytes)
    $totalHostChanges += $hostChanges
    Write-Host "$($nativeFile.Name) : $hostChanges hôte(s), $httpsChanges URL(s) HTTPS convertie(s)."
}
if ($totalHostChanges -eq 0) { throw 'Aucun hôte WibWob trouvé dans les bibliothèques natives. Vérifie l’APK source.' }

Write-Host 'Reconstruction...'
& $apktool b $decoded -o $unsignedApk
if ($LASTEXITCODE -ne 0) { throw 'APKTool n’a pas pu reconstruire l’APK.' }
& $zipalign -f -p 4 $unsignedApk $alignedApk
if ($LASTEXITCODE -ne 0) { throw 'zipalign a échoué.' }

if (-not (Test-Path $keystore)) {
    Write-Host 'Création de la clé de test...'
    & $keytool -genkeypair -keystore $keystore -storepass $settings.KeyPassword -keypass $settings.KeyPassword -alias $settings.KeyAlias -keyalg RSA -keysize 2048 -validity 10000 -dname 'CN=WibWob Custom Test, OU=Development, O=Local Server, C=FR'
    if ($LASTEXITCODE -ne 0) { throw 'Création du keystore impossible.' }
}
& $apksigner sign --ks $keystore --ks-key-alias $settings.KeyAlias --ks-pass "pass:$($settings.KeyPassword)" --key-pass "pass:$($settings.KeyPassword)" --out $outputApk $alignedApk
if ($LASTEXITCODE -ne 0) { throw 'Signature de l’APK impossible.' }
& $apksigner verify --verbose $outputApk
if ($LASTEXITCODE -ne 0) { throw 'Vérification de signature échouée.' }

Write-Host "OK : $outputApk"
Write-Host "Serveur HTTP natif requis : http://${serverIp}:80"
