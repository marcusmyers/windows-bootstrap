Param(
 [string] $computername = $null
)
# Get OS Version Major
#
# 5 - XP
# 6 - 7, 2008
#
# Since we are only using these for our
# client machines we don't need to test
# the minor versions
#

# Upgrade Puppet to the most current that will work
# with that OS
# Install Chocolatey (or update to latest if already installed)
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Puppet on Windows 7, 2008
choco install puppet


$confdir = puppet agent --configprint confdir

# Stop the puppet service to install the latest version
Stop-Service puppet

(Get-Content $confdir/puppet.conf) | Foreach-Object {$_ -replace 'server=puppet','server=puppet01.nacswildcats.org'}  | Out-File $confdir/puppet.conf

Add-Content $confdir/puppet.conf "`ncertname=$computername"

Remove-Item $confdir/ssl/* -force -recurse

Start-Service puppet
