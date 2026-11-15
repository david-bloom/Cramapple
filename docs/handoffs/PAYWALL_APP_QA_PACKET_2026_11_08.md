# QA packet for Codex — paywall plan app/docs work (2026-11-08)

**For:** Codex (independent QA). The author does not QA this work. **Authority:** `APPROVAL-0206`, Development/draft only. Nothing was published, deployed, emailed or enabled.

## What changed
**Cramapple repo (docs, draft PR):** `docs/product/PAYWALL_PHASE0_AND_UNIT_AUDIT_2026_11_08.md` (read-only Production findings), `docs/product/PAYWALL_ANALYTICS_AND_EMAIL_DRAFTS_2026_11_08.md` (proposed events; email DRAFTS), `docs/handoffs/LOVABLE_PROMPT_TRY_ROUTE_DRAFT_2026_11_08.md` (unsent), `APPROVAL-0206`, `ACTIVITY_LOG` entry, plan status/handoff in `PAYWALL_CHANGE_PLAN_2026_10_31.md`, `docs/INDEX.md`.
**App repo `david-bloom/ap-prep-blueprint`, branch `claude/paywall-sample-app-ui` (draft PR, not merged):** flag-gated `/sample` route (`src/routes/sample.tsx`), screen `src/screens/sample/SampleJourney.jsx`, `src/lib/sample/{flag,types,copy,mock}.ts`, tests `src/lib/sample/__tests__/sample-journey.test.tsx`, `SampleJourney` added to `src/imported-js.d.ts`, `src/routeTree.gen.ts` regenerated. **It renders MOCK data only** and says so on the page. No backend call exists.

## How to run
```bash
cd <app clone> && git checkout claude/paywall-sample-app-ui
npm install && git checkout -- package-lock.json   # lock is stale; see memory note
npx vitest run && npx tsc --noEmit -p . && npx vite build
VITE_SAMPLE_JOURNEY=on npx vite dev --port 5191
# open /sample?state=<unit_select|anonymous_mcq|register_prompt|saving|save_failed|active|grace|expired|readonly>
```
Flag off (default): `/sample` must 404. Author verified: vitest 1285/1285 (131 files), tsc clean, `vite build` succeeds, active and expired states rendered at desktop and 375px with no horizontal overflow. **Not browser-verified:** flag-off 404 (covered by a unit test of the flag default and the `beforeLoad`), other phases visually.

## Not built (blocked, do not mark missing by mistake)
Real data and the anonymous MCQ (backend contract not landed); registration handoff and first-answer save; real unit availability; photo-answer submission, transcript confirmation and BYOQ subject/unit/topic confirm UI (existing BYOQ screens exist but are not wired into the sample); analytics wiring (contract is a draft); marketing `/try` (Lovable prompt drafted, unsent); checkout first-paint fix.

## Risk areas to attack
1. **Copy that misstates deadlines:** every state must separate the 72-hour sample from the seven-day card trial; expired copy must not say access closed; grace shows the server deadline; deadlines are server timestamps. Check `copy.ts` and rendered text.
2. **Minors' data collected earlier:** the plan moves registration before any card; confirm the new path is reviewed against privacy/counsel work (plan §7). Nothing here collects data yet.
3. **Attribution loss at registration:** analytics draft requires `identify` aliasing and set-once acquisition properties plus server-side storage; verify once built that a trial start keeps the original `utm_campaign`.
4. **Offer inconsistency:** live landing says pay nothing today; live checkout first paint says $39.99 due today (audit §1). The screen takes offer text from the server and hard-codes no price (test enforces it).
5. **Unit availability:** the audit shows later units cannot deliver 8 MCQs; the picker must come from the backend, not a static list.
6. **Anonymous feedback:** existing `get_graded_mcq_feedback` needs `auth.uid()`; any anonymous path must not loosen answer-key access (DECISION-0089/0117).

## States and screens to check
All nine phases above; mobile 375px; the upgrade sheet appears once and omits the card-trial button when the server says no trial is available; the unit picker disables units that cannot deliver; `save_failed` says no time was used.

## Observations, not defects
Cards use the shared `cm-card` class, which has a purple top rule and soft shadow that may not match the orange/square/zero-motion system; I did not change shared styles. A pre-existing console error ("No queryFn" for `subject-catalog/published-packs`) appears on this route because `subjectLabel` is used without the catalog provider's fetcher; the label still resolves.

## Open decisions this work does not make
§8 open rules, D6 experiment, D7 nurture emails, whether the anonymous question runs on the marketing or app domain.
