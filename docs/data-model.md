# Data Model — MongoDB Reference Design

Field names may be adapted to the framework, but concepts must remain.

## Collections

**users**
_id, name, role, bio, profession, skills[], services[], interests[],
experience[], availability, verification, reputation, location,
locality_name, visibility_settings, contact_settings, search_radius_km,
status, created_at

**needs**
_id, requester_id, raw_text, parsed_need, category, urgency, budget_range?,
preferred_availability?, location_ref, radius_km, status, created_at

**profiles_embeddings**
user_id, embedding_vector, embedding_model, embedding_version, updated_at

**connection_requests**
_id, requester_id, provider_id, need_id, message, status, created_at,
responded_at

**connections**
_id, user_a, user_b, consent_state, chat_enabled, call_enabled, created_at

**ratings**
_id, connection_id, rater_id, rated_user_id, score, tags[], comment,
created_at, moderation_state

**reports**
_id, reporter_id, target_type, target_id, reason, evidence_ref?, status,
created_at, resolved_at

**verification_records**
_id, user_id, tier, method, status, provider_ref?, evidence_ref?,
verified_at, expires_at?

**localities**
_id, name, region, launch_status, supported_categories[], density_metrics,
created_at

**referrals**
_id, referrer_id, code, referred_user_id?, locality_id, created_at,
conversion_state

**analytics_events**
_id, event_type, actor_role, locality_id, need_id?, candidate_id?,
metadata, created_at

**validation_respondents**
_id, segment, approached, completed, current_solution, pain_points,
trust_concern, willingness, evidence_ref?, created_at

## Required location shape (privacy contract — enforce at schema/API layer)
```
location: { lat: Number, lng: Number }   // exact, stored server-side only
locality_name: String                    // human-readable, safe to expose
location_visibility: enum(...)
search_radius_km: Number
```

## Public profile response rules (DTO layer, not just a UI convention)
- Return `locality_name` + approximate distance only
- Return a zone/region for map display — NEVER exact coordinates
- NEVER return phone/email until connection consent is granted
- Enforce at the API/schema level so a modified client can't bypass it

## Verification tiers
| Tier | Examples | Checks | Profile state |
|---|---|---|---|
| 1 — Basic | Students/general users | Verified phone + compliant ID/KYC | Discoverable, basic badge |
| 2 — Skilled provider | Electrician, mechanic, decorator | ID + peer/community signals + reports/reputation | Provider badge |
| 3 — Regulated | Doctor, CA, financial/regulated | Registration/license number + identity | Mandatory verified badge before publishing |
