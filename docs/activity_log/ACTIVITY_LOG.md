# Activity Log

This log records meaningful operating activity, approvals, closeouts, blockers, and handoffs. Newest entries are at the top.

## Index

Most recent entries (full reverse-chronological list follows below):

- 8 Subjects Assigned for Tutor Review (Chemistry, Physics ×4, Calculus AB/BC, Precalculus) — 2026-07-21
- Content Review & QA Prompt for Codex Drafted — 2026-07-20
- AP Statistics Question Issues: Pre-Launch Log — 2 Content Stubs Found, 2026-07-11 QA Findings Confirmed Fixed — 2026-07-19
- AP Biology Stimulus Images: Uploaded, Linked, and Rendered — 3 Errors Found and Fixed in Second-Pass Review — 2026-07-19
- Statistics Deterministic Verifier Fixes: Independent Opus Re-QA — Confirmed Safe, Found Broader Scope Than Disclosed — 2026-07-12
- Statistics Deterministic Verifier: Fixed the Criterion-Bundling Severity Bug — 2026-07-12
- Statistics Deterministic Verifier: Fixed Redundant-Value Over-Strictness, Found a Severity Bug — 2026-07-12
- Phase C R4 Independent Re-QA — Confirmed — 2026-07-12
- Phase C Remediation R4: Fixed 3 Unanswerable FRQs + Module 8 Difficulty Labels — 2026-07-12
- Phase C Publish Packet Independent Re-QA — Fail, New Blockers Found — 2026-07-12
- TASK-0010 Approved and UX-006 Brief Replaced With Real Integration — 2026-07-12
- Phase A Broken-Import Fix and Deterministic-Layer-Only Ship Decision — 2026-07-12
- TASK-0016 Phase A Grading-Router Reconciled Onto Grading Branch — 2026-07-12
- AP Statistics Launch Task Drafted (TASK-0013) — 2026-06-30
- New-User Experience Live QA — 2026-06-29
- Production Readiness QA Handoff — 2026-06-21
- Cramapple Visual Identity Brief Revised From Family Discussion — 2026-06-21

**Rotation rule:** once this log exceeds ~400 lines, archive the older (bottom-of-file) entries to `docs/activity_log/archive/ACTIVITY_LOG-<range>.md` and update this index. Keep the index itself to the last ~10 entries.

---

## 8 Subjects Assigned for Tutor Review (Chemistry, Physics x4, Calculus AB/BC, Precalculus) - 2026-07-21

**Task:** David asked why Codex could only find Biology and Statistics
content, having asked before for the rest to be reviewable. Traced the cause
and fixed it directly rather than filing another report.

**Status:** Done. 288 `content_review_assignments` rows created directly in
Production (`pcntajvbdfqhbeewmdry`) via `execute_sql`, not through the
`assign-for-review` edge function (network egress to `*.supabase.co` is
blocked from this session, same constraint recorded in the 2026-07-19
Biology entries) — replicated its exact behavior by hand instead of routing
around the block.

**Root cause:** AP Chemistry, Physics 1, Physics 2, Physics C: Mechanics,
Physics C: E&M, Calculus AB, Calculus BC, and Precalculus all have real,
substantive authored content (36 items each — confirmed by reading actual
AP Chemistry FRQ/MCQ text directly, not just row counts) sitting in
`app.content_item_versions`, marked `status: active` at the subject level.
But `content_review_assignments` had **zero rows** for 7 of them and just 1
for Calculus AB — none of this content had ever been routed into the
tutor-review pipeline, unlike Biology (105 assignments) and AP Statistics
(100). Codex (or any reviewer surface reading through
`content_review_assignments`, which is what the review-queue edge function
and reviewer portal actually query) would correctly find nothing for those 8
subjects, because there was nothing to find — not a data-loss or access
problem, an unrun step.

**Fix:** For all 288 content items across the 8 subjects, inserted two
`content_review_assignments` rows each (`review_stage: tutor_question`,
`review_kind` matching `item_type`, a shared `blind_group_id` per item,
`status: pending`), assigning both to the same tutor pair already used for
all of Biology's and Statistics' real review work — Amjad Ali and Jill
Schmidlkofer (100/100 assignments each there, confirmed the established
pattern before reusing it, rather than picking arbitrarily from the seed
"Tutor Alpha/Beta" test accounts also present in `app.profiles`).
`ON CONFLICT (content_item_version_id, reviewer_id, review_stage) DO
NOTHING` against the existing unique index avoided touching Calculus AB's
1 pre-existing assignment. Then set `review_status = 'tutor_review_pending'`
on all 288 rows — matching `assign-for-review/index.ts`'s own
post-insert update exactly, including only firing where `review_status`
was previously null. Verified per-subject assignment counts (72 each, 73
for Calculus AB) and `review_status` values directly after, rather than
trusting the insert's row count alone.

**Next Owner:** David Bloom / tutor reviewers
**Next Required Action:** Amjad Ali and Jill Schmidlkofer now have 252 new
pending `tutor_question` assignments between them (36 items x 8 subjects x
2 reviewers, minus the 1 pre-existing) on top of their existing Biology/
Statistics queues — confirm that volume is workable, or reassign/stagger if
not. Consider whether due dates should be set (left null here, matching
how Biology/Statistics assignments were created).

---

## Content Review & QA Prompt for Codex Drafted - 2026-07-20

**Task:** David asked for a content review/QA prompt for Codex covering the
whole question bank, explicitly including assessing questions for missing
images and the quality of existing images.

**Status:** Drafted at
`docs/governance/CONTENT_REVIEW_QA_PROMPT_FOR_CODEX.md`. `Status: Draft` —
not yet run or approved as a standing procedure.

**Summary:** Grounded the prompt in the actual governing docs
(`CONTENT_GOVERNANCE_AND_VALIDATION.md`, `VISUAL_STIMULUS_AND_RENDERING_
SYSTEM.md` §4/§7, `TASK-0005`) rather than writing a generic checklist, and
built in the concrete defect patterns found during this session's Biology
and Statistics passes so the next reviewer doesn't have to rediscover them:
recompute-don't-eyeball canonical answers (the `APSTAT-MOD5-M001` SD error),
rubric-metadata mismatches and self-correction artifacts left in rubric text
(from `apbio_frq_corpus_quality_audit.md`), the content-stub pattern
(`APSTAT-MOD7-M001`/`-M004` — deterministic numeric grading with no
underlying data anywhere, which needs authoring, not an image), the
4-bucket image-need classification (genuine gap / embedded-data /
student-constructed / false positive), and — the part David specifically
asked for — a dedicated image-quality pass that requires actually viewing
each rendered image and tracing arrow direction/causality, since every real
image defect found this session (`APBIO-FRQ-S-008`, `-014`, `-015`) was a
directional/sequential error invisible without doing that, not a surface
content problem. Noted the current fixed concern-code vocabulary
(`Accuracy | Ambiguity | Rubric gap | Other`) has no dedicated "missing
image" or "image defect" tag and flagged that as a gap rather than forcing
a mismatch.

**Next Owner:** David Bloom
**Next Required Action:** Review the draft prompt, fill in `<SUBJECT>`, and
hand it to Codex for a pass (AP Biology and AP Statistics have already had
one round each this session; AP Calculus AB/BC and AP Precalculus have not).

---

## AP Statistics Question Issues: Pre-Launch Log - 2 Content Stubs Found, 2026-07-11 QA Findings Confirmed Fixed - 2026-07-19

**Task:** David asked for the AP Statistics equivalent of the AP Biology
stimulus-image sweep: review every question to find ones that reference a
graph/diagram they don't actually have. Relates to `TASK-0013`
(AP Statistics Launch).

**Status:** Investigation complete, logged to
`docs/research/ap_statistics_question_issues_2026_07_19/README.md`. Not
fixed — flagged for content authoring, not something to silently patch.

**Summary:** Queried all 276 `ap-statistics` content items for
graph/plot/diagram/table-reference language (~63 matches across two keyword
passes), read each candidate's full stem and stimulus by hand. Unlike
Biology, found **zero cases needing a generated stimulus image** — every
genuine graph reference already has its underlying data given as text, or is
a hand-drawn-graph (`HDG`) item where the student constructs their own graph
and photographs it.

