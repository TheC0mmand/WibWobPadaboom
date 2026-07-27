# Construire et installer l’APK locale

**Documentation : Français | [English](TEST_APK_LOCAL.en.md)**

> [!WARNING]
> **Le jeu reste en anglais.** Le choix Français/English du constructeur concerne uniquement son interface et ses journaux.

> [!IMPORTANT]
> Utilisez uniquement une APK source que vous avez le droit d’utiliser. Le projet ne fournit pas l’APK commerciale d’origine.

## Prérequis

- Java JDK 21 avec `JAVA_HOME` configuré ;
- Android SDK Build-Tools avec `ANDROID_SDK_ROOT` configuré ;
- APKTool accessible par le `PATH` ou sélectionné dans l’interface ;
- le serveur et le téléphone sur le même réseau local.

Commandes de vérification :

```powershell
java -version
keytool -help
adb version
zipalign -h
apksigner --help
apktool --version
```

## Préparer le réseau

1. Obtenez l’IPv4 du PC avec `ipconfig`.
2. Utilisez cette adresse dans `PublicServerURL`.
3. Lancez le serveur.
4. Depuis le téléphone, ouvrez :

   ```text
   http://IP_DU_PC:5000/eal/help.html
   ```

Ne construisez pas l’APK tant que cette page n’est pas accessible.

## Utiliser le constructeur

1. Lancez `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe`.
2. Choisissez **Français** ou **English**. Ce choix est mémorisé dans `builder-settings.json`.
3. Sélectionnez l’APK source anglaise.
4. Renseignez l’IPv4 du serveur et le port public, normalement `5000`.
5. Sélectionnez les dossiers Android Build-Tools et Java si leur détection automatique échoue.
6. Sélectionnez `apktool.bat`.
7. Choisissez le chemin de l’APK de sortie.
8. Cliquez sur **Construire l’APK**.

Les textes de l’interface et des journaux propres au builder proviennent de :

```text
CUSTOM_APK_BUILDER/lang/fr.lang
CUSTOM_APK_BUILDER/lang/en.lang
```

Ces deux fichiers doivent rester à côté de l’exécutable, dans le sous-dossier `lang`.

## Installer sur Android

Activez le débogage USB, connectez le téléphone puis exécutez :

```powershell
adb devices
adb install -r .\wwr_custom_server.apk
```

Si Android refuse l’installation en raison d’une signature différente, désinstallez l’ancienne application avant de recommencer. Cette opération supprime ses données locales.

## Dépannage

| Problème | Vérification |
| --- | --- |
| Java introuvable | Vérifiez `JAVA_HOME` et redémarrez le terminal. |
| Build-Tools invalides | Sélectionnez le dossier contenant `zipalign.exe` et `apksigner.bat`. |
| APKTool introuvable | Sélectionnez directement `apktool.bat`. |
| Aucun hôte WibWob trouvé | Vérifiez que l’APK source correspond à la version anglaise prise en charge. |
| Erreur réseau dans le jeu | Vérifiez l’IP, les ports, le pare-feu et reconstruisez l’APK. |
| Fichier `.lang` absent | Remettez le dossier `lang` livré avec le builder. |
