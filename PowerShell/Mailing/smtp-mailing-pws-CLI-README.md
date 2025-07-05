## smtp-mail-pws-cli (Version 2.0)

**Interner Gebrauch – Testzwecke**

---

### Übersicht

Dieses PowerShell-Skript ermöglicht das Versenden von Test-E-Mails von beliebigen Absender- zu beliebigen Empfängeradressen. Es dient ausschließlich internen Testzwecken und kann mit oder ohne Authentifizierung an einen SMTP-Server angebunden werden.

### Funktionen

* **SMTP-Server-Auswahl:** Abfrage der SMTP-Server-Adresse.
* **Port-Konfiguration:** Standardport 25 oder benutzerdefinierter Port.
* **Optionale Authentifizierung:** Abfrage von Benutzername und Passwort.
* **Betreff und Nachricht:** Eingabe von Betreff sowie Nachrichtentext oder HTML (mit `END` als Abschlussmarker).
* **Absender-Konfiguration:** Festlegung von Absender-Adresse und optionalem Absendernamen.
* **Empfänger und CC:** Mehrfachempfänger (Komma-getrennt) und CC-Adressen.
* **HTML-Unterstützung:** Nachrichten können HTML enthalten.
* **Fehler-Handling:** Validierung aller Eingaben und aussagekräftige Fehlermeldungen.

### Voraussetzungen

* Windows PowerShell (Version 3.0 oder höher empfohlen)
* Netzwerkzugang zum gewünschten SMTP-Server

### Sicherheits-Hinweis

Dieses Skript ist **ausschließlich für interne Tests** vorgesehen. Keine Verwendung in Produktionsumgebungen oder zum Versenden realer E-Mails.

---

## Bedienungsanleitung

1. **Ausführen**

   ```powershell
   .\Mail-Faker-01.ps1
   ```
2. **Eingabeaufforderungen**

   1. **SMTP-Server:** Hostname oder IP des SMTP-Servers.
   2. **Port:** Standard ist 25. Bei Eingabe eines anderen Werts wird dieser verwendet. Ungültige Eingaben führen zur Verwendung von Port 25.
   3. **Authentifizierung:** `j`/`ja` oder `y`/`yes` für Ja, sonst `n`. Bei Ja: Abfrage von Benutzername und Passwort.
   4. **Betreff:** Pflichtangabe. Leere Eingabe bricht das Skript ab.
   5. **Nachricht / HTML:** Mehrzeilige Eingabe, Abschluss mit `END` auf einer eigenen Zeile.
   6. **Absender-Adresse:** Pflichtfeld. Leere Eingabe bricht das Skript ab.
   7. **Absender-Name (optional)**
   8. **Empfänger:** Komma-getrennte Liste. Mindestens ein Eintrag erforderlich (Schleife bis gültig).
   9. **CC-Empfänger (optional):** Komma-getrennte Liste.
3. **Senden**

   * Das Skript erstellt ein MailAddress-Objekt für Absender und Empfänger.
   * Mit `Send-MailMessage` erfolgt der Versand mit HTML-Unterstützung.
   * Erfolgreiche Zustellung wird grün ausgegeben, Fehler rot mit Fehlermeldung.

---

## Beispiele

```powershell
PS> .\smtp-mail-cli.ps1
SMTP-Server: smtp.example.com
Port (Standard: 25): 587
Authentifizierung verwenden? (j/n, Standard: n): j
Benutzername: testuser
Passwort: ********
Betreff: Test-Mail
Gib deinen Nachrichtentext oder HTML-Code ein. Fuege am Ende immer ein END in der letzten Zeile ein!.
Hallo Tester,
Dies ist eine <b>Test-Mail</b>.
END
Absender-Adresse: test@example.com
Absender-Name (optional): Test System
Empfaenger (mehrere mit Komma trennen): user1@example.com, user2@example.com
CC-Empfaenger (optional, mehrere mit Komma trennen): cc@example.com

Mail erfolgreich gesendet an: user1@example.com, user2@example.com | CC: cc@example.com
```

---

## Versionshinweise

* **2.0**: Verbesserte Eingabevalidierung, CC-Unterstützung, HTML-Funktionalität.
* **1.x**: Erste Version ohne Authentifizierungsabfrage und CC.

---

*Dieses Dokument wurde automatisch generiert.*
