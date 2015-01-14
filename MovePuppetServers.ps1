Set-ExecutionPolicy unrestricted -Force

# Set Environment variable in order to run puppet
$env:PATH += ";C:\Program Files\Puppet Labs\Puppet\bin"	

#
# Get OS Version Major
#
# 5 - XP
# 6 - 7, 2008
#
# Since we are only using these for our
# client machines we don't need to test
# the minor versions
#
$confdir = puppet agent --configprint confdir

# Stop the puppet service to install the latest version
Stop-Service puppet

(Get-Content $confdir/puppet.conf) | Foreach-Object {$_ -replace 'server=puppet.nas.local','server=puppet01.nas.local'}  | Out-File $confdir/puppet.conf

Remove-Item $confdir/ssl/* -force -recurse

# Upgrade Puppet to the most current that will work
# with that OS
# Install Chocolatey (or update to latest if already installed)
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))


# Install Puppet on Windows 7, 2008
choco install puppet


# Start the puppet service after install is done
# By default it should start after update but lets
# ensure it starts
Start-Service puppet
