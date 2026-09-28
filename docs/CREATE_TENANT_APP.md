# Eigene App für einen Tenant starten

Eine Organisation-App ist eine eigene Flutter-App für **genau einen**
NGO.Tools-Tenant. Bevor irgendetwas registriert oder dauerhaft festgelegt wird,
entsteht zuerst eine lokale Live-Vorschau mit den echten Daten Deiner
Organisation, die ein Organisationsadmin für einige Stunden freigibt. Der einfachste
Einstieg ist ein öffentlicher Skill, der den vollständigen, versionierten
Arbeitsauftrag enthält.

## Mit einem KI-Agenten

Dieser Startauftrag funktioniert für Codex, Claude Code und andere Agenten,
die eine öffentliche `SKILL.md` lesen können:

```text
Erstelle eine eigene NGO.Tools-App für meine Organisation.
Nutze dafür den öffentlichen Skill:
https://github.com/ngo-tools/mobile-platform/tree/main/skills/create-ngo-tools-app
```

Mehr musst Du technisch nicht vorbereiten. Der Agent fragt zu Beginn immer
schlicht nach dem Organisations-Slug. Du gibst den Slug als freie Eingabe ein.
Danach wählst Du aus, welche verfügbaren Module Du zuerst sehen möchtest. Diese
Startauswahl lässt sich später jederzeit um weitere verfügbare Module ergänzen.
Anschließend erledigt der Agent selbst:

1. den öffentlichen Skill und die Mobile Platform laden;
2. den vollständigen, geprüften Platform-Commit bestimmen;
3. eine lokale Preview-App mit automatisch abgeleiteten Test-IDs erzeugen;
4. die gewählten Module einbauen, etwa Kontakte, Profil und Veranstaltungen;
5. eine Live-Vorschau anfordern und Dir Link und Code zur Freigabe zeigen;
6. Analyse und relevante Tests ausführen;
7. die App im lokalen iOS-Simulator oder Android-Emulator starten, in der Du
   Dich mit Deinem NGO.Tools-Konto anmeldest.

Vor dieser Vorschau fragt der Agent **nicht** nach:

- Support- oder Datenschutz-URL;
- endgültigen Bundle- oder Application-IDs;
- Store-, Signing- oder Distributionsdaten;
- Repository-Eigentümer oder App-Namen.

Die Freigabe erteilt ein Organisationsadmin im Browser: Er öffnet den Link,
vergleicht den angezeigten Code und bestätigt. Gib nur Vorschauen frei, die Du
oder Dein Team gerade selbst gestartet habt. Die Vorschau darf danach 8 Stunden
lang ausschließlich die gewählten Module **lesen**; Admins können sie jederzeit
unter Einstellungen → Mobile Apps widerrufen. Sie reserviert keine dauerhaften
IDs. Ist die Live-Vorschau für Deine Organisation noch nicht freigeschaltet
oder wird sie abgelehnt, zeigt der Agent die App mit synthetischen Beispieldaten.

Du kannst zunächst Screens, Module und Gestaltung beurteilen und ändern lassen.

## Erst nach der Vorschau

Erst wenn Du ausdrücklich sagst, dass die App mit dem Tenant verbunden werden
soll, beginnt die Registrierung. Dann werden nur noch fehlende endgültige
Angaben wie Zielplattformen, Support- und Datenschutz-URL sowie öffentliche
App-Kennungen geklärt. Die Browser-Freigabe bleibt eine menschliche Handlung.
Sie zeigt die konkrete Organisation, App-IDs und Plattformen, bevor NGO.Tools
Staging und Production registriert.

Bei Self-Service wird ohne Rückfrage das kundeneigene Repository mit den
kundeneigenen Store-Konten verwendet. Der Agent erhält keine Produktionsdaten,
Tokens, Signing-Schlüssel oder Store-Zugänge.

## Manuell zuerst ansehen

Die synthetische Golden App lässt sich ohne Registrierung direkt starten:

```bash
cd mobile-platform/example/golden_app
flutter pub get
flutter run -t lib/main_development.dart
```

Sie verwendet ausschließlich reservierte `.invalid`-Endpunkte und enthält
keine Produktionsdaten oder Zugangsdaten. Mit echten Daten verbindet sie
`dart run tool/live_preview.dart --app=<absoluter Pfad> --tenant=<slug>`
nach der Freigabe durch einen Organisationsadmin.

## Später manuell mit dem Tenant verbinden

Der manuelle Weg ist für Entwickler gedacht, die die von NGO.Tools exportierte
`ngo-tools.mobile.yaml` bereits besitzen. Im Checkout von
`ngo-tools/mobile-platform`:

```bash
dart pub get
platform_ref="$(git rev-parse HEAD)"

dart run tool/setup_app.dart \
  --registration="/Downloads/ngo-tools.mobile.yaml" \
  --output="../meine-organisation-app" \
  --platform-ref="$platform_ref"
```

Dabei ist:

- `/Downloads/ngo-tools.mobile.yaml` die freigegebene, nicht geheime
  Registrierung aus NGO.Tools;
- `../meine-organisation-app` ein neuer, noch nicht vorhandener Zielordner;
- `platform_ref` automatisch der aktuell ausgecheckte Platform-Commit.

Danach im erzeugten App-Repository:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug -t lib/main_staging.dart
flutter run -t lib/main_staging.dart
```

## Fertig für die Vorschau

- Der Organisations-Slug und die gewünschten Startmodule sind festgelegt.
- Die Live-Vorschau ist freigegeben und liest nur die gewählten Module, oder
  die App zeigt synthetische Beispieldaten.
- Die App läuft lokal im Simulator oder Emulator.
- Noch keine Registrierung, endgültige App-ID oder Store-Konfiguration wurde
  angelegt.

## Später fertig für Staging

- Tenant, App-IDs, Redirects und Endpunkte stammen aus der freigegebenen
  Registrierung.
- Die App besitzt keine freie Tenant-Auswahl.
- Kein Vorschau-Bezeichner (`prv_…`) wird übernommen; Staging verwendet ausschließlich den
  provisionierten Test-Tenant.
- Nur registrierte, verfügbare Module sind eingebunden; Backend-Capabilities
  und Benutzerrechte bleiben maßgeblich.
- Im Repository liegen keine Secrets, Signing-Schlüssel oder Store-Zugänge.
- Analyse, relevante Tests und mindestens ein Staging-Debug-Build sind grün.

Commit, Push, Deployment, Signierung und Store-Veröffentlichung benötigen
weiterhin jeweils eine ausdrückliche Freigabe.
