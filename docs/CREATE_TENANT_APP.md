# Eigene App für einen Tenant starten

Eine Organisation-App ist eine eigene Flutter-App für **genau einen**
NGO.Tools-Tenant. Sie erhält feste API-, OIDC- und App-IDs und bietet keine
freie Tenant-Auswahl. Der einfachste Einstieg ist ein öffentlicher Skill, der
den vollständigen, versionierten Arbeitsauftrag enthält.

## Mit einem KI-Agenten

Dieser Startauftrag funktioniert für Codex, Claude Code und andere Agenten,
die eine öffentliche `SKILL.md` lesen können:

```text
Erstelle eine eigene NGO.Tools-App für meine Organisation.
Nutze dafür den öffentlichen Skill:
https://github.com/ngo-tools/mobile-platform/tree/main/skills/create-ngo-tools-app
```

Mehr musst Du technisch nicht vorbereiten. Der Agent fragt zu Beginn immer
schlicht nach dem Organisations-Slug. Du gibst den Slug als freie Eingabe ein;
es gibt keine Auswahl zwischen Demo-, Staging- oder anderen Tenants.
Danach wählst Du aus, welche verfügbaren Module direkt mitgegeben werden
sollen. Diese Startauswahl lässt sich später jederzeit um weitere verfügbare
Module ergänzen. Anschließend erledigt der Agent selbst:

1. den öffentlichen Skill und die Mobile Platform laden;
2. den vollständigen, geprüften Platform-Commit bestimmen;
3. die App-Registrierung beim genannten Tenant starten;
4. nach Deiner Browser-Freigabe die öffentliche Konfiguration abholen;
5. einen passenden Zielordner aus dem App-Slug ableiten;
6. die tenantgebundene App generieren, anpassen und gegen Staging prüfen.

Der Agent fragt nur nach Entscheidungen, die er nicht sicher ermitteln darf:

- Module, die direkt mitgegeben werden sollen;
- iOS, Android oder beide Plattformen;
- Support- und Datenschutz-URL;
- öffentliche Store-/Signing-Kennungen, falls sie noch nirgends hinterlegt
  sind;
- optionale Logos, Farben und fachliche Besonderheiten.

Bei Self-Service wird ohne Rückfrage das kundeneigene Repository mit den
kundeneigenen Store-Konten verwendet. Einen Arbeitsnamen leitet der Agent aus
dem Organisationsnamen oder Slug ab.

Die Browser-Freigabe bleibt immer eine menschliche Handlung. Sie zeigt die
konkrete Organisation, App-IDs und Plattformen, bevor NGO.Tools Staging und
Production registriert. Der Agent erhält keine Produktionsdaten, Tokens,
Signing-Schlüssel oder Store-Zugänge.

## Manuell

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

## Fertig für Staging

- Tenant, App-IDs, Redirects und Endpunkte stammen aus der freigegebenen
  Registrierung.
- Die App besitzt keine freie Tenant-Auswahl.
- Development bleibt synthetisch und Staging verwendet ausschließlich den
  provisionierten Test-Tenant.
- Nur registrierte, verfügbare Module sind eingebunden; Backend-Capabilities
  und Benutzerrechte bleiben maßgeblich.
- Im Repository liegen keine Secrets, Signing-Schlüssel oder Store-Zugänge.
- Analyse, relevante Tests und mindestens ein Staging-Debug-Build sind grün.

Commit, Push, Deployment, Signierung und Store-Veröffentlichung benötigen
weiterhin jeweils eine ausdrückliche Freigabe.
