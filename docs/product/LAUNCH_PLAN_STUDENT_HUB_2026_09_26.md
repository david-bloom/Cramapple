# Launch Plan — Student Hub — 2026-09-26

**Status:** Draft | **Owner:** David Bloom | **Tier:** Standard
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`

## CORRECTION, 2026-09-26 (same day, after a second AI review)

**This plan originally treated `STUDENT_PORTAL_INTERACTION_DESIGN.md` as the sole authoritative spec.
It is not current: `docs/product/APP_REBUILD_MIGRATION_PLAN.md` (2026-09-22, David-approved) is a
newer, phased rebuild plan for this exact surface, with its own decision register (§11, 25 items) and
its own exit criterion.** The two documents partially overlap and are not reconciled with each other.
Do not audit against the older spec alone — you will report "not implemented" against a design that
may itself be superseded.

**RESOLVED and CONFIRMED, 2026-09-26 (`DECISION-0073`): the launch frontend is the "Remix of Cramapple
App" Lovable project** (id `d334fed9-5a97-4e76-906e-7c0ad7082212`), published at
`https://ap-prep-canvas.lovable.app/`. Confirmed via the live HTML's embedded `og:image`, which points
to this exact project's screenshot, and independently via the HTML's TanStack Start/Router markers
matching this project's stored tech-stack description. This session's first guess ("New Cramapple App")
was wrong — corrected.

**No visual/brand rebuild is needed.** The live HTML imports `docs/new_design/`'s token CSS verbatim
(the page's own inline stylesheet comments cite that exact GitHub path) and renders the full
orange/Bungee/Passion One/Source Sans 3 system correctly. The earlier "old blue/red wordmark" finding
was real but pointed at a stale Lovable `get_project` screenshot cache, not the live page — the live
page was already correct. Lesson: don't trust `get_project` screenshots as current-state evidence for
this project; use the live URL/HTML instead.

**New, launch-blocking finding from the live HTML:** the page still shows a $39.99 purchase CTA and a
full Stripe-style pricing/buy section. This is stale against `DECISION-0071` (October 2 launches free, no
Stripe). David is handling this directly (a "Free this week!" banner), not delegated to an agent — see
`LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md`.

## CORRECTION, 2026-09-26 (later same day): the launch frontend has changed since `DECISION-0073`

**`DECISION-0073`'s identification of the launch frontend is now stale.** The marketing/app split
described in `.lovable/plan/split-cramapple-into-marketing-logged-in-projects-2026-09-22.md` has
progressed since that decision was recorded: `ap-prep-canvas.lovable.app` — the alias `DECISION-0073`
verified against — now serves a **different** Lovable project, **"New Cramapple Marketing"**
(`61dd6602-6991-4561-b418-e988bb7c8a0b`, last edited 2026-09-26T16:05 UTC), not "Remix of Cramapple App"
(`d334fed9`, the project the rest of this doc verified). David confirmed directly: `ap-prep-canvas.lovable.app`
is the real, current launch homepage, and `cramapple.com` is intentionally left pointing at the old
`d334fed9` build until the new split app is functional — this is not a defect, it's a deliberate
staged cutover. Everything below in this section is about the **new** split (Marketing +
`56cae479`/"New Cramapple App"), verified live/read directly, not inferred from either project's
`description` or cached screenshot (both have shown stale content before — see the note two sections
up).

**Free-access routing is implemented correctly on the marketing side.** `New Cramapple Marketing`'s
`src/routes/signup.tsx` `SubjectStep.onPick` sends the browser straight to
`appUrl('/home?subject=<slug>')` — bypassing the paid confirm→role→plan→account→Stripe chain entirely
(that chain still exists and is reachable only via deep links, by design, for the parent/bundle-purchase
path). `appUrl()` resolves to `https://app.cramapple.com`, the logged-in "New Cramapple App" project
(`56cae479-f7c9-4988-b536-56538c38ee4e`). This part is done and correct.

**Blocker: the destination isn't reachable yet — this is the actual launch risk, not the routing.**
- `app.cramapple.com` has **no DNS record at all** (checked directly; Namecheap is the registrar/DNS
  host — confirmed by David). `cramapple.com`/`www` do resolve, to `185.158.133.1` (Lovable's
  custom-domain edge IP), so DNS management itself works; the `app` subdomain simply was never created.
- Independent of DNS, the "New Cramapple App" project's own default Lovable preview
  (`id-preview--56cae479-...lovable.app`) redirects to a Lovable login wall at both `/` and `/home`,
  even though its project metadata says `is_published: true` / `publish_audience: public`. That
  combination means the publish/deploy action itself likely hasn't completed — pointing DNS at this
  project today would not fix access on its own. Two separate things need to happen in Lovable before
  DNS matters: confirm `56cae479` is actually publishing successfully, then attach the
  `app.cramapple.com` custom domain to it (which will give the DNS target to add at Namecheap).
- Net effect: a student who visits the real launch homepage, clicks "Get started," and picks a subject
  today lands on a dead domain. Session/grading correctness for the new app (the question below) cannot
  be tested at all until this is fixed, since there is nowhere live to test it.

**The homepage's own "real product" claim doesn't hold up as written.** The interactive demo embedded
in the New Cramapple Marketing homepage (`src/components/homepage-preview/HomepagePreview.tsx`) states
*"The real product is below, not a video of it. Click anything — take a point away, pull a hint, open
the notes."* Read directly: this component is entirely hardcoded client-side state (a fixed `2/3`
score, canned rubric/feedback strings in `CRITERIA`/`MCQ_OPTIONS`/`NARRATION`) with zero backend calls
anywhere in the file — no `supabase.functions.invoke`, no session/attempt creation. It is a scripted
interactive mock, not the real product, regardless of being interactive rather than an autoplay video.
This is a public factual claim that should be corrected or softened before launch, independent of the
app-readiness question above.

## CORRECTION, 2026-09-26 (later still): domain blocker resolved; new bug found in the login path

