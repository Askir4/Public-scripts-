# Mail-Faker-GUI

**Achtung: Nur für interne Testzwecke!**

---

## Inhaltsverzeichnis

1. [Beschreibung](#beschreibung)  
2. [Voraussetzungen](#voraussetzungen)  
3. [Installation](#installation)  
4. [Starten des Skripts](#starten-des-skripts)  
5. [GUI-Elemente & Funktionen](#gui-elemente--funktionen)  
6. [Dark Mode & Authentifizierung](#dark-mode--authentifizierung)  
7. [Anhang hinzufügen](#anhang-hinzufügen)  
8. [Fehlerbehandlung](#fehlerbehandlung)  
9. [Haftungsausschluss](#haftungsausschluss)

---

## Beschreibung

Dieses PowerShell-Skript stellt eine einfache grafische Oberfläche (GUI) bereit, um testweise E-Mails **beliebiger Absender- und Empfänger-Adressen** über einen SMTP-Server zu schicken.  
**WICHTIG:** Dieses Tool ist ausschließlich für interne Tests gedacht und darf nicht im produktiven Umfeld eingesetzt werden!

---

## Voraussetzungen

- Windows PowerShell (Version 5.1 oder höher)  
- .NET Framework mit `System.Windows.Forms` und `System.Drawing`  
- Netzwerkzugriff auf einen SMTP-Server (Port 25, 465, 587 oder 2525)  

---

## Installation

1. Skript-Datei **`Mail-faker-gui-03.ps1`** in einen lokalen Ordner kopieren.  
2. PowerShell mit **Administrator-Rechten** starten (falls erforderlich).  
3. Gegebenenfalls Execution Policy anpassen:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
