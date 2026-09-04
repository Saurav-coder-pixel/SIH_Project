# Core API Contract

| Module | Example endpoint | Purpose |
|---|---|---|
| Auth | POST /auth/register | Register + base verification initiation |
| Users | GET /users/me | Profile |
| Profiles | PATCH /profiles/me | Update profession/skills/services/visibility |
| Location | POST /location/geocode | Address/place -> lat/lng via internal abstraction |
| Needs | POST /needs | Create a natural-language need |
| Needs | GET /needs/:id/matches | Return ranked nearby candidates |
| Matches | POST /matches/:id/feedback | Useful/not relevant/too far/not trustworthy/unavailable |
| Connections | POST /connections/requests | Request connection |
| Connections | PATCH /connections/requests/:id | Accept/reject |
| Messaging | POST /conversations | Start conversation after consent |
| Reports | POST /reports | Report profile/content/misuse |
| Verification | POST /verification/start | Start tier-specific verification |
| Admin | GET /admin/localities/:id/density | Category density and supply gaps |
| Admin | POST /admin/providers/invite | Provider seeding/invitations |
| Validation | POST /admin/validation/respondents | Record interview/concierge evidence |
| Analytics | GET /admin/analytics/funnel | Needs -> matches -> requests -> accepted connections |

## Map/vendor abstraction rule
Frontend calls only your own `location-service`. That service uses Google
Geocoding, Places and Maps internally. This keeps vendors swappable and
centralizes privacy/rate limiting — the frontend must never call Google
Maps APIs directly.

## Matching pipeline (hybrid — deterministic core + AI assist)
1. Parse raw text -> need/category/urgency/availability/budget/location context
2. Apply HARD filters -> profile active, visibility allows discovery,
   mandatory verification satisfied where required, radius allowed,
   category compatible
3. Run semantic similarity -> need embedding vs provider skills/services
   embeddings
4. Add deterministic signals -> distance, availability, verification tier,
   reputation, historical feedback
5. Rank + explain -> return a "Why this result?" breakdown, never a black box
6. Gather feedback -> Useful / Not Relevant / Too Far / Not Trustworthy /
   Unavailable
7. Record outcome -> connection request, acceptance, eventual success

AI safety boundary: AI may suggest similarity but may NOT create candidate
records, invent credentials, bypass radius/visibility/verification filters,
or expose hidden data. Low-confidence semantic matches fall back to
deterministic keyword/category matching, or show "no match" — never invent
a confidence score.

## Acceptance checklist (must pass before demo)
- [ ] Public profile API never returns exact home coordinates
- [ ] Changing radius (1/5/10 km) correctly changes candidate scope
- [ ] No local match -> radius expands automatically, user is informed
- [ ] Regulated/high-risk provider cannot be discoverable pre-verification
- [ ] User can report a false skill claim; admin can review/suspend
- [ ] Every result shows explainable ranking signals
- [ ] AI cannot return a candidate ID not present in the DB candidate list
- [ ] Low-confidence AI match falls back to deterministic matching
- [ ] Every result supports structured feedback
- [ ] Contact details stay private until connection consent
- [ ] Rate limits and report/block flows work
- [ ] Search endpoints are stateless
- [ ] Need -> match -> request -> acceptance funnel is stored and queryable
