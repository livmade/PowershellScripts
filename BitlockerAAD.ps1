$BLV = Get-BitLockerVolume -MountPoint "C:" | select *

BackupToAAD-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId