# ----------------------------------------------------------
# Script to send fake Mails for testing ONLY. 
# For internal use
# ----------------------------------------------------------
##******************************
#___  ___      _ _  ______    _             
#|  \/  |     (_) | |  ___|  | |            
#| .  . | __ _ _| | | |_ __ _| | _____ _ __ 
#| |\/| |/ _` | | | |  _/ _` | |/ / _ \ '__|
#| |  | | (_| | | | | || (_| |   <  __/ |   
#\_|  |_/\__,_|_|_| \_| \__,_|_|\_\___|_|   
#******************************
#=======================================================================
#Mail-faker-gui-03.ps1 - Send test Mails fro any address to any address.
#Send authenticated over 587
#=======================================================================

#=======================================================================
#For INTERNAL testing only!
# SendEmailGUI.ps1

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Form erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = "Mail Faker"
$form.Size = New-Object System.Drawing.Size(450,670)
$form.StartPosition = "CenterScreen"

# Schriftart für alle Controls
$defaultFont = New-Object System.Drawing.Font("Segoe UI", 9)

function Set-Font($ctrl) {
    $ctrl.Font = $defaultFont
}

# Helper-Funktionen
function New-Label($text, $x, $y) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text
    $lbl.Location = New-Object System.Drawing.Point($x, $y)
    $lbl.AutoSize = $true
    return $lbl
}

function New-TextBox($x, $y, $width=250, $multiline=$false, $height=20) {
    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Location = New-Object System.Drawing.Point($x, $y)
    $tb.Size = New-Object System.Drawing.Size($width, $height)
    $tb.Multiline = $multiline
    return $tb
}

# Controls anlegen
$lblSmtp     = New-Label "SMTP-Server:"           20  20
$txtSmtp     = New-TextBox 120 18

$lblPort     = New-Label "Port:"                  20  55
$comboPort   = New-Object System.Windows.Forms.ComboBox
$comboPort.Location = New-Object System.Drawing.Point(120,53)
$comboPort.Size     = New-Object System.Drawing.Size(100,20)
$comboPort.Items.AddRange(@("25","465","587","2525"))
$comboPort.DropDownStyle = "DropDownList"
$comboPort.SelectedIndex = 2  # Standard 587

$lblFrom     = New-Label "Absender:"  20 90
$txtFrom     = New-TextBox 120  88

$lblDispName = New-Label "D-Name(opt.):"   20 120
$txtDispName = New-TextBox 120 118

$lblTo       = New-Label "An (To):"               20 150
$txtTo       = New-TextBox 120 148

$lblCc       = New-Label "CC (optional):"          20 200
$txtCc       = New-TextBox 120 198

$lblSubj     = New-Label "Betreff (Subject):"     20 250
$txtSubj     = New-TextBox 120 248

$lblBody     = New-Label "Nachricht (Body):"      20 280
$txtBody     = New-TextBox 120 278 300 $true 100
$txtBody.ScrollBars = "Vertical"

$chkHtml     = New-Object System.Windows.Forms.CheckBox
$chkHtml.Text = "Body as HTML"
$chkHtml.Location = New-Object System.Drawing.Point(120,383)

# Checkbox für Darkmode
$chkDarkMode = New-Object System.Windows.Forms.CheckBox
$chkDarkMode.Text = "Darkmode"
$chkDarkMode.Location = New-Object System.Drawing.Point(20, 420)

# Checkbox für Authentifizierung
$chkAuth = New-Object System.Windows.Forms.CheckBox
$chkAuth.Text = "Authent"
$chkAuth.Location = New-Object System.Drawing.Point(140, 420)

# Benutzername und Passwort-Felder (standardmäßig unsichtbar)
$lblUser = New-Label "Benutzername:" 20 450
$txtUser = New-TextBox 120 448 150
$lblUser.Visible = $false
$txtUser.Visible = $false

$lblPass = New-Label "Passwort:" 20 480
$txtPass = New-TextBox 120 478 150
$lblPass.Visible = $false
$txtPass.Visible = $false
$txtPass.UseSystemPasswordChar = $true  # Passwortfeld

$chkAuth.Add_CheckedChanged({
    if ($chkAuth.Checked) {
        $comboPort.SelectedItem = "587"
        $lblUser.Visible = $true
        $txtUser.Visible = $true
        $lblPass.Visible = $true
        $txtPass.Visible = $true
    } else {
        $lblUser.Visible = $false
        $txtUser.Visible = $false
        $lblPass.Visible = $false
        $txtPass.Visible = $false
        $txtUser.Text = ""
        $txtPass.Text = ""
    }
})

# Event-Handler für Darkmode
$chkDarkMode.Add_CheckedChanged({
    if ($chkDarkMode.Checked) {
        $form.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
        foreach ($ctrl in $form.Controls) {
            if ($ctrl -is [System.Windows.Forms.Label] -or $ctrl -is [System.Windows.Forms.CheckBox]) {
                $ctrl.ForeColor = [System.Drawing.Color]::White
                $ctrl.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
            } elseif ($ctrl -is [System.Windows.Forms.TextBox]) {
                $ctrl.BackColor = [System.Drawing.Color]::FromArgb(45,45,45)
                $ctrl.ForeColor = [System.Drawing.Color]::White
            } elseif ($ctrl -is [System.Windows.Forms.Button]) {
                $ctrl.BackColor = [System.Drawing.Color]::FromArgb(50,50,50)
                $ctrl.ForeColor = [System.Drawing.Color]::White
            } elseif ($ctrl -is [System.Windows.Forms.ComboBox]) {
                $ctrl.BackColor = [System.Drawing.Color]::FromArgb(45,45,45)
                $ctrl.ForeColor = [System.Drawing.Color]::White
            }
        }
    } else {
        $form.BackColor = [System.Drawing.SystemColors]::Control
        foreach ($ctrl in $form.Controls) {
            if ($ctrl -is [System.Windows.Forms.Label] -or $ctrl -is [System.Windows.Forms.CheckBox]) {
                $ctrl.ForeColor = [System.Drawing.SystemColors]::ControlText
                $ctrl.BackColor = [System.Drawing.SystemColors]::Control
            } elseif ($ctrl -is [System.Windows.Forms.TextBox]) {
                $ctrl.BackColor = [System.Drawing.SystemColors]::Window
                $ctrl.ForeColor = [System.Drawing.SystemColors]::WindowText
            } elseif ($ctrl -is [System.Windows.Forms.Button]) {
                $ctrl.BackColor = [System.Drawing.SystemColors]::Control
                $ctrl.ForeColor = [System.Drawing.SystemColors]::ControlText
            } elseif ($ctrl -is [System.Windows.Forms.ComboBox]) {
                $ctrl.BackColor = [System.Drawing.SystemColors]::Window
                $ctrl.ForeColor = [System.Drawing.SystemColors]::WindowText
            }
        }
    }
})

# Anhang-Bereich
$lblAttachment = New-Label "Anhang (optional):"   20 510
$txtAttachment = New-TextBox 120 508 250
$btnSelectAttachment = New-Object System.Windows.Forms.Button
$btnSelectAttachment.Text = "Anhang"
$btnSelectAttachment.Location = New-Object System.Drawing.Point(370,505)
$btnSelectAttachment.Size = New-Object System.Drawing.Size(60,25)
$btnSelectAttachment.Add_Click({
    $ofd = New-Object System.Windows.Forms.OpenFileDialog
    $ofd.Filter = "Alle Dateien (*.*)|*.*"
    if ($ofd.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $txtAttachment.Text = $ofd.FileName
    }
})

# Send-Button
$btnSend = New-Object System.Windows.Forms.Button
$btnSend.Text = "Nuke it"
$btnSend.Location = New-Object System.Drawing.Point(170, 550)
$btnSend.Size = New-Object System.Drawing.Size(100,30)

# Mehrzeilige Empfänger-Eingabe
$txtTo.Multiline = $true
$txtTo.Height = 40
$txtCc.Multiline = $true
$txtCc.Height = 40

# Validierungsfunktion für E-Mail
function Is-ValidEmail($email) {
    return $email -match '^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$'
}

# Hilfsfunktion für Pflichtfeld-Validierung
function Check-Required($value, $fieldName) {
    if ([string]::IsNullOrWhiteSpace($value)) {
        [System.Windows.Forms.MessageBox]::Show("Bitte das Feld '" + $fieldName + "' ausfüllen!", "Fehlende Eingabe", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return $false
    }
    return $true
}

# Event-Handler für Senden (ersetzt alten Handler)
$btnSend.Add_Click({
    # Werte einsammeln
    $smtpServer     = $txtSmtp.Text.Trim()
    $port           = [int]$comboPort.SelectedItem
    $from           = $txtFrom.Text.Trim()
    $displayName    = $txtDispName.Text.Trim()
    $to             = $txtTo.Text.Trim()
    $cc             = $txtCc.Text.Trim()
    $subject        = $txtSubj.Text
    $body           = $txtBody.Text
    $asHtml         = $chkHtml.Checked
    $attachmentPath = $txtAttachment.Text.Trim()
    $authUser       = $txtUser.Text
    $authPass       = $txtPass.Text

    # Pflichtfeld-Validierung
    if (-not (Check-Required $smtpServer 'SMTP-Server')) { return }
    if (-not (Check-Required $from 'Absender')) { return }
    if (-not (Check-Required $to 'An (To)')) { return }
    if (-not (Is-ValidEmail $from)) {
        [System.Windows.Forms.MessageBox]::Show("Ungültige Absender-E-Mail-Adresse!", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }
    $toList = $to -split "[\r\n,;]+" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    foreach ($addr in $toList) {
        if (-not (Is-ValidEmail $addr.Trim())) {
            [System.Windows.Forms.MessageBox]::Show("Ungültige Empfänger-Adresse: $addr", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            return
        }
    }
    $ccList = @()
    if (-not [string]::IsNullOrWhiteSpace($cc)) {
        $ccList = $cc -split "[\r\n,;]+" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
        foreach ($addr in $ccList) {
            if (-not (Is-ValidEmail $addr.Trim())) {
                [System.Windows.Forms.MessageBox]::Show("Ungültige CC-Adresse: $addr", "Fehler", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                return
            }
        }
    }

    $statusLabel.Text = "Sendevorgang läuft..."
    $form.Refresh()

    try {
        # MailMessage bauen
        $mailMessage = New-Object System.Net.Mail.MailMessage
        if ([string]::IsNullOrWhiteSpace($displayName)) {
            $mailMessage.From = New-Object System.Net.Mail.MailAddress($from)
        } else {
            $mailMessage.From = New-Object System.Net.Mail.MailAddress($from, $displayName)
        }
        foreach ($addr in $toList) { $mailMessage.To.Add($addr.Trim()) }
        foreach ($addr in $ccList) { $mailMessage.CC.Add($addr.Trim()) }
        $mailMessage.Subject    = $subject
        $mailMessage.Body       = $body
        $mailMessage.IsBodyHtml = $asHtml

        # Attachment optional hinzufügen
        if (-not [string]::IsNullOrWhiteSpace($attachmentPath)) {
            $attachment = New-Object System.Net.Mail.Attachment($attachmentPath)
            $mailMessage.Attachments.Add($attachment)
        }

        # Senden
        $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $port)
        if ($chkAuth.Checked) {
            if ([string]::IsNullOrWhiteSpace($authUser) -or [string]::IsNullOrWhiteSpace($authPass)) {
                [System.Windows.Forms.MessageBox]::Show(
                    "Bitte Benutzername und Passwort für die Authentifizierung eingeben!",
                    "Fehlende Eingaben",
                    [System.Windows.Forms.MessageBoxButtons]::OK,
                    [System.Windows.Forms.MessageBoxIcon]::Warning
                )
                $statusLabel.Text = "Fehler: Authentifizierungsdaten fehlen."
                return
            }
            $smtpClient.UseDefaultCredentials = $false
            $smtpClient.Credentials = New-Object System.Net.NetworkCredential($authUser.Trim(), $authPass)
            $smtpClient.EnableSsl = $true
        } else {
            $smtpClient.UseDefaultCredentials = $true
            $smtpClient.Credentials = $null
            if ($port -eq 465 -or $port -eq 587) {
                $smtpClient.EnableSsl = $true
            }
        }
        $smtpClient.Send($mailMessage)

        [System.Windows.Forms.MessageBox]::Show(
            "E-Mail erfolgreich gesendet!",
            "Erfolg",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        $statusLabel.Text = "E-Mail erfolgreich gesendet."
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Fehler beim Senden:`n$($_.Exception.Message)",
            "Fehler",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        $statusLabel.Text = "Fehler beim Senden: $($_.Exception.Message)"
    }
})

# Alle Controls zum Formular hinzufügen
$form.Controls.AddRange(@(
    $lblSmtp;     $txtSmtp;
    $lblPort;     $comboPort;
    $lblFrom;     $txtFrom;
    $lblDispName; $txtDispName;
    $lblTo;       $txtTo;
    $lblCc;       $txtCc;
    $lblSubj;     $txtSubj;
    $lblBody;     $txtBody;
    $chkHtml;
    $chkDarkMode;
    $chkAuth;
    $lblUser; $txtUser; $lblPass; $txtPass;
    $lblAttachment; $txtAttachment; $btnSelectAttachment;
    $btnSend
))

# Nach dem Erstellen jedes Controls:
Set-Font $form
Set-Font $lblSmtp; Set-Font $txtSmtp; Set-Font $lblPort; Set-Font $comboPort
Set-Font $lblFrom; Set-Font $txtFrom; Set-Font $lblDispName; Set-Font $txtDispName
Set-Font $lblTo; Set-Font $txtTo; Set-Font $lblCc; Set-Font $txtCc
Set-Font $lblSubj; Set-Font $txtSubj; Set-Font $lblBody; Set-Font $txtBody
Set-Font $chkHtml; Set-Font $chkDarkMode; Set-Font $chkAuth
Set-Font $lblUser; Set-Font $txtUser; Set-Font $lblPass; Set-Font $txtPass
Set-Font $lblAttachment; Set-Font $txtAttachment; Set-Font $btnSelectAttachment; Set-Font $btnSend

# Tooltips
$toolTip = New-Object System.Windows.Forms.ToolTip
$toolTip.SetToolTip($txtSmtp, "SMTP-Server-Adresse, z.B. smtp.example.com")
$toolTip.SetToolTip($comboPort, "SMTP-Port, Standard: 587 für Authentifizierung")
$toolTip.SetToolTip($txtFrom, "Absender-E-Mail-Adresse")
$toolTip.SetToolTip($txtTo, "Empfänger-E-Mail-Adresse(n), Komma-getrennt")
$toolTip.SetToolTip($txtAttachment, "Dateipfad für Anhang oder per Drag & Drop einfügen")
$toolTip.SetToolTip($btnSend, "E-Mail senden")

# Controls zum Formular hinzufügen (nur einmal, keine GroupBoxen)
$form.Controls.Clear()
$form.Controls.AddRange(@(
    $lblSmtp; $txtSmtp; $lblPort; $comboPort;
    $lblFrom; $txtFrom; $lblDispName; $txtDispName; $lblTo; $txtTo; $lblCc; $txtCc;
    $lblSubj; $txtSubj; $lblBody; $txtBody; $chkHtml;
    $chkDarkMode; $chkAuth; $lblUser; $txtUser; $lblPass; $txtPass;
    $lblAttachment; $txtAttachment; $btnSelectAttachment;
    $btnSend; $statusBar
))

# Statusleiste am unteren Rand
$statusBar = New-Object System.Windows.Forms.StatusStrip
$statusLabel = New-Object System.Windows.Forms.ToolStripStatusLabel
$statusLabel.Text = "Bereit."
$statusBar.Items.Add($statusLabel)

# Fenster dynamisch skalierbar machen
$form.FormBorderStyle = 'Sizable'
$form.MinimumSize = New-Object System.Drawing.Size(450, 670)

# Controls dynamisch anpassen (z.B. $groupAddresses, $groupMessage, $txtBody, $txtAttachment)
$txtBody.Anchor = 'Top, Left, Right'
$txtAttachment.Anchor = 'Top, Left, Right'
$btnSend.Anchor = 'Bottom'
$statusBar.Anchor = 'Bottom, Left, Right'

# Drag & Drop für Anhang-Feld
$txtAttachment.AllowDrop = $true
$txtAttachment.Add_DragEnter({
    if ($_.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $_.Effect = [Windows.Forms.DragDropEffects]::Copy
    } else {

        $_.Effect = [Windows.Forms.DragDropEffects]::None
    }
})
$txtAttachment.Add_DragDrop({
    $files = $_.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    if ($files -and $files.Length -gt 0) {
        $txtAttachment.Text = $files[0]
    }
})

# Tab-Reihenfolge setzen
$txtSmtp.TabIndex = 0
$comboPort.TabIndex = 1
$txtFrom.TabIndex = 2
$txtDispName.TabIndex = 3
$txtTo.TabIndex = 4
$txtCc.TabIndex = 5
$txtSubj.TabIndex = 6
$txtBody.TabIndex = 7
$chkHtml.TabIndex = 8
$chkDarkMode.TabIndex = 9
$chkAuth.TabIndex = 10
$txtUser.TabIndex = 11
$txtPass.TabIndex = 12
$txtAttachment.TabIndex = 13
$btnSelectAttachment.TabIndex = 14
$btnSend.TabIndex = 15

# Fokus beim Start auf SMTP-Server-Feld
$form.Add_Shown({ $txtSmtp.Focus() })

# Statusmeldungen bei Senden/Fehler
# (Im Send-Button-Handler: $statusLabel.Text = "Sendevorgang läuft..." usw.)

# Statusleiste zum Formular hinzufügen
$form.Controls.Add($statusBar)

# Formular anzeigen
[void]$form.ShowDialog()
