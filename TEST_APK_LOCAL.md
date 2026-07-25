# APK locale — guide rapide (avant la vidéo)

Ce guide permet de fabriquer une APK de test qui se connecte à **votre serveur WibWob Reload local**. Lisez-le entièrement une première fois : l’adresse IP du serveur est intégrée dans l’APK.

> [!IMPORTANT]
> Le téléphone et le serveur doivent être sur le même Wi-Fi. Si le serveur tourne dans une machine virtuelle, la carte réseau de la VM doit être en mode **Bridged / Pont**, sur la carte Wi-Fi physique.

## 1. Préparer le serveur

1. Dans la VM ou sur le PC serveur, exécutez `ipconfig` et notez son adresse IPv4 locale, par exemple `192.168.1.144`.
2. Dans `appsettings.Development.json`, adaptez :

   ```json
   "PublicServerURL": "http://192.168.1.144:5000",
   "Urls": "http://0.0.0.0:80;http://0.0.0.0:5000"
   ```

3. Lancez `LANCER_WIBWOB.bat`.
4. Autorisez les deux ports dans le pare-feu Windows de la machine qui héberge le serveur :

   ```powershell
   netsh advfirewall firewall add rule name="WibWob HTTP 80" dir=in action=allow protocol=TCP localport=80
   netsh advfirewall firewall add rule name="WibWob HTTP 5000" dir=in action=allow protocol=TCP localport=5000
   ```

5. Depuis le navigateur du téléphone, ouvrez :

   ```text
   http://192.168.1.144:5000/eal/help.html
   ```

   La page doit s’ouvrir avant de construire l’APK. Sinon, corrigez le réseau ou le pare-feu d’abord.

## 2. Installer les outils APK sur Windows

Ces outils servent uniquement à construire l’APK. Le serveur C# utilise aussi .NET 8, mais pas Java ni Android Studio.

### Java 21

1. Installez **Eclipse Temurin JDK 21**.
2. Créez la variable utilisateur `JAVA_HOME` avec le dossier du JDK, par exemple :

   ```text
   C:\Program Files\Eclipse Adoptium\jdk-21
   ```

3. Ajoutez `%JAVA_HOME%\bin` dans la variable utilisateur `Path`.
4. Fermez puis rouvrez PowerShell, puis vérifiez :

   ```powershell
   java -version
   keytool -help
   ```

### Android Studio et Android SDK

1. Installez **Android Studio**.
2. Ouvrez Android Studio → **More Actions** → **SDK Manager**.
3. Dans **SDK Tools**, installez :
   - Android SDK Platform-Tools ;
   - Android SDK Build-Tools (36.0.0 ou la version la plus récente) ;
   - Android SDK Command-line Tools.
4. Notez le chemin du SDK, habituellement :

   ```text
   C:\Users\VOTRE_NOM\AppData\Local\Android\Sdk\buildtools
   ```

5. Créez la variable utilisateur `ANDROID_SDK_ROOT` avec ce chemin.
6. Ajoutez au `Path` utilisateur :

   ```text
   %ANDROID_SDK_ROOT%\platform-tools
   %ANDROID_SDK_ROOT%\build-tools\36.0.0
   ```

7. Rouvrez PowerShell et vérifiez :

   ```powershell
   adb version
   zipalign -h
   apksigner --help
   ```

### APKTool

Installez APKTool puis ajoutez son dossier au `Path`. La commande suivante doit fonctionner dans un nouveau terminal :

```powershell
apktool --version
```

> [!TIP]
> Le nouveau builder recherche Java via `JAVA_HOME`, Android via `ANDROID_SDK_ROOT` / `ANDROID_HOME`, et APKTool via le `Path`. Vous n’avez donc normalement pas besoin de modifier les chemins Android/Java dans `server.json`.

## 3. Construire l’APK personnalisée

1. Placez l’APK d’origine dans le dossier principal du projet.
2. Ouvrez `CUSTOM_APK_BUILDER/server.example.json` et copiez-le sous le nom `server.json` dans le même dossier.
3. Dans `server.json`, adaptez au minimum :

   ```json
   {
     "SourceApk": "..\\MonApkOriginale.apk",
     "ServerIp": "192.168.1.144",
     "PublicPort": 5000,
     "NativePort": 80
   }
   ```

   Gardez les antislashs doublés (`\\`) : c’est obligatoire dans un fichier JSON Windows.

4. Lancez `CUSTOM_APK_BUILDER/BUILD_CUSTOM_APK.bat`.
5. Le fichier final est créé à la racine du projet :

   ```text
   wwr_custom_server.apk
   ```

Le script décompile l’APK, remplace les URL HSP et les ressources, modifie l’adresse native, reconstruit, aligne puis signe l’APK avec une clé de test locale.

## 4. Installer sur le téléphone

1. Activez les **Options développeur** et le **Débogage USB** sur Android.
2. Branchez le téléphone en USB et acceptez l’empreinte RSA.
3. Vérifiez qu’il apparaît :

   ```powershell
   adb devices
   ```

4. Installez l’APK :

   ```powershell
   adb install -r .\wwr_custom_server.apk
   ```

Si Android indique une signature différente pour `com.Level5.YWWWUS`, désinstallez l’ancienne APK dans les réglages Android, puis réinstallez. **Cela efface les données locales de cette application.**

## Dépannage express

| Symptôme | Vérification |
| --- | --- |
| `java` ou `keytool` introuvable | Vérifiez `JAVA_HOME`, `%JAVA_HOME%\bin` dans `Path`, puis rouvrez le terminal. |
| `AndroidBuildTools invalide` | Laissez `AndroidBuildTools` vide dans `server.json` et définissez `ANDROID_SDK_ROOT`. |
| `apktool` introuvable | Ajoutez APKTool au `Path`, puis rouvrez le terminal. |
| `help.html` inaccessible sur le téléphone | Vérifiez le bridge de la VM, l’IP, le Wi-Fi et le pare-feu sur 80/5000. |
| L’APK affiche une erreur réseau | Vérifiez que `ServerIp` dans `server.json` est exactement l’IP de la machine/VM qui lance le serveur, puis reconstruisez l’APK. |

Une vidéo de démonstration sera ajoutée plus tard ; ce guide permet de tout tester dès maintenant.
