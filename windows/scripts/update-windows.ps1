##
#
# Apply Windows Updated from Windows Update Server and Auto Reboot Server
#
##

try{
    # Imports PSWindows Update Module

    Import-Module PSWindowsUpdate -ErrorAction Stop
    }
catch{

    # Dowloads, Install and Imports PSWindowsUpdate Module if not installed

    if($PSVersionTable.PSVersion -ge '5.0'){
        Install-PackageProvider Nuget -force -Confirm:$false
        Install-Module -Name PSWindowsUpdate -Force -Confirm:$false 
    }
    else {
        $url = 'https://s3-ap-southeast-2.amazonaws.com/bambora-ap-installers/PSWindowsUpdate.zip'
        $output = 'c:\temp\PSWindowsUpdate.zip'
        $powershellModues = 'c:\windows\System32\WindowsPowerShell\v1.0\Modules'
        
        Get-Service BITS | Start-Service

        Import-Module BitsTransfer
        New-Item -Path c:\temp -ItemType directory -Force
        
        Get-Service 
        Start-BitsTransfer -Source $url -Destination $output

        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory($output, $powershellModues)
    }

    Import-Module PSWindowsUpdate
}

# Gets the ServiceID of the Windows Update Server 
$WsusID = (Get-WUServiceManager | Where-Object {$_.name -like 'Windows Server Update Service' }).ServiceID

# List of KBs not to be install
# kb3072779 = SQL Server 2012 SP3

$ExcludedKBs = 'kb3072779'

# Install the Windows Update

Write-Host 'Now Installing Windows Updates' -ForegroundColor Green

if($PSVersionTable.PSVersion -ge '5.0'){
    #if($env:USERNAME -eq 'vagrant'){
        Get-WUInstall -install -AcceptAll -ServiceID $WsusID -NotKBArticleID $ExcludedKBs -Verbose -IgnoreReboot -Severity Critical | format-table X, Status, Size, KB, Title -AutoSize
    <#}
    else {
        Get-WUInstall -install -AcceptAll -ServiceID $WsusID -NotKBArticleID $ExcludedKBs -AutoReboot -Verbose | format-table X, Status, Size, KB, Title -AutoSize
    }
    #>
}
else{
    
    Get-WUInstall -AcceptAll -ServiceID $WsusID -NotKBArticleID $ExcludedKBs -AutoReboot -Verbose | format-table X, Status, Size, KB, Title -AutoSize
}