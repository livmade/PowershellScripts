pwsh.exe -ExecutionPolicy Bypass
$bitlockervolume = (Get-BitLockerVolume ).VolumeStatus #grabbing status of volumes on device
$bitlockermount = if($bitlockervolume -eq 'FullyDecrypted') {
    (Get-BitLockerVolume).MountPoint
}
if($bitlockermount -like "*") {
    Write-Host "Bitlocker is Disabled for Volume(s): `n" $bitlockermount
}
<# Bitlocker encryption below starting on line 10. Currently specified to TPM, but can be changed to a 
different combination if wanted/ warranted/ required per compliance #>
Enable-BitLocker -MountPoint $bitlockermount -EncryptionMethod Aes256 -TpmProtector -UsedSpaceOnly
$bitlockerkeys = (Get-BitLockerVolume).KeyProtector # | Export-Csv -Path .\BitlockerKeys.csv -Delimiter ';' -NoTypeInformation

#Above export commented out, only required if using something other than TPM
if($bitlockerkeys -ne $null) {
    Write-Host "Encryption complete. Restart may be required."
}