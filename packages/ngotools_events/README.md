# ngotools_events

Events for NGO.Tools organization apps. The package lists upcoming events the
user may see, shows an event's agenda with computed start times, songs and
keys, and its team by name only. Volunteers see where they are scheduled and
answer availability requests.

Visibility is decided by the server: events of calendars the user may view,
plus events the user's contact serves at or is asked about. The module needs
the `events` feature, `events:read` to read and `events:write` to answer
availability. Tokens without `events:write`, such as live previews, stay
read-only; the views switch to a read-only notice after the first denied
answer and never retry it silently.

Answers are applied optimistically and reverted when the server rejects them.
The package keeps no offline copy of events.