Instead found **2 unfinished content stubs**: `APSTAT-MOD7-M004` ("This tree
diagram shows...") and `APSTAT-MOD7-M001` ("A contingency table shows...")
both narrate a data source that was never populated — empty stimulus, no
numbers anywhere in stem/stimulus/explanation — while their
`prompt_json.deterministic_criteria` wires them for deterministic numeric
grading against a value that doesn't exist. Did not generate illustrative
images or invent plausible-looking numbers for either: doing so would mean
authoring new graded exam content (asserting specific branch probabilities /
table cell counts as the answer key) under the guise of "adding an image,"
not just illustrating existing text the way the Biology images did. Flagged
for a content author to write real values instead.

Cross-checked this session's finding against
`docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/qa_review.md`,
which found the same class of problem in an earlier staging pass and blocked
that import (`Fail`). Confirmed all of its findings are now fixed in current
Production content: the `APSTAT-MOD5-M001` sample-SD keying error (was
7.07/population value, now correctly ≈7.91) and all 8 FRQs it flagged as
"requires absent visual/data stimuli" — each re-read directly and confirmed
to now have sufficient text-embedded data or description to answer without
an image (histogram bin counts, five-number summaries, fully-described
scatterplot/residual shapes, or a plain CLT theory question that never
needed a plotted graph at all).

Also flagged, lower confidence: `APSTAT-MOD6-M001` asks for a required
sample size (`n_required`, deterministic numeric) from a stated margin of
error but no stated confidence level — `n_required` needs both. Didn't
confirm this is actually broken (a documented grading convention elsewhere
could resolve it) — noted for a second look rather than asserted as a
defect.

Separately observed, not a question-content issue: every `published`
AP Statistics item (FRQ and MCQ alike) currently sits at `review_status` of
`tutor_review_pending` or `null` — no terminal approved/confirmed status
anywhere. Same pattern holds for Biology, so likely reflects how the
`content_review_assignments`/`content_review_decisions` review workflow
relates to the `content_item_versions.review_status` field generally, not
a Statistics-specific gap — not confirmed either way, flagged for whoever
owns that question before launch.

**Next Owner:** David Bloom / AP Statistics content author
**Next Required Action:** Write real tree-diagram branch probabilities for
`APSTAT-MOD7-M004` and a real contingency table for `APSTAT-MOD7-M001`
(with canonical numeric answers), confirm or dismiss the
`APSTAT-MOD6-M001` confidence-level ambiguity, and clarify whether
`published` AP Statistics content has actually cleared tutor/reader review
before treating it as launch-ready.

---

## AP Biology Stimulus Images: Uploaded, Linked, and Rendered - 3 Errors Found and Fixed in Second-Pass Review - 2026-07-19

**Task:** Finishes the remaining-steps checklist in
`docs/research/ap_biology_stimulus_images_2026_07_12/README.md` (written
2026-07-12, blocked mid-execution by an MCP tool access interruption at the
time).

**Status:** Done. Branch `claude/ap-biology-stimulus-images-y9x86f`, latest
commit `b5aa05a`, pushed. Not yet merged to `main`.

**Summary:** Applied migration `202607121001` (already committed, not yet
applied) adding `app.content_item_versions.stimulus_image_path` to
Production (`pcntajvbdfqhbeewmdry`). Added a new migration `202607121002`
extending the curated `public.content_item_versions` view to expose the
column (same drop-and-recreate gap pattern already fixed once for
`public.grading_results` in `202607120001`). Deployed `storage-sign-url`
with the already-committed reviewer-role fix, and deployed an update to
`review-queue` adding `stimulus_image_path` to its artifact payload. Both
verified byte-for-byte against the local repo after deploy — one deploy
attempt had a paste error that corrupted `_shared/auth.ts` into
`.eq("name", "cors.ts")` instead of `.eq("user_id", user.id)`, which would
have broken all authorization on `storage-sign-url`; caught by post-deploy
verification and redeployed correctly before any live traffic.

Found the actual frontend project in use is `exam-buddy-wireframe`
("Remix of Cramapple App", id `d334fed9-5a97-4e76-906e-7c0ad7082212`) —
correctly wired to `pcntajvbdfqhbeewmdry` — not `cramapple-prototype`
(the name in the original README), which turned out to be a stale/orphaned
Lovable project pointed at an unrelated Supabase project
(`tazjfzphsevtgervlyit`) with a completely different schema shape. Directed
the Lovable agent to add a `useSignedAssetUrl` hook (signs a download URL
via `storage-sign-url`, cached per-path with react-query) and wire it into
both `reviewer.review.$assignmentId.tsx` and `_ux.session.frq.tsx`. Its
first pass had a real bug — read `data.url`/`data.signedUrl` when the
actual `storage-sign-url` response nests the URL at `result.signed_url` —
caught by inspecting the diff, not just trusting the agent's summary; fixed
in a follow-up message, typecheck + all 42 tests passed after.

This session's egress policy blocks outbound HTTPS to `*.supabase.co`
(confirmed 403 at the proxy, twice), so images couldn't be uploaded or an
edge function invoked directly from here. Found `storage.googleapis.com`
(Lovable's file-upload endpoint) is not blocked, staged the 10 PNGs there,
but Lovable Cloud was off for that project (no privileged Supabase access
in its session either) — that route was a dead end too, confirmed rather
than assumed. David explicitly ruled out enabling Lovable Cloud
("architectural decision, not revisiting") and uploaded the files to
`content-assets` directly via the Supabase dashboard instead.

**Second-pass image review, before upload:** re-checked all 10 generated
images against their stimulus text (beyond the individual review recorded
when they were first generated on 2026-07-12) and found 3 real errors,
fixed in `generate.py` and regenerated:
- `APBIO-FRQ-S-008` (replication fork) — the "fork movement" arrow pointed
  away from the still-paired parental strands into the already-unwound
  region. Backwards; a fork only advances into unreplicated DNA.
- `APBIO-FRQ-S-014` (electron transport chain) — a direct
  Complex I → Complex II arrow implied one sequential I-II-III-IV pathway.
  Complex I and Complex II are independent parallel entry points (from
  NADH and FADH₂ respectively) that both feed Complex III, not each other.
- `APBIO-FRQ-S-015` (lac operon) — an arrow from `lacI` into the operon's
  `Promoter` box implied a functional link between lacI's own promoter and
  the operon's promoter; they're unrelated.

David uploaded all 10 corrected images to `content-assets` at
`Biology/FRQ/<content_key>.png` (capitalized, differing from the
`biology/frq/` convention documented in the migration comment — used the
actual uploaded paths rather than fight the casing). Verified object
presence and byte sizes in `storage.objects` against the corrected local
files before writing `stimulus_image_path`, and confirmed the missing
10th file (`APBIO-FRQ-S-008` was absent from the first upload pass) before
running the update. All 10 `app.content_item_versions.stimulus_image_path`
values set and confirmed exposed through `public.content_item_versions`.

**Verified end-to-end at the data/auth level:** a real tutor-role account
(`83098fb9-...`) has existing (submitted) review assignments on 3 of these
exact content items (`APBIO-FRQ-S-005`, `-009`, `-014`), `storage-sign-url`
now authorizes the `tutor` role for `sign_download` on `content-assets`,
and the objects exist at the paths now stored in `stimulus_image_path`.
**Not verified:** an actual live click-through in the reviewer portal or
student session UI by a logged-in tutor/student account — this session has
no credentials for one and no browser access to the deployed frontend.

**Next Owner:** David Bloom
**Next Required Action:** Click through the reviewer portal
(`exam-buddy-wireframe`) as a tutor on one of `APBIO-FRQ-S-005`, `-009`, or
`-014` and confirm the image actually renders, then spot-check the student
FRQ session for at least one of the 10 items. Get this independently
re-QA'd before treating it as fully done, per standing practice for
live-grading/content changes this session. Merge
`claude/ap-biology-stimulus-images-y9x86f` to `main` once confirmed.

---

## Statistics Deterministic Verifier Fixes: Independent Opus Re-QA - Confirmed Safe, Found Broader Scope Than Disclosed - 2026-07-12

**Task:** Verifies the two entries below (SE/SE_diff removal, criterion-
count guard). Relates to `TASK-0016`, `TASK-0010`.
**Status:** Both fixes confirmed correct and safe by independent re-QA
(David's request: run the re-QA with a different model, `opus`, for
genuine model-diversity independence, not just fresh context). One
correction applied to the guard's own commit-time claim; one comment
inaccuracy fixed. Still not deployed to Production.

**Summary:** Opus re-derived all the math independently (SE, CI bounds,
t-statistics from `ecf_parts` canonical formulas), independently ported
and ran the exact `extractNumbers`/`matchesTarget` logic against the real
response texts, and traced the live call site line-by-line rather than
trusting the commit messages. Verdict on both fixes: **correct, safe, no
over-grading hole introduced.** Specifically confirmed the "final value
mathematically implies correct intermediate value" argument is airtight
for both `MOD3-H001-INV` and `MOD6-H001` — the checker matches against
fixed canonical values (not the student's own derivation), and each final
value is strictly monotonic in its intermediate, so no arithmetic-error-
cancellation path exists that could let a wrong SE produce a passing final
value. Confirmed `MOD6-H001` now genuinely passes (t=2.1 clears the 2%
tolerance on 2.06104) and `MOD3-H001-INV` still genuinely fails, specifically
on the missing hypothesis-test t-statistic (2.28217) — the response never
computes it. Confirmed the "signal isn't lost" claim precisely: `statisticsCheck`
threads through as `action_hint`/`repair_hint`/metadata on the LLM path,
but does **not** reach the LLM's own prompt — it shapes feedback, not the
score, worth being precise about going forward.

**What the QA caught that the original fix missed:** the criterion-count
guard checks `input.criteria.length`, which is *total* rubric criteria
(numeric + conceptual combined) — there's no "kind" field available at
that call site to filter to just numeric ones. Every content_key currently
in `STATISTICS_TARGETS` has 2+ total criteria (`MOD3-H001-INV`: 5,
`MOD6-H001`: 3, `MOD7-H001`: 2, all 18 `APSTATS-SFRQ-*` items: 4 each).
That means the guard currently returns null for the **entire configured
catalog**, not just the one multi-numeric-criterion item that motivated
the fix — the hard-block/cost-saving prefilter path is presently
unreachable for everything. Safe (every response gets real LLM grading
now, no wrong zeros), but a real, previously-undisclosed side effect: the
prefilter's cost-saving purpose is dormant, not narrowly fixed.

**Also caught and corrected:** the guard's original commit claimed the 18
`APSTATS-SFRQ-*` items' criterion structure "couldn't be confirmed without
live DB access." That was wrong — it's determinable from
`docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/ap_statistics_frq_batch_2026_07_01.json`'s
a/b/c/d criterion structure, which was already checked out on this branch.
Missed it the first time; QA found it. Corrected the code comment to state
this plainly instead of the "unknown" claim.

**Also caught:** a minor but real inaccuracy in the SE_diff fix's own
comment — it claimed the response's "2.0 to 2.1" range "already passes
the 2% tolerance," when actually only the 2.1 endpoint does (2.0 misses by
0.02); the conclusion (response passes) was still correct since the
numeric-match logic only needs one hit, but the comment overstated why.
Fixed.

**Verified, not just re-asserted:** independently confirmed no test
breakage — the only tests referencing the removed SE/SE_diff values
(`math-verifier_test.ts`) exercise the separate symbolic ECF verifier, not
this file. Confirmed no TypeScript-level issues from reading (still no
Deno available in this environment for a real compile check).

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Decide whether the dormant cost-saving prefilter
is worth restoring properly (would need a numeric-vs-conceptual criterion
"kind" signal threaded to the call site — a real follow-up feature, not a
quick fix) or is an acceptable tradeoff to leave as-is (safety over cost
savings). Decide whether/when to deploy both statistics-verifier.ts fixes
to Production — still undeployed.

---

## Statistics Deterministic Verifier: Fixed the Criterion-Bundling Severity Bug - 2026-07-12

**Task:** Directly follows the entry below. Relates to `TASK-0016`,
`TASK-0010`.
**Status:** Fixed on `claude/cramapple-grading-mlr0o1`
(`supabase/functions/_shared/statistics-verifier.ts`), not yet deployed to
Production, not yet independently re-QA'd.

**Summary:** David asked whether the criterion-bundling issue flagged in
the prior entry had an identifiable root cause, and then asked to fix it.
Root cause confirmed precisely: `STATISTICS_TARGETS` is item-level (one
flat required-values list per `content_key`), with no mapping of which
value belongs to which rubric criterion. The gate this feeds
(`buildStatisticsDeterministicFallback`, wired at `evaluate-attempt/
index.ts` as `"deterministic-statistics-prefilter"`) is intentionally a
cost-saving pre-filter, not an accidental fallback — but its item-level
granularity doesn't match rubrics that have more than one independently-
gradable criterion, so on those items ANY single missing value hard-blocks
credit and the LLM call for the ENTIRE response, not just the one affected
criterion.

**Confirmed scope before fixing, not guessed:** checked all 5 items with
visible per-criterion data (`statistics_item_keys.json`) for criterion
count. Only `APSTAT-MOD3-H001-INV` has more than one numeric criterion
(`ci_calculation` + `hypothesis_test`) — confirmed exposed. `MOD6-H001`,
`MOD7-H001`, `MOD8-H001` are single-criterion — safe even before this fix.
The 14 `APSTATS-SFRQ-*` items (already-published production content, not
the calibration corpus) aren't in that file, so their criterion count
couldn't be confirmed without live Supabase access (not available this
session — MCP tool calls started requiring interactive approval).

**The fix, chosen specifically to not require knowing what wasn't
confirmed:** rather than attempting to guess which target value belongs to
which criterion for the 14 unverified items (real risk of silently
assigning a value to the wrong criterion and introducing a new,
differently-shaped bug), added a guard in
`buildStatisticsDeterministicFallback`: the hard block now only fires when
the item has exactly one rubric criterion
(`input.criteria.length !== 1 -> return null`). `promptBase.criteria` is
already the live rubric loaded from the `frq_criteria` table at the
`evaluate-attempt` call site, so this check works correctly at runtime for
every item, including the 14 unverified ones, without needing their
structure known in advance — if any of them turn out to be multi-criterion,
this guard already protects them; if single-criterion, behavior is
unchanged.

**What this does NOT do:** it doesn't add real per-criterion deterministic
partial credit — multi-criterion items just stop being hard-blocked and
fall through to full LLM grading instead, still informed by the same
signal as a repair-hint (confirmed the codebase already threads
`checkStatisticsDeterministicEvidence`'s raw result through as a soft
signal via a separate `statisticsCheck` variable, used for
`action_hint`/`repair_hint` even when the LLM grades normally — not lost
by this change, only the hard block is narrowed).

**Verified before committing:** ran a plain-JS simulation of the exact
guard logic against three cases — `MOD3-H001-INV` (2 criteria, still flags
internally) now correctly falls through (`null`, LLM runs); `MOD6-H001` (1
criterion, already passes after the prior fix) unaffected; a hypothetical
single-criterion item with genuinely no evidence still hard-blocks as
before. Brace-balance checked (no Deno available in this environment for a
real typecheck, same standing limitation as every code change this
session).

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Get this independently re-QA'd before deploying.
Decide whether to check the 14 `APSTATS-SFRQ-*` items' live criterion
structure (needs Supabase MCP re-approval) to know for certain whether any
of them were actually exposed to the original bug, versus leaving it
unconfirmed since the fix protects them either way. Decide whether/when to
deploy this and the prior SE/SE_diff fix to Production — neither has been
deployed yet.

---

## Statistics Deterministic Verifier: Fixed Redundant-Value Over-Strictness, Found a Severity Bug - 2026-07-12

**Task:** Follows from the AP Statistics calibration dry-run's 10 disagreement
cases (85.7% agreement, `ap_statistics_phase_c_calibration_dryrun_2026_07_11/report.md`).
Relates to `TASK-0016` (grading engine), `TASK-0010` (grading confidence).
**Status:** 2 of 10 cases fixed in `supabase/functions/_shared/statistics-verifier.ts`
(live production code, already deployed and now updated in git on
`claude/cramapple-grading-mlr0o1`). 1 fully verified fixed, 1 partially
fixed with the remaining blocker identified and deliberately not touched.
A severity-level architectural issue was found and is flagged, not fixed,
pending an explicit decision. Not yet independently re-QA'd.

**Summary:** At David's request, went through all 10 calibration dry-run
disagreements individually, pulling the exact response text and rubric for
each (not just the dry-run's summary notes) before deciding what to fix.
They split into four distinct categories, not one "tolerance" problem:

**Category A — over-strict, live, fixed (2 of 3 cases):**
`APSTAT-MOD3-H001-INV` and `APSTAT-MOD6-H001` both required an
intermediate value (SE / SE_diff) to appear as a bare typed number in the
response, even though (a) the rubric's own `learner_facing_text` only asks
for the final CI bounds / t-statistic, never a separately-stated SE, and
(b) a correct final value mathematically implies a correct intermediate
value (CI_low/CI_high are computed directly from SE; t_stat from SE_diff),
making the explicit intermediate check both over-strict and redundant.
Removed SE (21.9089) from `APSTAT-MOD3-H001-INV`'s target list and SE_diff
(1.94079) from `APSTAT-MOD6-H001`'s. **Verified by hand** (plain-JS
reimplementation of the exact comparison logic, run against the real
response texts from `provisional_labels.json`, not assumed): `MOD6-H001`
now fully passes. `MOD3-H001-INV` only partially improves — see the
severity finding below for why it still doesn't fully flip.

**Category B — not a live bug (1 case, `APSTAT-MOD4-H001-INV`):** this
content_key isn't in `statistics-verifier.ts`'s target list at all: this
disagreement only exists in the calibration dry-run's own standalone
research-script reimplementation (`calibration_runner.ts`), not in
production. No live code to fix. Not adding new deterministic coverage for
it — that's expanding what the system checks, a different decision than
fixing what's already checked.

**Category C — false-positive over-credit risk, not currently live (2
cases, `APSTAT-MOD7-M005` and `STATS-MOD1-E004`):** both are genuine bugs
in the *dry-run script's* local number-matching (a coincidentally-matching
number gets credited even when it's not the actual computed answer — e.g.
`STATS-MOD1-E004`'s response computes the WRONG mean, 22.5, but happens to
include "18" as one of the four raw data values it's averaging, and the
naive matcher credits it as if 18 were the given answer). **Neither
content_key is in the live `statistics-verifier.ts` target list**, so this
specific exposure isn't live today — but the underlying pattern (matching
any occurrence of a number in free text, with no check that it's presented
as the actual final answer) is structurally present in every one of the
~20 items that *are* covered. Correctly distinguishing "the decisive final
answer" from "a number that happens to appear" is a real NLP problem, not
a parameter tweak — deliberately not attempting an ad-hoc heuristic fix for
this now, same reasoning as the QA checker's visual-keyword heuristic
earlier this session. Flagging as a known structural risk across the whole
target list, not fixing.

