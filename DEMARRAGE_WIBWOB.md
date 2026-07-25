# Démarrage de WibWob Reload

Le projet utilise directement les tables et les assets de `WWR_BACKUP` : aucune copie supplémentaire des 654 Mo n'est nécessaire.

1. Copiez `appsettings.example.json` en `appsettings.Development.json` et renseignez le mot de passe PostgreSQL ainsi que `PublicServerURL`. Cette URL doit être l'adresse joignable par l'appareil ; pour un téléphone sur le même Wi-Fi, utilisez l'IPv4 du PC, pas `localhost`.
2. Créez une base vide `wibwob`, puis importez **une seule fois** la sauvegarde :

   ```powershell
   & 'C:\Program Files\PostgreSQL\18\bin\createdb.exe' -U postgres wibwob
   & 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -f .\WWR_BACKUP\backup_nomail.sql
   & 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -c 'CREATE TABLE IF NOT EXISTS public.mail (mail text PRIMARY KEY, "currentUdkey" text);'
   ```

   La sauvegarde fait environ 919 Mo et contient les comptes ; n'importez pas `Database\schema.sql` en plus. La dernière commande recrée uniquement la table `mail`, absente par conception de `backup_nomail.sql`, pour que l'authentification par e-mail fonctionne.
3. Lancez 
LANCER_WIBWOB.bat
Le serveur expose aussi les assets archivés sous `http://<adresse>:5000/eal/...`. L'endpoint `init.nhn` annonce désormais cette même URL au client au lieu de `gameserver.yw-p.com`.

Ne rendez pas la base PostgreSQL publique et ne versionnez jamais `appsettings.Development.json`.
