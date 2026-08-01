# WibWob Reload V1.1

**Documentation: [Francais](README.md) | English**

This is the user release folder. Download and extract the release ZIP, then set it up manually. No tool downloads or installs the project automatically.

## Downloads required

- [.NET SDK 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0);
- [PostgreSQL 18 for Windows](https://www.postgresql.org/download/windows/);
- only to rebuild an APK: [Java JDK 21](https://adoptium.net/temurin/releases/?version=21), [Android Studio / SDK](https://developer.android.com/studio), and [JavaTool/ApkTool](./JavaTools.zip).

## Setup

1. [Download the WibWobPadaBoom V1.1 ZIP](https://mega.nz/file/CwpECSQJ#UcNqHXAKcA2nOe-IQrhK7LM9PR16r9IEjTH0qC6Bow0) and extract it to a writable directory.
2. In `appsettings.Development.json`, replace `CHANGE_ME` with the PostgreSQL password and set `PublicServerURL` to the PC's local IPv4 address and port 5000.
3. Run `LANCER_WIBWOB.bat`; it opens the Admin Client.
4. Let the Admin Client initialize the `wibwob` database when needed, then click **Start server**.
5. From a phone on the same Wi-Fi, verify `http://PC_IP:5000/eal/help.html` before opening the APK.

Use `APK/WibWobPadaBoom.apk` or build a custom APK through `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe`.

Keep your configured `appsettings.Development.json`, PostgreSQL database, and `ADMIN_CLIENT/backups` when updating from an older version. Do not re-import `backup_nomail.sql` into a database that already contains accounts.