**Category D — label/scope questions, not code bugs (4 cases,
`APSTAT-MOD6-M001` x2, `APSTAT-MOD7-H001`, `APSTAT-MOD8-M002`,
`APSTAT-MOD8-M004`):** the deterministic checker (where it applies) is
either already correct and the *provisional* AI-draft label looks wrong
(`MOD6-M001`'s two disagreements look like a genuine labeling
inconsistency — one arithmetically-correct response labeled
`partially_earned`, another labeled `not_earned` for what reads as the
same class of correct-arithmetic response; `MOD7-H001` looks like the
provisional label under-crediting terse-but-correct work), or the
criterion is fundamentally about *interpretation* language, not just
numeric presence (`MOD8-M002`/`MOD8-M004`: the number is present but the
interpretation is backwards/miscontextualized, which a number-presence
check structurally cannot evaluate). None of these are addressed here —
they're `TASK-0010` Phase 2 adjudication-queue material, not code to
patch unilaterally.

**Severity finding, not fixed, needs an explicit decision:** traced
exactly how `checkStatisticsDeterministicEvidence`'s result is used in
`evaluate-attempt/index.ts` (lines ~747, ~1128). When it flags, the result
(`buildStatisticsDeterministicFallback`) **replaces the entire grading
payload for the whole response, zeroes points_earned, sets confidence to
low, and skips the LLM grader call entirely** — for every criterion in the
item, not just the one with the missing value. This is exactly why the
`MOD3-H001-INV` fix above only partially worked: the item's flat target
list bundles values from two logically separate rubric criteria
(`ci_calculation`'s CI bounds and `hypothesis_test`'s t-statistic) into one
undifferentiated list, so a response that fully earns `ci_calculation` but
doesn't compute an explicit numeric t-statistic for `hypothesis_test`
still gets the *entire response* hard-zeroed and never reaches the LLM —
confirmed against the real provisional-labeled-"earned" response used in
the dry-run. Fixing this properly means making the deterministic gate
criterion-aware (the calibration script's own local `keyedCriterionVerdict`
already does this correctly via `statistics_item_keys.json`'s
per-criterion `parts`, live production code does not) — a real
architecture change to a hard-gate in live grading code, not a parameter
tweak. Deliberately not attempted in this pass: no way to test the change
end-to-end in this environment (no Deno, no ability to invoke
`evaluate-attempt` live), and the blast radius (every AP Statistics FRQ
routed through this pre-filter, currently ~20 keyed items) is large enough
to warrant explicit sign-off before restructuring, not a same-session
silent fix.

