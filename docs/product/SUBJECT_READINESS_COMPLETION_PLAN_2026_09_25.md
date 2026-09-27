# Subject Readiness Completion Plan (2026-09-25)

**Status this plan starts from:** AP Biology is the only subject closed on all six servability criteria
(`docs/product/SUBJECT_SERVABILITY_CRITERIA.md`). Criterion 4 (canonical answers) is now closed and
independently double-verified for seven subjects (Calc AB, Chemistry, Physics 1, Physics 2, Physics C:
Mechanics, Physics C: E&M, Statistics) via PRs #188/#189/#190 and the follow-on remediation
(`supabase/migrations/20260925070000` through `20260925140000`). Two subjects (Precalculus, Calculus BC)
have not had criterion 4 touched yet. Criteria 3 (labels) and 5 (difficulty) are effectively untouched
everywhere except Biology. AP Statistics has a live, unresolved criterion-6 hazard.

**Read this whole plan before executing anything.** It splits into three tiers by how realistic "done
today" actually is, and one decision that has to be made by David before either agent touches Production.

---

## Tier 1 — Achievable today: close criterion 4 for the last two subjects

Precalculus and Calculus BC are the only subjects where canonical-answer authoring (the work this session
has been doing all day) is still open:

| Subject | FRQ total | Missing canonical | Labels validated/non-validated | Difficulty | Source |
| --- | ---: | ---: | ---: | ---: | --- |
| AP Precalculus | 65 | 32 | 30 / 90 | 0 | `prompts/CODEX_WORK_ORDER_AP_PRECALCULUS_LAUNCH_READINESS_2026_09_25.md`, confirmed fresh by PR #189 |
| AP Calculus BC | 65 | 29 | 4 / 125 | 0 | `prompts/CODEX_WORK_ORDER_AP_CALCULUS_BC_LAUNCH_READINESS_2026_09_25.md`, confirmed fresh by PR #189 |

**Split:** Claude authors Precalculus (32 items) directly, the same way it authored the other seven
subjects today. Codex authors Calculus BC (29 items) from its own existing work order.

**Why split this way, given Codex's token budget:** Direct multi-part FRQ authoring is the most
token-expensive thing either of us does today — today's 195-item run consumed a full day of Claude's
budget. Codex's context window is the scarcer resource of the two, so Codex gets the *smaller* of the two
batches (29 vs 32) and a work order that already exists (no remeasurement/discovery cost), and its output
gets checked by Claude rather than by a third read-only pass, since Codex re-reading its own 29-item
output a second time would burn budget for no new signal.

**Cross-QA (mirrors today's established pattern — the author never grades their own work):**
- Claude independently re-derives all 29 of Codex's Calc BC answers from each item's stem/rubric before
  trusting them, the same way Claude re-verified Codex's Statistics/Physics 1 measurements earlier today.
- Codex is handed a QA task for Claude's 32 Precalculus answers, scoped tightly (32 items, not a
  corpus-wide re-sweep) to keep it inside a reasonable token budget — modeled directly on
  `docs/content/CODEX_QA_TASK_P0_REMEDIATION_VERIFICATION_2026_09_25.md`'s narrow-scope pattern rather
  than the original 372-item full-corpus task.

**Deliverable:** two new migrations (Claude's Precalc batch, Codex's Calc BC batch), one QA report from
each direction, remediation of anything either QA pass finds, same loop as today's 34-P0 cycle.

---

## Tier 2 — Needs a decision before anyone executes: AP Statistics' dual-pack hazard

This is criterion 6, not criterion 4, and it is a live routing hazard, not a content gap: two
`exam_pack_versions` rows are simultaneously published for Statistics —

- `548f06be-ccf4-426d-b82b-b424137a4438` (old/general pack) — the only one actually serving FRQ (49
  targeted-drill, 27 unit-gated), now criterion-4-complete.
