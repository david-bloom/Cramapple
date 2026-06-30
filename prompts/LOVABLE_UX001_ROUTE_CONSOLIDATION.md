# Lovable Build Brief - Route Consolidation (remove `/prototype`)

## How To Use This File

Give this entire file to Lovable as a focused maintenance prompt. It resolves the
`/prototype` route collisions and is independent of the returning-experience
build (`prompts/LOVABLE_UX001_RETURNING_EXPERIENCE.md`).

Canonical source: `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md`,
`prompts/LOVABLE_UX001_STUDENT_EXPERIENCE.md`.

---

## Goal

There must be exactly **one** student app, living at real top-level routes. The
`/prototype/*` namespace was a temporary review artifact and must not ship.

Promoting the prototype pages to real routes collides with existing live pages.
That collision is **expected and intended** — we want one canonical set of real
routes, not two parallel ones. The prototype (UX-001) implementation is the
canonical version; the live duplicates should be replaced.

## Steps

1. **Before overwriting anything, report a one-line summary of what each
   conflicting live page currently contains**, so nothing valuable is lost:
   - `home.tsx`
   - `progress.tsx`
   - `check-work.tsx`
   - `account-created.tsx`
   If any of these contains real, current work we should keep, **stop and flag it
   before overwriting.**
2. **Make the UX-001 implementation canonical at each real route, then delete the
   `/prototype` duplicate.** Do not keep both. Intended real routes:
   - `/account-created`
   - `/setup`
   - `/setup-paused`
   - `/home`
   - `/progress`
   - `/check-work`
   - `/bring-question`
   - `/topic`
   - `/session/mcq`, `/session/frq`, `/session/uncertain`, `/session/complete`
   - `/account`
3. **`/setup` vs `/session/setup`:** different paths, so no hard conflict. Keep
   them distinct only if `/session/setup` is a genuine mid-session adjustment
   screen. If `session.setup.tsx` merely duplicates the composed first-session
   setup surface, fold it into `/setup` and remove it.
4. After consolidation, **no `/prototype` route, prototype switcher, or
   demo-state menu may remain.** Navigation is ordinary student navigation only:
   Home, Review, Progress, Account.

## Acceptance Criteria

- No `/prototype` route, switcher, or demo menu remains.
- Conflicting live pages are summarized before replacement, then replaced by the
  UX-001 implementations with the prototype duplicates deleted.
- `/setup` and `/session/setup` are either clearly distinct or consolidated.
- All student navigation reaches the real routes; no dead or duplicate routes.

## Do Not Do

- Do not keep both `/prototype/*` and a top-level version of any page.
- Do not overwrite a conflicting live page that contains real current work
  without flagging it first.
- Do not create production database schema unless an existing backend contract
  already requires it.

## Completion Output

Report: conflicting-page summaries, routes changed and deleted, components
touched, anything flagged for keep-vs-replace, and a preview link.