**The DNS/deploy blocker above is now resolved.** David connected the domains in Lovable directly:
`cramapple.com` → "New Cramapple Marketing" (`61dd6602`), `app.cramapple.com` → "New Cramapple App"
(`56cae479`). Both were verified live (`dig`, `curl`, and browser) after a brief Cloudflare provisioning
window (error 1001, cleared on its own within a few minutes — not a real problem). `cramapple.com` and
`app.cramapple.com` both resolve and serve their correct respective projects now. One mid-flight mistake
is worth recording: David initially connected `app.cramapple.com`'s project to the bare `cramapple.com`
domain, which caused a live production outage (an infinite `302` self-redirect loop at the apex, because
the App project's own `marketing-redirect.ts` assumes `cramapple.com` is a *different* origin) — caught
and corrected within the same session.

**TASK-0044 (AP Statistics MCQ serving) shipped to Production, independent of the domain work above.**
Codex built and Dev-verified a fix on branch `codex/task-0044-statistics-mcq` (commit `7c709b51`) for the
same gap this doc's servability section will need to check: `select_practice_frqs` is FRQ-only, so AP
Statistics' 101 published MCQs were unreachable on the ordinary/flat practice path. Verified and applied
directly to Production in this session, not just reviewed:
- Found and corrected a discrepancy in Codex's own status report first: the `app.select_ordinary_combined_practice_items`
  function already existed in Production in an **older, less-safe form** (missing the retired-pack
  fail-closed check and the "MCQ must have a recorded correct choice" guard) — contradicting the claim
  that "Production remains unchanged." Applied the second, safer migration to bring it in line with what
  Codex tested in Dev.
- Redeployed the `student-session-items` edge function to Production (version 23) with the routing
  branch that calls this selector for AP Statistics on both `targeted_drill` and `mcq` practice formats.
- Verified directly against real Production content post-deploy: `select_ordinary_combined_practice_items`
  called with AP Statistics' real exam-pack-version id returns 20/20 valid MCQs at `mcq` mode. Matches
  Codex's Dev result, now proven against Production data.
- Purely additive: no existing table, function, or other subject's serving path was touched; AP Biology's
  dedicated `select_biology_practice_items` path is untouched.

**New, more serious bug found while live-testing the free-signup flow end-to-end: the post-login
cross-domain handoff is broken.** Traced by reading source in both split projects, not just clicking
around:
- `cramapple.com/signup` → pick a subject → correctly does a full-page cross-domain jump to
  `app.cramapple.com/home?subject=<slug>`. Working as designed.
- On the App side, `/home` renders `HomeV2` (feature-flagged in), which — with no session — does a
  **same-project** client-side `navigate({ to: "/login", search: { redirect: "/home" } })`
  (`src/components/home/HomeV2.tsx`, App project). This silently drops the `subject` param.
- The App project's own `/login` route is a redirect stub (`beforeLoad: () => redirectToMarketing(...)`)
  that correctly bounces to `https://cramapple.com/login?redirect=%2Fhome` — this is the exact URL David
  observed live.
- **The actual bug**: Marketing's `login.tsx` reads that `redirect` param and, after a successful sign-in,
  does `navigate({ to: destination, replace: true })` where `destination = redirect ?? "/home"` — a
  **same-project** client-side navigation within Marketing. Marketing has no `/home` route at all (it only
  exists in the separate App project), so a student who successfully signs in would land on a
  broken/missing route instead of the real app. This would have blocked every free student, not just an
  edge case.
- Fix identified and sent to Lovable (as a direct prompt, 2026-09-26): use `window.location.href =
  appUrl(destination)` in `login.tsx` instead of `navigate()` — the same cross-domain pattern
  `signup.tsx`'s `SubjectStep.onPick` already uses correctly — and preserve the `subject` param through
  the `HomeV2` → login → back-to-home round trip.

**RESOLVED, 2026-09-26 (later still): fix verified live, not just reported.** David forgot to publish
after the first Lovable response; once published, re-checked directly rather than trusting the report:
- `login.tsx` in the correct project (`61dd6602`, the one serving `cramapple.com`) now does
  `window.location.href = appUrl(destination)` in both the manual-sign-in path and the
  already-signed-in effect — confirmed by reading the live source, not just the change description.
- Lovable's own report claimed it could not fix the App-project side ("that code is in the other
  project, I can't change it from here") — but the App project (`56cae479`) had *also* already been
  fixed by the time this was checked: `HomeV2.tsx` now imports a new `src/lib/home-subject-param.ts`
  helper and builds the login redirect as `/home?subject=<slug>` instead of a bare `/home`.
- Live-reproduced end-to-end up to the sign-in wall: clicking "AP Statistics" on `cramapple.com/signup`
  now lands on `https://cramapple.com/login?redirect=%2Fhome%3Fsubject%3Dap-statistics` — the subject
  survives the full cross-domain round trip.
- Lovable's third concern (cross-domain session sharing might not work) is not a real gap: both
  projects' `supabase-cookie-options.ts` independently scope the session cookie to `.cramapple.com` on
  both real hosts — the mechanism that makes a `cramapple.com` sign-in valid on `app.cramapple.com` too.
  Built and unit-tested back on 2026-09-24; Lovable's agent likely just can't see the other project's
  code from its own workspace.
- **Not yet verified**: an actual completed sign-in landing the student in the real app. That requires
  real credentials and was not done live in this session (no test account used against Production).
  This is the one remaining gap before calling the free-signup flow fully closed.

## CONFIRMED BROKEN, 2026-09-26: BYOQ's public retention/privacy claim doesn't hold up

**This resolves the BYOQ risk flagged as unverified across multiple prior sessions (most recently
`TASK-0040-QA-HANDOFF-2026-09-26.md`: "BYOQ exposes a canonical answer or makes inaccurate
retention/privacy claims") — the answer is: the claim is unverifiable because the feature has no
implementation on the page making it, not merely untested.**

The real, live homepage (`src/routes/index.tsx` — the actual `/` route in the "New Cramapple Marketing"
project, not a demo variant) has a "Bring Your Own Question" section that says *"Photograph a question
from your homework or a past paper"* and, specifically, *"One free question. Your photo isn't kept."*
Read directly:
- The "Upload a photo" `ActionButton` has no `onClick` and no `href`.
- The "Paste the text" `ActionButton` is identically inert.
- `ActionButton`'s own source (`src/components/cramapple/ActionButton.tsx`) confirms: with neither prop
  set, it renders a plain `<button type="button">` with `onClick={undefined}` — genuinely does nothing.
- No file input, hidden upload mechanism, or navigation exists anywhere else in the file.

This is a live, public, specific privacy claim ("your photo isn't kept") about a feature that does not
exist on the page making the claim — worse than the separately-flagged `HomepagePreview.tsx` "not a
video of it" overclaim (that one is at least interactive; this one promises a retention guarantee for a
dead button). Needs a copy fix (soften/remove the claim, or mark "coming soon" the way the older
`homepage-preview-data.ts` variant honestly does) before this page sees real traffic. Not yet sent to
Lovable — pick up here next session.

**CORRECTION to this section, 2026-09-26 (new session): both overclaims are actually in the same file,
`src/routes/index.tsx`, not `HomepagePreview.tsx`.** `HomepagePreview.tsx` still exists in the repo but
is dead code — the live `/` route imports its own inline plate + data from `@/data/liveHomepage`
instead. Read directly, not inferred. Correcting the record so a future session doesn't waste time
editing the wrong file.

## RESOLVED (pending publish), 2026-09-26: both homepage overclaims fixed in Lovable

Sent both fixes to the "New Cramapple Marketing" project (`61dd6602`) in one scoped message; verified
via `get_diff` against the resulting commit (`50e8bd54`), not just Lovable's own report:
- Hook line: `"The real product is below, not a video of it..."` → `"Try the real rubric mechanics
  below, not a video of it..."` — drops the "real product" claim about a scripted client-side demo,
  keeps the true "not a video" part.
- BYOQ fineprint: `"One free question. Your photo isn't kept."` → `"Photo upload is coming soon — pick a
  subject above to start practising today."` — removes the retention/privacy promise for a dead-button
  feature. A "Coming soon" marker was also added beside the two inert buttons (Lovable's own choice
  between that and dimming the buttons, since the shared `ActionButton` component has no `disabled`
  prop to touch safely).
- Flagged, not fixed at the time (out of the two requested scopes, left for a decision): the paragraph
  above the buttons still read *"Photograph a question from your homework or a past paper. It opens in
  the same three panes you just used, with its own rubric."* — present-tense description of the same
  nonexistent feature. **Now also fixed** (same session, later): reworded to *"Photograph a question from
  your homework or a past paper — this is coming soon. It'll open in the same three panes you just used,
  with its own rubric."* (commit `ae1f7f88`), deployed via Lovable's `deploy_project`, and confirmed live
  by reading the rendered `cramapple.com` page after the deploy propagated (~1 min lag observed).

**VERIFIED live, 2026-09-26 (after David published):** loaded `https://cramapple.com/` directly and read
the rendered page text. All three new strings are present ("Try the real rubric mechanics below, not a
video of it...", "Photo upload is coming soon — pick a subject above to start practising today." plus the
"Coming soon" marker beside the two buttons, and "this is coming soon. It'll open in the same three
panes..."); none of the three old strings appear anywhere on the page. Closed.

## Session status, end of day 2026-09-26 — resume here next session

**Closed out today:**
- Domain cutover complete and verified live: `cramapple.com` → New Cramapple Marketing (`61dd6602`),
  `app.cramapple.com` → New Cramapple App (`56cae479`). Both resolve correctly; the mid-flight
  mis-attachment (App wrongly connected to bare `cramapple.com`, causing an infinite-redirect outage) was
  caught and fixed within the same session.
- TASK-0044 (AP Statistics MCQ serving) shipped to Production: migration applied (with a
  Codex-report-vs-reality discrepancy caught and corrected — the function already existed in an older,
  less-safe form), edge function redeployed (v23), verified against real Production content (20/20 MCQs).
- Cross-domain login-redirect bug (found, fixed, and independently verified live in this session, not
  just reported): `login.tsx` now correctly hands off to `app.cramapple.com` via `appUrl()`; subject
  param survives the full round trip; cross-domain session cookie sharing confirmed correct by design
  (`.cramapple.com` scope on both projects).

**Closed out in the following session (same day, resumed):**
- All three homepage overclaim/privacy-copy bugs (hook line, BYOQ fineprint, BYOQ present-tense
  paragraph) fixed in Lovable, published, and confirmed live on `cramapple.com`.
- Stale local branch `codex/task-0044-ap-stats-mcq-fix` deleted (already gone from `origin`; superseded,
  unmerged).
- Full §3–§14 acceptance-criteria audit run against the actual live split app (`56cae479`), not just the
  spec — see "AUDIT, 2026-09-26" section above. Surfaced four new, concrete launch risks (recheck dialog
  no-op, dead Account route, duplicate feedback-UI implementations, unbuilt BYOQ/Open Hand) and cleared
  one suspected risk (build/env drift — checked live, not an issue).
- Item 3 (real completed sign-in) confirmed as blocked for an agent to do autonomously on Production;
  needs David directly.

**Status: still Draft, not launch-ready.** The free-signup routing and domain topology are solid, and
Progress/Home is genuinely strong, but four undecided/unwired gaps (recheck no-op, dead Account, split
feedback implementations, unbuilt BYOQ/Open Hand) plus the still-unverified real sign-in mean this cannot
be called done for Oct 2 without David's input on items 3, 6, 7, and 8.

**Open, for next session:**
1. ~~BYOQ homepage claim~~ — fixed, diff-verified, and confirmed live on `cramapple.com` after publish.
   Closed.
2. ~~Homepage "not a video of it" overclaim~~ — fixed in the same message/commit as #1 above (both were
   actually in `src/routes/index.tsx`, not `HomepagePreview.tsx` as originally recorded); confirmed live.
   Closed.
2b. ~~BYOQ paragraph "It opens in the same three panes..."~~ — reworded and confirmed live (see above).
    Closed.
3. The one remaining live-test gap on the free-signup flow: an actual completed sign-in (real
   credentials) landing a student in the real app has not been done — everything up to the sign-in wall
   is verified, the step after it is not. **BLOCKED for an agent to do autonomously**: completing a real
   sign-in against Production means creating/using an account and entering credentials on a live
   production site, which is outside an assistant's allowed autonomous actions (the "testing your own
   application" exception only covers local dev hosts, not `cramapple.com`/`app.cramapple.com`). David
   needs to do this step himself, or explicitly hand over a specific test account's credentials for this
   session to use for this one check.
4. ~~The rest of this doc's original acceptance-criteria audit (§3–§14)~~ — **done**, see the "AUDIT,
   2026-09-26" section above (read-only source audit against `56cae479`, no live-session testing
   possible without credentials — that gap is tracked as item 3). Closed as an audit task; it surfaced
   four new, unfixed launch risks below that are decisions/dev work for David, not further audit.
