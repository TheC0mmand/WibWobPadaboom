# Installing and starting the server

**Documentation: [Français](DEMARRAGE_WIBWOB.md) | English**

> [!WARNING]
> This project supports the **English version** of Wibble Wobble. It does not provide a French translation of the game.

## 1. Install the requirements

Install .NET SDK 8 and PostgreSQL 18, then check:

```powershell
dotnet --version
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' --version
```

Adjust the paths if PostgreSQL is installed elsewhere.

## 2. Configure the server

Copy `appsettings.example.json` to `appsettings.Development.json`, then configure:

```json
{
  "PostgresConnectionString": "Host=127.0.0.1;Port=5432;Database=wibwob;Username=postgres;Password=YOUR_PASSWORD",
  "PublicServerURL": "http://192.168.1.100:5000"
}
```

Replace `192.168.1.100` with the PC’s IPv4 address shown by `ipconfig`. Do not use `localhost` for a phone.

## 3. Create the database

From the project root:

```powershell
& 'C:\Program Files\PostgreSQL\18\bin\createdb.exe' -U postgres wibwob
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -f .\WWR_BACKUP\backup_nomail.sql
& 'C:\Program Files\PostgreSQL\18\bin\psql.exe' -U postgres -d wibwob -c 'CREATE TABLE IF NOT EXISTS public.mail (mail text PRIMARY KEY, "currentUdkey" text);'
```

The import can take several minutes. Do not also import `Database/schema.sql`.

## 4. Start the server

Double-click `LANCER_WIBWOB.bat`. It opens the Admin Client; then click **Start server** in the interface.

For a manual start without the Admin Client, run:

```powershell
$env:ASPNETCORE_ENVIRONMENT = 'Development'
dotnet run --no-launch-profile
```

Stop the server cleanly with `Ctrl+C`.

## 5. Test the network

On the PC, open:

```text
http://127.0.0.1:5000/eal/help.html
```

On the phone, open:

```text
http://PC_IP:5000/eal/help.html
```

If only the local test works, check Windows Firewall, Wi-Fi, and router client isolation.

## Common errors

| Error | Solution |
| --- | --- |
| `NU1100` | Enable `nuget.org`, then run `dotnet restore`. |
| Database `wibwob` does not exist / `3D000` | Create and import the database as described above. |
| Password rejected / `28P01` | Correct the password in `PostgresConnectionString`. |
| Port already in use | Stop the other server or change the configured ports. |
| Phone cannot open the test page | Use the PC’s IPv4 address and allow the ports through the firewall. |

Never publish `appsettings.Development.json`.
