# WibWob Reload ( Video will be uploaded soon )
**Tutorial if you had an old version of the project**
[Updating from an older version](#updating-from-an-older-version)


**Documentation: [Français](README.md) | English**

A community-made, experimental local server for **Yo-kai Watch Wibble Wobble**.

> [!WARNING]
> **English game version only.** The server and APK Builder support the English version of the game. The Français/English option changes only the Builder interface and its logs; it does not translate the game.

> [!CAUTION]
> This is an unofficial project with no affiliation, endorsement, or partnership with **LEVEL-5**, **NHN PlayArt**, or **SuperTavor**. All trademarks and content belong to their respective owners. Only use and share files you are legally allowed to use.

## Release contents

| Item | Purpose |
| --- | --- |
| `LANCER_WIBWOB.bat` | Starts the server with the Development configuration. |
| `ADMIN_CLIENT/WibWobAdmin.exe` | Manages local accounts and the database. |
| `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe` | Builds an APK configured for the local server. |
| `WWR_BACKUP/` | PostgreSQL backup and resources required by the server. |
| `appsettings.Development.json` | Configuration template without real credentials. |

## New installation

### 1. Install the requirements

Install the following software on Windows:

- [WibWobPadaBoom](https://mega.nz/file/rtY3kTJD#nksXNAaiLicizXbpOXbwk2wGUEsVD5STt1cur8YEbIw) the main project unzip it;
- [.NET SDK 8](https://dotnet.microsoft.com/download/dotnet/8.0) for the server ;
- [PostgreSQL](https://www.postgresql.org/download/) 18 for account and saves ;
- [Apktool](./JavaTools.zip) ; 
- [Java JDK 21](https://www.oracle.com/fr/java/technologies/downloads/#jdk21-windows);
- Android SDK Build-Tools to build the apk.

Python is not required to use the provided executables.

Check the installations in PowerShell:

```powershell
dotnet --version
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' --version
java -version
apktool --version
```

If you use a different PostgreSQL version, adjust `18` in the paths below.

### 2. Configure the server

1. Extract the project into a folder where you have write permission.
2. Copy `appsettings.example.json`.
3. Rename the copy to `appsettings.Development.json`.
4. Run `ipconfig` and note the computer’s IPv4 address, for example `192.168.1.100`.
5. Open `appsettings.Development.json` and configure at least:

   ```json
   {
     "PostgresConnectionString": "Host=127.0.0.1;Port=5432;Database=wibwob;Username=postgres;Password=PASSWORD",
     "PublicServerURL": "http://LOCALIP:5000"
   }
   ```

Replace the IP address and password with your own values. Do not use `localhost` for a phone.

### 3. Create and import the database

From PowerShell in the project root:

```powershell
& 'C:\Program Files\PostgreSQL\18\bin\createdb.exe' -U postgres wibwob
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -f .\WWR_BACKUP\backup_nomail.sql
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -c 'CREATE TABLE IF NOT EXISTS public.mail (mail text PRIMARY KEY, "currentUdkey" text);'
```

The import may take several minutes. Run it only once and do not import `Database/schema.sql` afterward.

### 4. Start and test the server

1. Double-click `LANCER_WIBWOB.bat`.
2. Keep the server window open.
3. On the PC, open `http://127.0.0.1:5000/eal/help.html`.
4. On a phone connected to the same Wi-Fi, open `http://LOCALIP:5000/eal/help.html`.

If the PC test works but the phone test does not, allow the server ports through Windows Firewall and confirm both devices are on the same network.

### 5. Build the APK

1. Run `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe`.
2. Choose **Français** or **English** for the Builder interface.
3. Select a legally obtained English source APK.
4. Enter the PC’s IPv4 address and port `5000`.
5. Select Java, Android Build-Tools, and `apktool.bat` if automatic detection fails.
6. Click **Build APK**.
7. Install the generated APK on Android.

See [TEST_APK_LOCAL.en.md](TEST_APK_LOCAL.en.md) for the detailed guide.

## Updating from an older version

> [!IMPORTANT]
> Do not import `backup_nomail.sql` again if your existing `wibwob` database already contains accounts.

1. Stop the server completely with `Ctrl+C`.
2. Back up:
   - `appsettings.Development.json`;
   - the PostgreSQL `wibwob` database;
   - `ADMIN_CLIENT/backups/`, if present;
   - `CUSTOM_APK_BUILDER/wibwob-custom-test.keystore`.
3. Copy the update package into the old project folder and allow it to replace files.
4. Keep your existing `appsettings.Development.json`.
5. Keep your existing PostgreSQL database; do not run `createdb` or the SQL import again.
6. Confirm these files are present:
   - `ADMIN_CLIENT/WibWobAdmin.exe`;
   - `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe`;
   - `CUSTOM_APK_BUILDER/lang/fr.lang`;
   - `CUSTOM_APK_BUILDER/lang/en.lang`.
7. Start `LANCER_WIBWOB.bat`.
8. Rebuild the APK only if the server IP changed or the previous APK no longer connects.

## Administration

Run `ADMIN_CLIENT/WibWobAdmin.exe`. Stop the server before directly modifying the database because the server cache can overwrite external changes.

The Admin Client creates backups before sensitive operations. Never publish account backups.

## Security

- Never expose PostgreSQL to the Internet.
- Never publish `appsettings.Development.json`, signing keys, or account backups.
- Open only the required HTTP ports on a trusted network.
- Use a legally obtained source APK.

## Documentation

- [APK building and installation](TEST_APK_LOCAL.en.md)
- [Admin Client guide](ADMINCLIENT.en.md)

## Credits

Based on **Puniemu**.

- Zura and DarkCraft — lead development
- wibwob_yt — development
- onepiecefreak3 and kuronosuFear — reverse-engineering assistance
- picky_x_keizen — logo

Local configuration and tools: **TheC0mmand**.
