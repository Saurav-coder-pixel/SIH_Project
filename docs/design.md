# design.md — Nook UI/Design System Reference

PURPOSE: This is the visual and component reference for building Nook's
Flutter UI. It is based on an approved reference design (light-themed,
clean, trust-first hyperlocal app). Every screen built in Flutter should
match this system unless explicitly changed by the team — treat this like
AGENTS.md but for design decisions.

Reference screens observed: Onboarding, Home/Categories, Search/Need results,
Provider Profile, Connection Request, In-app Chat, Post-connection Rating.
Every screen below is mapped to the required screen inventory in
docs/architecture-spec.md so nothing in the reference gets built without a
backing feature, and nothing required gets skipped because it wasn't in the
reference mockup.

---

## 1. Visual language

- **Theme:** Light only. White/off-white base (#FFFFFF, #FAFAF8-ish warm
  off-white for large illustration panels). No dark mode for MVP.
- **Overall feel:** Clean, trustworthy, modern — closer to a fintech/trust
  product (Airbnb-Trust, LinkedIn-clean) than a social feed. NOT
  Snapchat-dark, NOT map-heavy-first. Warmth comes from soft illustration,
  not color saturation.
- **Primary accent color:** Indigo/blue (~#4F5DFF / #4A55E8 range) — used for
  primary buttons, active nav state, links, selected chips, "Best Match"
  text.
- **Success / trust color:** Soft green (~#E8F7EE background, #1E9E5A text/
  icon) — used ONLY for consent/privacy reassurance banners and verified
  states. This color = "you are safe/protected," reserve it for that meaning
  only.
- **Text:** Near-black (#111111 / #1A1A1A) for headings, mid-gray (#6B7280)
  for secondary/meta text (timestamps, subtext, review counts).
- **Borders/dividers:** Very light gray (#E5E7EB), 1px, used on unselected
  chips and card outlines — kept subtle, not heavy.
- **Rating stars:** Gold/amber outline-filled stars, small, inline with bold
  numeric rating (e.g. "4.8 ★").

## 2. Typography

- Sans-serif, modern (Inter / SF Pro / Manrope-equivalent in Flutter: use
  `Inter` via google_fonts package).
- Headings: bold, large (24–32px equivalent), tight line height.
- Body: regular weight, 14–16px equivalent, generous line height for
  readability (About sections, chat bubbles).
- Buttons/labels: medium-bold, 14–16px.
- No italics, no decorative fonts anywhere.

## 3. Spacing & shape

- 8pt grid spacing throughout.
- Corner radius: large and consistent — cards ~16–20px radius, buttons fully
  pill-shaped (999px radius), chips fully pill-shaped, small elements
  (avatars) circular.
- Cards: white background, soft shadow OR 1px light border (not both
  heavily) — reference screens lean on borders/whitespace more than drop
  shadow.
- Generous whitespace between sections — do not compress the layout to fit
  more content; let sections breathe (matches reference's sparse, calm
  density).

## 4. Component library

### Buttons
- Primary: filled pill, accent blue background, white bold text (e.g.
  "Send Request").
- Secondary/outline: white background, thin border, black text, pill shape
  (e.g. "I already have an account", "Message").
- Filter chip (unselected): white bg, thin gray border, black text, pill.
- Filter chip (selected): filled accent blue, white text, pill (e.g.
  "Verified" filter, "Photographer" category, "$300-$600" budget option).

### Cards
- Result/profile card: white bg, rounded corners, avatar (circular) + name +
  role/subtitle + rating row + meta stats row (reviews, jobs completed,
  response time) — all left-aligned, generous padding.
- Section cards (Services Offered, Featured Work): simple list rows with
  right-aligned price, or horizontal-scroll image thumbnails with rounded
  corners for portfolio/featured work.

### Badges & trust signals
- Verification badge: small shield/check icon, used inline next to name or
  as a standalone "100% Verified Help" banner element on onboarding.
- Consent/privacy banner: soft green rounded banner with shield icon +
  reassurance copy (e.g. "Your contact information is shared only after
  mutual consent is granted. Safe and reliable.") — appears on the
  connection-request screen, directly addresses Q6/Q7 from the interview
  set (never expose contact/address without consent).
- Rating display: bold number + gold star icon + "(N reviews)" in gray,
  inline, everywhere a provider is shown (list, card, profile).

### Navigation
- Bottom tab bar, 4 items: **Home, Search, Messages, Profile** — icon above
  label, accent blue for active tab, gray for inactive. Simple, no floating
  action button needed in the reference style.
- Screen header pattern: back arrow (top-left) + centered or left title +
  optional right-side icon action (share, call). Consistent across all
  secondary screens.

### Forms & inputs
- Natural-language need input: rounded search-bar-style field with a small
  sparkle/AI icon prefix, placeholder like "I need a photographer for...",
  NOT a plain text box — visually signals "this understands language," not
  "this is a keyword filter."
- Date/time pickers: two side-by-side rounded fields ("Preferred Date",
  "Preferred Time") with icon prefixes.
- Budget selector: horizontal row of pill chips ("$100-$300", "$300-$600",
  "$600+") — single-select, selected = filled blue.
- Message/textarea: large rounded rectangle, placeholder guidance text,
  used both for connection-request messages and post-job reviews.
- Chat input: rounded pill text field + circular send button (filled blue,
  paper-plane icon), "+" attach icon on the left.

### Chat
- Message bubbles: sender (provider) = light gray bg, left-aligned;
  recipient (self) = filled accent blue bg, white text, right-aligned.
  Timestamps small and gray, below each bubble.
- System/consent banner inside chat: centered gray pill banner with lock
  icon (e.g. "Connection accepted. You can now chat and safely coordinate
  task details.") — reinforces consent-gating at the exact moment it takes
  effect.

### Post-connection rating
- Star selector (large, tappable, gold outline -> filled on selection).
- Tag chips for quick feedback ("Professional", "Skilled", "Friendly" etc.)
  — multi-select pills, same chip style as filters.
- Free-text comment box below.

## 5. Screen-by-screen mapping (reference -> required build)

| Reference screen (from mockup) | Required spec screen (docs/architecture-spec.md) | Notes |
|---|---|---|
| Onboarding illustration + "Find trusted help nearby" | Landing / role selection | Add role-selection UI here — reference shows generic entry, spec requires explicit "Find a service" vs "Offer a skill" choice before this or right after |
| "Hello, Sarah" + category chips + locality | Home screen | MUST also include a map view per spec (approximate locality/zone only) — reference's home is list/category-first; add a map toggle or map section to satisfy the spec's map-privacy requirement, not a plain category grid alone |
| Natural-language search bar + filters (Distance/Rating/Verified/Available Now) + "3 verified matches found" | Need composer + Nearby results list | Filters map directly to ranking signals (distance, rating=reputation, verified=verification tier, available now=availability) — keep these as the visible filter set |
| Provider Profile (About, Services Offered, Featured Work, stats) | Result detail / trust card | Add the explainable match breakdown (skill match / distance / verification / availability / reputation) somewhere on this screen — reference doesn't show it explicitly, spec requires it |
| "New Connection" request screen with date/time/budget + green consent banner | Connection request modal | Exactly matches spec's requirement: message field + reassurance that contact is private until consent |
| In-app chat with consent system banner + call icon | In-app chat | Matches spec directly; call icon = in-app call initiation entry point |
| Post-job rating screen (stars + tags + comment) | Ratings and feedback | Matches directly |

### Screens in the spec NOT shown in the reference — still required, build in this visual system
- Map view with approximate locality/zone pins (spec's core map-privacy
  requirement — reference mockup skipped this, do not skip it in the build)
- Radius slider/selector (1/5/10 km)
- Verification dashboard (tiered upload flow, Tier 1/2/3 status)
- My Requests / Connections list (Pending/Accepted/Past tabs)
- Report / block modal
- Settings / privacy controls (visibility toggle, location precision note)
- Match feedback buttons (Useful / Not Relevant / Too Far / Not Trustworthy /
  Unavailable) on each result card — reference shows filters but not this
  specific feedback row; add it to the result card or result detail screen
- Admin screens (Locality Launch Mode, Provider Seeding, Category Density,
  Validation Workspace) — separate internal tool, not part of this
  consumer design system; style plainer/functional, reuse the same color
  tokens but skip the illustration-heavy warmth

## 6. Things to explicitly avoid
- Do not go dark-mode or Snapchat/Instagram-saturated — this reference is
  the actual direction: light, calm, trust-first.
- Do not show an exact address or exact pin anywhere, including in
  illustrations (onboarding art shows generic neighborhood scenes, not real
  map pins — keep it that way).
- Do not skip the green consent banner pattern — it is doing real
  interview-defense work (Q6/Q7) and should appear on every screen where
  contact/location sensitivity is relevant, not just once.