- `7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` (pilot pack) — MCQ-only, 203 items, 0 serving labels, returns 0
  from every measured serving selector (confirmed live as of PR #189, this morning).

**This needs your call before either agent touches it**, because retiring or otherwise resolving a
published exam-pack version is exactly the kind of hard-to-reverse, routing-affecting action this session
has consistently held out of scope pending explicit authorization. The obvious default resolution — retire
the pilot pack, since it currently serves nothing and has no labels — may be correct, but there could be a
reason it exists (a staged future migration, content worth salvaging) that only you know. Options:

1. **Retire the pilot pack now.** If you confirm there's no reason to preserve it, Claude can do this in
   minutes (one `exam_pack_versions` update + verification) — this is not an authoring task and doesn't
   need to go through Codex at all.
2. **Migrate anything worth keeping from the pilot pack into the general pack first, then retire it.**
   Slower; needs you to say what (if anything) in the pilot pack is worth preserving.
3. **Leave it as-is for now** and just make sure the routing logic never actually serves it to a student
   (verify `profiles.active_exam_pack_version_id` never points at it) — a lower-effort stopgap, not a real
   fix.

Not blocking Tier 1 — Precalc/Calc BC authoring can proceed in parallel while you decide this.

---

## Tier 3 — Not realistically finishable today: criteria 3 (labels) and 5 (difficulty), everywhere

Being direct about this rather than promising something that won't happen: labels and difficulty are not
the same kind of task as canonical-answer authoring, and hand-authoring them at today's pace is not
viable.

- **Scale:** roughly 900 non-validated labels and roughly 900 missing difficulty rows across the nine
  non-Biology subjects combined (see `docs/content/CODEX_QA_REPORT_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`'s
  per-subject counts). Today's 195-item canonical-answer push, split across two agents working most of a
  session, is roughly a fifth of that volume, and canonicals are the *harder* per-item task of the two.
- **Method mismatch:** per established practice (`docs/product/SUBJECT_SERVABILITY_CRITERIA.md` and this
  session's own memory of prior label work), serving labels and difficulty values are meant to come from
  the two-model-agreement / CRR pipeline, not from an agent hand-writing a label or a difficulty band
  per item the way we hand-write a canonical answer's prose. Doing it by hand today would mean improvising
  a process that already exists in a more reliable form elsewhere in this codebase, and would produce
  labels/difficulty values with a different (worse-understood) provenance than the rest of the corpus.

**What's realistic today instead:** confirm the two-model-agreement pipeline and the difficulty-scoring
methodology (the one Biology already used, governed by DECISION-0061's attainment-ratio rules) both still
run cleanly end-to-end against Production, and queue/kick off runs for the seven criterion-4-complete
subjects so the *pipeline* work is in motion, even though it won't finish today. This is worth a short,
separate work order once Tier 1 is done — not part of this plan's today-scope, and not something to
improvise inside a canonical-answer authoring task.

---

## Sequencing for today

1. **Now:** post this plan; Codex reviews it.
2. **In parallel once Codex confirms:**
   - Claude authors Precalculus's 32 canonical answers.
   - Codex authors Calculus BC's 29 canonical answers from its existing work order.
   - David decides Tier 2 (Statistics pack resolution).
3. **After both authoring passes land:** cross-QA (Claude checks Codex's 29, Codex checks Claude's 32),
   same independent-re-derivation discipline as today's work — no confirming against the other's stated
   answer.
4. **Remediate** anything either QA pass finds, same tight loop as today's 34-P0 cycle.
5. **If Tier 2's decision is "retire the pilot pack":** Claude executes it (not an authoring task, doesn't
   need Codex).
6. **Tier 3:** write the pipeline-kickoff work order as a fast follow, separate from today's scope.

**What "done today" actually means under this plan:** criterion 4 closed for all nine non-Biology
subjects (matching Biology's own criterion-4 status), Statistics' criterion-6 hazard resolved or
explicitly deferred with a stated reason, and the labels/difficulty pipeline queued but not finished.
That is a meaningfully different, more honest bar than "all subjects fully ready for student use" — which
would additionally require criteria 3 and 5 closed everywhere and the grading pipeline itself opened
beyond Biology (`qa_path_ap_biology_only`), neither of which is in scope for today.
