<#

  This is a simple example that calls the hardenedServerConfig resource with custom params.

#>
configuration mySecureServer
{

    $PreLogonMessageTitle = 'Logon Policy for $CompanyName'
    $PreLogonMessageBody = @'
    ---------------------------------------------------------------------------------
                    This is a secured and audited system.
    Access is strictly for those persons authorised to do so, and use must be in line 
    with $CompanyName Acceptable Use Policy.
    Unathorised access to this system may result in disciplinary actions 
    and/or criminal prosecution.
    ---------------------------------------------------------------------------------    
'@
    
    Import-DscResource -ModuleName HardenedServerDSC, xNetworking

    hardenedServerConfig securebuild {
        CompanyName          = 'Sage Group plc'
        PreLogonMessageTitle = $PreLogonMessageTitle
        PreLogonMessageBody  = $PreLogonMessageBody
        renameGuestTo        = '667yaPegaS'
        renameAdminTo        = 'itadmin'
        PasswordHistory      = 24
        MaxPasswordAge       = 90
        MinPasswordAge       = 1
        MinPasswordLength    = 14
        AccountLockoutThreshold = 6
        AccountLockoutDuration = 30
        ResetAccountLockoutAfter = 30
    } 

    <# Install a firewall rule too, just to illustrate that this is a composite resource
       that can be built upon.
    #>
    #xFirewall Firewall {
    #    Name                  = 'IIS-WebServerRole-HTTP-In-TCP'
    #    Ensure                = 'Present'
    #    Enabled               = 'True'
    #}
}

# somewhere for the configuration document to live
$DSCFolder = 'C:\Admin\DSC'
New-Item -ItemType Directory -Path $DSCFolder -ErrorAction SilentlyContinue

# create the MOF:
mySecureServer -OutputPath $DSCFolder -Verbose

# Make the server compliant
#Start-DscConfiguration -Wait -Verbose -Path $DSCFolder -Force -ComputerName $env:COMPUTERNAME

# Test compliance with
#Test-DscConfiguration -ComputerName $env:COMPUTERNAME -Path $DSCFolder -Verbose
