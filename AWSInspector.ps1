<powershell>
# Install AWS Inspector agent  and Powershell 5.1 at EC2 launch
$awsinspector = "https://d1wk0tztpsntt1.cloudfront.net/windows/installer/latest/AWSAgentInstall.exe"
$temp = "$env:Temp\AWSAgentInstall.exe"
$download = start-bitstransfer -source $awsinspector -Destination $temp
Start-Process -Wait -FilePath $temp -argumentlist "/install /quiet"
# Clean up
Remove-Item $temp 

# Use shortcode to find latest TechNet download site
$confirmationPage = 'http://www.microsoft.com/en-us/download/' +  $((invoke-webrequest 'http://aka.ms/wmf5latest' -UseBasicParsing).links | ? Class -eq 'mscom-link download-button dl' | % href)
# Parse confirmation page and look for URL to file
$directURL = (invoke-webrequest $confirmationPage -UseBasicParsing).Links | ? Class -eq 'mscom-link' | ? href -match "Win8.1AndW2K12R2-KB\d\d\d\d\d\d\d-x64.msu" | % href | select -first 1
# Download file to local
$download = start-bitstransfer -Source $directURL -Destination $env:Temp\wmf5latest.msu
# Install quietly with no reboot
if (test-path $env:Temp\wmf5latest.msu) {
  start -wait $env:Temp\wmf5latest.msu -argumentlist '/quiet'
  }
else { throw 'the update file is not available at the specified location' }
# Clean up
Remove-Item $env:Temp\wmf5latest.msu

# Assumption is that the next likely step will be DSC config, starting with xPendingReboot to finish install
</powershell>
