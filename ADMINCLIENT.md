# Client administrateur WibWob Reload

**Documentation : Français | [English](README.en.md)**

Le client admin permet de gérer les comptes du serveur PostgreSQL local.

> [!WARNING]
> Le projet prend en charge la **version anglaise** du jeu. Le client admin ne traduit pas les données du jeu.

## Démarrage

1. Configurez et importez PostgreSQL selon `../DEMARRAGE_WIBWOB.md`.
2. Arrêtez le serveur avant toute modification directe de la base.
3. Lancez `WibWobAdmin-Obfuscated.exe`.

Python n’est pas nécessaire pour utiliser l’exécutable de la release.

## Fonctions principales

- démarrage et arrêt du serveur local ;
- recherche et consultation des comptes ;
- modification des ressources d’un joueur ;
- ajout d’objets ;
- modification du niveau, des HP et de l’attaque d’un Yo-kai possédé ;
- déblocage de progression ;
- transfert d’une sauvegarde entre deux comptes ;
- réparation ou restauration de la base.

## Sauvegardes et sécurité

- Une sauvegarde est créée avant les opérations sensibles.
- Ne publiez jamais le contenu du dossier `backups`.
- Ne partagez jamais un GDKey, un mot de passe PostgreSQL ou `appsettings.Development.json`.
- Seul le serveur démarré depuis le client admin peut être arrêté par son bouton d’arrêt.

## Important

Lorsque le serveur fonctionne, les comptes chargés sont conservés en mémoire. Une modification directe dans PostgreSQL peut alors être écrasée par le cache du serveur. Arrêtez toujours le serveur avant d’enregistrer une modification.

Le fichier `WibWobAdmin.py` est destiné au développement. La release publique doit distribuer `WibWobAdmin-Obfuscated.exe`, construit depuis le source intermédiaire obscurci.