**Verified before committing:** brace-balance checked (no Deno available
in this environment for a real typecheck — same limitation as every prior
code change this session); the two target-list edits verified against the
exact real response texts, not assumed correct from the summary notes.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Decide whether `buildStatisticsDeterministicFallback`
should keep its current all-or-nothing hard-block-and-zero-credit behavior,
or whether a criterion-aware version (or a softer "flag for review, still
let the LLM grade" behavior) should replace it — this affects every live
AP Statistics FRQ response routed through it today, not a hypothetical.
Route `MOD6-M001`'s apparent label inconsistency and `MOD7-H001`'s
possible under-crediting to `TASK-0010` Phase 2 adjudication once staffed.
Get this round independently re-QA'd before treating it as verified — same
standing caveat as every remediation round this session.

---

## Phase C R4 Independent Re-QA - Confirmed - 2026-07-12

**Task:** TASK-0016 Phase C. Verifies the R4 remediation entry below.
**Status:** Independently re-QA'd, fresh/isolated agent, no memory of
building R4 or the checker script. **Verdict: holds up — no defects
found.** First remediation round on this packet to pass independent
re-verification on the first try; R1-R3 needed a second pass to find gaps.

**Summary:** Re-checked every specific R4 claim rather than trusting the
self-report: independently recomputed the `APSTAT-MOD7-H002-INV`
chi-square statistic from scratch (χ² = 48.61, df = 2, p < 0.0001 —
matches exactly) and confirmed all 4 response variants are internally
consistent with the new stimulus, not just the `fully_correct` one;
verified the `APSTAT-MOD7-M001`/`-M004` stimulus fixes against the
deterministic answer keys and `validate_keys.py`; wrote an independent
script checking difficulty-suffix consistency across **all 100 FRQ items
in every module**, not just Module 8 — zero mismatches, confirming the fix
was complete and didn't regress anything elsewhere; rebuilt the packet
from a clean detached worktree and confirmed byte-identical reproducibility.

**Directly tested, not just read, both self-disclosed checker
limitations** flagged in `scripts/task0016_phase_c_qa_checks.mjs`'s own
comments: scanned every `ecf_parts[].givens` value in the full 30-item key
file for the whitelisted convention values (0.5, 1.96, 1.645, 2.576, 2.326,
1.282) — found 9 occurrences, checked each by hand, all are genuine
textbook conventions (stated confidence levels, true/false guess
probability, or in one case a value the checker's own percent-regex
already catches directly). Separately grepped all 100 FRQ stems for
visual-vocabulary words the checker's keyword list doesn't cover ("bar
chart," "dotplot," "stem-and-leaf," "normal curve," etc.) — zero hits;
every "plot"/"table"/"graph" mention already matches the existing regex and
already shows up in the 7 human-read candidates. **Neither limitation is
currently exploitable on this corpus** — real gaps in principle, but not
live defects today.

Also read a further 10-item unchecklisted random sample (no keyword
heuristic, no prior review) for the same answerability defect class this
entire investigation has been about — no new issues found.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** None blocking — R4 is verified. Remaining open
items unchanged from R4's own list: `APSTAT-MOD8-M001`'s strength-
assessment gap (left open, out of scope), and the rights/source +
manifest-schema-drift publish blockers flagged in `approval_packet.md`.

---

## Phase C Remediation R4: Fixed 3 Unanswerable FRQs + Module 8 Difficulty Labels - 2026-07-12

**Task:** TASK-0016 Phase C. Directly follows the independent re-QA entry
below.
**Status:** Fixed on `claude/cramapple-grading-mlr0o1` (commit `b552f06`,
pushed to PR #38). **Independently re-QA'd 2026-07-12, same day — held up.**
See the "Phase C R4 Independent Re-QA — Confirmed" entry above for the
verification record. No staging or publish action executed.

**Summary:** At David's request to fix the 3 new answerability blockers,
the Module 8 difficulty labels, commit the missing checker script, and
re-scan the full corpus, brought the entire Phase C publish packet (all 9
generator inputs + the generator script + the deterministic-key validator,
previously only on `codex/task0016-phase-c-content-publish-approval-main`)
onto this branch.

**Fixed `APSTAT-MOD7-M001`/`-M004`/`-H002-INV`** — same defect class as the
original 8: rubric/answer-key data never shown to the student. Added the
missing stimulus text for the first two. For `-H002-INV` (a 4-part
contingency-table + chi-square item that was missing its medium-anxiety
group entirely), constructed a full self-consistent data set, independently
computed the chi-square statistic by hand (χ² ≈ 48.61, df=2, p<0.0001)
*before* writing it into the model response, and rewrote all 4 response
texts (fully-correct through subtly-wrong) to match. Also fixed an
unrelated bug found while editing: the item's `module` field said 6, its
content_key says MOD7.

**Fixed the Module 8 difficulty labels** — 9 of 10 items were tagged
`very_hard` regardless of key suffix; corrected `M001`-`M005` to `medium`
and `H001`-`H004` to `hard`, matching the corpus-wide suffix convention
confirmed elsewhere (E→easy 15/15, VH→very_hard 6/6, no exceptions outside
Module 8).

**Committed `scripts/task0016_phase_c_qa_checks.mjs`** — the checker both
`qa_review.md` and the original `remediation_log.md` cite was confirmed (by
the independent re-QA) to never have been committed anywhere; this is a
fresh implementation, not a recovery. Its first version produced its own
false positives — flagged the standard z=1.96 95%-CI critical value as a
"hidden given," and missed percentage-form data (`"35%"` in a stem vs.
`0.35` in the answer key) due to a number-matching bug. Fixed both before
committing. The full-corpus visual/tabular-keyword scan is deliberately a
**warning tier, not fail-closed** — verified by hand that it produces real
false positives on this corpus (self-contained or purely conceptual items
that happen to mention "table"/"plot"), so a regex flags human-read
candidates rather than asserting a verdict it can't actually make.

**Full-corpus scan result:** 7 candidates, resolved by hand — 6 confirmed
false positives (documented individually in `remediation_log.md`'s R4
section), 1 real and left open (`APSTAT-MOD8-M001`: direction is
answerable but the rubric's "strength" requirement has no supporting
scatter-tightness data in the stem — same defect class, but outside the
specific 3-item scope requested this round, so flagged rather than
silently fixed).

**Verified, not just asserted:** regenerated the packet
(`build_task0016_phase_c_publish_packet.mjs`, same 200/100/100/18/0/0
structural counts as before); re-ran `validate_keys.py`
(`ALL CHECKS PASS`, 44/44 keys, 7/7 ECF templates — confirms the
stem/stimulus-only edits didn't disturb the deterministic answer keys
underneath them); ran the new checker (`PASS`, 28 deterministically-keyed
FRQs matching R1-R3's figure).

**Also found and deliberately did not fix:** the checker's disposition
count (`deterministicKeyed`/`conceptualOnly`/`excludedOrMethodOnly`)
initially tried to reproduce R1-R3's "28 keyed / 68 conceptual / 4
excluded" split, but `statistics_item_keys.json` only covers 30 of the 100
FRQ items — there's no way to derive that specific 68/4 split from data
this checker has visibility into. Renamed the output to
`deterministicKeyed` (28, verified) / `notDeterministicallyKeyed` (72,
honest about being unclassified) rather than fabricate a number that looks
precise but isn't verifiable.

**Not done, at the time this entry was written:** independent re-QA of this
round — completed later the same day, see the entry above. Rights/source
and manifest-schema-drift issues flagged separately in `approval_packet.md`
remain untouched, out of scope for this fix.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Decide whether to fix `APSTAT-MOD8-M001` now or
leave it for a later round. Rights/source and manifest-schema-drift gate
still needs to clear before this packet is actually stage-ready — R4 fixed
content-answerability, not the separately-flagged publish blockers.

---

## Phase C Publish Packet Independent Re-QA - Fail, New Blockers Found - 2026-07-12

**Task:** TASK-0016 Phase C (AP Statistics content publish packet). Relates
to `TASK-0010` (rubric/content quality) and the earlier Fail verdict on
`codex/task0016-phase-c-content-publish-approval-main`.
**Status:** Independently re-QA'd, fresh/isolated agent, no prior context on
this content. **Verdict: Fail — new blockers, not just re-confirmation of
old ones.** No content changed; this is a review-only pass. Not merged, not
published.

**Summary:** At David's request to "make sure" the Phase C remediation
actually holds up (the original Fail verdict's fixes had only been
self-verified by the same author who made them — see the earlier session
entries), ran an independent QA pass in an isolated git worktree
(`git worktree add --detach`, no shared state with the remediator's or the
original reviewer's checkout).

**R1 (reproducibility) and R2 (`APSTAT-MOD5-M001` sample-SD value:
7.91) — confirmed genuinely fixed.** Rebuilt the packet from a second,
independent detached worktree; output byte-identical to the committed
`bulk_import_payload.json`. Independently recomputed the SD by hand (sample
variance 62.5, sqrt = 7.905694... ≈ 7.91) — checks out. Re-ran
`validate_keys.py` independently (had to install `sympy`, undocumented
dependency): `ALL CHECKS PASS`.

**R3 (8 answerability fixes) — the named 8 are real, but the sweep was
incomplete.** All 8 claimed fixes independently verified as genuinely
answerable from their (now text-embedded) stimuli, math/logic checked by
hand for each. But the agent scanned the **full 100-item FRQ corpus**, not
just the 8-item checklist, and found the identical defect class
(rubric/answer requires data never shown to the student) still present in
at least 3 more items never mentioned by either the original QA or the
remediation log:

- `APSTAT-MOD7-M001` — contingency-table marginal-probability item; the
  needed counts (`prefer: 80, total: 200`) exist only in the hidden answer
  key, never in the student-facing stem.
- `APSTAT-MOD7-M004` — same pattern, tree-diagram probabilities
  (`p1: 0.3, p2: 0.7`) never surfaced to the student.
- `APSTAT-MOD7-H002-INV` — part (a) asks the student to construct a
  contingency table from data that isn't fully given (missing the
  low/medium/high anxiety group sizes) — same class as the already-fixed
  `MOD6-H002-INV`, but this sibling item was missed.
- Plus a softer one, `APSTAT-MOD8-M001` (rubric requires "moderate to
  strong strength" from a stem that only says "appears linear," no
  scatter-tightness info given).

**New issue, unrelated to R1-R3:** all 10 Module-8 FRQ items are tagged
`difficulty: "very_hard"` in `prompt_json` regardless of their key-suffix
letter (which encodes difficulty everywhere else in the corpus) — Module
8's medium/hard difficulty buckets are effectively empty for exam-draw
purposes. Not caught by the original QA's 15-item sample (Module 8 wasn't
in it).

**Could not verify:** the fail-closed checker script (`task0016_qa_checks.mjs`)
both prior documents cite as returning a clean pass is **not committed
anywhere in the repo** — it only ever existed at a `/private/tmp/...` path
on the original author's/remediator's own machines. The agent independently
re-derived the structural counts it would have checked (duplicates,
disposition counts, `-CAL` key count) by hand instead — matched, but this
is a partial substitute, not a re-run of the actual cited tool. Live-DB
collision/publish behavior also not checked (no live access), consistent
with both prior documents' own scope limits.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Do not run `bulk_import` on this packet. Fix
`APSTAT-MOD7-M001`, `APSTAT-MOD7-M004`, `APSTAT-MOD7-H002-INV` (same
stimulus-completion pattern as the original 8), correct the Module 8
difficulty field, and commit the QA-cited checker script into the repo so
future passes can actually re-run the same tool instead of re-deriving
substitute checks by hand. Then run a full-corpus (not 15-item sample)
answerability scan before the next QA pass, given a sample-based scan
already missed 3+4 items across two rounds.

---

## TASK-0010 Approved and UX-006 Brief Replaced With Real Integration - 2026-07-12

**Task:** TASK-0010, UX-006. Follows directly from the two entries below.
**Status:** `TASK-0010` approved to execute (`APPROVAL-0026`/`DECISION-0036`).
`prompts/LOVABLE_UX006_STUDENT_PRACTICE_GRADING.md` replaced with a
real-integration version. Neither is a production deploy by itself — the
UX-006 brief is a build spec for whoever executes it next (Lovable), not
yet executed.

**Summary:** After the Phase A ship-and-fix work in the two entries below,
David approved `TASK-0010` (Grader Confidence and Calibration) to move from
`Proposed` to active execution, and asked for the `UX-006` Lovable brief to
be replaced from frontend-only/simulated to real backend integration.
Recorded as `APPROVAL-0026` and `DECISION-0036`: this authorizes the
confidence/calibration program to run, not a Done decision — none of
`TASK-0010`'s eleven acceptance criteria are met, and `NOW-013`'s gate on
learner-facing automated scores is explicitly still open (needs Phase 4
shadow cohort + Phase 5 limited release to actually pass). Updated
`docs/tasks/TASK-0010-...md` status/approval-state and
`docs/MASTER_TODO.md`'s `NOW-013`/Active Task Register rows accordingly.

Rewrote `prompts/LOVABLE_UX006_STUDENT_PRACTICE_GRADING.md` to wire the
existing UX design (MCQ/FRQ practice, criterion feedback, grading states)
to the real Production backend instead of Lovable-fixture state: real
Supabase auth (no anonymous), reads only through the curated `public.*`
views (`PHASE1_CURATED_INTERFACE_NOTES.md`), and a concrete
`evaluate-attempt` request/response contract pulled directly from the
deployed function's source (`operation`/`idempotency_key`/`attempt_id`/
`response_version_id`/`content_item_version_id`/`rubric_version_id`/
`assistance_condition`; response fields including the `feedback_preview`/
`action_hint`/`repair_hint` columns fixed in the prior entry). Explicitly
kept dispute and regrade simulated — no backend exists for either, in git
or on Production, so building against them for real would mean fabricating
a contract that doesn't exist anywhere.

**Two things flagged in the brief as needing live verification before
build, not asserted as fact:** (1) whether AP Biology content is actually
published yet — a prior finding (`DECISION-0033`) flagged all
`content_items` stuck in `draft`, which would block this brief from being
exercised end-to-end at all; (2) which entrypoint actually submits a
response — git has a `submit-response` edge function and an
`app.submit_response` RPC, but Production's live edge-function list
(checked this session) shows a differently-named `attempt-response`
function instead, consistent with the same out-of-band deployment pattern
already found for grading. Supabase MCP tool calls started requiring
interactive approval partway through this session (tool server
reconnected under new IDs) and couldn't be retried non-interactively, so
neither was confirmed live — the brief tells whoever builds it to check
both before wiring anything, rather than guessing.

**Addendum, same day:** David named himself Learning Quality Owner / Grading
Lead for `TASK-0010`. Updated the task file's `Owner` line and
`MASTER_TODO.md`'s `NOW-013` owner column accordingly; corrected
`DECISION-0036`'s Risks/Follow-ups (still unmerged at the time, so amended
in place rather than logged as a separate correction) to reflect it instead
of shipping a stale "not yet named" note. Phase 2 still needs a *second*
qualified Grading Validator besides David before that phase can run — the
task requires two independent blind scorers.

**Second addendum, same day:** David clarified the Grading Validators
(plural, Phase 2's "two qualified Grading Validators") will be sourced from
the tutors currently being hired, not separately recruited — no individuals
named yet since hiring is in progress. Recorded in the task file's Phase 2
section with an explicit dependency this creates: those tutors must clear
`TASK-0005`/`NOW-005`'s validator-qualification bar (still `In Progress`,
not yet approved) before they can score gold-set cases, so Phase 2 is now
blocked on two things, not one — hiring completing, and `NOW-005` clearing.
Whether David also serves as Lead Grading Validator (who adjudicates
disagreements between the two scorers) or that's a separate hired-tutor
role is not yet decided.

**Third addendum, same day:** David asked to be named one of the two
Grading Validators himself (not just Lead / Learning Quality Owner).
Recorded in the task file. This sharpens rather than resolves the open
question from the addendum above: the Lead's entire function is
adjudicating disagreements *between* the two blind scorers, so if David is
one of the two scorers, he structurally cannot also be the Lead
adjudicating his own disagreements with the other scorer — that would
collapse the independence the phase exists to protect. Flagged in the task
file as an unresolved process-design tradeoff (third person as Lead, or
David steps back from being a scorer) rather than picking one unilaterally.
Also noted explicitly: the `NOW-005`/`TASK-0005` qualification bar applies
to David the same as any hired-tutor validator — being Product Owner
doesn't exempt him from it.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Resolve the Lead-vs-scorer conflict above before
Phase 2 can actually run once validators are qualified and hiring lands.
Before handing the UX-006 brief to Lovable, confirm the two open items from
the first addendum via Supabase MCP or dashboard (content publish status;
`attempt-response` vs `submit-response`/`app.submit_response` as the real
submission entrypoint). Track `NOW-005` (validator qualifications) as a
prerequisite for anyone — David included — to score Phase 2 gold-set
cases.

---

## Phase A Broken-Import Fix and Deterministic-Layer-Only Ship Decision - 2026-07-12

**Task:** TASK-0016, Phase A. Corrects the previous entry below.
**Status:** Fixed on `claude/cramapple-grading-mlr0o1` (commit `62758c9`),
pushed to PR #37. Still not merged to `main`, still no production deploy at
the time of this entry.

**Summary:** David asked to land Phase A wiring live for tutors to see it in
action without waiting for the tutor-approval gate, shipping today's
single-call LLM grader plus the deterministic layer only (explicitly not the
SP-1 misattribution audit or `C2Direct-Low` routing). Before deploying,
found that the `evaluate-attempt/index.ts` landed in the prior entry
(sourced from upstream commit `8f79ebe`) imports four modules —
`evaluate-attempt-response.ts`, `grading-feedback.ts`,
`statistics-verifier.ts`, `verification-profiles.ts` — that do not exist on
any branch in the repository's history, **including `8f79ebe`'s own source
branch at any commit**. That code would fail to load in Deno at all; it was
never actually runnable upstream, not just unmerged. The prior entry's claim
that the file was verified "byte-identical to `8f79ebe`'s target" was true
but insufficient — byte-identical to a target that itself doesn't resolve is
not a working verification.

Did not attempt to fabricate the four missing modules. Instead rewrote the
integration from the pre-Phase-A `evaluate-attempt/index.ts` by hand:
`resolveGradingRoute` (self-contained, verified) picks a route from
`rubric_type`/`evaluator_strategy` (now selected from `content_item_versions`)
or falls back to legacy `item_type`; when the route is `symbolic_ecf` and the
item's `content_key` matches a seeded entry in `math-verifier.ts`'s
`STATISTICS_ITEM_KEYS` lookup with populated `ecf_parts`, `buildEcfResult`
grades it deterministically (`model_id: "deterministic-symbolic-ecf"`,
`deterministic_verifier_version` recorded) and the LLM call and budget
reservation are both skipped. Every other case — including every currently
published AP Biology item, since none are in that lookup — falls through to
the existing single-call LLM grader completely unchanged. Deliberately did
not wire `formula-notation.ts`'s ambiguous-text/action-hint/repair-hint
helpers or populate the `feedback_preview`/`action_hint`/`repair_hint`
columns added by the prior entry's migrations — those need the still-missing
feedback-formatting layer; left null rather than fabricated.

Verified: only `grading-router.ts`, `math-verifier.ts`, and
`formula-notation.ts` are imported, and grepped the full `supabase/functions/`
tree to confirm zero remaining references to any of the four missing
modules. Brace-balance checked (no Deno available in this environment, so
this is not a substitute for `deno check`/`deno test`, which is still
outstanding).

**Decision, recorded per David's instruction:** ship Phase A (deterministic
layer + existing single-call grader) to Production ahead of the formal AP
Biology tutor-review gate (`NOW-004`) and `TASK-0010` approval, specifically
so tutors can observe it live and drive iteration from real behavior rather
than reviewing it statically first. This is a scoped exception for tutor
visibility, not a decision to open automated FRQ scores to students broadly
— `TASK-0010`/`NOW-013`'s gate on learner-facing automated scores is
unchanged and still open.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Merge PR #37, apply the pending migrations to
`Cramapple-Production` (`pcntajvbdfqhbeewmdry`), and redeploy
`evaluate-attempt`. Run `deno check`/`deno test` in an environment with Deno
before or immediately after deploy, since that verification is still
outstanding.

