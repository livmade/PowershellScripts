$bitlockervolume = (Get-BitLockerVolume ).VolumeStatus #grabbing status of volumes on device
$bitlockermount = if($bitlockervolume -eq 'FullyDecrypted') {
    (Get-BitLockerVolume).MountPoint
}
if($bitlockermount -like "*") {
    Write-Host "Bitlocker is Disabled for Volume(s): `n" $bitlockermount
}
<# Bitlocker encryption below starting on line 10. Currently specified to TPM, but can be changed to a 
different combination if wanted/ warranted/ required per compliance #>
Enable-BitLocker -MountPoint $bitlockermount -EncryptionMethod XtsAes256 -UsedSpaceOnly -SkipHardwareTest -RecoveryPasswordProtector


# After restart, encrypting can take up to an hour...
# Be sure to run:
$bitlockerkeys = (Get-BitLockerVolume).KeyProtector  | Export-Csv -Path C:\BitlockerKeys.csv -Delimiter ';' -NoTypeInformation

# To verify information has been captured, you can run:
Get-Content -Path .\BitlockerKeys.csv