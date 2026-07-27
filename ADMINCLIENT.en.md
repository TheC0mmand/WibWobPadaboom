# WibWob Reload Admin Client

**Documentation: [Français](README.md) | English**

The Admin Client manages accounts stored in the local PostgreSQL server.

> [!WARNING]
> The project supports the **English game version**. The Admin Client does not translate game data.

## Starting

1. Configure and import PostgreSQL according to `README.en.md`.
2. Stop the server before directly modifying the database.
3. Run `WibWobAdmin.exe`.

Python is not required to use the release executable.

## Main features

- start and stop the local server;
- search and inspect accounts;
- edit player resources;
- give items;
- edit the level, HP, and attack of an owned Yo-kai;
- unlock progression;
- transfer save data between two accounts;
- repair or restore the database.

## Backups and security

- A backup is created before sensitive operations.
- Never publish the contents of the `backups` folder.
- Never share a GDKey, PostgreSQL password, or `appsettings.Development.json`.
- The stop button can stop only a server started by the Admin Client.

## Important

The running server keeps loaded accounts in memory. A direct PostgreSQL edit can therefore be overwritten by the server cache. Always stop the server before saving a modification.