---

## TASK-0016 Phase A Grading-Router Reconciled Onto Grading Branch - 2026-07-12

**Task:** TASK-0016 (Grading Engine Rollout), Phase A
**Status:** Landed on `claude/cramapple-grading-mlr0o1` (pushed, draft PR
opened). Not on `main`. No production deploy, no approval requested yet —
mechanical reconciliation only.

**Summary:** At David's request to move grading toward production wired to
the Lovable frontend, first step was reconciling TASK-0016's Phase A
deterministic/symbolic grading-router work — previously stranded on
`origin/codex/task0016-phase-c-base` and never merged — onto this branch's
current, post-backend-consolidation `main` lineage. A straight cherry-pick of
commits `8f79ebe`/`98dc544` produced false conflicts because their branch
lineage also carries unrelated, unwanted Lovable runtime-context commits
(`44687a4`, `3b61a41`) earlier in its history. Resolved by diffing each
commit directly against the actual merge-base (`4a179e0`, confirmed identical
to this branch's pre-change `evaluate-attempt/index.ts` and `_shared/`) and
applying that diff instead, then cherry-picking `98dc544` (R1/R2 remediation)
on top, which applied cleanly since its parent is `8f79ebe` exactly.

Added `supabase/functions/_shared/{grading-router,math-verifier,
formula-notation}.ts` (+ tests) and wired them into `evaluate-attempt`, plus
6 migrations (deterministic verifier pins, rubric-routing columns +
backfill, feedback/action/repair hint columns on `grading_results`).
Verified the reconstructed `evaluate-attempt/index.ts` is byte-identical to
`8f79ebe`'s target before layering the remediation commit.

**Found and fixed during reconciliation, not carried over from any branch:**
the curated `public.grading_results` view (`202607090001_curated_public_
interface.sql`, applied 2026-07-09, one day after Phase A's migrations but
before Phase A was ever reconciled onto this history) lists `grading_results`
columns explicitly and was missing all 5 of Phase A's new columns
(`feedback_preview`, `action_hint`, `repair_hint`,
`deterministic_verifier_version`, `boundary_contract_version`). Since Lovable
reads through `public.grading_results`, not `app.grading_results` directly,
this would have silently hidden Phase A's feedback/repair output from the
frontend even after Phase A landed. Added
`202607120001_grading_results_view_phase_a_columns.sql` to recreate the view
with those columns included.

**Deliberately left out of this reconciliation** (present on
`codex/task0016-phase-c-base` but out of scope for landing the grading
router): AP Chemistry/Physics launch scaffolding, AP Statistics content-sync
commits, review-queue admin-scope changes, the Lovable runtime-context/
student-memory wiring, and the small `25da9ea` `review-queue` `frq_form`
fix. None of these are prerequisites for Phase A; pulling them in would have
reintroduced the large unrelated diff surface this step was meant to avoid.

**Not done in this step:** Phase C (AP Statistics deterministic-layer +
content publish) — its QA verdict is `FAIL`
(`ap_statistics_phase_c_publish_staging_2026_07_11/qa_review.md` on
`codex/task0016-phase-c-content-publish-approval-main`) with remediation
claimed but never re-verified; not pulled in here. No SP-1 quality-research
findings (misattribution audit, `C2Direct-Low` routing) are wired in — those
were never wired into `evaluate-attempt` on any branch, including this one.
Migrations have not been applied to any live Supabase project; `deno check`/
tests have not been run (no `deno` available in this environment) — TypeScript
correctness has only been verified by exact diff match against the source
commit's target, not by compiling.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Decide the quality bar for what ships first (per
prior session discussion: deterministic layer alone vs. also wiring the
misattribution audit before merge to `main`), get the outstanding Phase A
reviewer sign-off confirmed, and run `deno check`/tests against these files
in an environment with Deno before treating Phase A as merge-ready.

---

## AP Statistics Launch Task Drafted (TASK-0013) - 2026-06-30

**Task:** TASK-0013 (new — AP Statistics, Subject 2)
**Status:** Spec drafted, Hard-Gate tier, `Ready for Review` / Awaiting Owner
Approval. No implementation has started; this is plan-only.

**Summary:** At David's request, assessed which AP subject is the closest
technical match to AP Biology among the subjects Orly (AP Statistics, AP
Calculus AB, AP English Literature) and Micah (AP World History) are taking
this year, on grading-architecture reuse grounds — FRQ scoring shape
(criterion/rubric vs holistic essay) and what verification technique each
needs (deterministic calculation checks, symbolic math, document-use
reasoning, or none of the above). AP Statistics ranked closest: criterion/
rubric-scored FRQs with quantitative thresholds, same scoring shape as
Biology's FRQ criterion contracts, plus a shared curriculum owner (Orly).

