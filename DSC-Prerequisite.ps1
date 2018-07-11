# Add PSGallery and install required modules for HardeningServerDSC
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PowerShellGet -RequiredVersion 1.6.5 -Force
# Set PSGallery as trousted source
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module AuditPolicyDSC,SecurityPolicyDSC,xNetworking -Force #-Scope CurrentUser -Force

# Download https://github.com/kewalaka/HardenedServerDSC 
# Copy subfolder HardendedDSC from HrdenedServerDSC-master\Modules to c:\ProgramFiles\Windows Powershell\Modules

$hardeneddsc = "https://github.com/kewalaka/HardenedServerDSC/archive/master.zip"
$temp = "$env:Temp\HardenedServerDSC-master.zip"
$download = start-bitstransfer -source $hardeneddsc -Destination $temp
$unzip = Expand-Archive $temp -DestinationPath $Home\Downloads
Remove-Item $temp
#Start-Process -Wait -FilePath $temp -argumentlist "/install /quiet"
$module = Copy-Item $HOME\Downloads\HardenedServerDSC-master\Modules\HardenedServerDSC -Destination $env:ProgramFiles\WindowsPowerShell\Modules -Recurse
# Check available resources to local machine, should be 5 HardenedServer modules.
Get-DSCResource -Module *DSC