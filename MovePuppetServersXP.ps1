Set-ExecutionPolicy unrestricted -Force

# Set Environment variable in order to run puppet
$env:PATH += ";C:\Program Files\Puppet Labs\Puppet\bin"	

# Configuration directory for Puppet and XP
$confdir = 'C:\Documents and Settings\All Users\Application Data\PuppetLabs\puppet\etc

# Stop the puppet service to install the latest version
Stop-Service puppet

(Get-Content $confdir/puppet.conf) | Foreach-Object {$_ -replace 'server=puppet.nas.local','server=puppet01.nas.local'}  | Out-File $confdir/puppet.conf

# Remove old ssl folder
Remove-Item $confdir/ssl/* -force -recurse

# Upgrade Puppet to the most current that will work
# with that OS
# Windows XP
[Environment]::SetEnvironmentVariable("ChocolateyInstall", "C:\Chocolatey", "Machine")

# Install Chocolatey (or update to latest if already installed)
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Puppet on Windows XP
choco install puppet -Version 3.6.2


# Start the puppet service after install is done
# By default it should start after update but lets
# ensure it starts
Start-Service puppet
