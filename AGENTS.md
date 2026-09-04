# AGENTS.md — Nook: Hyperlocal Professional & Community Connection Platform (SIH 2026)

You are building "Nook" for Smart India Hackathon 2026 (Problem Statement ID 26199,
Theme: Miscellaneous). Full architecture reference: see docs/architecture-spec.md.
UI/design system reference: see docs/design.md — read this before building any
screen or widget. Do not deviate from this stack, data model, or design system
without asking first.

## Core product loop (build this end-to-end before anything else)
1. User picks role: "Find a service/professional" OR "Offer a skill/service"
2. User creates/completes profile: profession, skills, services, interests,
   experience, availability, verification status
3. User describes a need in natural language
4. AI/NLP converts need -> structured matching attributes (category, urgency,
   location context) — WITHOUT inventing providers
5. Geospatial search finds candidates within selected radius
6. Ranking combines: relevance, distance, verification, availability, reputation
7. User marks each result: Useful / Not Relevant / Too Far / Not Trustworthy / Unavailable
8. User sends connection request — contact stays private until accepted
9. Outcome recorded for analytics

## Tech stack — do not substitute without confirming
- Frontend: Flutter (single codebase, Android + iOS)
- Backend: Node.js + Express, stateless services
- Database: MongoDB with 2dsphere geospatial index (primary)
- Cache: Redis (bounded TTL, invalidated on profile/provider change)
- Auth: Phone OTP-based (Firebase Auth or JWT)
- Realtime chat: Firestore listeners or Socket.io
- AI/NLP: Multilingual sentence-transformer embedding model (versioned) +
  deterministic rule-based hard filters — hybrid, not AI-only
- Maps: Internal `location-service` wrapping Google Geocoding + Places +
  Maps JS API — frontend never calls Google directly
- Async jobs: Queue (RabbitMQ/Kafka) for notifications/embeddings/analytics only
  — never put synchronous nearby-search behind a queue

## NON-NEGOTIABLE RULES (enforce in code, not just UI)
- Public profile APIs must NEVER return exact home coordinates — only
  `locality_name` and approximate distance
- Phone/email must NEVER be returned until connection consent is granted
- AI may suggest similarity but must NEVER invent candidate records, credentials,
  or bypass radius/visibility/verification filters — candidate IDs must
  originate only from the database search service
- High-risk profession categories (doctor, CA, regulated professions) cannot
  be publicly discoverable without completing Tier 3 verification first
- Never put basic nearby-search behind an async queue — it must stay synchronous
- Do not build: public people-directory, large social feed, nationwide
  directory, dozens of categories, or a recommendation engine that invents
  providers

## Verification tiers
- Tier 1 (Basic — students/general users): verified phone + KYC -> basic badge
- Tier 2 (Skilled provider — electrician, mechanic, decorator): ID + peer/
  community signals -> provider badge
- Tier 3 (Regulated — doctor, CA, financial/regulated): license/registration
  number verification + identity -> MANDATORY before publishing service profile

## Build priority — implement in this order
P0 (must work in the live demo): auth/roles, profiles, location, need input,
  nearby search, ranking, verification status, connection request,
  privacy-safe profile API, basic reports, radius slider, locality display,
  match explanation card, verification badge, feedback buttons, no-match
  radius expansion

P1 (must exist in architecture, can be partially stubbed): AI parser,
  embedding service, grounding/validation layer, Redis caching, load
  balancing config, rate limiting, admin moderation queue, analytics funnel,
  Locality Launch Mode, Provider Seeding Dashboard, referral codes, Need
  Test/Concierge mode, validation workspace

P2 (architect the contract now, activate later): full notification engine,
  Kafka/RabbitMQ workers, sharding activation, advanced reputation scoring,
  CDN optimization

## Minimum end-to-end demo scenario (this must work before anything else)
1. Business role selects "Find a service"
2. Business enters: "I need product photography for 500 SKUs this week"
3. System parses: category=product photography, urgency=this week
4. System uses business location + selected radius
5. Nearby candidates returned with locality, approximate distance,
   verification, availability, reputation
6. User filters/compares, marks one candidate "Useful"
7. User sends connection request
8. Provider accepts
9. In-app chat opens — exact home address stays hidden throughout
10. Analytics records the full funnel (need -> match -> request -> accepted)

## Multi-contributor sessions — READ THIS FIRST, EVERY SESSION
This project has multiple team members, each running their own Antigravity
session (possibly on different machines, different days). A single agent
session can also hit a usage/turn limit mid-task. To avoid duplicated or
conflicting work:

1. Before writing any code, read PROGRESS_LOG.md in full — not just this
   file. Check its "IN PROGRESS / BLOCKED" section first. If something is
   marked in-progress or blocked, resume and finish that work before
   starting anything new, unless the user tells you otherwise.
2. Before ending the session — or the moment you sense you're about to hit
   a usage/turn/context limit — stop and write a new entry in
   PROGRESS_LOG.md under "SESSION LOG" using the template already in that
   file. Also update "IN PROGRESS / BLOCKED" and "NEXT UP" so the next
   contributor knows exactly where to resume. Do this even if the task
   feels unfinished — a half-done task with a clear log entry is far more
   useful to a teammate than a silently abandoned one.
3. Never overwrite or delete a previous log entry. Append only.
4. If you make an architectural or scope decision not already covered in
   this file or docs/, record it in PROGRESS_LOG.md's "DECISIONS LOG" so
   other contributors' sessions don't contradict it later.

## Before writing code
Confirm the data model (docs/data-model.md) and API contract
(docs/api-contract.md) with me before implementation. Then start with the P0
module list and the minimum end-to-end demo scenario above.
