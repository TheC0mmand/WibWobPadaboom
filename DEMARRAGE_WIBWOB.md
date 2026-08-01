# Installer et démarrer le serveur

**Documentation : Français | [English](DEMARRAGE_WIBWOB.en.md)**

> [!WARNING]
> Ce projet prend en charge la **version anglaise** de Wibble Wobble. Il ne fournit pas de traduction française du jeu.

## 1. Installer les prérequis

Installez :

- .NET SDK 8 ;
- PostgreSQL 18.

Vérifiez ensuite :

```powershell
dotnet --version
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' --version
```

Si PostgreSQL est installé dans une autre version ou un autre dossier, adaptez les chemins des commandes suivantes.

## 2. Configurer le serveur

Copiez `appsettings.example.json` sous le nom `appsettings.Development.json`, puis modifiez au minimum :

```json
{
  "PostgresConnectionString": "Host=127.0.0.1;Port=5432;Database=wibwob;Username=postgres;Password=VOTRE_MOT_DE_PASSE",
  "PublicServerURL": "http://192.168.1.100:5000"
}
```

Remplacez `192.168.1.100` par l’adresse IPv4 du PC obtenue avec `ipconfig`. N’utilisez pas `localhost` pour un téléphone.

## 3. Créer la base

Depuis la racine du projet :

```powershell
& 'C:\Program Files\PostgreSQL\18\bin\createdb.exe' -U postgres wibwob
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -f .\WWR_BACKUP\backup_nomail.sql
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -c 'CREATE TABLE IF NOT EXISTS public.mail (mail text PRIMARY KEY, "currentUdkey" text);'
```

L’import peut prendre plusieurs minutes. N’importez pas `Database/schema.sql` en plus de la sauvegarde.

Si la base existe déjà, ne relancez pas l’import sans sauvegarde : vous risqueriez de créer des doublons ou de remplacer des données.

## 4. Lancer

Double-cliquez sur `LANCER_WIBWOB.bat`. Il ouvre le client administrateur ; cliquez ensuite sur **Demarrer le serveur** dans l'interface.

Pour un lancement manuel sans l'admin, utilisez :

```powershell
$env:ASPNETCORE_ENVIRONMENT = 'Development'
dotnet run --no-launch-profile
```

Arrêtez proprement le serveur avec `Ctrl+C`.

## 5. Vérifier le réseau

Sur le PC :

```text
http://127.0.0.1:5000/eal/help.html
```

Puis sur le téléphone :

```text
http://IP_DU_PC:5000/eal/help.html
```

Si le test local fonctionne mais pas celui du téléphone, vérifiez le pare-feu Windows, le Wi-Fi et l’isolation des appareils du routeur.

## Erreurs fréquentes

| Erreur | Solution |
| --- | --- |
| `NU1100` | Activez `nuget.org`, puis lancez `dotnet restore`. |
| Base `wibwob` inexistante / `3D000` | Créez et importez la base comme indiqué à l’étape 3. |
| Mot de passe refusé / `28P01` | Corrigez le mot de passe dans `PostgresConnectionString`. |
| Port déjà utilisé | Fermez l’autre serveur ou modifiez les ports de la configuration. |
| Page inaccessible sur le téléphone | Utilisez l’IPv4 du PC et autorisez les ports dans le pare-feu. |

Ne publiez jamais `appsettings.Development.json`.
