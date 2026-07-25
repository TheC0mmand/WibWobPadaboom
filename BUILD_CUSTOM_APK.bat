@echo off
cd /d "%~dp0"
if not exist server.json (
  copy /y server.example.json server.json >nul
  echo server.json a ete cree. Modifie ServerIp, puis relance ce fichier.
  echo Les chemins Java et Android sont detectes depuis JAVA_HOME, ANDROID_SDK_ROOT ou le PATH.
  notepad server.json
  pause
  exit /b 0
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build-CustomApk.ps1" -Config "%~dp0server.json"
pause
