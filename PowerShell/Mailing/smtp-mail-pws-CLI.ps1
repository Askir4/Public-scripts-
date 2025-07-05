# ----------------------------------------------------------
# Script to send fake Mails for testing ONLY. 
# For internal use
# ----------------------------------------------------------
# ASCII-Text als Banner
$banner = @"
******************************
___  ___      _ _  ______    _             
|  \/  |     (_) | |  ___|  | |            
| .  . | __ _ _| | | |_ __ _| | _____ _ __ 
| |\/| |/ _` | | | |  _/ _` | |/ / _ \ '__|
| |  | | (_| | | | | || (_| |   <  __/ |   
\_|  |_/\__,_|_|_| \_| \__,_|_|\_\___|_|   
                                           
                                           

 
                                            
******************************

    
===================================================================
Mail-faker-01.ps1 - Send test Mails fro any address to any address.
===================================================================
For INTERNAL testing only!


"@
     Write-Host $banner

# 1. SMTP-Server
$smtpServer = Read-Host "SMTP-Server"
if ([string]::IsNullOrWhiteSpace($smtpServer)) {
    Write-Error "SMTP-Server darf nicht leer sein. Skript abgebrochen."
    exit 1
}

# 2. Port
$portInput = Read-Host "Port (Standard: 25)"
if ([string]::IsNullOrWhiteSpace($portInput)) {
    $port = 25
} else {
    if ($portInput -match '^\d+$') {
        $port = [int]$portInput
    } else {
        Write-Error "Port muss eine Zahl sein. Verwende Standard-Port 25."
        $port = 25
    }
}

# 3. Authentifizierung
$useAuth = Read-Host "Authentifizierung verwenden? (j/n, Standard: n)"
$useAuth = $useAuth.ToLower()
$username = $null
$password = $null

if ($useAuth -eq "j" -or $useAuth -eq "ja" -or $useAuth -eq "y" -or $useAuth -eq "yes") {
    $username = Read-Host "Benutzername"
    if ([string]::IsNullOrWhiteSpace($username)) {
        Write-Error "Benutzername darf nicht leer sein. Skript abgebrochen."
        exit 1
    }
    
    $password = Read-Host "Passwort" -AsSecureString
    if ($password.Length -eq 0) {
        Write-Error "Passwort darf nicht leer sein. Skript abgebrochen."
        exit 1
    }
}

# 4. Betreff
$subject = Read-Host "Betreff"
if ([string]::IsNullOrWhiteSpace($subject)) {
    Write-Error "Betreff darf nicht leer sein. Skript abgebrochen."
    exit 1
}

# 5. Nachrichtentext oder HTML-Code
Write-Host "Gib deinen Nachrichtentext oder HTML-Code ein. Fuege am Ende immer ein END in der letzten Zeile ein!."
$bodyLines = @()
do {
    $line = Read-Host
    if ($line -ne 'END') {
        $bodyLines += $line
    }
} while ($line -ne 'END')
$body = $bodyLines -join "`r`n"
if ([string]::IsNullOrWhiteSpace($body)) {
    Write-Error "Nachricht (oder HTML) darf nicht leer sein. Skript abgebrochen."
    exit 1
}

# 6. Absender-Adresse
$fromAddr = Read-Host "Absender-Adresse"
if ([string]::IsNullOrWhiteSpace($fromAddr)) {
    Write-Error "Absender-Adresse darf nicht leer sein. Skript abgebrochen."
    exit 1
}

# 7. Absender-Name (optional)
$fromName = Read-Host "Absender-Name (optional)"

# 8. Empfänger (mehrere mit Komma trennen), Loop bis nicht-leer
do {
    $toInput = Read-Host "Empfaenger (mehrere mit Komma trennen)"
    if ([string]::IsNullOrWhiteSpace($toInput)) {
        Write-Warning "Bitte mindestens einen Empfänger angeben!"
    }
} until (-not [string]::IsNullOrWhiteSpace($toInput))
$to = $toInput -split ",\s*"

# 9. CC-Empfänger (optional)
$ccInput = Read-Host "CC-Empfaenger (optional, mehrere mit Komma trennen)"
$cc = @()
if (-not [string]::IsNullOrWhiteSpace($ccInput)) {
    $cc = $ccInput -split ",\s*"
}

# 10. MailAddress-Objekt erstellen
if (-not [string]::IsNullOrWhiteSpace($fromName)) {
    $from = New-Object System.Net.Mail.MailAddress($fromAddr, $fromName)
} else {
    $from = New-Object System.Net.Mail.MailAddress($fromAddr)
}

# 11. Send-MailMessage mit HTML-Unterstützung
try {
    $mailParams = @{
        SmtpServer = $smtpServer
        Port = $port
        Subject = $subject
        Body = $body
        BodyAsHtml = $true
        From = $from
        To = $to
    }
    
    # Authentifizierung hinzufügen, falls angegeben
    if ($username -and $password) {
        $credential = New-Object System.Management.Automation.PSCredential($username, $password)
        $mailParams.Credential = $credential
    }
    
    # CC hinzufügen, falls angegeben
    if ($cc.Count -gt 0) {
        $mailParams.Cc = $cc
    }
    
    Send-MailMessage @mailParams
    
    $successMessage = "Mail erfolgreich gesendet an: $($to -join ', ')"
    if ($cc.Count -gt 0) {
        $successMessage += " | CC: $($cc -join ', ')"
    }
    Write-Host $successMessage -ForegroundColor Green
}
catch {
    Write-Error "Fehler beim Senden der Mail: $_"
}
