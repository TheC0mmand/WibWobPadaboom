# WibWob Reload V1.1

**Documentation : Francais | [English](README.en.md)**

> [!IMPORTANT]
> ## Installateur Windows avec mise a jour automatique
> L'installateur est disponible ici [Installer](./ServerInstaller.zip) : telechargez et lancez `WibWobInstaller.bat` qui est dans le zip.
>
> A chaque lancement, il recherche une nouvelle version de **l'installateur**, la verifie par SHA-256 puis la relance automatiquement si necessaire. Il ne telecharge pas le projet a votre place : telechargez toujours le ZIP V1.1 ci-dessous et selectionnez-le dans l'installateur.

Serveur local communautaire et experimental pour Yo-kai Watch Wibble Wobble.

> [!WARNING]
> Version anglaise uniquement. Le choix Francais/English du constructeur APK ne traduit que son interface, pas le jeu.

> [!CAUTION]
> Projet non officiel, sans affiliation avec LEVEL-5, NHN PlayArt ou SuperTavor. Utilisez uniquement les fichiers pour lesquels vous avez les droits necessaires.

## Installation V1.1 : manuelle

Il n'y a pas d'installation automatique. Telechargez d'abord la release **WibWobPadaBoom V1.1** depuis le lien de distribution, puis extrayez le ZIP dans un dossier ou vous avez les droits d'ecriture.

[Telecharger WibWobPadaBoom](https://mega.nz/file/24hBnSyA#lRIf9XDH4r-HCx5K6xyKaX3B4pIrPLoH-AAxVk_cQVs)

Utilisez directement le dossier extrait : c'est la version a utiliser et a partager.

## A telecharger avant de commencer

- le ZIP de la release WibWobPadaBoom V1.1 ;
- [.NET SDK 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) ;
- [PostgreSQL 18 pour Windows](https://www.postgresql.org/download/windows/) ;
- seulement pour reconstruire une APK : [Java JDK 21](https://adoptium.net/temurin/releases/?version=21), [Android Studio / SDK](https://developer.android.com/studio) et [APKTool](https://apktool.org/docs/install/).

Python n'est pas necessaire : les outils utilisateur sont deja fournis en `.exe`.

Verifiez les prerequis dans PowerShell :

```powershell
dotnet --version
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' --version
java -version
apktool --version
```

## Demarrage rapide

1. Ouvrez `appsettings.Development.json`.
2. Remplacez `CHANGE_ME` par le mot de passe PostgreSQL choisi a l'installation.
3. Executez `ipconfig`, puis remplacez l'IP de `PublicServerURL` par l'IPv4 du PC, par exemple `http://192.168.1.100:5000`.
4. Double-cliquez sur `LANCER_WIBWOB.bat`. Il ouvre le client administrateur.
5. Dans l'admin, laissez-le creer/importer la base `wibwob` si elle est absente, puis cliquez sur **Demarrer le serveur**.
6. Depuis le telephone connecte au meme Wi-Fi, ouvrez `http://IP_DU_PC:5000/eal/help.html`. Le jeu ne pourra se connecter que si cette page fonctionne.

Les details sont dans [DEMARRAGE_WIBWOB.md](DEMARRAGE_WIBWOB.md) et [TEST_APK_LOCAL.md](TEST_APK_LOCAL.md).

## APK

- `APK/WibWobPadaBoom.apk` est l'APK finale deja construite.
- Pour modifier l'adresse, le port ou reconstruire une APK, lancez `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe` et suivez `TEST_APK_LOCAL.md`.

## Mise a jour depuis une ancienne version

1. Arretez le serveur.
2. Sauvegardez `appsettings.Development.json`, votre base PostgreSQL `wibwob` et `ADMIN_CLIENT/backups` si present.
3. Telechargez et extrayez V1.1 par-dessus une copie de l'ancien projet, ou utilisez un nouveau dossier.
4. Conservez votre ancien `appsettings.Development.json` : ne gardez pas le fichier `CHANGE_ME` fourni par la release.
5. Ne reimportez pas `WWR_BACKUP/backup_nomail.sql` si votre base contient deja vos comptes.
6. Lancez l'admin puis le serveur.

## Changements V1.1

- recompenses de premiere victoire story rechargees au demarrage du serveur ;
- faux drop Orcanos retire du stage 7001001 ;
- Moximous N (stage 1009001) donne la montre `30036` et l'app compatible `10` ;
- dossier de distribution nettoye pour la release manuelle.

## Securite

- Ne partagez jamais `appsettings.Development.json` apres l'avoir configure : il contient le mot de passe PostgreSQL.
- Ne rendez pas PostgreSQL accessible depuis Internet.
- N'ouvrez que les ports HTTP necessaires sur un reseau de confiance.

Configuration et outils locaux : **TheC0mmand**.