6. ~~Disputed-grade (recheck) dialog was a silent no-op~~ — **fixed and deployed, David's call.** See
   "RESOLVED, 2026-09-26: three audit-risk fixes shipped" below.
7. ~~Account route is dead~~ — **retired, David's call ("no longer serves a purpose").** See below.
8. ~~Two parallel feedback-UI implementations~~ — **`FeedbackCard`/`Plate` design system is now the live
   one, David's call.** See below.
9. BYOQ and Open Hand are both fully unbuilt, against open decisions 18/19/21 in
   `APP_REBUILD_MIGRATION_PLAN.md` §11 — **David: Codex is already working this, no action taken here.**
   Not a regression, just a reminder these can't be assumed "mostly there" for Oct 2 scoping.

## RESOLVED, 2026-09-26 (later still): three audit-risk fixes shipped to Production, David's explicit call on all three

David reviewed the four audit risks above and directed action on three of them (BYOQ/Open Hand left to
Codex). All three below were built, verified (typecheck + full 413-test suite, plus a targeted render
check for the feedback-UI swap), and deployed to Production (`app.cramapple.com`) via `deploy_project` —
not just committed to Lovable's working tree.

**1. Recheck dialog wired to a real backend (risk #1).** Added `public.grade_disputes` (mirrors
`question_reports`' RLS shape: `authenticated` can insert/select only `student_id = auth.uid()` rows) —
applied to Dev (`wmgjsdkphcyhngaffbqf`) then Production (`pcntajvbdfqhbeewmdry`), `get_advisors` clean on
both. Added `submitGradeDispute` to `use-session.ts` (mirrors `ReportQuestionButton`'s insert pattern).
`RecheckDialog.tsx` now has real submit/success/error phases (was: fire-and-close) — a student who
submits a recheck now gets "Thanks — recheck requested." or a retryable error, never silence. Diff
verified via `get_diff` against commit `436a87d6`.

**2. Account retired (risk #2).** Deleted `src/routes/account.tsx` outright (its own `profiles` query used
`.eq("id", guard.userId)` — already broken, since `profiles` has no `id` column, only `user_id` — so
"fix it" was never on the table once David said "no longer serves a purpose"). Removed the Account menu
item from `SessionHamburgerMenu.tsx`. Lovable's own repo-wide search caught three *more* stale `/account`
links this audit hadn't found — `session.setup.tsx`'s "Complete profile" (repointed to `/onboard`) and
three "Back to progress" links in `attempt.$id.tsx` (repointed to `/progress`) — all real dead links this
one decision would otherwise have left behind. Verified via `get_diff` against commit `4018a7c4`.

**3. `FeedbackCard`/`Plate` design system made live (risk #3).** Only `GradeResultView.tsx`'s
`phase === "done"` branch changed — every other phase (loading, tutor-review, content-unavailable, error)
is untouched, and all existing behavior (confetti, streak badge, the `(uncertain)` marker, retry-on-fail)
is preserved around the new card. One real gap surfaced and fixed, not papered over:
`VerdictChip.jsx` previously only had two states (correct/incorrect) and would have silently mislabeled a
partially-correct answer as flatly "Incorrect" — added a genuine third "Partially correct" state
(amber, `--status-partial`) instead. Flagged, not fixed (out of scope, cosmetic only): `ScoreChip` has no
matching amber tone yet, so a partial score still renders in the "lost" maroon color next to the new amber
label — a color mismatch, not a mislabeling. Verified via `get_diff` against commit `322e8b47`, plus a
throwaway render test (partial/uncertain/failed states all confirmed rendering correctly) that Lovable
deleted after use.

**Not yet done, flagged for a future session:** none of this was checked live in a browser against a real
student session (still blocked on item 3 — no test credentials); the `ScoreChip` amber-color cosmetic gap
above.

## CORRECTION, 2026-09-26 (next session, discovered via a §9.1 investigation agent): fix #3 above did not
reach the real default student path — there are three parallel feedback implementations, not two

The picture this doc has carried since the first audit — "`GradeResultView.tsx` is what's actually routed
to; `FeedbackCard.jsx` is unwired" — was itself incomplete. Read directly, not inferred:

- `TopicHome.tsx`'s `startPractice()`/`startDiagnostic()` (the buttons a real student clicks from Home)
  both `navigate({ to: "/session", ... })` — the **bare** `/session` route, which mounts `SessionFrame.tsx`.
- `SessionFrame.tsx` has its **own, third, independent** graded-result rendering block (`ResultPanel` /
  `CriterionCard`, driven by `graderResult` from `use-session.ts`) — it does not import or use
  `GradeResultView.tsx` at all. Confirmed by grep: zero references.
- `_ux.session.mcq.tsx`/`_ux.session.frq.tsx` — the route `GradeResultView.tsx` (and today's `FeedbackCard`
  swap) actually serves — is reachable only via the legacy `?home=v1` override or an explicit
  `VITE_HOME_V2=off`. `isHomeV2Enabled()` in `feature-flags.ts` defaults to **on** (confirmed: no
  `VITE_HOME_V2` override in `56cae479`'s `.env`), so bare `/session` is what a real student hits by
  default today, not `_ux.session.mcq.tsx`.

**Net effect: today's "make FeedbackCard live" fix is real, verified, deployed — but on a route most
students won't reach by default.** The recheck-dialog backend fix, by contrast, genuinely is on the
default live path, since it lives directly in `SessionFrame.tsx`. **Not yet decided:** whether to redo the
same `FeedbackCard` restyle against `SessionFrame.tsx`'s actual `ResultPanel`/`CriterionCard` block —
that's a materially bigger, riskier change (deeply intertwined with Course Mode repair panels,
confirm-transfer, and the uncertain/review/failed states in the same block) and deserves its own careful
pass rather than a hasty follow-up inside an already-long session. Flagged for David's call, not
auto-executed.

**RESOLVED same day: the `_ux.setup.index.tsx`/`profiles` divergence concern was a non-issue, checked and
closed, not fixed because there was nothing to fix.** `_ux.setup.index.tsx`'s exam date and available
minutes are pure `localStorage` state (`src/lib/prototype-state.ts`, key `cramapple.ux001.state`) — never
touches Supabase at all, so there is no live conflict with anything server-side. Separately, pulled
`public.profiles`' real column list directly: `user_id, full_name, role, review_queue_scope, timezone,
locale, onboarding_completed_at, created_at, updated_at, active_exam_pack_version_id,
first_run_dismissed_at`. The deleted `account.tsx` queried `display_name, exam, active_subject, exam_date,
target_score, daily_study_minutes` filtered on `.eq("id", ...)` — **every one of those column names,
including the filter column itself, was already wrong** before today's deletion. That page's
profile/preferences UI would have thrown a Postgres error on every load; it was fully non-functional
already, not merely redirected away. Deleting it was a clean no-op risk-wise — there was never real data
for anything else to diverge from.
5. ~~Redundant branch `codex/task-0044-ap-stats-mcq-fix`~~ — checked: already deleted from `origin`
   (likely in the 2026-09-25 cleanup); only a stale local ref remained, unmerged and superseded by
   `codex/task-0044-statistics-mcq` (whose fix is already live in Production per this doc's earlier
   session). Deleted the local branch. Closed.

## VERIFIED, 2026-09-26 (earlier same day, about the OLD `d334fed9` build only):
practice/grading is real production infrastructure, not a demo

**This section's finding is still true, but only describes the `d334fed9` "Remix of Cramapple App"
project — the build `cramapple.com` currently serves, not the one launching per the correction above.**
It has not yet been re-verified against `56cae479` ("New Cramapple App"), which cannot be tested live
until the deploy/DNS blocker above is resolved.

David asked whether this app's practice/grading is genuinely wired to a real grading backend or is a
demo — the answer is **it's real for `d334fed9`**, verified by reading the project's source directly
(see `DECISION-0073`'s verification addendum for full detail):

- `src/lib/use-grade-practice.ts` (used by the real session/practice components,
  `SessionFrame.tsx`/`GradeResultView.tsx`) calls `supabase.functions.invoke()` against the actual
  production edge functions this repo documents elsewhere — `session-event`, `attempt-response`,
  `evaluate-attempt` (the same infrastructure as TASK-0016's grading rollout). Not mocked, not a
  separate path.
- Only the home-page hero's `FrqDemo.tsx` (explicitly under `src/components/marketing/`) is a scripted,
  hardcoded animation — expected and fine for a marketing teaser, not a defect.
- This independently confirms the entitlement-gating bug flagged earlier (unentitled students hitting a
  generic "Couldn't score that — try again." error) lives in exactly this real grading path — the error
  string matches `use-grade-practice.ts`'s `runEvaluate` function verbatim.

**This closes out the "is student hub / practice-grading genuinely separate and how far along is it"
question this plan originally left open.** It's not a build item — it exists and is production-wired.
The remaining real risk for October 2 is the first-user access boundary, not the absence of real
grading. Verify a brand-new student receives the free/trial subject entitlement required by
Production and can complete grading in both Day-1 subjects.

## Product Goal

The logged-in, student-facing app matches its governing spec closely enough that a real student can
complete a full session (enter, attempt, get feedback, see progress) without hitting an undesigned or
unimplemented gap. This plan is an **implementation audit**, not a redesign — do not propose UX changes
to sections that are already decided; flag implementation gaps instead.

## Authoritative sources (corrected)

- **Primary:** `docs/product/APP_REBUILD_MIGRATION_PLAN.md` §12 — the phased rebuild plan for the
  student-facing app, with its own exit criterion ("a student can sign in, be taught from a vetted
  item, attempt a real multi-part FRQ and a real MCQ, be graded..."). Treat this plan's phases as the
  primary execution structure for this audit. §11 holds 25 open decisions — read before assuming any
  UX question here is settled.
- **Secondary/cross-check:** `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md` — the older 14-section
  UX spec (purpose, experience principles, information architecture, entry flows, session-mode
  presentation, the learning-session frame, feedback treatment, coaching copy,
  uncertainty/escalation/disagreement, progress/home, accessibility, scope, research plan, and §14's
  own decisions-required list). Use this to cross-check the rebuild plan for gaps, not as the primary
  source of truth where the two conflict — flag conflicts to David rather than picking one silently.

## Related implementation docs to cross-check, not duplicate

- `docs/product/PROGRESS_DASHBOARD_V1_PLAN_2026_08_21.md`, `PROGRESS_REVIEW_RECOMMENDATIONS_DESIGN.md`
  — implementation plan for spec §10 (Progress and Home).
- `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` — implementation detail for the learning-
  session frame (§6) and feedback treatment (§7).
- `docs/product/HANDWRITTEN_GRAPH_CAPTURE_EXPERIENCE_DESIGN.md`,
  `BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md` — edge-case input handling.
- Course Mode layer (`docs/teaching/COURSE_MODE_*`) is a major in-portal feature with its own pilot
  history — `COURSE_MODE_PILOT_LAUNCH_PLAN_2026_08_26.md` and
  `COURSE_MODE_PILOT_LIVE_HANDOFF_2026_08_27.md` are the most recent status. **Use this pilot's gating
  pattern (phased rollout, named owner per phase, explicit exit gate per phase, a held gate requiring
  David's explicit go before real students) as the template for how this plan should be executed**,
  rather than inventing a new gating structure.

## Acceptance Criteria

- [x] Frontend confirmed: "Remix of Cramapple App" Lovable project (`d334fed9-5a97-4e76-906e-7c0ad7082212`),
      published at `ap-prep-canvas.lovable.app` — verified via live HTML, see `DECISION-0073`.
- [x] Rebuild plan §12's phase structure and its exit criterion are used as the primary execution
      frame; `STUDENT_PORTAL_INTERACTION_DESIGN.md` sections below are cross-checked against it, with
      any conflict between the two named explicitly rather than silently resolved. Done in the AUDIT
      section below — the phased §12 sequence is confirmed not yet started (this is pre-split code), and
      the one real conflict found (§5 session-mode variant) is named rather than silently resolved.

Audit implementation status against each spec section and record a status (Implemented / Partial /
Not implemented / Deferred-by-decision) with evidence (live app check, not a design doc read):

- [x] §3 Information architecture — **Partial.** Home, Progress, session routes, and BYOQ all route
      correctly, but Account (one of the four MVP persistent destinations) is dead: `account.tsx` does
      `beforeLoad: () => throw redirect({ to: "/home" })`, unconditionally. See audit below.
- [x] §4 Entry flows — **Partial.** First-session setup (`_ux.setup.index.tsx`) closely matches spec.
      Returning-session logic (`_ux.home.tsx`) is real UI wired to fixture data, not a backend — its own
      code comment flags this as TODO. See audit below.
- [x] §5 Session mode presentation — **Decision Required, silently resolved in code.** Code has already
      committed to Variant B (time-first) with no matching entry in either doc's decision registry. See
      audit below.
- [x] §6 Stable learning-session frame — **Partial, static-code-verified only (no login credentials
      available to this session).** Cold attempt/feedback/retry/completion are genuinely wired to real
      edge functions in the actually-routed component. A second, unwired feedback component tree exists
      in parallel — see audit below. Live-session verification is still open (see item 3, blocked).
- [x] §7 Feedback treatment — **Not implemented.** No bracket-marker/highlighting logic in either
      feedback component; feedback is a plain verdict + summary string.
- [x] §8 Coaching copy — **Not implemented.** No paste-event detection anywhere in BYOQ or the answer
      field; BYOQ is a two-field form that saves to `localStorage`.
- [x] §9 Uncertainty/escalation/disagreement — **Partial, weakest area found.** Grading uncertainty,
      content-uncertainty reporting, and retry-after-failure are all really wired. The disputed-grade
      (recheck) dialog is a fully-built UI that is a silent no-op on submit — see audit below, risk #1.
- [x] §10 Progress and home — **Implemented.** Single-RPC-sourced, matches the "estimate not a score"
      framing. Strongest-implemented surface found.
- [x] §11 Accessibility requirements — **Partial.** Good ARIA/focus-management patterns found in the
      pieces read; reduced-motion, zoom/reflow, and any table/chart equivalent-access were not
      verifiable without a live login.
- [x] §14 Decisions Required — **Mostly open.** See audit below for the item-by-item mapping to
      `APP_REBUILD_MIGRATION_PLAN.md` §11's 25-item registry.
- [x] Course Mode's own pilot-launch plan and QA report are checked for anything it found that
      generalizes to the rest of the student hub — see audit below (migration-ledger drift risk,
      build/env baked-at-publish risk, the held-gate-before-real-students pattern).

**Full audit detail, findings, conflicts, and ranked launch risks: see "AUDIT, 2026-09-26" section
below.**

## AUDIT, 2026-09-26: §3–§14 implementation status (New Cramapple App, `56cae479`)

Read-only source audit against `56cae479` ("New Cramapple App", serves `app.cramapple.com`),
cross-referenced against `61dd6602` ("New Cramapple Marketing") and the governing specs. No live-session
testing was possible (no test credentials available to this session — see item 3, blocked, above).

**Key context: `56cae479` is not a stripped-down rebuild.** `list_files` shows it is essentially the full
carried-over `exam-buddy-wireframe` tree (same routes, same `src/lib/course-mode/*`, same reviewer
routes, same test suite) — consistent with `APP_REBUILD_MIGRATION_PLAN.md` §3 ("both remixed, code
copied, no other changes"). **Phase 1 of that plan's §12 sequence has not been executed yet.** Every
"Implemented" finding below means "implemented in the pre-split app, carried over unchanged by the
split" — not evidence that rebuild work has happened.

**§3 Information architecture (Partial).** Home (`_ux.home.tsx`), Progress (`_ux.progress.tsx`), session
routes, and `byoq.tsx` all route correctly. `account.tsx` has `beforeLoad: () => throw redirect({ to:
"/home" })` — Account, one of the four MVP persistent destinations in the spec, is present in code but
unconditionally unreachable. 13 reviewer/admin routes are also still present (correctly out of scope per
the migration plan, but unreviewed for cutover).

**§4 Entry flows (Partial).** First session: `_ux.setup.index.tsx` closely matches spec §4.1 (exam date,
course-position confirm/change, time picker, "Recommended first session" card with disclosure), near-
verbatim onboarding copy. Returning session: `_ux.home.tsx` implements resume-incomplete-onboarding,
resume-interrupted-session, and reconfirm/invitation/recommendation cards — but its own code comment
says `ctx: ReturningContext` is "built from authored per-course fixtures... Backend wiring TODO: replace
this derivation with a real `getReturningContext` server fn once available." Fixture-driven, not
backend-wired (this can't be fully wired yet regardless, since no item carries a topic label — see §6
and the migration plan's own §5.4 finding).

**§5 Session mode presentation (Decision Required, silently resolved in code).** Spec §5/§14-1 leaves
"named cards vs. time-first" as an open Product Owner decision; neither this doc nor
`APP_REBUILD_MIGRATION_PLAN.md` §11 records it as resolved. `_ux.setup.index.tsx` already implements
Variant B (Time First: 15/30/60-minute buttons; internal mode names "quick"/"focused"/"buckle_down"
never surfaced to the student) — a real, working implementation built ahead of the decision being made
on the record.

**§6 Stable learning-session frame (Partial; two parallel implementations exist).** The route a student
actually reaches, `_ux.session.mcq.tsx` + `GradeResultView.tsx`, is really wired:
`use-grade-practice.ts` / `live-practice-mcq/grade.ts` / `live-practice-frq/grade.ts` call the real edge-
function chain (`session-event` → `attempt-response` ×3 → `evaluate-attempt`), with explicit comments
ruling out any local-fallback/legacy path. Cold attempt, feedback, retry (`grader.reset()`), and
completion (`/session/complete`) all function against this real path — static-code-verified only, not
live-session-verified. Repair labels in `SessionFrame.tsx` match the spec's internal→student-facing
table exactly. **But** `FeedbackCard.jsx` + `Plate.jsx` (the extracted design-system templates the
migration plan's §4.1/§9.1 describe) are a separate, unwired component tree — the live route uses
`GradeResultView.tsx`, not `FeedbackCard.jsx`. Design work on one may never reach the live path, and vice
versa — this is the migration plan's own Risk #2 playing out concretely, not a new problem.

**§7 Feedback treatment (Not implemented).** No bracket-marker or sentence-level-highlighting logic in
either feedback component — feedback is a plain verdict + `student_facing_summary` +
`highest_value_gap.repair_prompt` string. Spec §7's Variant A/B bracket-marker experiment isn't built in
either code path.

**§8 Coaching copy (Not implemented).** `AnswerField.jsx` has no paste listener at all. `byoq.tsx` is a
plain textarea + subject dropdown that saves to `localStorage` and navigates to `/session/setup` — no
paste-event detection, no anti-gaming classification confirm, no camera/upload option (despite the
migration plan's decision 19 naming camera/upload as David's stated intent). Matches the migration
plan's own §9.4 characterization of BYOQ as "not visually designed at all."

**§9 Uncertainty/escalation/disagreement (Partial — weakest area found).**
- Grading uncertainty: real — `GradeResultView.tsx` renders `(uncertain)` inline; the tutor-review branch
  never shows a bare 0. Implemented.
- Content uncertainty: real — `ReportQuestionButton.tsx` does a genuine
  `supabase.from("question_reports").insert(...)`. Implemented.
- **Disputed grade: UI-only, not wired.** `RecheckDialog.tsx` (invoked from `SessionFrame.tsx`) collects
  a full dispute (criterion, overlooked text, explanation) and then its `onSubmit` just does
  `setRecheckCriterion(null)` — closes itself. No backend call of any kind. **Not implemented despite a
  complete-looking UI — see Risk #1 below.**
- Temporary failure: real — `GradeResultView.tsx`'s error phase offers "Retry scoring" wired to
  `grader.retryGrading()`, re-running `evaluate-attempt` without a duplicate attempt. Implemented.
- Separately, `_ux.session.uncertain.tsx` is a static standalone route with matching copy, but its "Flag
  for review" button has no `onClick`, and nothing in the real grading path navigates to it on an
  uncertain result — appears to be a disconnected mock, not a reachable state.

**§10 Progress and home (Implemented).** `_ux.progress.tsx` is genuinely single-source: its own comment
states every number comes from one RPC, `public.get_student_progress_dashboard`, with nothing computed
client-side. Handles signed-out, locked-subject, and no-subject states distinctly; matches
`PROGRESS_DASHBOARD_V1_PLAN`'s "estimate not a score" framing. Strongest-implemented surface found.

**§11 Accessibility (Partial).** Positive: correct `radiogroup`/`aria-checked` on answer choices and
pickers, `aria-live="polite"` on toasts/status changes, focus management with restore on dialog
open/close, `aria-expanded`/`aria-controls` on disclosures, no color-only correctness cues in the pieces
read (verdict text always paired with a word). Not verified (no live login possible): reduced-motion
handling for `ConfettiBurst` (the migration plan's §9.7 already flags `--motion-duration: 0ms` as
conflicting with the existing celebratory confetti — an open product question, not just a token), zoom/
reflow behavior, equivalent access to tables/charts.

**§14 Decisions Required — mapped to `APP_REBUILD_MIGRATION_PLAN.md` §11's registry:**
1. Named cards vs. time-first — code silently implements Variant B; not on record as decided.
2. Minimum onboarding explanation — resolved in code, matches spec.
3. Four-region frame — structurally matches, not verified as a governed decision.
4. Progressive disclosure order for feedback — not implemented as specced (simpler than the 6-step
   order).
5. Repair labels/override — resolved, implemented, matches spec exactly.
6. Bracket marker vs. highlighting — not implemented, not decided.
7. Coaching/paste posture — not implemented, not decided.
8. Uncertainty/disputed-grade language — uncertainty copy implemented; disputed-grade UI exists but isn't
   wired to any backend.
9. MVP navigation/Progress hierarchy — Progress is strong; Account (a named MVP destination) is disabled
   via redirect.
Cross-reference: decisions 1 (fixed frame), 11 (multi-part FRQ), and 21 (Open Hand answer-key RPC) are
all still OPEN in `APP_REBUILD_MIGRATION_PLAN.md` §11 itself, and no code read shows Open Hand
implemented (no full-disclosure answer-key view, no `SECURITY DEFINER` RPC call site found anywhere).

**Conflicts found between the primary plan and the secondary spec:**
- Spec §5 leaves session-mode variant open; the migration plan doesn't list it in its own §11 decision
  table at all, yet live code has already committed to Variant B. A gap in the primary plan's own
  decision registry (it claims to consolidate all open decisions) rather than a direct contradiction.
- Migration plan §13.3 records two explicit, still-unresolved contradictions (BYOQ default-vs-alternative,
  paste-first-vs-camera-first) — moot for now, since `byoq.tsx` currently does neither; the contradiction
  hasn't been forced into an implementation choice, it's just unbuilt.

**Course Mode pilot pattern — what generalizes:**
- The pilot handoff shows a migration ledger can claim a table/object exists in Dev when it doesn't
  (`app.content_asset_metadata` / `content_visual_requirements` were "stamped" but absent, causing a
  live 500 mid-pilot) — same bug class as [[feedback_dev_verification_drift]] already in memory. Since
  the migration plan's §8.5 notes nothing in the content library is `validated` yet, the same silent-
  drift risk applies to the topic-labelling work planned in its §6.
- The pilot's "Lovable publish, not Vercel, env baked at build time" gotcha directly threatens the new
  split: if `New Cramapple App`'s env/build hasn't been explicitly re-pointed and republished since the
  split, it could be serving a stale bundle the same way `d334fed9` was mid-pilot. Worth an explicit
  verification pass before trusting any "live" finding above.
- The pilot's discipline of a named owner + a held gate requiring David's explicit go-ahead before real
  students touch a feature is exactly what the migration plan's own §16 admits is missing for this
  rebuild ("No Task ID allocated and no owner assigned").

**Biggest risks for Oct 2 launch, ranked:**
1. **Disputed-grade (recheck) UI is fully built but silently a no-op.** A student who files a recheck
   gets no confirmation their dispute went anywhere, because none did. Looks finished; isn't. Highest
   priority to either wire up or visibly disable before launch.
2. **Account is unreachable** — any settings/exam-date/target-score UI meant to live there is dead code;
   `_ux.setup.index.tsx` has its own separate prototype-state copy of similar fields, a possibly
   divergent data path from whatever `account.tsx` was meant to read/write on `profiles`.
3. **Two parallel session-feedback implementations** (`FeedbackCard.jsx`/`Plate.jsx` design-system vs.
   the actually-routed `GradeResultView.tsx`) — visual/design work on one may never reach students.
4. **BYOQ and Open Hand are both still fully unbuilt**, against open decisions 18/19/21 — if either is
   assumed "mostly there" in Oct 2 planning, it isn't; BYOQ is a two-field form writing to
   `localStorage`.
5. ~~Build/env drift risk carried over from the Course Mode pilot~~ — **checked directly, not a live
   risk.** `app.cramapple.com/home` (unauthenticated) correctly redirects to
   `https://cramapple.com/login?redirect=%2Fhome`, exactly the designed handoff this doc already
   verified earlier today — the App project is live, reachable, and wired to the right marketing
   project, not serving a stale/wrong bundle. `get_project`'s `is_published: true` and a fresh
   `latest_commit_sha` (`41ed495b`) corroborate this. Downgraded from the audit's ranked risk list;
   the four risks above (recheck no-op, dead Account route, duplicate feedback implementations, unbuilt
   BYOQ/Open Hand) remain the real open risks for Oct 2.

## EXECUTED, 2026-09-26 (next session): `APP_REBUILD_MIGRATION_PLAN.md` §7–§11 pass

David asked for workstreams 7–11 of the migration plan's §7 (content production), §8 (remaining content
gaps), §9 (functional gaps — Phase 1), §10 (what is not migrating), and §11 (open decisions) to be
executed, with multiple agents run in parallel where there was no conflict risk, and policy decisions
surfaced rather than silently resolved. Full results below.

### Executed and verified

**§8.2 `rubric_type` backfill — closed on Dev and Production.** The plan's own figures were stale (it says
"92 Stats MCQ, 14 Stats FRQ, 1 Bio FRQ"; the real number was 207 nulls spread across 8 exam-pack versions).
Before writing anything, confirmed all 207 also had a null `evaluator_strategy` — the exact precondition
the original production backfill (`202607080006_backfill_rubric_routing_metadata.sql`) used, meaning none
of the residual nulls were hiding a spatial/hand-drawn item that needed different handling. Re-ran that
same, already-proven migration (`item_type='mcq'`→`rubric_type='mcq'`/`evaluator_strategy='rule_based_mcq'`,
`'frq'`→`'discrete_text'`/`'llm_discrete_text'`) on Dev then Production. It correctly excluded the one
genuine exception (a `human_shadow`/hand-drawn item, Dev-only synthetic test fixture, not real Production
content). Production now has zero published items with a null `rubric_type`.

**§10 cleanup — 7 dead files deleted from the App project, David to decide on deploy.** A background agent
paginated the full file list (not just trusting the plan's description), confirmed via direct reads that
nothing in `src/routes/**`, `src/components/home/**`, reviewer/admin routes, or `src/screens/**` imported
any of them, then deleted: `src/routes/dev.celebrations.tsx` (its own header comment said "Not linked from
any navigation"), `src/lib/beta-attempt.functions.ts`, `src/lib/beta-consent.functions.ts`, and a
self-contained orphaned "returning-student prototype + Instagram/TikTok share modal" module
(`src/lib/proto/{fixtures,referral,state}.ts(x)`, `src/components/proto/ShareWinModal.tsx`) — fictional
fixture data and a share-studio UI nothing reachable ever imported. `src/routeTree.gen.ts` was edited by
the same commit purely to drop the now-dead `DevCelebrationsRoute` entries — verified directly: 11 hunks,
0 additions, 21 removals, nothing else touched. Typecheck clean, 413/413 tests pass, `get_diff` against
commit `8d6d93fb` confirmed exactly these 8 changes and nothing else (no reviewer/admin file touched).
**Not deployed** — left for David to decide when to publish.
- Explicitly left alone: `src/lib/prototype-state.ts` (a different file, still live — imported by
  `_ux.home.tsx`, `_ux.setup.index.tsx`, `_ux.topic.tsx`); all reviewer/admin routes (confirmed via direct
  reads, none import any deleted file); `public/course-mode/*.html` static mocks (out of scope for this
  task's four named patterns, flagged as unexamined rather than silently skipped).
- **The plan's own §10 route/file count was wrong, confirmed by checking rather than trusting it:** no
  `beta.*` or `_authenticated/proto.*` *routes* exist anywhere in this repo — only 1 literal route
  (`dev.celebrations.tsx`) matched the named patterns; the rest of the "18 routes" turned out to be 6
  orphaned library files, not routes. **`style-guide` does not exist at all** — no route, component, or
  directory by that name anywhere in the project; the plan's claim that it's "superseded by
  `.claude/skills/cramapple-design/guidelines/`" is moot since there's no current surface to retire.

**§9.1 Course Mode component investigation — Decision 17 sharpened, not resolved.** A background agent
read all 7 components (`SkillRail`, `ConfirmTransferBeat`, `CourseModeRepairPanel`, `RepairBlock`,
`WorkedExample`, `LessonOpener`, `StreakBadge`) directly in the live App project and checked actual
reachability/coupling rather than trusting the plan's provisional table:
- **Clear enough to close now, no further investigation needed:** `SkillRail` (subject-agnostic despite
  importing Course Mode types; survives as-is), `WorkedExample` (pure presentational, survives as-is),
  `RepairBlock` (fully generic, already decoupled — only its gate, `CourseModeRepairPanel`, needs
  generalizing beyond the Stats-pilot cell), `StreakBadge` (zero Course Mode dependency at all despite
  being catalogued under "Course Mode session UI" — the most portable of the seven; the plan's "needs a
  design" framing doesn't apply, there's nothing to decouple).
- **Still need David's product judgment:** `ConfirmTransferBeat` (the component is portable, but its
  *trigger* — `needsConfirmTransfer()` — is currently inseparable from the Stats-pilot transfer machine;
  generalizing it is real engineering work, not just a placement call); `LessonOpener` (the plan lumps
  this with `WorkedExample` as one mechanism, but code shows it's hard-scoped to one subject/unit/topic —
  closer to disposable pilot scaffolding than a durable mechanism; conflating the two risks preserving
  one-off pilot code as if it were the general case).
- **A structural finding the plan doesn't mention at all, and the single most consequential thing this
  pass surfaced:** there are **two parallel, fully live session flows** today, and which one a student
  hits depends on a feature-flag default, not a decision. Bare `/session` (`SessionFrame.tsx`, carries all
  7 Course Mode components) is what `TopicHome.tsx`'s "Start" buttons actually navigate to, and `home-v2`
  defaults on (confirmed: no `VITE_HOME_V2` override in the App project's `.env`) — so this is the real
  default path. `/session/mcq` + `/session/frq` (a 2026-09-23 rebuild, carries **none** of the 7
  components, and is what `GradeResultView.tsx` serves) is reachable only via the legacy `?home=v1`
  override. **This directly corrects this doc's earlier record** — see the correction immediately below.

### Correction to this doc's own prior record, same investigation

Earlier this session this doc recorded fix #3 ("`FeedbackCard`/`Plate` design system made live") as
resolved. It was verified and deployed as described, but **it does not reach the real default student
path.** `SessionFrame.tsx` (the file bare `/session` mounts) has its own third, independent graded-result
rendering — `ResultPanel`/`CriterionCard`, driven by `graderResult` from `use-session.ts` — and never
imports `GradeResultView.tsx` at all (confirmed: zero references). The recheck-dialog backend fix (#1) is
unaffected by this — it lives directly in `SessionFrame.tsx`, so it genuinely is on the default path.
**Not yet decided:** whether to redo the same `FeedbackCard` restyle against the actual
`ResultPanel`/`CriterionCard` block. That's a materially bigger, riskier change — deeply intertwined with
Course Mode repair panels, confirm-transfer, and the uncertain/review/failed states in the same render
block — and deserves its own careful pass, not a hasty follow-up. David's call.

### Consolidated policy decisions — David's call, not further audit

From `APP_REBUILD_MIGRATION_PLAN.md` §11 plus what this pass surfaced, organized by what's actually
blocking §7–§11 work. Recommendations are this session's opinion, not a decision — David's call stands.

| Decision | Description | Recommendation |
| --- | --- | --- |
| **#1 Fixed 1440×900 frame vs. responsive** | Blocking. Collides with hand-drawn capture (§9.2, phone-only), multi-part FRQ (§8.4), and the 6 image-stimulus Biology FRQs (§8.3). Nothing touching phones or long content resolves until this is settled. | Go responsive, at minimum allow vertical scroll. Phone support is already a committed feature (QR hand-drawn capture shipped 2026-08-20) — a hard no-scroll frame is incompatible with a decision already made elsewhere. Keep a max content width for readability, don't keep the hard `overflow: hidden`. |
| **#11 Multi-part FRQ / typed-math treatment** | Blocking. 323 of 563 published FRQ have parts as prose in the stem, not structured data — a content-migration-or-parser choice, not a UI choice. | Build a lightweight parser/heuristic to segment `(a)/(b)/(c)` prose markers as a stopgap, not a full re-authoring pass on 323 items up front. Migrate to structured `prompt_json.parts` opportunistically as items get touched for other reasons — full migration now blocks Phase 1 too long for the payoff. |
| **#24 Does `validated` content status gate launch?** | Nothing in the library is `validated` today (§8.5) — a governance call, not engineering. | No, don't gate on it for Oct 2. Biology and Statistics already passed their own six servability criteria through a different, already-completed validation path (Tier 3 audits, cross-QA). A blanket `validated` gate would block launch on content-governance process debt, not actual quality. Treat as a post-launch content-hygiene project. |
| **#18 BYOQ: default entry or alternative?** | You and the consolidation plan already disagree on record (§13.3). | Alternative, not default — matches your own 2026-09-22 note ("Practice defaults to a Cramapple question") over the older consolidation plan's assumption. Recommend formally closing this in the plan record so it stops being cited as open. |
| **#19 Paste-first or camera/upload-first intake?** | Same §13.3 disagreement, the other half. | Camera/document upload first, paste as fallback — matches your stated intent and matches how students actually have a question in hand (a worksheet, a textbook page). Also aligns with #1: camera intake is inherently mobile, so deciding responsive-first makes this pairing coherent instead of contradictory. |
| **#3 ConfettiBurst motion exception** | Design system says zero motion; product has a deliberate celebration moment. Real product question, not a token. | Keep it, as a named documented exception to the "zero motion" rule, not a silent violation. Low stakes, cheap to close — do this one first just to shrink the list. |
| **#17 Course Mode component survival** | Narrowed to 2 real open items (`ConfirmTransferBeat`'s generalization cost, `LessonOpener`'s disposable-vs-durable status) plus the unchanged `StreakBadge` keep/drop call. | `ConfirmTransferBeat`: worth generalizing — it's the one piece of Course Mode logic likely to matter in a BYOQ-first world too. `LessonOpener`: treat as disposable pilot scaffolding, fold into `WorkedExample` rather than investing further — it's hard-scoped to one subject/unit/topic today, not a durable mechanism. `StreakBadge`: keep — it's fully portable already and costs nothing to carry forward. |
| **NEW — Which session flow should be canonical?** | Bare `/session` (`SessionFrame.tsx`, all 7 Course Mode components, real default via `home-v2`) vs. `/session/mcq`+`/session/frq` (2026-09-23 rebuild, none of them, legacy-only today). Both are live in Production right now; nothing has decided which one the product is actually building toward. | Standardize on bare `/session`/`SessionFrame.tsx`. It's already the real default and it carries the most recently hard-won product work (the 7 Course Mode components, per §9.1: "the largest single functional gap in this plan" if lost). Retire `/session/mcq`+`/session/frq` rather than maintaining two parallel graded-result implementations indefinitely. |
| **NEW — Redo the `FeedbackCard` restyle on the real default path?** | Today's fix is real but landed on the legacy route. Redoing it against `SessionFrame.tsx`'s actual `ResultPanel` is bigger and riskier — needs your go-ahead, not a unilateral follow-up. | Yes, but sequence it after the session-flow decision above — restyling a path you're about to retire would be wasted, riskier work for nothing. Once that's settled, this is the same well-scoped pattern already used successfully on `GradeResultView.tsx`. |
| **#20 What derives mastery from help-taken + score** | Unbuilt and unspecified — upstream of the whole plate-mode design. | Don't block launch on a fully general model. Ship a simple rule now (cold + correct + no repair = independent evidence; anything coached = provisional only) and refine post-launch once there's real usage data to design against. |
| **#23 Item-package backfill vs. dual-read adapter** | 203 of 1,346 items carry a newer package-format payload; needs a call before more content ships in either shape. | Build the dual-read adapter, not a backfill. Cheaper, reversible, and doesn't force a format decision before the newer authoring shape has proven itself at scale. |
| **#7 Owner / Task ID for this rebuild** | Still unassigned — nothing in §7–§11 has a named owner or exit gate the way the Course Mode pilot did. | Assign one now, following the Course Mode pilot's own pattern (phased rollout, named owner per phase, explicit exit gate, a held gate requiring your go-ahead before real students) — the plan already says to imitate this pattern but nothing in §7-§11 has done so yet. |

## DECIDED, 2026-09-26 (David's responses to the policy table above)

- **#1 Frame:** go responsive. **Done** — `TASK-0047` Workstream A, commit `44a0f59e`, verified.
- **#11 Multi-part FRQ:** cheap parser stopgap now, "we'll see what we need later" — full migration
  explicitly not committed to. **Done** — `TASK-0047` Workstream B, commit `c52c3fd6`, verified.
- **#24 `validated` gate:** agreed, don't gate Oct 2 on it. **Closed.**
- **#18/#19 BYOQ shape:** "BYOQ is phone capture to start. Document upload post launch" — closes both the
  default-vs-alternative and intake-order questions together: BYOQ ships at launch as camera/phone capture
  only; document/text upload is explicitly deferred post-launch. **Closed.** (BYOQ's actual build remains
  Codex's work per earlier direction — this is the shape decision, not new scope for this session.)
- **#3 ConfettiBurst:** agreed, keep as a named exception. **Closed.**
- **#17 Course Mode components:** confirmed via follow-up question — proceed as recommended. Generalize
  `ConfirmTransferBeat`'s trigger beyond the Stats pilot; fold `LessonOpener` into `WorkedExample` rather
  than investing further; keep `StreakBadge` as-is. **Done** — `TASK-0047` Workstream D, commits
  `8337b270`/`6b696008`, verified. Note: `ConfirmTransferBeat` generalization is shape-level only (a
  pluggable registry replacing a hardcoded check) — it does not yet fire outside Statistics, since no
  other subject has an equivalent cell/skill map; that's separate future content/backend work.
- **NEW canonical session flow:** agreed — standardize on bare `/session`/`SessionFrame.tsx` (the real
  default); retire `/session/mcq`+`/session/frq`. **Closed on shape; actual route retirement not yet
  executed** — deleting the legacy route today would remove the only fallback/escape hatch (`?home=v1`)
  while the FeedbackCard redo below is still in flight. Retirement is a follow-up cleanup step once the
  redo is verified, not urgent to do in the same pass.
- **NEW redo FeedbackCard:** agreed, sequenced after the flow decision above, which is now settled.
  **Done** — `TASK-0047` Workstream C, commit `f2475531`, verified — against `SessionFrame.tsx`'s actual
  `ResultPanel`/`CriterionCard`, not `GradeResultView.tsx`.
- **#20 Mastery derivation — superseded 2026-09-26 by `DECISION-0074`, see that decision for the current
  rule.** (Original first pass, kept for traceability: "Mastery = 2 full-point answers, with hint.
  Hints may be triggered after scoring without affecting mastery." That version allowed a hint before
  submission without disqualifying the answer.) **`DECISION-0074` tightens this**: mastery now requires
  2 correct MCQ + 1 full-point FRQ, with **no hint use prior to submission** on any of the three (hints
  after submission/scoring still never affect mastery). Still genuinely foundational and unbuilt — see
  `DECISION-0074` for the schema gap (no discrete hint-timing or item-type-mix tracking exists yet on
  `app.student_cell_state`) and the new content-coverage dependency this adds (`GAP-9` in
  `CONTENT_GAPS_RUNNING_LIST.md`: a cell needs both a servable MCQ and FRQ to ever reach mastery under
  this rule).
- **#23 Item-package format:** confirmed via follow-up question — build the dual-read adapter, not a
  backfill. **Done** — `TASK-0047` Workstream E, commit `1a6e8404` (this repo), verified. Investigation
  found the underlying gap was dormant (100% of the 203 items already had complete legacy data) — the
  adapter is forward insurance, not an active fix.
- **#7 Owner/Task ID:** agreed, assign now. **Done** — see `docs/tasks/TASK-0047-APP-REBUILD-SECTIONS-7-11.md`,
  created this session. Owner still unassigned to a specific agent/person pending David's pick, following
  the same pattern TASK-0045 used.

## Student interaction data schema — plan drafted 2026-09-27, not executed

`DECISION-0074`'s mastery rule exposed a broader question: is the schema recording student
interaction with each question (response content, scoring, timing, hint usage, retry/repair,
recommendation inputs) rational, efficient, and complete enough to support feedback, progress, and
next-best-action? A full plan for auditing, extending, and pruning that schema is documented in
`docs/product/STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md` — **plan only, nothing in it has
been executed** (no migrations, no code changes).

Summary: a live audit found `attempts.confidence_level`/`result_summary` are not actually dead
columns (the write path exists but isn't reaching them — a bug, not stale schema); found
`attempts.assistance_state` already models "coached vs. independent" and should be extended, not
replaced; and identified six gaps (hint timing/count, MCQ/FRQ mix per mastery cell, active
engagement time, student confidence self-report, retry-reason tagging, recommendation provenance)
that need new columns/tables in the existing schema's conventions. The plan has three phases (live
audit → additive schema → dead-column elimination) and one hard gate: Phase 1's hint-tracking table
cannot be built until David answers which in-attempt events count as "hint use before submission"
under `DECISION-0074` — see that plan doc's "Open decisions" section for the full list and why that
one specifically can't wait.

## EXECUTED, 2026-09-27: Content taxonomy rationalization, all four phases — session close

`docs/product/CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md` (the "fable" plan) is now fully
built, QA-verified, and merged. Summary for whoever picks up the student hub launch next:

- **Phase 1** (generalize `app.content_item_cells` to allow topic-only rows) — committed `1d9dcfff`,
  applied to Production. 112 Biology topic labels migrated in as `provisional_model`.
- **Phase 2** (retire content-key parsing) — backend committed `912699b2`; frontend committed in the
  Lovable "New Cramapple App" project (`8fdaa40c`) and **deployed by David**. The AP Statistics pilot
  now serves through `student-session-items`'s new `cell_scoped` mode with server-resolved `.cell`,
  not a client-side content-key regex. `MAX_ITEMS` raised globally from 20 to 999 (David's explicit
  call — no subject-specific exemption, to avoid a special case someone forgets later). Lazy-loading
  the item pool (fetch ~50, top up at ~40 consumed) was discussed for future image-heavy subjects and
  deliberately deferred — see that plan doc's Phase 2 section for the index/content-split design this
  would need so it doesn't break `scope-mcqs.ts`/`retry-order.ts`'s whole-subject retry logic.
- **Phase 3** (seed 181 new Statistics topic labels) — committed `6888116e`, applied to Production.
  Dev rehearsal deliberately skipped (Dev doesn't contain these rows at all — pre-existing drift, not
  introduced here). 6 boxplot items relabeled 1.8 → 1.9 per QA finding E-QA-001.
- **Phase 4** (census monitoring columns) — committed `ac883a9e`, applied to Production.
- All four phases merged to `main` via **PR #208** (test check passed first). Independently
  QA-verified against live Production state, not just trusted from agent reports — see the plan doc
  and this session's transcript for the query-level evidence (row counts, view DDL, integration test
  run live).

**Open items for the student hub launch, carried forward:**

1. **Decision #2 (Biology topic labels) and the new 181 Statistics labels are still `provisional_model`
   — deliberately not promoted to `validated`.** They exist in `content_item_cells` but are invisible
   through `content_item_topic_resolution` (confirmed live: 0 unvalidated rows exposed). Promoting them
   is its own decision, not part of this work.
2. **`GAP-9`** (`CONTENT_GAPS_RUNNING_LIST.md`) — unmeasured: how many topic × skill cells lack a
   servable MCQ or FRQ, which under `DECISION-0074` blocks mastery on that cell permanently, not just
   slows it. Needs a count before mastery ships.
3. **The student interaction data schema plan** (previous section) is drafted, not executed, and has
   its own hard gate (David's answer on what counts as "hint use before submission").
4. **Mastery derivation itself (`DECISION-0074`) is still unbuilt** — no discrete
   hint-timing/item-type-mix tracking exists on `app.student_cell_state` yet.
5. **Phase 2's frontend deploy was not independently re-verified against the live domain** by this
   session after David confirmed he'd deployed it — worth a quick smoke test (start a Stats pilot
   session, confirm items load and a skill's rail resolves) next time someone is in the app, rather
   than assuming from the deploy confirmation alone.
6. **BYOQ and Open Hand remain fully unbuilt** (Codex's separate workstream, unchanged this session).

## Out of Scope

Redesigning any already-decided section of the interaction design spec — raise a proposal to David
instead of implementing an unrequested UX change.

## Method Note

Test against a real logged-in session in a non-production environment wherever possible. A design spec
describing a flow is not evidence the flow is built — this is the same lesson the six-criteria doc
learned the hard way on content servability, and it applies equally here.
