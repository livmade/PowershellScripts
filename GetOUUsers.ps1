# This script exports users from a specified OU(s) (Can edit to your Org and path)
Get-ADUser -Filter * -Properties * -SearchBase "OU=Accounting,OU=ADPRO Users,DC=ad,DC=activedirectorypro,DC=com" | select displayname, DistinguishedName, Enabled

# To export this list to .csv, add:
# "| export-csv -path c:\temp\export-ou.csv" aftered 'Enabled'