# APK de test local WibWob Reload

L'APK de test est `wwr_local_test.apk`. Il est signé avec une clé de test locale et pointe vers `http://192.168.1.94:5000`.

Les modifications sont les suivantes :

- `GAMESVR` pointe vers le serveur local ;
- les assets `IMAGE` et `IMAGE_RESIZE` pointent vers `/eal`, servi depuis `WWR_BACKUP/dataDownload` ;
- tous les environnements HSP (`hsp_launching_zone.xml`) pointent vers ce même serveur local ;
- le manifeste autorise déjà le trafic HTTP non chiffré.

## Démarrage

1. Connectez le téléphone et le PC au même Wi-Fi.
2. Démarrez `LANCER_WIBWOB.bat` et gardez l'URL proposée `http://192.168.1.94:5000`.
3. Autorisez le port TCP 5000 dans le pare-feu Windows pour le réseau privé.
4. Installez l'APK avec `INSTALLER_APK_TEST.bat`, ou copiez `wwr_local_test.apk` sur le téléphone.
5. Lancez l'application.

Le premier chargement peut télécharger beaucoup de données depuis la sauvegarde WWR. L'APK ne fonctionnera que tant que le PC conserve l'adresse `192.168.1.94`; si cette adresse change, il faut reconstruire l'APK et modifier l'adresse dans le lanceur.

## Vérification

Depuis le téléphone, ouvrez `http://192.168.1.94:5000/eal/help.html`. Une page doit s'afficher. Si ce test échoue, le jeu ne pourra pas charger les données.

L'APK est signé v1, v2 et v3. Son SHA-256 est :

`96C26509362F5135DFB554F923B4D4B9DAA042D9EF6812FFBDEA6C5AA8821979`

Si une ancienne APK avec le même package (`com.Level5.YWWWUS`) est installée, Android peut refuser la mise à jour à cause de la nouvelle signature. Désinstallez-la uniquement si vous acceptez de perdre ses données locales.
