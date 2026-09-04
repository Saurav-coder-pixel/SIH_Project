# Code Style & Standards — Nook

- Flutter: null-safety enabled, one widget per file where reasonable, use
  Riverpod or Provider for state management (pick one, stay consistent)
- Backend: Express routes grouped by module (auth/, users/, needs/, matches/,
  connections/, admin/) — one file per resource, not one giant routes.js
- All environment secrets (API keys, DB URIs) go in `.env`, never hardcoded
  or committed
- Every MongoDB query touching `location` must go through the internal
  location-service — no direct `location.lat`/`location.lng` reads from
  route handlers
- Every new API endpoint that returns a user profile must use the
  privacy-safe DTO (see docs/data-model.md) — code review checklist item,
  not optional
- Write a docstring/comment on every function that touches verification
  tier logic or the matching/ranking pipeline — these are the modules
  evaluators will ask about most
- Prefer explicit, named constants over magic numbers (radius defaults,
  score weights, rate limits)
