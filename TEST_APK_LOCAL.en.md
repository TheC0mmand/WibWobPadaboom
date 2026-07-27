# Building and installing the local APK

**Documentation: [Français](TEST_APK_LOCAL.md) | English**

> [!WARNING]
> **The game remains in English.** The Français/English choice affects only the Builder interface and logs.

> [!IMPORTANT]
> Use only a source APK you are legally allowed to use. This project does not provide the original commercial APK.

## Requirements

- Java JDK 21 with `JAVA_HOME` configured;
- Android SDK Build-Tools with `ANDROID_SDK_ROOT` configured;
- APKTool available through `PATH` or selected in the interface;
- the server and phone connected to the same local network.

Check the tools:

```powershell
java -version
keytool -help
adb version
zipalign -h
apksigner --help
apktool --version
```

## Prepare the network

1. Find the PC’s IPv4 address with `ipconfig`.
2. Use this address in `PublicServerURL`.
3. Start the server.
4. From the phone, open `http://PC_IP:5000/eal/help.html`.

Do not build the APK until this page is accessible.

## Use the APK Builder

1. Run `CUSTOM_APK_BUILDER/WibWobApkBuilder.exe`.
2. Choose **Français** or **English**. The choice is saved in `builder-settings.json`.
3. Select the supported English source APK.
4. Enter the server IPv4 address and public port, normally `5000`.
5. Select Android Build-Tools, Java, and `apktool.bat` if automatic detection fails.
6. Select the output APK path.
7. Click **Build APK**.

The Builder’s own interface and log messages are loaded from:

```text
CUSTOM_APK_BUILDER/lang/fr.lang
CUSTOM_APK_BUILDER/lang/en.lang
```

Keep the `lang` folder beside the executable.

## Install on Android

Enable USB debugging, connect the phone, then run:

```powershell
adb devices
adb install -r .\wwr_custom_server.apk
```

If Android reports a different signature, uninstall the previous application before trying again. Uninstalling deletes its local application data.

## Troubleshooting

| Problem | Check |
| --- | --- |
| Java not found | Check `JAVA_HOME`, then restart the terminal. |
| Invalid Build-Tools | Select the folder containing `zipalign.exe` and `apksigner.bat`. |
| APKTool not found | Select the `apktool.bat` file directly. |
| No WibWob host found | Confirm the source APK is the supported English version. |
| Network error in game | Check the IP, ports, firewall, then rebuild the APK. |
| Missing `.lang` file | Restore the `lang` folder delivered with the Builder. |
