# AD Staff Onboarding Script

A PowerShell tool to automate the creation of Organizational Units (OUs), Security Groups, and User Accounts in Active Directory based on a CSV input.

## Features
- **Auto-OU Creation:** Checks for and creates Department OUs if they don't exist.
- **Group Management:** Automatically creates and populates Security Groups for specific departments (Sales, IT, Marketing, HR).
- **Splatting:** Uses PowerShell splatting for clean, readable code when creating user objects.
- **Safety:** Checks for existing users and OUs before attempting creation to prevent errors.

## Prerequisites
- Windows PowerShell with the `ActiveDirectory` module installed.
- Domain Administrator privileges (or delegated rights to create OUs and users).
- A CSV file located at your preferred destination.

## CSV Structure
The script expects the following headers in your CSV:
`FirstName, LastName, Username, Password, Department, Title, City, Country, OU`

## Usage
1. Update the `$csvPath` variable in the script if your CSV is in a different location.
2. Run the script from an elevated PowerShell prompt:
   ```powershell
   .\staff-onboarding.ps1
