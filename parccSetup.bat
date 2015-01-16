@ECHO OFF
SET domain=nas.local

ECHO .
ECHO Welcome to the post image/domain script info!
ECHO .
ECHO Before we start lets get some basic information about
ECHO this computer. Also keep in mind all responses *ARE*
ECHO case sensitive. Before we get started lets install
ECHO Chocolatey...
ECHO .

REG ADD "HKLM\Software\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /F /v ExecutionPolicy /t reg_sz /d "Unrestricted"

@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" 
