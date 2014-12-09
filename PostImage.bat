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

@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

SET /p computer= What's the name of this computer?

ECHO .
SET /p mont= What's the monitor inventory tag?
REG ADD "HKLM\Software\NACSTech\Accessories\Monitors" /F /v Monitor1 /t reg_sz /d %mont%


SET fqdn=%computer%.%domain%
REM Start of the install process for Puppet
ECHO ############################
ECHO .
ECHO !!!Installing puppet!!!
ECHO .
@powershell -NoProfile -ExecutionPolicy unrestricted -Command ./installPuppet.ps1 %fqdn%
ECHO .
ECHO .
ECHO ?!?!Installed Puppet?!?!
ECHO .
ECHO ^^^^^ REMOVING Puppet from Start Menu^^^^^^^^^^^^
ECHO .

rmdir "C:\Documents and Settings\All Users\Start Menu\Programs\Puppet" /s /q

ECHO !#!#!#!#! ALL DONE !#!#!#!#
ECHO .
ECHO ###########################


REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /F /v AutoAdminLogon
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /F /v DefaultPassword
curl http://api.napoleonareaschools.org/imaged/%computername%