Drafted `docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md` with a phased
delegation plan: Phase 1 (de-hardcode `grade-frq`/`evaluate-attempt` away
from literal "AP Biology" strings and wire the existing prompt-build-manifest
design from `CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §5 to
`subject_id`) is the one piece that blocks any second subject regardless of
which one is chosen, so it's sequenced first and delegated to Codex. Also
drafted a ready-to-fire Codex execution prompt for that phase
(`prompts/CODEX_AP_STATISTICS_PHASE1_GRADING_GENERALIZATION.md`), explicitly
marked do-not-execute pending task approval. Lovable's frontend phase is
scoped but not prompted yet, since the AP Statistics response-input UI
(typed calculation entry vs Biology's freehand graph canvas) depends on
Phase 1's output.

Confirmed via schema read that the multi-subject logical model was already
partially built: `app.subjects` exists as a first-class table
(`202606230002_subjects_normalization.sql`), and `content_key`/taxonomy
`label_type` columns are generic, not Biology-specific. The actual gap is in
the grading edge functions, not the schema.

**Next Owner:** David Bloom
**Next Required Action:** Review `docs/tasks/TASK-0013-AP-STATISTICS-LAUNCH.md`
and answer the five pending owner decisions listed in its Approval State
section (subject confirmation, content-sourcing model, pilot batch size/date,
reviewer credentialing, rights posture) before Codex Phase 1 begins.

---

## Hand-Drawn Graph Corpus Realism Fix and Four-Finding Spot-Check - 2026-06-30

**Task:** TASK-0011 (handwritten graph capture); relates to TASK-0010 gold/calibration governance.
**Status:** Research progress — generator fixed and verified. No production or content-release approval. Committed, rebased onto `main`, and opened as PR #18 (`claude/task-0012-deferred-findings`) alongside the broader working-tree cleanup; mergeable.

**Summary:** Spot-checked the in-repo hand-drawn graph generation artifacts
against four defect modes carried over from prior corpus/reference-image work:
(a) pen-type tradeoff (legibility vs point-position precision), (b) recurring
"carrying capacity" in student-facing text, (c) synthetic data that lands on
uniform/consecutive-integer sequences that are not real noise, and (d) paired
good/bad reference images that must isolate exactly one criterion violation.

Findings against the 2026-06-29 v0.1 corpus (`HDG-2026-P1-*`): (b) clean — zero
student-facing or reviewer occurrences; (a) only partially handled — the Orly
protocol logs `writing_instrument` after the fact but the 150-item capture
instruction is identical and silent on instrument; (c) failing and systemic —
no replicate-level data (SEM was an arithmetic formula), 60/90 uniform x-grids,
only 5 categorical mean-shapes recycled across 50 items, symmetric analytic
series; (d) absent in-repo — neither generator produces single-violation pairs,
so there are no true-negative criterion cases.

Acted on (c): rewrote `scripts/generate_hand_drawn_graph_corpus.py` to a
seeded, reproducible v0.2 generator. Every displayed mean and SEM is now derived
from synthetic replicate observations (stored per point for audit); two noise
scales give off-model scatter plus a legitimate irregular SEM; x-grids are
non-uniform but clean; displayed values are integer means / one-decimal SEM; and
shapes are RNG-varied per item. Output written to a NEW package
`docs/research/hand_drawn_graph_corpus_2026_06_30/` (prefix `HDG-2026-P2-*`); the
v0.1 package is left untouched and stays bound to the 100+ pages already drawn.

**Verified:** Generator runs and is bit-for-bit reproducible across runs
(identical JSONL hash). Re-running the v0.1 audit checks on v0.2: uniform x-grids
4/100 (was 60/90), uniform/fake SEM 0/100 (was 13/100), distinct categorical
shapes 50/50 (was 5), non-integer means 0 and non-1dp SEM 0, replicate-derived
SEM varies within every item, real off-model scatter in 49/50 series items. A
late-binding closure bug in the peak branch (corrupted 13 items) was found and
fixed; peak items now render proper optima with mild scatter. v0.1 dir confirmed
unmodified.

**Open / not done:** (a) pen-type is still uncontrolled (no felt-tip caution,
no matched-instrument capture sets); (d) single-violation negative cases still
do not exist — required before criterion precision can be measured; v0.2 has no
trace-set renders yet (`generate_hand_drawn_trace_sets.py` still targets v0.1);
no adjudicated dual-human gold exists for any image; external multimodal grading
remains blocked on Product Owner data-transfer approval. These gate any
learner-facing automated graph score per the drawn-response architecture review
and TASK-0010.

**Next Owner:** David Bloom (Product Owner).
**Next Required Action:** Decide the next collection/test focus — recommended
order: (1) reviewer blind-scoring pass to establish adjudicated gold (no provider
needed), (2) author single-violation responses for true negatives (finding d),
(3) point the trace renderer at the v0.2 package if drawable pages are wanted.
Review/merge PR #18 (note: TASK-0012 decisions were renumbered to DECISION-0029
CORS / DECISION-0030 budget to resolve a numbering collision with `main`).

## New-User Experience Live QA - 2026-06-29

**Task:** UX-001 (year-aware onboarding); Lovable-built student app at cramapple.com
**Status:** QA findings proposed — NOT passed. Pass/Done decision is the Product Owner's.

**Summary:** Live walkthrough of the new-user flow on cramapple.com via the
connected Chrome browser, signed in as `dbloom01@gmail.com` (so QA ran on the
owner's real account, leaving test data: one completed setup, one practice
session, one submitted MCQ). The `/signup` purchase wizard and account creation
could not be exercised (payment/account creation are prohibited agent actions),
so the commercial funnel is verified only to step 1 ("Which AP subject are you
buying?", 4-step, AP Biology available).

Working: landing page; `/account-created` welcome screen (prior dead-end
regression is fixed); setup-complete guard (`/account-created` → `/home` for a
returning user); `/setup` one-screen composed surface matching the design
(exam panel, course-position copy, time selector defaulting to 15 min,
recommended-session card, secondary "Other ways to start"); time selector;
`Start session` → `/session/mcq`; MCQ cold attempt → submit → "1 of 1 point"
feedback in an accessibility live region → Continue/Retry; returning Home
recommendation card. No console errors observed during the flow.

Defects found:
1. (HIGH) `/setup` course-position controls are unwired — "Change" opens no unit
   picker and "Yes, that's right" has no visible effect (silent no-op, no console
   error). Learner cannot confirm/adjust course position, breaking a locked
   onboarding decision.
2. (HIGH — needs confirmation) `/account-created` primary CTA "Set up my first
   session" did not navigate to `/setup` on first pass; could not reproduce
   because the page now forwards to `/home` (setup complete) and the owner's
   account state was not reset to retest.
3. (MEDIUM-HIGH) Exam date wrong/stale: `/setup` shows "Tuesday, May 12, 2026"
   with "0 days from today" — a past date with a clamped countdown. An Aug 2026
   beta needs the 2027 administration date.
4. (MEDIUM) In-app pages (`/setup`, `/session/mcq`) render in a cramped ~210px
   left column at desktop width; marketing pages render full-width — an app-shell
   container issue.
5. (LOW) Page titles leak the internal "UX-001" dev label (e.g. "MCQ attempt —
   Cramapple UX-001").

Fix prompt drafted: `prompts/LOVABLE_UX001_FIX_SETUP_DEFECTS.md` (covers #1–#4
plus the #5 minor).

**Next Owner:** David Bloom (Product Owner) for pass/Done decision; Lovable for
fixes once approved.
**Next Required Action:** Run `LOVABLE_UX001_FIX_SETUP_DEFECTS.md`; confirm the
welcome-CTA navigation with a true first-time user; resolve the exam-pack date
source (data, not just frontend). Do not treat the new-user experience as
launch-ready until #1 and #3 are fixed and re-verified.

## Production Readiness QA Handoff - 2026-06-21

**Task:** TASK-0012 / production-readiness review
**Status:** Handoff Logged; Live Function Boundary Still Unverified End-to-End
**Summary:** Captured the current state so the next session can resume cleanly. The local repo is on `claude/task-0012-qa-fixes` at `c5a4f93`, and PR #12 fixes are present locally: audit-event idempotency now scopes to `(request_id, reason_code)` via `supabase/migrations/202606210001_audit_events_idempotency_per_operation.sql`, and shared Supabase env validation now fails fast at module load in `supabase/functions/_shared/supabase.ts`. Live Vercel route checks for `/beta/start`, `/beta/resume`, and `/beta/admin/health` returned `200`, but direct POSTs to `https://cugmpcpdeqkaqmyyqujx.supabase.co/functions/v1/session-event`, `/evaluate-attempt`, and `/admin-content` returned `404 NOT_FOUND`, so the configured Supabase project still does not expose the expected function endpoints. The code review also established that the repo contains no `useServerFn`, `createServerFn`, or `_serverFn` call sites, so any remaining Lovable backend coupling would have to be confirmed in the live runtime/network tab, not from source alone.

**Next Owner:** Main Conductor / Claude QA
**Next Required Action:** Verify the live beta network path against the intended Supabase function origin, confirm beta/prod Supabase isolation in the dashboards, and enumerate any remaining `admin-content` defects as explicit checklist items before cutover.

## Cramapple Visual Identity Brief Revised From Family Discussion - 2026-06-21

**Task:** No tracked task number yet (brand/visual identity work; not yet filed under docs/tasks)
**Status:** Brief Revised; Color/Mark Direction Still Unresolved
**Summary:** Transcribed a full-family recorded brand discussion (David, Orly, Micah, Nama, plus the kids as target-user panel) and revised `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md` against it. Changes: added buyer-timing segmentation (2-month/1-month/cram cohorts) plus an ongoing-class-support segment; flagged an open, unresolved question on whether parents should lead messaging over students, especially early in the cycle; added explicit voice guidance to not lead with "AI" as the sell and to use the family/primary-source story as evidence of rigor rather than founder-story novelty; clarified that "feels like a really good tutor" is an interaction-tone target distinct from the Apple/Chrome visual-brand-temperature target; added semantic/functional color use for criterion-level grading feedback (correct/partial/incorrect) as a deliberate palette exception; added a seasonal grade-now/exam-later copy framing note; and flagged programmatic per-question SEO landing pages as a real design-system requirement needing a template. Color palette (mono+green leaning) and logo mark (Option A vs. B) from the prior session remain unresolved and untouched by this revision.

**Next Owner:** David Bloom
**Next Required Action:** Resolve the buyer-order open question (student-first vs. parent-first messaging) and confirm or amend the new Voice/Color additions; separately, still owes a decision on the mono+green palette and mark Option A/B from the prior session.

## Cramapple Visual Identity Brief Revised From Family Discussion - 2026-06-21

**Task:** No tracked task number yet (brand/visual identity work; not yet filed under docs/tasks)
**Status:** Brief Revised; Color/Mark Direction Still Unresolved
**Summary:** Transcribed a full-family recorded brand discussion (David, Orly, Micah, Nama, plus the kids as target-user panel) and revised `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md` against it. Changes: added buyer-timing segmentation (2-month/1-month/cram cohorts) plus an ongoing-class-support segment; flagged an open, unresolved question on whether parents should lead messaging over students, especially early in the cycle; added explicit voice guidance to not lead with "AI" as the sell and to use the family/primary-source story as evidence of rigor rather than founder-story novelty; clarified that "feels like a really good tutor" is an interaction-tone target distinct from the Apple/Chrome visual-brand-temperature target; added semantic/functional color use for criterion-level grading feedback (correct/partial/incorrect) as a deliberate palette exception; added a seasonal grade-now/exam-later copy framing note; and flagged programmatic per-question SEO landing pages as a real design-system requirement needing a template. Color palette (mono+green leaning) and logo mark (Option A vs. B) from the prior session remain unresolved and untouched by this revision.

**Next Owner:** David Bloom
**Next Required Action:** Resolve the buyer-order open question (student-first vs. parent-first messaging) and confirm or amend the new Voice/Color additions; separately, still owes a decision on the mono+green palette and mark Option A/B from the prior session.

## Session and Storage Backend Surfaces Wired - 2026-06-21

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Replaced the remaining `session-event` and `storage-sign-url` Edge Function scaffolds with authenticated production implementations. `session-event` now creates, resumes, saves, and ends `app.learning_sessions` rows with idempotent audit logging, while explicitly returning a clear unsupported response for anonymous-session attachment until the schema supports it. `storage-sign-url` now validates bucket/path scope, enforces learner-owned `learner-uploads` paths, issues signed upload/download URLs, and performs admin-only cleanup deletes. The function set still passes `deno check`. Browser smoke on the local prototype pages succeeded. The Supabase project roots responded, the updated Edge Functions were deployed to `pcntajvbdfqhbeewmdry`, and the live function routes now return `401` instead of `404`, confirming they are exposed at the expected boundary.

**Next Owner:** Main Conductor
**Next Required Action:** Verify the Vercel-facing app routes in production still point at the deployed Supabase functions, then confirm whether any remaining live beta traffic still depends on Lovable-hosted backend execution.

## Cramapple Visual Identity Brief Drafted - 2026-06-21

**Task:** No tracked task number yet (brand/visual identity work; not yet filed under docs/tasks)
**Status:** Brief Draft Complete; Color/Mark Direction In Progress (unresolved)
**Summary:** Worked through David's preliminary creative brief (Google Doc) and tightened it into `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md`. Resolved several open forks: Khan Academy/Quizlet/Duolingo are stature-only references (importance to students), not visual style references; Apple/Mozilla/Chrome/Instagram are the actual style touchstones — Cramapple should read as a tech-category product, not another edtech app; identity is designed for the student, parent-facing material inherits it rather than getting a separate "credibility" register; deliverable order is voice -> typography -> color -> fonts -> logo/wordmark; product is web-first (not mobile), used at a desk late at night, so contrast and a dark-mode-first palette are hard requirements, not aesthetic preference; the brand helps the student manage urgency rather than manufacturing more of it (no countdown/FOMO devices). Explored four color directions (signal blue/Chrome-coded, graphite+amber/Apple-coded, mono+green/terminal-coded, deep violet/Instagram-coded) in both dark and light mode as inline chat mockups. David is leaning toward mono+green. Iterated the apple mark through three rounds toward more geometric, less literal forms, ending with two unresolved options: (A) a faceted straight-edged polygon silhouette that keeps a faint apple echo, (B) a fully abstract open-ring mark with no literal apple reference at all.

**Next Owner:** David Bloom (creative direction decision)
**Next Required Action:** Decide between mark Option A and Option B (or request another iteration) and confirm the mono+green palette. Note: the color/mark mockups shown this session were inline chat visualizations only — nothing was saved as a file in the repo. Once a direction is locked, the brief's Color and Logo/Wordmark sections need to be updated with the final hex values and a saved SVG of the chosen mark.

## Production Plumbing Session Handoff - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Completed the first production-plumbing pass for the new Vercel/Supabase boundary. Confirmed Vercel project mapping for `cramapple` and `cramapple-dev`, set the Supabase environment split, and documented the `SUPABASE_URL` / `SUPABASE_ANON_KEY` / `SUPABASE_SERVICE_ROLE_KEY` checklist for both environments. Provisioned `Cramapple-Development` in Supabase by applying the `app` schema migrations in order, creating the private storage buckets, and verifying the seeded exam pack and account/profile rows. Verified auth and session persistence in the beta flow, then identified that the live graded attempt path was still executing through Lovable-managed `useServerFn` / `_serverFn` behavior instead of the new backend boundary.

**Next Owner:** Main Conductor, then David Bloom for continued migration sequencing
**Next Required Action:** Finish removing the remaining Lovable backend surface (`beta.admin.health.tsx`), then wire the live attempt/session/admin paths to the repo-owned Vercel/Supabase endpoints when ready.

## Supabase Production Migrations and Storage Policies Drafted - 2026-06-20

**Task:** TASK-0012
**Status:** Draft Complete
**Summary:** Converted the production Supabase schema plan into SQL migrations under `supabase/migrations/`. The migration set creates the `app` schema, profiles, exam packs, versioned content, sessions, attempts, criterion results, progress snapshots, audit events, the initial AP Biology seed, and private storage bucket policies. No live deployment or database change was applied.

**Next Owner:** Main Conductor, then David Bloom for review and live application approval
**Next Required Action:** Review the migrations and policies for any scope tweaks, then decide whether to apply them to the production Supabase project.

## Supabase Production Schema and RLS Plan Drafted - 2026-06-20

**Task:** TASK-0012
**Status:** Draft Complete
**Summary:** Drafted the production Supabase schema, RLS, and storage plan for the fresh production project `pcntajvbdfqhbeewmdry`. The plan defines the `app` schema, profiles, exam packs, versioned content, attempts, progress snapshots, audit events, private storage buckets, and the browser/server trust boundary. No live database, RLS, or storage changes were made.

**Next Owner:** Main Conductor, then David Bloom for approval and migration sequencing
**Next Required Action:** Review the schema and policy draft, decide whether any tables or bucket rules need scope reduction, and then convert the approved plan into migrations and server-side functions.

## Supabase Edge Function Draft Added - 2026-06-20

**Task:** TASK-0012
**Status:** Draft Complete
**Summary:** Added a production Edge Function draft covering assessment grading, session orchestration, storage URL signing, and admin content lifecycle operations. The draft includes a dedicated architecture note and scaffolded function entrypoints under `supabase/functions/`, but no live deployment or provider calls were made.

**Next Owner:** Main Conductor, then David Bloom for review and implementation sequencing
**Next Required Action:** Review the function catalog and decide whether the draft should be expanded into real authorization, database, and model-orchestration logic before any deployment.

## Evaluate-Attempt Production Path Implemented - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Replaced the `evaluate-attempt` scaffold with a real production-grade Edge Function that authenticates the caller, loads the attempt, response version, content item, and rubric criteria from Supabase, reserves daily model budget atomically, calls the OpenAI Responses API with structured output, persists grading results, and updates the attempt record. Added the supporting `response_versions`, `grading_results`, `model_usage_ledger`, and `prompt_versions` migration.

**Next Owner:** Main Conductor, then David Bloom for review, secret setup, and live migration approval
**Next Required Action:** Review the new migration and function contract, then decide whether to wire the remaining session and admin functions to the same production ledger pattern before deployment.

## Supabase Schema Review Feedback Addressed - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Incorporated Claude's review feedback by narrowing the schema-plan language to the operational learning boundary, explicitly separating the full content-governance model as a separate hard-gated task, and adding database guardrails for client-side grading-truth writes, published-content uniqueness, MCQ correctness uniqueness, duplicate-response protection, attempt rubric uniqueness, and session-query indexing.

**Next Owner:** Main Conductor, then David Bloom for approval and migration sequencing
**Next Required Action:** Review the new guardrail migration and decide whether to further decompose the content-side model into the governance task before production application.

## Full Content Governance Model Added - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Added the logical content-governance schema for source provenance, rights, artifact versions, state events, commissions, author and validator qualifications, review assignments, validation suites, release candidates, manifests, publication events, incidents, and revalidation tracking. The production plan was updated to note that the governance model now exists in the migration set.

**Next Owner:** Main Conductor, then David Bloom for review of the governance migration and any wiring changes needed in the application
**Next Required Action:** Verify the new tables and decide whether the app should be rewired to them immediately or left on compatibility tables until the next release slice.

## Content Workflows Wired to Governance Tables - 2026-06-20

**Task:** TASK-0012
**Status:** In Progress
**Summary:** Replaced the admin content scaffold with a real governance-aware Edge Function that writes source, rights, artifact version, state event, release candidate, manifest, and publication records. The legacy content tables now act as a compatibility projection, and a new migration marks them as deprecated so the transition is explicit.

**Next Owner:** Main Conductor, then David Bloom for review of the content workflow wiring and compatibility projection behavior
**Next Required Action:** Decide when to rewire the remaining read path off the legacy content tables and whether to keep the compatibility projection only for a bounded transition window.

## Production Plumbing and Cutover Readiness Task Created - 2026-06-20

**Task:** TASK-0012
**Status:** Not Started
**Summary:** Added a production-plumbing task to define the environment split, production accounts and keys, backend trust boundaries, deployment and rollback expectations, observability, and cutover criteria for moving from beta validation into a governed production launch. The task intentionally stays documentation-only and does not change live secrets, migrations, or deployments.

**Next Owner:** Main Conductor, then David Bloom for approval and implementation sequencing
**Next Required Action:** Review the task scope against UX001 and UX006, then turn the approved boundaries into the concrete production setup plan.

## Beta Revised-Answer Scoring Bug Logged - 2026-06-16

**Surface:** `https://cramapple-beta.lovable.app/beta`
**Status:** Patch Prompt Drafted
**Summary:** Confirmed by manual walkthrough on the Photosynthesis light
reactions FRQ that a coached revision targeting a single missed criterion
returns `Predicted: +0   Actual: +0` and leaves the revised total unchanged
even when the revision plainly satisfies the targeted criterion. Root cause
hypothesis: the revision is graded in isolation against the full rubric, so
it silently loses credit on criteria the original earned. Recommended fix
is targeted-criterion grading: grade the revised text only against the
clicked criterion and carry every other per-criterion decision forward
from the immutable original, then recompute the total. The comparison panel
must also expose original total, revised total, per-criterion delta,
predicted gain, and observed gain. Drafted
`prompts/LOVABLE_BETA_FIX_REVISION_SCORING.md` with the bug, the (b)
grading semantics, the updated comparison fields, and an acceptance check
requiring `REVISED (3/4)` with `+1` on the reproduction.

**Next Owner:** Lovable patch operator, then David Bloom for verification
**Next Required Action:** Apply the patch prompt to the beta, rerun the
documented walkthrough, and confirm both the gain case and the
no-improvement case behave as specified before any further beta use.

## Content Authoring and Revision Workbench Design Started - 2026-06-15

**Task:** UX-003
**Status:** In Progress
**Summary:** Defined the author-facing destination for new commissions and
items recycled by UX-002. The workbench covers task acknowledgement, complete
MCQ and FRQ package editing, simulated document import, anchored reviewer
comments, immutable version comparison, provenance and rights capture,
preflight, resubmission to two-tutor reassessment, and qualified access to the
review carousel with self-review exclusion. Renumbered student-provided
question intake to UX-004.

**Next Owner:** Paid Tutor Authors, AP Readers, Learning Quality Owner,
accessibility, security, privacy, and rights reviewers, then David Bloom
**Next Required Action:** Test the queue, editor, comments, comparison,
provenance, resubmission, and review-mode transition before any production
implementation.

## Student-Provided Question Intake Design Started - 2026-06-13

**Task:** UX-004
**Status:** In Progress
**Summary:** Defined a five-stage outside-question intake covering typed,
pasted, photographed, and document inputs; extraction confirmation; possible
personal information; one-round missing-context clarification; confidence-aware
subject matching; Teach, Hint, Check My Work, and Solution modes; and a
conservative active-assessment state. Created the canonical UX specification,
task record, clickable prototype, and Lovable render brief.

**Next Owner:** Learning Quality, accessibility, security, privacy, rights, and
academic-integrity reviewers, then David Bloom
**Next Required Action:** Test whether students can provide complete context,
understand confidence limits, choose the intended help mode, and distinguish
private use from anonymous improvement and separately reviewed publication.

## Question and Answer Review Portal Design Started - 2026-06-13

**Task:** UX-002
**Status:** In Progress
**Summary:** Defined the staged two-tutor and AP Reader workflow for question
candidates and MCQ answer options, including aggregate-score routing, immutable
edit-and-recycle behavior, whole-package exclusion, exact-agreement difficulty
labels, reviewer independence, and the boundary between candidate approval and
production release. Created the canonical interaction design, task record,
clickable prototype, and Lovable render brief.

**Next Owner:** Tutors, AP Readers, Learning Quality Owner, accessibility and
security reviewers, and David Bloom
**Next Required Action:** Review and test the carousel, score meanings,
rationale requirements, answer-package behavior, and difficulty discussion
before any production implementation.

## Drawn-Response Pilot V0 Preflight Blocked - 2026-06-13

**Tasks:** TASK-0010 / TASK-0011
**Status:** QA Blocked - Revision Required
**Summary:** Reviewed Claude's three-prompt AI-drafted pilot. The package has
the right scope, student/reviewer separation, candidate labeling, and capture
controls. Preflight found that Prompt 2's enzyme table is not reproducible from
its incomplete stated formula, Prompt 3's values do not match its logistic
equation, and the rights section cites a nonexistent Product Owner originality
approval. Standardized the P0 recommendation to SEM, symmetric error bars, an
operational plateau estimate, and a bounded linear scale. Corrected unsupported
rubric assumptions.

**Next Owner:** Claude for v0.2 remediation
**Next Required Action:** Produce a new immutable package satisfying
`prompts/CLAUDE_REMEDIATE_DRAWN_RESPONSE_PILOT_V0.md`, then return it for
deterministic recalculation, Learning Quality preflight, rights-status review,
and Product Owner decision before Orly begins.

## Orly Drawn-Response Pilot Protocol Prepared - 2026-06-13

**Tasks:** TASK-0010 / TASK-0011
**Status:** Draft internal research protocol
**Summary:** Reviewed Claude's 12-item hand-drawn AP Biology reference library.
Retained its graph-feature taxonomy and recommendation to begin with bounded
quantitative graphs, but rejected the historical official-question derivatives
as pilot prompts or gold-set seeds. Corrected overgeneralized graphing and
scoring claims. Prepared a protocol for Orly to complete three or fewer
independently authored graph prompts and submit two raw phone captures per
response.

**Next Owner:** Claude for rights-clean pilot drafting; Orly Bloom for Learning
Quality review and participation after the prompts pass review
**Next Required Action:** Claude produces three original student prompt sheets,
separate reviewer packages, provenance records, and the Orly administration
checklist defined in
`prompts/CLAUDE_REVISE_DRAWN_RESPONSE_PILOT_SET.md`.

## Official Exam Date and Registration Direction Applied - 2026-06-13

**Task:** UX-001
**Status:** In Progress
**Summary:** Removed learner-entered AP exam dates from the canonical student
portal UX, clickable prototype, architecture workflow, and Lovable render
brief. The active versioned exam specification now supplies the official date,
while the learner confirms registered, not registered yet, or unsure status.
The latter two paths remain non-blocking and explain that registration happens
through the learner's school or AP coordinator.

**Next Owner:** Learning, accessibility, representative learners, and David
Bloom for review
**Next Required Action:** Review whether the three registration choices and
school/AP coordinator explanation are clear without distracting from the first
useful learning action.

## Lovable UX-001 Render Brief Prepared - 2026-06-13

**Task:** UX-001
**Status:** In Progress
**Summary:** Created a self-contained Lovable build brief for rendering the
post-account student experience and related learning-session states. The brief
defines frontend routes, mock state, exact copy, branching behavior,
accessibility requirements, QA paths, and explicit prohibitions on backend
connections, production deployment, protected content, and invented product
policy.

**Next Owner:** David Bloom / Lovable operator
**Next Required Action:** Give
`prompts/LOVABLE_UX001_STUDENT_EXPERIENCE.md` to Lovable, generate a preview,
and return the preview for Learning, Marketing, accessibility, learner, and
Product Owner review.

## Post-Account Student Experience Expanded - 2026-06-13

**Task:** UX-001
**Status:** In Progress
**Summary:** Expanded the first-run prototype from a single setup screen into a
five-step, recoverable post-account journey: account-ready explanation, AP
Biology exam context, immediate learner goal, available time, optional
calibration, and a transparent first-session plan. The plan changes with the
learner's choices and preserves direct-start and finish-later paths.

**Next Owner:** Learning, Marketing, accessibility, representative learners,
and David Bloom for review
**Next Required Action:** Test whether learners understand why each setup
question is asked, how it changes their plan, and whether calibration feels
optional rather than required.

## Initial Student Portal UX Work Started - 2026-06-13

**Task:** UX-001
**Status:** In Progress
**Summary:** David authorized the initial product UX work. Created the formal
task record and proposed student-portal interaction design covering onboarding,
session modes, the stable learning-session frame, criterion feedback, repair
and retry, learner override, Move On and return behavior, coaching copy,
uncertainty, disputed grades, progress, accessibility, prototype scope, and
research questions. Production implementation and final UX decisions remain
hard-gated.

**Next Owner:** Main Conductor for low-fidelity prototype preparation; Orly
Bloom, Micah Bloom, accessibility reviewer, and David Bloom for review
**Next Required Action:** Conduct Learning, Marketing, accessibility, and
representative learner review of `prototypes/ux-001/index.html`, then bring the
nine proposed UX decisions to David.

## Content Follow-On Tasks Defined — 2026-06-13

**Tasks:** TASK-0008 through TASK-0011
**Status:** Proposed / Research
**Summary:** Added a clean proprietary exemplar replacement, conceptual
schema-governance reconciliation, phased grader-confidence program, and
paper-first QR-linked handwritten graph-capture research. Confirmed that MCQ
and FRQ authoring proceed simultaneously and that all reviewed FRQs remain
unapproved candidates subject to edit or rejection.

**Next Owner:** Learning Quality Owner, Grading Lead, Technical Owner, and
counsel as assigned
**Next Required Action:** Review task scopes and approve execution resources and
participants where required.

## Authoring Architecture Rewritten and Experiment Defined — 2026-06-13

**Task:** TASK-0007 / CONTENT-001
**Status:** In Progress
**Summary:** Rejected the prohibited official-derived candidate, converted useful
quality lessons into abstract failure cards, preserved paid-tutor authorship as
the production baseline, and defined a blinded validation-only experiment for
alternative AI-led authoring models. Replaced stale physical-schema proposals
with an immutable prompt-build-manifest architecture and complete MCQ/FRQ
package contracts.

**Next Owner:** Orly Bloom / Learning Quality Owner and counsel
**Next Required Action:** Review the architecture, experimental arms, source
isolation, contracts, metrics, and decision thresholds before execution.

## Visual Stimulus Architecture Review Prepared — 2026-06-12

**Task:** TASK-0006 / CONTENT-001
**Status:** Ready for Owner Review
**Summary:** Assessed the proposed structured-chart, prose-fallback, and
image-generation model. Recommended deterministic quantitative visuals,
governed authored or constrained diagrams, validated accessible equivalents,
and deferral of free-form generated scientific images. Added fail-closed,
answer-leakage, source, rights, revalidation, and learner-created graphing
requirements.

**Next Owner:** David Bloom
**Next Required Action:** Decide the five architecture questions in
`TASK-0006`, followed by Learning Quality, accessibility, and counsel review.

## Corrected AP Biology Coverage Direction Adopted — 2026-06-12

**Task:** TASK-0005 / CONTENT-001A
**Status:** Approved direction; Learning Quality review remains
**Summary:** Reviewed Claude's coverage and schema package. Retained the
separate MCQ/FRQ targeting model but corrected the taxonomy from 48 to 60
official topics and the full target from 784 to 964 inventory items. Defined one
inventory item as one MCQ or one independently delivered FRQ prompt. Approved
expert-curated diagnostic use before empirical confirmation, required human
review for statistical signals, and deferred physical Supabase design.

**Next Owner:** Orly Bloom / Learning Quality Owner
**Next Required Action:** Review topic-level feasibility, content variety, and
beta prioritization against the corrected matrix.

## Markdown-First Document Rule Adopted — 2026-06-12

**Task:** Operating documentation
**Status:** Approved
**Summary:** Established Markdown in GitHub as the default and canonical project
document medium. Google Docs is the preferred collaboration or backup copy.
Word is now an exception for a specific external, submission, printing, or
layout-fidelity need and is not regenerated by default.

**Next Owner:** Main Conductor
**Next Required Action:** Apply the format hierarchy to new and updated
documents and return accepted Google Docs edits to canonical Markdown.

## GitHub Synchronization Rule Adopted — 2026-06-12

**Task:** Operating documentation
**Status:** Approved
**Summary:** Required every retained local project document to be committed and
pushed to `david-bloom/Cramapple`. Added machine-local metadata exclusions and
remote-verification requirements.

**Next Owner:** Main Conductor
**Next Required Action:** Commit and push the current documentation set, then
verify the remote branch.

## Question Distribution Analysis Started — 2026-06-12

**Task:** CONTENT-001A
**Status:** Completed with corrections
**Summary:** Claude analyzed the distribution of MCQs and FRQs. Review retained
the separate question-form target model but rejected the 48-topic assumption
and 784-item total. `DECISION-0014` records the corrected 60-topic, 964-item
direction.

**Next Owner:** Orly Bloom / Learning Quality Owner
**Next Required Action:** Review the corrected coverage matrix, topic-level
feasibility, content variety, and beta prioritization.

## Proprietary Question Bank Rules Defined — 2026-06-12

**Task:** TASK-0005 / CONTENT-001
**Status:** Approved direction with open gates
**Summary:** Defined a proprietary MCQ and FRQ bank. Quantity was later refined
by `DECISION-0014` to ten MCQs and five short-FRQ prompts per official topic
plus eight long-FRQ prompts per unit. Base packages come from paid authors or
purchases; AI may create candidate variants only from packages with explicit
derivative and model-input rights. Every variant requires a complete rubric,
teaching package, provenance, and independent validation.

**Next Owner:** Orly Bloom / Learning Quality Owner with counsel
**Next Required Action:** Review topic-level feasibility, draft the simple
release, define permitted source and asset rules, establish the AI holdout, and
set production sample thresholds for question changes and retirement.

## Paid Tutor Question-Authoring Model Adopted — 2026-06-12

**Task:** TASK-0005 / CONTENT-001
**Status:** Approved direction; operating details in progress
**Summary:** Replaced the proposed historical-question-seeded generation model
with paid qualified tutors independently authoring original question packages
from Cramapple coverage briefs. Official College Board questions and scoring
materials are excluded from seeds, adaptation targets, few-shot examples, and
generative-model inputs.

**Next Owner:** Orly Bloom / Learning Quality Owner
**Next Required Action:** Define tutor author qualifications, commissioning
briefs, compensation and revision terms, originality and IP agreements,
preflight checks, coverage targets, and independent validation assignments.

## Owner Review Queue Updated — 2026-06-12

**Tasks:** TASK-0001, TASK-0003, TASK-0004
**Status:** NOW-001, NOW-002, and NOW-003 Done
**Summary:** David recorded `TASK-0001` and `TASK-0003` as Done and completed
owner review of the current `TASK-0004` documentation. `TASK-0004` remains open
for the independent AP Biology tutor review required by `NOW-004`.

**Next Owner:** Orly Bloom / qualified AP Biology tutors
**Next Required Action:** Complete `NOW-004`, record findings, and determine
whether `TASK-0004` requires remediation or can be closed.

## Master Backlog Created — 2026-06-12

**Task:** Operating documentation
**Status:** Active
**Summary:** Created `docs/MASTER_TODO.md` as the canonical index of current
task closures, required designs, legal and quality gates, teaching research,
MVP implementation, commercial readiness, and deferred expansion work. Backlog
entries preserve their existing approval state and do not authorize execution.

**Next Owner:** David Bloom / Main Conductor
**Next Required Action:** Continue with `NOW-004` through `NOW-007`.

## Content Governance and Validation Procedure Prepared — 2026-06-12

**Task:** TASK-0005
**Status:** In Progress
**Summary:** Drafted the complete proposed operating procedure for immutable
content and rubric versions, source and rights provenance, independent teaching
and grading validation, reviewer qualifications, numeric release gates, atomic
exam-pack publication, monitoring, revalidation, retirement, rollback, and
audit.

**Next Owner:** David Bloom
**Next Required Action:** Coordinate Learning Quality Owner and counsel review,
then approve, request changes, or reject the proposed policy and thresholds.

## Learning Boundary Questions Resolved — 2026-06-11

**Task:** TASK-0004
**Status:** Documentation revision in progress
**Summary:** Defined assessable skill targets for repeated-miss evidence; established diagnostic and instructional Frame behavior; made intervention selection recommendation-with-override; marked per-target time and stable-success thresholds for pedagogy research; and assigned public student-question publishing primarily to marketing/content with teaching and grading gates.

**Next Owner:** David Bloom
**Next Required Action:** Review the revised documents and PR language.

## Unified Learning and Stuck-State Revision — 2026-06-10

**Task:** TASK-0004
**Status:** Documentation revision in progress
**Summary:** Replaced deterministic miss counting and universal Sideways-first routing with evidence-weighted escalation, discriminating probes, independent and delayed confirmation, learner Move On, schedule-aware Park, and skill-and-task-specific intervention effectiveness. Added explicit anonymous use of student responses to improve Cramapple, separate from public publication.

**Next Owner:** David Bloom
**Next Required Action:** Review the revised learning-system documents and the updated pull request.

## Component Architecture and Teaching Design Prepared — 2026-06-10

**Task:** TASK-0004
**Status:** Ready for Owner Review
**Summary:** Created separate canonical designs for system context and logical components, and for ten-day teaching and pedagogy. Added a versioned exam-fact boundary, AP Biology point-distribution guidance, diagnostic and improvability models, next-action logic, FRQ pedagogy, and validator requirements.

**Next Owner:** David Bloom
**Next Required Action:** Review the documents and proposed decisions, then approve, request changes, or record the Done decision.

## High-Level System Architecture Prepared — 2026-06-09

**Task:** TASK-0003
**Status:** Ready for Owner Review
**Summary:** Promoted the architecture planning discussion into a canonical high-level design covering critical workflows, logical components, learner memory, account progress, user-provided questions, validator operations, parent entitlements, AI/provider boundaries, marketing interoperability, security, deployment, and AP-exam extensibility.

**Next Owner:** David Bloom
**Next Required Action:** Review the pull request and approve, request changes, or record the Done decision.

## Estimated AP Score Guidance Revision Prepared — 2026-06-09

**Task:** TASK-0002
**Status:** Ready for Owner Review
**Summary:** Updated Cramapple Vision v0.3 to permit qualified estimated AP score ranges, require confidence and non-official labeling, and connect estimates to concrete improvement guidance. Recorded the owner-approved planning scope and calibration requirements.

**Next Owner:** David Bloom
**Next Required Action:** Review the pull request and approve, request changes, or record the Done decision.

## Project Operating System Initialized — 2026-06-09

**Task:** TASK-0001
**Status:** Ready for Owner Review
**Summary:** Installed and customized the AI Project Operating Kit. Added David Bloom as Product Owner, added the Strategy Advisor role, established GitHub as the source of truth, and stored Cramapple Vision v0.2 in `docs/product/`.

**Next Owner:** David Bloom
**Next Required Action:** Review the draft pull request and approve or request changes.
