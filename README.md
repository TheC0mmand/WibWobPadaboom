# WibWob Reload V1.1

**Documentation : Francais | [English](README.en.md)**

Ce dossier est la release utilisateur. Il faut le telecharger, le dezipper puis faire l'installation manuellement ; aucun outil ne telecharge ou n'installe automatiquement le projet.

## 1. A telecharger

Avant de lancer le projet, installez :

- [.NET SDK 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) ;
- [PostgreSQL 18 pour Windows](https://www.postgresql.org/download/windows/) ;
- seulement pour reconstruire une APK : [Java JDK 21](https://adoptium.net/temurin/releases/?version=21), [Android Studio / SDK](https://developer.android.com/studio) et [JavaTool/ApkTool](./JavaTools.zip).

Python n'est pas necessaire. Le jeu pris en charge est en anglais.

## 2. Installer manuellement

1. [Telechargez le ZIP WibWobPadaBoom V1.1](https://mega.nz/file/24hBnSyA#lRIf9XDH4r-HCx5K6xyKaX3B4pIrPLoH-AAxVk_cQVs).
2. Dezippez-le dans un dossier writable, par exemple `C:\Games\WibWobReload`.
3. Ouvrez `appsettings.Development.json`.
4. Remplacez `CHANGE_ME` par votre mot de passe PostgreSQL et configurez `PublicServerURL` avec l'IPv4 du PC, par exemple `http://192.168.1.100:5000`.
5. Lancez `LANCER_WIBWOB.bat`. Il ouvre l'admin.
6. L'admin initialise la base `wibwob` si elle n'existe pas. Cliquez ensuite sur **Demarrer le serveur**.

Depuis le telephone sur le meme Wi-Fi, testez `http://IP_DU_PC:5000/eal/help.html` avant de lancer l'APK.

## 3. APK

- APK deja construite : `APK/WibWobPadaBoom.apk`.
- Pour creer votre propre APK : `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe` puis [TEST_APK_LOCAL.md](TEST_APK_LOCAL.md).

## Mise a jour depuis une ancienne version

Arretez le serveur, conservez votre `appsettings.Development.json`, votre base `wibwob` et `ADMIN_CLIENT/backups`. Extrayez ensuite V1.1, remettez votre configuration et ne reimportez pas `backup_nomail.sql` sur une base contenant deja des comptes.

## Contenu utile

- `Src`, `Properties`, `Puniemu.csproj` : serveur ;
- `WWR_BACKUP` : base et ressources ;
- `ADMIN_CLIENT` : administration et lancement ;
- `CUSTOM_APK_BUILDER` : constructeur APK ;
- `APK` : APK preconstruite.

Ne partagez pas `appsettings.Development.json` une fois configure.
