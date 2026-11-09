# Codex QA prompt: paywall app side and docs (2026-11-09)

Paste everything below the line into a new Codex session. Written by the author session, which does not QA its own work.

---

You are the independent QA reviewer for the app side and docs of the Cramapple 72-hour free-sample change. You did not build it. Do not fix anything; report. Tier: Hard-Gate (access control, payments adjacency, minors' data). Start with `docs/team_charter/CRAMAPPLE_SESSION_START.md` and `docs/INDEX.md` per `AGENTS.md`. Do not scan the repo broadly.

## What you are reviewing

1. **Docs PR** (Cramapple repo, draft, PR #593, branch `claude/paywall-app-docs-cdd3b5`): `APPROVAL-0206`, `docs/product/PAYWALL_PHASE0_AND_UNIT_AUDIT_2026_11_08.md`, `docs/product/PAYWALL_ANALYTICS_AND_EMAIL_DRAFTS_2026_11_08.md`, `docs/handoffs/PAYWALL_APP_QA_PACKET_2026_11_08.md`, `docs/handoffs/LOVABLE_PROMPT_TRY_ROUTE_DRAFT_2026_11_08.md`, plan status block, `docs/INDEX.md`, log entries.
2. **App PR** (`david-bloom/ap-prep-blueprint`, draft, PR #47, branch `claude/paywall-sample-app-wiring`): `src/lib/sample/*`, `src/screens/sample/SampleJourney.jsx`, `src/routes/sample.tsx`. (The earlier mock scaffold, PR #45, is already merged.)
3. The contract they must match: `docs/product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md` on main, §3, §4, §8, §10, §11, §14 (decided as DECISION-0134). The backend itself is reviewed separately (`docs/qa/QA_PACKET_PAYWALL_SAMPLE_BACKEND_2026_11_08.md`); here, check only that the app uses it correctly.

Authority: `APPROVAL-0206` is Development/draft only. No Production deploy, Lovable publish, email or Loops send, PostHog schema change, or flag enablement is authorized. The open rules in plan §8, D6 (experiment) and D7 (nurture emails) are not decided; anything depending on them must be a marked placeholder, not a silent decision.

## Known limits (do not report these as new findings; confirm they are accurately disclosed)

- App is NOT verified against a live backend. `sample-try` exists in Development only, flags off; the app's local env points at Production.
- Not built: FRQ source choice, photo-answer submission, transcript confirm, BYOQ confirm in the sample, analytics emission, `ad_attribution` forwarding, marketing `/try`, checkout first-paint fix, follow-on question queue (`student-session-items`).
- Backend §11: uploaded-FRQ grading is a blocker; the UI must not promise it works.

## Checks

**A. Contract fidelity (app vs spec §10).** Operation names and payload fields for `sample-try`; RPC names `claim_sample_try(p_try_token)` and `get_sample_access_state()`; mapping of `phase` (active/grace/expired/superseded/revoked/disabled), counts, deadlines, `in_progress`, `offer_context`. Does `invoke` return shape handling (`data.result` vs `data`) match the real edge response `{status, operation, result}`? Are typed errors read from the response body for non-2xx? Are all §8 codes either handled or fall to a safe default?

**B. Rules are the server's.** The client must not derive eligibility, deadlines, remaining counts, or prices. Look for any client-side computation of phase, any hard-coded price or trial length, any `7`/`8`/`72` that is not display copy. Check "7 more questions" and "question 1 of 8" copy against server values.

**C. Retry safety and token handling.** Double-click Register/claim, two tabs, reload mid-claim, claim failure after answer, sign-in redirect round trip (`studentLoginHref`), token cleared only on final refusals, token never logged, put in a URL, or sent to analytics. localStorage unavailable. Expired (24h answer / 7d claim) tokens. Rule refusals vs transient failures: is "save failed" ever shown for a rule refusal, or a retry button for a final one?

**D. Anonymous exposure.** Confirm the anonymous path never renders or stores `is_correct`, rationale, or explanation before the answer. Check what gets stored in the browser and sent to PostHog (allow-list in `src/lib/posthog.ts`): no question text, answer text, names, emails.

**E. Flag and routing.** Flag off => `/sample` is a 404 and nothing sample-related loads or calls the network. `?state=` preview is clearly labelled MOCK and cannot be mistaken for live. No new nav links, no route reachable from marketing.

**F. Copy honesty.** The 72-hour sample and the seven-day card trial are named differently everywhere. Never "access ended", "account closed", "can't log in". Saved feedback stays readable. Deadlines are server timestamps with time zone. Email drafts are not labelled transactional and say nothing false about grace.

**G. Design rules** (`docs/new_design/`, skill `cramapple-design`): orange, light, Bungee, square, zero motion, no characters, brand bar only for anonymous/new users. Check 375px and desktop in a browser; keyboard and screen-reader basics (radiogroup labels, status/alert roles, focus after state changes); contrast; no horizontal scroll.

**H. Docs accuracy.** Phase 0 and per-unit audit numbers: recount a sample of units against Production read-only SQL yourself (do not trust the table). Does any doc claim something shipped, verified or decided that is not? Are D6/D7/§8 left open? Log entry and approval numbering consistent (no collision with open PRs); INDEX rows resolve to real files.

**I. Build checks.** In the app clone: `npx tsc --noEmit`, `npx vitest run` (author reports 1295/1295), `npx vite build`. Report any differences. Try to break the 10 new mapping tests (do they assert anything real?).

**J. Live check, Development only, if you can.** Point a local app at the Development Supabase project (`wmgjsdkphcyhngaffbqf`), enable the flags only there, and walk: unit list, start, answer, register, claim, grant state, second claim replay, a second account (should see `already_sampled`), expiry/grace via time manipulation in Development. Never touch Production writes; never print or commit keys.

## Output

A findings list ranked by severity. For each: what, where (`file:line`), how to reproduce, and whether it is a **verified** observation or an **inference**. Separate: blockers before any release request, should-fix, notes. State explicitly what you did not check. End with a one-line verdict per PR: ready for David's review / needs changes / blocked. Do not merge, publish, send, or change flags.
