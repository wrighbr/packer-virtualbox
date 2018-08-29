#Set-LocalUser -Name "vagrant" -PasswordNeverExpires 1
$user = [adsi]"WinNT://$env:computername/vagrant"
$user.UserFlags.value = $user.UserFlags.value -bor 0x10000
$user.CommitChanges()