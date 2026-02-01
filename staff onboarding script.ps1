# Import Active Directory module
Import-Module ActiveDirectory

# Define CSV file path 
$csvPath = "path to csv"

# Import users from CSV
$users = Import-Csv -Path $csvPath  

foreach ($user in $users) {
    $ou = $user.OU
    $department = $user.Department

    # 1. Create OU if it doesn't exist
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$department'")) {
        $ouSplat = @{
            Name                            = $department
            Path                            = $ou
            ProtectedFromAccidentalDeletion = $false
        }
        New-ADOrganizationalUnit @ouSplat
        Write-Host "Created OU '$department' in '$ou'"
    }

    # 2. Create group if it doesn't exist
    if (-not (Get-ADGroup -Filter "Name -eq '$department'")) {
        $groupSplat = @{
            Name          = $department
            GroupCategory = "Security"
            GroupScope    = "Global"
            Path          = "OU=$department,$ou"
        }
        New-ADGroup @groupSplat
        Write-Host "Created Group '$department' in $department OU"
    }
}

# Define user parameters and create accounts
foreach ($user in $users) {
    $samAccountName = $user.Username
    $ou = $user.OU
    $department = $user.Department

    if (-not (Get-ADUser -Filter "SamAccountName -eq '$samAccountName'")) {
        
        # Prepare the Hashtable for Splatting
        $userSplat = @{
            Name                  = "$($user.FirstName) $($user.LastName)"
            GivenName             = $user.FirstName
            Surname               = $user.LastName
            SamAccountName        = $samAccountName
            Department            = $user.Department
            City                  = $user.City
            Country               = $user.Country
            Title                 = $user.Title
            Enabled               = $true
            AccountPassword       = (ConvertTo-SecureString -String $user.Password -AsPlainText -Force)
            ChangePasswordAtLogon = $false
            Path                  = "OU=$department,$ou"
        }

        # Create user account using @ symbol for splatting
        New-ADUser @userSplat
        Write-Host "Created user '$($userSplat.Name)' in $department OU"       
    }

    # Add users to respective group
    switch ($user.Department) {
        "Sales"     { Add-ADGroupMember -Identity "Sales" -Members $samAccountName }
        "IT"        { Add-ADGroupMember -Identity "IT" -Members $samAccountName }
        "Marketing" { Add-ADGroupMember -Identity "Marketing" -Members $samAccountName }
        "HR"        { Add-ADGroupMember -Identity "HR" -Members $samAccountName }
        default     { Write-Host "Unknown department: $($user.Department)" }
    }

}
