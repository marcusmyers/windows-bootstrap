@ECHO OFF
SET domain=nas.local

ECHO .
ECHO Welcome to the parcc setup script info!
ECHO .
ECHO Before we start lets get some basic information about
ECHO this computer. Also keep in mind all responses *ARE*
ECHO case sensitive. Before we get started lets install
ECHO Chocolatey...
ECHO .

REG ADD "HKLM\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /F /v ExecutionPolicy /t reg_sz /d "Unrestricted"

ECHO.
ECHO Setup ChocolateyInstall variable
SET ChocolateyInstall=C:\Chocolatey
ECHO .

ECHO .
ECHO Update Chocolatey
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" 
ECHO .

ECHO .
ECHO Create parcc user
net user parcc testing /add
ECHO parcc user created
ECHO .

ECHO Install Firfox 34.05.20141222
choco install firefox -Version 34.05.20141222
ECHO Firfox installed

ECHO .
ECHO Install Javaruntime 7.0.71
choco install javaruntime -Version 7.0.71
ECHO Installed JRE 7.0.71
