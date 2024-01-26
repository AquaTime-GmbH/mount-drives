# Automatisches Mounten von Serverlaufwerken nach Standby

Willkommen! Dieses Skript ermöglicht es dir, Serverlaufwerke automatisch als Administrator einzuhängen, nachdem du deinen Computer ausgeschaltet oder aus dem Standby geholt hast. Folge einfach den Schritten unten, um alles einzurichten.

# Schritt-für-Schritt-Anleitung by CMT

## 1. Kopiere "mountdrives.sh" in dein Home-Verzeichnis

Öffne das Terminal und führe die folgenden Schritte aus:

```sh
cp path/to/mountdrives.sh ~/
```

Stelle sicher, dass du den vollständigen Pfad zur "mountdrives.sh"-Datei angibst.

## 2. Kopiere "com.mountdrives.afterstandby.plist" in den LaunchAgents-Ordner
Öffne den Finder und gehe zu "Gehe zu..." -> "Gehe zum Ordner..." (oder benutze COMMAND + SHIFT + G) und gib ein: _~/Library/LaunchAgents_

Kopiere dann die _com.mountdrives.afterstandby.plist_-Datei in diesen Ordner.

## 3. Lade das LaunchAgent-Setup
Führe den folgenden Befehl im Terminal aus:

```sh
launchctl load ~/Library/LaunchAgents/com.mountdrives.afterstandby.plist
```

# Wenn kein Fehler auftritt, ist das Setup abgeschlossen!

## Nutzung
Nachdem der Computer ausgeschaltet oder aus dem Standby geholt wurde, wird das Skript automatisch gestartet und die Serverlaufwerke werden als Administrator eingehängt.

Viel Spaß mit deinem automatisierten Setup! 🚀