function Install-NinjaCmdlet {
    $CurrentVersion = (Find-Module -Name 'NinjaOne' -AllowPrerelease).Version
    $InstalledVersion = ((Get-Module -ListAvailable -Name 'NinjaOne').Version | Sort-Object -Descending)[0]
    if ( (-not $InstalledVersion) -or $InstalledVersion.parse -lt $CurrentVersion.parse) {
        Update-Progress 'Ninja not installed or out of date. Installing...'
        Install-Module NinjaOne -AllowPrerelease -Force
    }
}

function Connect-NinjaAPI {
    $ConnectionParameters = @{
        Instance      = 'us'
        ClientID      = #' insert '
        ClientSecret  = #' insert '
        UseClientAuth = $true
    }
    Connect-NinjaOne @ConnectionParameters
}

# This is your function for connecting to Ninja
Install-NinjaCmdlet
Connect-NinjaAPI

#get a list of the ninja users by firstname, lastname, and email
$ninjauser = Get-NinjaOneUsers | Select-Object firstname, lastname, email

# Used for combining Ninja information with AD Enabled status
$userArray = @()

# Check each ninja user by their email address in AD and find their Enabled property.  Combine with the ninja information.
foreach ($user in $ninjauser)
{
    $userAccount = Get-ADUser -Filter "Mail -eq '$($user.email)'" -Properties Enabled
    $userObject = [PSCustomObject]@{
        name = $user.firstname + " " + $user.lastname
        email = $user.email
        enabled = $userAccount.Enabled
    }
    $userArray += $userObject
}

$userArray | Sort-Object enabled