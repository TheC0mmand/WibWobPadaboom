# WibWob Reload V1.1

**Documentation: [Francais](README.md) | English**

Community-made experimental local server for Yo-kai Watch Wibble Wobble.

> [!WARNING]
> English game version only. The French/English APK Builder setting only changes its user interface; it does not translate the game.

## V1.1 manual installation

There is no automatic installation. Download the **WibWobPadaBoom V1.1** release ZIP from the distribution link, then extract it to a writable folder. If the archive contains a `production` folder, use that folder.

[Download WibWobPadaBoom](https://mega.nz/file/24hBnSyA#lRIf9XDH4r-HCx5K6xyKaX3B4pIrPLoH-AAxVk_cQVs)

Download before starting:

- [.NET SDK 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0);
- [PostgreSQL 18 for Windows](https://www.postgresql.org/download/windows/);
- only to rebuild an APK: [Java JDK 21](https://adoptium.net/temurin/releases/?version=21), [Android Studio / SDK](https://developer.android.com/studio), and [APKTool](https://apktool.org/docs/install/).

Python is not required for the provided user executables.

## Quick start

1. Edit `appsettings.Development.json`: replace `CHANGE_ME` with the PostgreSQL password and set `PublicServerURL` to your PC's local IPv4 address and port 5000.
2. Run `LANCER_WIBWOB.bat`. It opens the Admin Client.
3. Let the Admin Client create/import the `wibwob` database if needed, then click **Start server**.
4. On a phone connected to the same Wi-Fi, open `http://PC_IP:5000/eal/help.html`. The game can connect only after this test succeeds.

See [DEMARRAGE_WIBWOB.en.md](DEMARRAGE_WIBWOB.en.md) and [TEST_APK_LOCAL.en.md](TEST_APK_LOCAL.en.md) for the detailed guides.

## V1.1 changes

- story first-clear rewards are loaded at server startup;
- the fake Orcanos reward was removed from stage 7001001;
- Moximous N stage 1009001 grants watch item `30036` and compatible app `10`;
- the `production` folder is the clean manual distribution package.

Do not share a configured `appsettings.Development.json`: it contains the PostgreSQL password.

Local configuration and tools: **TheC0mmand**.
