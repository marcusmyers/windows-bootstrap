@ECHO OFF
SET puppet=puppet-3.6.1.msi
SET fusion=fusioninventory-agent_windows-x86_2.3.8.exe
SET domain=nas.local

ECHO .
ECHO Welcome to the post image/domain script info!
ECHO .
ECHO Before we start lets get some basic information about
ECHO this computer. Also keep in mind all responses *ARE*
ECHO case sensitive.
ECHO .

SET /p computer= What's the name of this computer?

ECHO .
SET /p mont= What's the monitor inventory tag?
REG ADD "HKCC\NACSTech\Accessories\Monitors" /F /v Monitor1 /t reg_sz /d %mont%

ECHO .
SET /p teach= Is this a teacher machine [Y/n]?
IF %teach% == Y GOTO Teach
GOTO Install

:Teach
ECHO .
ECHO **This is a teacher machine**
ECHO .
ECHO Lets get some basic information about the
ECHO inventory in this room . Also keep in mind
ECHO all responses *ARE* case sensitive.
ECHO .
SET /p projector= What's the projector inventory tag?
REG ADD "HKCC\NACSTech\Accessories\Projectors" /F /v Projector1 /t reg_sz /d %projector%
ECHO .
SET /p smart= What's the SMARTBoard inventory tag?
REG ADD "HKCC\NACSTech\Accessories\SMART" /F /v SMARTBoard /t reg_sz /d %smart%
ECHO Thank You! We will move to installing software now...
GOTO Install


:Install
ECHO .
ECHO Choose which one to install:
ECHO .
ECHO 	1. Fusion
ECHO		2. Puppet
ECHO		3. Done
ECHO .
SET /p ichoice= Which one do you want to install [1/2]?
IF %ichoice% == 1 GOTO Fusion
IF %ichoice% == 2 GOTO Puppet
GOTO END


:Fusion
ECHO .
REM Start of the install process for Fusion Inventory
ECHO .
ECHO ###Before we install Fusion we need the Inventory Tag###
ECHO .
SET /p tag= Whats the inventory tag number?
ECHO .
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
ECHO .
ECHO !!!Installing Fusion Inventory Agent!!!

%fusion% /S /acceptlicense /installtasks=Full /runnow /tag=%tag% /server='http://helpdesk.napoleonareaschools.org/plugins/fusioninventory/'

ECHO .
ECHO ?!?!Successfully install Fusion Inventory Agent?!?!
ECHO .
ECHO @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
GOTO Install


:Puppet
SET fqdn=%computer%.%domain%
REM Start of the install process for Puppet
ECHO ############################
ECHO .
ECHO !!!Installing puppet!!!
ECHO .
msiexec /qn /i %puppet% PUPPET_MASTER_SERVER=puppet01.nas.local PUPPET_AGENT_NAME=%fqdn%
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
GOTO Install


:End
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /F /v AutoAdminLogon
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /F /v DefaultPassword
del %puppet% %fusion%
curl http://api.napoleonareaschools.org/imaged/%computername%
