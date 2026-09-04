# PROGRESS_LOG.md — Nook Team Build Log

PURPOSE: Multiple team members will run separate Antigravity sessions on this
project (different laptops, different agent instances, different days).
Antigravity does NOT share memory across contributors or across sessions
that hit a usage limit mid-task. This file is the single source of truth for
"what has been built, what's half-done, and what's next" — every session
must read it first and update it before finishing.

HOW TO USE THIS FILE (for the AI agent, every session):
1. On session start: read this entire file before writing any code, even if
   AGENTS.md was already read. Check the "IN PROGRESS / BLOCKED" section
   first — if something is marked in-progress or stuck, resume that work
   instead of starting something new, unless the user explicitly says
   otherwise.
2. Before ending a session, or if you are about to hit a usage/turn limit:
   add a new entry under "SESSION LOG" with the format below, and update
   "IN PROGRESS / BLOCKED" and "NEXT UP" so the next contributor (human or
   agent) knows exactly where to pick up.
3. Never delete a previous entry. Append only. If something an earlier
   entry describes turns out to be wrong or was later changed, add a new
   entry noting the correction — don't rewrite history.
4. Keep entries factual and specific: file paths touched, what works, what
   doesn't, and any decision made (e.g. "chose MongoDB over Postgres per
   spec"). Vague entries like "worked on backend" are not useful to the
   next person.

---

## IN PROGRESS / BLOCKED
(Update this section every session — this is the first thing the next
contributor reads.)

- Nothing started yet. First contributor: replace this line with what
  you're about to work on.

## NEXT UP
(Ordered list — what should happen next, per AGENTS.md build priority.)

1. Scaffold P0: auth/roles, profile schema, location schema
2. Nearby search + radius slider (P0)
3. Need input + basic ranking (P0)
4. Connection request flow (P0)
5. See AGENTS.md "Build priority" section for full P0/P1/P2 order

## DECISIONS LOG
(One line each — permanent record of choices made mid-build that aren't
already in AGENTS.md, so nobody re-litigates or contradicts them later.)

- (none yet)

---

## SESSION LOG
(Newest entry at the top. Copy the template below for each new entry.)

### Template for new entries
```
### [YYYY-MM-DD HH:MM] — Contributor: <name> — Module(s): <e.g. auth, profiles>
STATUS: Completed / In progress / Blocked
WHAT WAS DONE:
- <specific file(s) created/changed and what they do>
- <any endpoint/schema/screen implemented>
WHAT'S NOT DONE / KNOWN ISSUES:
- <anything half-built, TODOs left in code, bugs known but not fixed>
BLOCKED ON (if applicable):
- <e.g. "hit Antigravity usage limit mid-way through ranking service",
   "waiting on Google Maps API key", "need team decision on X">
NEXT STEP FOR WHOEVER PICKS THIS UP:
- <concrete next action, not just "continue">
```

(No entries yet — first contributor adds the first one here.)
