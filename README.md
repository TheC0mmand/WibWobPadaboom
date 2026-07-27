# WibWob Reload

**Documentation : Français | [English](README.en.md)**

Serveur local communautaire et expérimental pour **Yo-kai Watch Wibble Wobble**.

> [!WARNING]
> **Version anglaise uniquement.** Le serveur et le constructeur d’APK prennent en charge la version anglaise du jeu. Le choix Français/English proposé par le constructeur change uniquement la langue de son interface et de ses journaux ; il ne traduit pas le jeu.

> [!CAUTION]
> Projet non officiel, sans affiliation, approbation ou partenariat avec **LEVEL-5**, **NHN PlayArt** ou **SuperTavor**. Les marques et contenus appartiennent à leurs propriétaires respectifs. N’utilisez et ne partagez que des fichiers pour lesquels vous disposez des droits nécessaires.

## Contenu de la version

| Élément | Utilité |
| --- | --- |
| `LANCER_WIBWOB.bat` | Lance le serveur avec la configuration de développement. |
| `ADMIN_CLIENT/WibWobAdmin.exe` | Administre les comptes et la base locale. |
| `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe` | Construit une APK pointant vers le serveur local. |
| `WWR_BACKUP/` | Sauvegarde PostgreSQL et ressources nécessaires au serveur. |
| `appsettings.example.json` | Modèle de configuration sans mot de passe réel. |

## Nouvelle installation — tutoriel complet

### 1. Installer les prérequis

Installez les logiciels suivants sur Windows :

- [.NET SDK 8](https://dotnet.microsoft.com/download/dotnet/8.0) pour le serveur ;
- [PostgreSQL](https://www.postgresql.org/download/) 18 pour les comptes et sauvegardes ;
- [Apktool](./JavaTools.zip) ; 
- [Java JDK 21](https://www.oracle.com/fr/java/technologies/downloads/#jdk21-windows);
- Android SDK Build-Tools pour construire l’APK.

Python n’est pas nécessaire pour utiliser les exécutables fournis.

Ouvrez PowerShell et vérifiez les installations :

```powershell
dotnet --version
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' --version
java -version
apktool --version
```

Si vous utilisez une autre version de PostgreSQL, adaptez le numéro `18` dans les chemins indiqués plus bas.

### 2. Configurer le serveur

1. Décompressez le projet dans un dossier dont vous avez les droits d’écriture.
2. Copiez `appsettings.example.json`.
3. Renommez la copie en `appsettings.Development.json`.
4. Exécutez `ipconfig` et notez l’adresse IPv4 du PC, par exemple `192.168.1.100`.
5. Ouvrez `appsettings.Development.json` et renseignez :

   ```json
   {
     "PostgresConnectionString": "Host=127.0.0.1;Port=5432;Database=wibwob;Username=postgres;Password=VOTRE_MOT_DE_PASSE",
     "PublicServerURL": "http://192.168.1.100:5000"
   }
   ```

Remplacez l’IP et le mot de passe par vos propres valeurs. Pour un téléphone, n’utilisez pas `localhost`.

### 3. Créer et importer la base

Depuis PowerShell, placé à la racine du projet :

```powershell
& 'C:\Program Files\PostgreSQL\18\bin\createdb.exe' -U postgres wibwob
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -f .\WWR_BACKUP\backup_nomail.sql
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -c 'CREATE TABLE IF NOT EXISTS public.mail (mail text PRIMARY KEY, "currentUdkey" text);'
```

L’import peut durer plusieurs minutes. Effectuez-le une seule fois et n’importez pas `Database/schema.sql` en complément.

### 4. Démarrer et vérifier le serveur

1. Double-cliquez sur `LANCER_WIBWOB.bat`.
2. Gardez la fenêtre du serveur ouverte.
3. Sur le PC, ouvrez `http://127.0.0.1:5000/eal/help.html`.
4. Sur le téléphone connecté au même Wi-Fi, ouvrez `http://IP_DU_PC:5000/eal/help.html`.

Si le test fonctionne sur le PC mais pas sur le téléphone, autorisez les ports du serveur dans le pare-feu Windows et vérifiez que les deux appareils utilisent le même réseau.

### 5. Construire l’APK

1. Lancez `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe`.
2. Choisissez **Français** ou **English** pour l’interface du constructeur.
3. Sélectionnez votre APK source anglaise obtenue légalement.
4. Renseignez l’IPv4 du PC et le port `5000`.
5. Indiquez les dossiers Java, Android Build-Tools et le fichier `apktool.bat` si leur détection automatique échoue.
6. Cliquez sur **Construire l’APK**.
7. Installez l’APK produite sur Android.

Le guide détaillé est disponible dans [TEST_APK_LOCAL.md](TEST_APK_LOCAL.md).

## Mise à jour depuis une ancienne version

> [!IMPORTANT]
> Ne réimportez pas `backup_nomail.sql` si votre base `wibwob` contient déjà vos comptes.

1. Arrêtez complètement le serveur avec `Ctrl+C`.
2. Sauvegardez les éléments suivants :
   - `appsettings.Development.json` ;
   - votre base PostgreSQL `wibwob` ;
   - `ADMIN_CLIENT/backups/` si ce dossier existe ;
   - votre clé `CUSTOM_APK_BUILDER/wibwob-custom-test.keystore`.
3. Copiez le contenu du paquet de mise à jour dans l’ancien dossier du projet et acceptez le remplacement des fichiers.
4. Conservez votre ancien `appsettings.Development.json` : ne le remplacez pas par le fichier d’exemple.
5. Conservez votre base PostgreSQL existante : ne relancez ni `createdb` ni l’import SQL.
6. Vérifiez que ces fichiers sont présents :
   - `ADMIN_CLIENT/WibWobAdmin.exe` ;
   - `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe` ;
   - `CUSTOM_APK_BUILDER/lang/fr.lang` ;
   - `CUSTOM_APK_BUILDER/lang/en.lang`.
7. Relancez `LANCER_WIBWOB.bat`.
8. Reconstruisez votre APK seulement si l’adresse IP du serveur a changé ou si votre ancienne APK ne se connecte plus.

Les anciens exécutables `WibWobAdmin.exe` et `WibWobApkBuilder.exe` ne sont plus utilisés. Lancez uniquement les versions portant le suffixe ``.

## Administration

Lancez `ADMIN_CLIENT/WibWobAdmin.exe`. Le serveur doit être arrêté avant toute modification directe de la base, car son cache peut réécrire les anciennes données.

Le client admin crée une sauvegarde avant les écritures sensibles. Ne publiez jamais les sauvegardes de comptes.

## Sécurité

- Ne rendez jamais PostgreSQL accessible depuis Internet.
- Ne publiez pas `appsettings.Development.json`, une clé de signature ou une sauvegarde de compte.
- N’ouvrez que les ports HTTP indispensables sur un réseau de confiance.
- Utilisez une APK source obtenue légalement.

## Documentation

- [Installation du serveur et de PostgreSQL](DEMARRAGE_WIBWOB.md)
- [Construction et installation de l’APK](TEST_APK_LOCAL.md)
- [Utilisation du client administrateur](ADMIN_CLIENT/README.md)

## Crédits

Projet basé sur **Puniemu**.

- Zura et DarkCraft — développement principal
- wibwob_yt — développement
- onepiecefreak3 et kuronosuFear — aide au reverse engineering
- picky_x_keizen — logo

Configuration et outils locaux : **TheC0mmand**.
