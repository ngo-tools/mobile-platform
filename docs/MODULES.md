# NGO.Tools mobile modules

<!-- GENERATED FILE. DO NOT EDIT. -->

This catalog describes client integration requirements. Server capabilities and policies remain authoritative.

## Chat (`chat`)

- German: Chat
- Status: `planned`
- Delivery: `package` (`ngotools_chat_module`)
- Required modules: `profile`
- API scopes: `chat:login`, `chat:read`
- Features: `chat`
- Permissions: none
- Device permissions: none
- Deep links: `/chat`, `/chat/rooms/{id}`

The organization's encrypted chat with direct messages, groups, and threads.

Verschlüsselter Chat der Organisation mit Direktnachrichten, Gruppen und Threads.

## Contacts (`contacts`)

- German: Kontakte
- Status: `available`
- Delivery: `package` (`ngotools_contacts`)
- Required modules: `profile`
- API scopes: `contacts:read`, `contacts:write`
- Features: `contacts`
- Permissions: `contacts:read`, `contacts:write`
- Device permissions: none
- Deep links: `/contacts/{id}`

Searches and manages contacts with controlled offline behavior.

Durchsucht und verwaltet Kontakte mit kontrolliertem Offline-Verhalten.

## Events (`events`)

- German: Veranstaltungen
- Status: `available`
- Delivery: `package` (`ngotools_events`)
- Required modules: `profile`
- API scopes: `events:read`, `events:write`
- Features: `events`
- Permissions: none
- Device permissions: none
- Deep links: `/events/duties`, `/events/{id}`

Shows events with agenda and team, own services, and asks for availability.

Zeigt Termine mit Ablauf und Team, eigene Dienste und fragt die Verfügbarkeit ab.

## Profile (`profile`)

- German: Profil
- Status: `available`
- Delivery: `built_in`
- Required modules: none
- API scopes: `profile:read`
- Features: `profile`
- Permissions: `profile:read`
- Device permissions: none
- Deep links: `/profile`

Displays the current sanitized NGO.Tools user profile.

Zeigt das eigene bereinigte NGO.Tools-Benutzerprofil an.
