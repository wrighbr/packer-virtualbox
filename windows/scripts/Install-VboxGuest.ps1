#Mount-DiskImage c:\users\vagrant
#$VboxISO = C:\Users\vagrant\VBoxGuestAdditions.iso
Mount-DiskImage -ImagePath 'C:\Users\vagrant\VBoxGuestAdditions.iso'

Get-ChildItem E:\cert\ -Filter vbox*.cer | ForEach-Object {
    E:\cert\VBoxCertUtil.exe add-trusted-publisher $_.FullName --root $_.FullName
}
Set-Location E:
./VBoxWindowsAdditions.exe /S