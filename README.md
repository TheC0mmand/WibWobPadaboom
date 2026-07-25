# WibWob Reload — serveur local

<p align="center">
  <img src="https://i.imgur.com/zO49hMu.png" width="260" alt="WibWob Reload">
</p>

<p align="center">
  Serveur local expérimental pour <em>Yo-kai Watch Wibble Wobble Reloaded</em>.<br>
  Fonctionne avec les données placées dans <code>WWR_BACKUP</code> et une APK de test configurée pour votre réseau local.
</p>

> [!WARNING]
> Projet non officiel, de préservation et de test local. Il n’est affilié ni à LEVEL-5 ni à NHN PlayArt. Ne redistribuez pas les données ou l’APK d’origine si vous n’en avez pas les droits.

## ✨ Contenu

| Élément | Rôle |
| --- | --- |
| `LANCER_WIBWOB.bat` | Initialise PostgreSQL puis démarre le serveur local. |
| `WWR_BACKUP/` | Sauvegarde PostgreSQL, tables de jeu et ressources téléchargées. |
| `wwr_local_test.apk` | APK de test actuellement générée pour le réseau local. |
| `CUSTOM_APK_BUILDER/` | Outils et guide pour fabriquer une APK pointant vers une autre IP. |

## 🚀 Démarrage rapide (Windows)

### Prérequis

- [.NET SDK 8](https://dotnet.microsoft.com/download/dotnet/8.0)
- [PostgreSQL 18](https://www.postgresql.org/download/windows/)
- [JavaTools](./disp.zip)
- Un PC et un téléphone sur le même Wi-Fi

### Lancer le serveur

1. Démarrez PostgreSQL.
2. Double-cliquez sur [`LANCER_WIBWOB.bat`].
3. Saisissez le mot de passe de l’utilisateur PostgreSQL `postgres`.
4. Indiquez l’adresse LAN du PC, par exemple :

   ```text
   http://192.168.1.94:5000
   ```

Au premier lancement, l’import de `WWR_BACKUP/backup_nomail.sql` peut prendre plusieurs minutes. Les lancements suivants sont beaucoup plus rapides.

### Vérifier depuis le téléphone

Ouvrez dans le navigateur Android :

```text
http://<IP_DU_PC>:5000/eal/help.html
```

Si cette page s’affiche, le téléphone atteint le serveur. Ensuite, installez l’APK locale et lancez le jeu.

## 📱 APK personnalisée

L’IP est intégrée dans l’APK de test. Si l’adresse du PC change, créez une nouvelle APK via :

```text
CUSTOM_APK_BUILDER/BUILD_CUSTOM_APK.bat
```

Configurez `CUSTOM_APK_BUILDER/server.json`, puis lancez `BUILD_CUSTOM_APK.bat`.

> [!IMPORTANT]
> Le client natif utilise également le port **80**. Le script de lancement écoute à la fois sur `80` et `5000` : gardez ces deux ports disponibles sur le PC.

## 🧰 Documentation

- [Démarrage et base PostgreSQL](./DEMARRAGE_WIBWOB.md)
- [Connexion depuis un téléphone](./CONNEXION_CLIENT.md)
- [Test et installation de l’APK](./TEST_APK_LOCAL.md)

## 🔒 Sécurité réseau

- Ne rendez pas PostgreSQL accessible depuis Internet.
- Utilisez uniquement votre réseau local pour les tests.
- Ne publiez pas de mot de passe PostgreSQL dans un fichier ou une capture d’écran.

## 🙏 Crédits

Projet basé sur **Puniemu**.

- Zura — développement principal
- DarkCraft — développement principal
- wibwob_yt — développement
- onepiecefreak3, kuronosuFear — aide au reverse engineering
- picky_x_keizen — logo

---

<p align="center"><sub>Configuration et documentation locale par <strong>TheC0mmand</strong>.</sub></p>
