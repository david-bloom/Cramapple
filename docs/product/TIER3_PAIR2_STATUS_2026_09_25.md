# Tier 3 Pair 2 Status (2026-09-25, kickoff)

Per `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md`. Pair 1 (AP Statistics/Claude, AP
Chemistry/Codex) is CLOSED — see `docs/product/TIER3_PAIR1_STATUS_2026_09_25.md`. This is Pair 2: **AP
Calculus AB (Codex)** and **AP Precalculus (Claude)**.

## Assignment rationale

The paired plan named the pair but not who takes which subject. Baseline counts (verified against
Production, `pcntajvbdfqhbeewmdry`, 2026-09-25):

| Subject | Live items | No label | `legacy_unvalidated` | `stale` | `held` | `provisional_model` | `validated` | Difficulty rows |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| AP Calculus AB | 128 | 34 | 46 | 17 | 16 | 6 | 9 | 0 |
| AP Precalculus | 126 | 20 | 28 | 6 | 10 | 31 | 31 | 0 |

Calculus AB's label queue is larger (97 items need a fresh label vs. Precalculus's 54) and neither subject
has an existing difficulty-assignment CSV — unlike Pair 1, where both CSVs already existed. Codex gets
Calculus AB (bigger label queue, runs unsupervised overnight, has more time to build and validate a new
difficulty classifier). Claude takes AP Precalculus in the same session as this kickoff.

No duplicate-current-serving-label-row anomaly (the Chemistry 12-item case) was found in either subject.

## AP Calculus AB (Codex's half) — DONE, cross-QA'd, follow-up fixes applied

`docs/content/CODEX_TASK_AP_CALCULUS_AB_TIER3_LABELS_DIFFICULTY_2026_09_25.md` (v1). Codex ran it without a
clarification round this time (unlike Chemistry's v1→v4) and opened PR #197: 93 label decisions (64
`provisional_model` + 29 `held`) targeting the 97-candidate/42-published-after-filtering set, and 122
difficulty rows (12 Easy / 99 Medium / 11 Hard) via a Calculus-specific regex classifier
(`assign_difficulty_calcab.py`), since — as anticipated — the generic verb list didn't fit Calculus phrasing.

Claude's independent cross-QA (`docs/content/CLAUDE_CROSS_QA_AP_CALCULUS_AB_2026_09_25.md`, PR #199)
re-verified every count, contamination check, and migration-file byte-fidelity claim from scratch against
Production and found them all correct. It also spot-checked unit-assignment reasoning and difficulty-band
placement against real item text and found the work generally strong, with three fixable issues:

1. `apcalcab-frq-005` held for `empty_required_units` — a Gemini model-output-extraction bug (its own prose
   evidence agreed with GPT-5.5's `required_units=[2,3]`/`primary_unit=3`, but its structured array came back
   empty).
2. `apcalcab-mcq-030` held for `model_unit_disagreement` — a narrow secondary-unit-tagging disagreement
   ([3] vs [2,3]), not a substantive one.
3. `apcalcab-frq-033` — a real rubric defect (`part-a-criterion-3` scored an operation part (a)'s stem never
   asked for) that also caused a difficulty misclassification (Easy, when the item is actually a non-routine
   existence-and-uniqueness proof — Hard).

All three were fixed 2026-09-26 (`docs/content/CLAUDE_CROSS_QA_FOLLOWUP_FIXES_APCALCAB_2026_09_26.md`):
both holds resolved with a new current label row superseding the held one; `apcalcab-frq-033`'s stem reworded
to match its (correct) rubric criterion, and its difficulty corrected to Hard (corroborated independently by
the item's own authored `prompt_json.difficulty` field, which already said Hard). `apcalcab-frq-033`'s
serving-label hold was deliberately left in place — resolving it requires re-running the two-model label
pipeline against the now-corrected stem, not a hand-typed guess. PRs #197, #199, and the follow-up fix PR are
merged.

- Label target: 42 published items after filtering (36 clean + 6 Group A analog — see the run report for
  exact composition). Post-fix current-row state for the full live AP Calculus AB pack (128 items): 72
  `provisional_model`, 43 `held`, 9 `validated` (untouched), 3 `legacy_unvalidated` (untouched, non-published
  exclusions) — the two resolved holds moved from `held` to `provisional_model`.
- Difficulty target: 122 items (item-and-current-version published), 12 Easy / 99 Medium / 11 Hard, 1
  corrected to Hard post-fix.

## AP Precalculus (Claude's half) — DONE, cross-QA'd, remediated 2026-09-26

Codex's independent cross-QA of PR #198 (this section, below) found two real problems: the
Precalculus-specific difficulty classifier was never committed to the repository, and its output showed a
likely scoring defect (several multi-part FRQs recorded Hard on every criterion from a single hard cue in
one part). Both were fixed 2026-09-26
(`docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md`): a corrected classifier was written and
committed (`docs/research/apbio_difficulty_calibration_2026_09_22/assign_difficulty_apprecalc.py`, per-part
stem cue classification with a genuine per-criterion modal-tier computation, falling back to per-criterion
`learner_facing_text` for the templated `apprecalc-frq-u12-*` items), re-run against all 117 servable items,
and reloaded to Production (30 of 117 rows changed; corrected distribution Easy 1 / Medium 109 / Hard 7, down
from the original Easy 1 / Medium 96 / Hard 20). Separately, all 13 `model_unit_disagreement` serving-label
holds (not just Codex's sampled six) were resolved: 11 to the broader Unit-1-secondary answer, 1 to the same
pattern in reverse, and 1 individually to the narrower, correct answer after reading the item's stem — see
the remediation doc for the full before/after table. `apprecalc-frq-np2-008`'s rubric defect remains
correctly held, untouched. The narrative below (serving-label and difficulty run details) is the original
2026-09-25 run report; the corrected final numbers are in the remediation doc.

## AP Precalculus (Claude's half) — original 2026-09-25 run report

Independently re-derived baseline against Production matched the kickoff table exactly: 126 live items, 0
duplicate-current-serving-label-row anomaly, 20 no-current-row + 10 `held` + 28 `legacy_unvalidated` + 31
`provisional_model` + 6 `stale` + 31 `validated` = 126, servable (item-and-current-version `published`) set
117.

**A real infra bug was caught and fixed during this run, not just Pair 1's two carried-forward bugs.** The
label pipeline script (`extend_serving_labels_mcp.mjs`) hardcodes its output directory
(`/private/tmp/cramapple-math-taxonomy-serving/`) — the same directory Codex's concurrent AP Calculus AB
run was writing to. The first run's `write_labels.sql` came back with 93 tuples instead of the expected 49;
a contamination check (join through `exam_pack_versions`/`exam_packs.exam_code`) showed **all 93 belonged to
AP Calculus AB, zero to AP Precalculus** — Codex's process had overwritten the shared file after this run's
script wrote it. Per the task's stop conditions ("any generated SQL references a content_item_id not
belonging to the live AP Precalculus pack"), nothing from that file was applied. Root cause fixed by running
a copy of the script with `OUT_DIR` patched to an isolated scratch directory, then independently
contamination-checking the fresh 49-tuple output (100% AP Precalculus) before batching. Flagging this for
whoever runs Pair 3/4 concurrently with another agent: **do not trust the pipeline's default output
directory when two subjects are running at the same time** — either serialize the two subjects' pipeline
runs, or patch `OUT_DIR` per run before executing.

### Part A — serving labels (criterion 3)

Target: 54 items (20 no-current-row + 28 `legacy_unvalidated` + 6 `stale`) before published-filtering; 5
items (`apprecalc-mcq-042/044/046/048/050`) are `status='assigned'` (not `published`) at both the item and
current-version level and were excluded — matching the Chemistry precedent (55→42) of dropping non-published
items from the label run. Final target: **49 published items**, confirmed to match the pipeline's own
`--packets-file=` export exactly (same 49 `content_key`s, verified by set comparison before running the
script).

Pipeline run: `node scripts/taxonomy/extend_serving_labels_mcp.mjs --subject=ap_precalculus`, run ID
`serving-units-mcp-2026-09-25-20260926030633`, models `openai/gpt-5.5` + `google/gemini-2.5-flash` via the
Vercel AI Gateway. Output: 38 `provisional_model` + 11 `held` = 49 (matches target exactly). Applied to
Production in 10 batches of 4-5 tuples each (`apprecalc_serving_labels_batch_01` through `batch_10`, all in
Supabase's own migration history via `list_migrations`; local files
`supabase/migrations/20260925230000` through `20260925230900`). Batch size was smaller than the nominal
25-35 tuples because each tuple's `source_payload` carries the full two-model raw response (reasoning tokens
included), which made 25-tuple batches too large to read/verify reliably in one pass — batching smaller kept
every batch's exact applied SQL verifiable before sending. Cumulative row count (keyed on `model_run_id`)
was verified after every single batch: 5, 10, 15, 20, 25, 30, 35, 40, 45, 49.

Held items (11), by reason — none stood out on inspection as a clear, individually-resolvable case the way
Statistics found removed-topic distractors, so none were re-run; one is flagged below as a candidate for a
content reviewer, not resolved inline:
- `model_unit_disagreement` (8): `apprecalc-frq-np2-003`, `apprecalc-frq-np2-007`, `apprecalc-frq-u12-002`,
  `apprecalc-frq-u12-007`, `apprecalc-frq-u12-009`, `apprecalc-frq-u12-014`, `apprecalc-frq-u12-016`,
  `apprecalc-frq-u12-017` — genuine two-model disagreement on which unit(s) a multi-topic FRQ requires; not
  obviously resolvable without a taxonomy owner's judgment call.
- `rubric_preflight_failure` (2): `apprecalc-frq-np2-008`, `apprecalc-frq-u12-004` — one model found a
  rubric/prompt-part mismatch (e.g. `apprecalc-frq-np2-008`'s rubric scores the x-location of a local max
  when the prompt asks for the y-coordinate); a genuine content defect, flagged as a follow-up candidate for
  content review, not something this labeling task should silently patch.
- `other` (1): `apprecalc-frq-np2-001` — one model flagged a scope concern that the item's rational-function
  end-behavior part uses limit notation ("as x approaches infinity"), which it read as possibly
  calculus-adjacent for an AP Precalculus item; **candidate for a content-reviewer follow-up**: worth a
  human check on whether the existing limit-notation phrasing should be reworded to Precalculus-native
  language (e.g. "as x increases without bound") without touching the underlying (non-calculus) rational
  end-behavior content itself.

Final serving-label status breakdown for AP Precalculus (all 126 live items): `held` 21 (10 pre-existing +
11 new), `legacy_unvalidated` 5 (the excluded non-published items, untouched), `provisional_model` 69 (31
pre-existing + 38 new), `validated` 31 (untouched, governance-gated, out of scope). 21+5+69+31 = 126.
Post-apply integrity check: every one of the 126 live items has exactly 1 current (`superseded_by is null`)
serving-label row — 0 duplicate-current-row items, 0 zero-current-row items among the ones that should have
one.

### Part B — difficulty (criterion 5)

Target: 117 items (item-and-current-version `published`), re-derived independently and matching the kickoff
number exactly. 0 existing rows (clean slate) and **no existing difficulty CSV** — a classifier had to be
built from scratch, same requirement as Calculus AB.

**Classification approach.** Hand-spot-checked ~30 real AP Precalculus item stems/rubric-criteria pulled
from Production against the generic task-verb method (README §3). The generic verb list does not fit
Precalculus's dominant phrasing: "find", "solve", "give five consecutive key points", "average rate of
change", and "construct/write a model" are the load-bearing phrases across the corpus and none of them
appear in the documented Easy/Medium/Hard verb lists. Built a Precalculus-specific regex-cue classifier
(`assign_difficulty_apprecalc.py`, modeled on `assign_difficulty_chem.py`'s pattern) that extends the
generic tiers with Precalculus-specific cues:
- **Hard cues**: `justify`, `prove`, `explain why`/`explain one limitation`/`explain one reason` (the
  explain-split rule from the generic method, reused as-is: `explain` is Medium unless paired with an
  argumentation/limitation marker), `should not`/`cannot be used`/`may not`/`unreasonable`/`extrapolat*`,
  `at most one solution`, `critique`/`evaluate the design`/`design`/`propose`, plus two MCQ-specific cues
  found during the spot-check (`greatest caution`, `residual plot`/`most strongly indicates` — statistical
  model-validity reasoning).
- **Medium cues**: `construct`, `write a model/equation/inverse`, `average rate of change`, `compare`,
  `describe`, `interpret`, `explain` (default), `graph`/`plot`, `verify`, `find`, `solve`, `determine`,
  `give ... key points`, `state whether`, `approximate`, `compute`.
- **Easy cues**: the generic list unchanged (`identify`, `state`, `name`, `list`, `label`, `select`, etc.).
- Item-level difficulty is the modal tier across an FRQ's criteria (ties broken upward, per the documented
  method); MCQ is classified from stem + choice rationale text.

**Distribution**: All 117 — Easy 1 (0.9%), Medium 96 (82.1%), Hard 20 (17.1%). FRQ (64): Medium 47 (73.4%),
Hard 17 (26.6%), Easy 0. MCQ (53): Medium 49 (92.5%), Hard 3 (5.7%), Easy 1 (1.9%). **45 of 117 (38.5%) are
`calibrated_judgement`** (no cue matched at all, defaulted Medium) — a materially higher judgement fraction
than Biology's 37/118 (31%), driven mostly by terse MCQ stems ("Solve `log₂(x−1)=3`", "Convert 150° to
radians", "If `f(x)=2x−1`... then...") that carry no verb at all. This corpus is heavily Medium-concentrated
and the Medium band should be treated as undiscriminated, consistent with every prior subject's own stated
limitation — do not read the 82% Medium figure as a measurement of real difficulty distribution.

**CRR-agreement check**: `crr_calibration_all_subjects.csv`'s 24 AP Precalculus rows are scored rubric
points from the actual 2025 AP Precalculus exam's 4 FRQs (labeled by question/part-letter, e.g. "Q2 B3"),
not tied to any Cramapple `content_key` — there is no clean per-item mapping to compute a kappa against, the
same gap the README's Limitations §6 anticipates for `verb_auto`/`attr_method`. Computed instead: the CRR
points' own tertile distribution (Hard ≤0.41, Easy ≥0.56, mean 0.448) is Easy 9 / Medium 6 / Hard 9 — this is
close to an even three-way split *by construction* (tertile cuts are defined to divide the calibration
sample roughly into thirds) and is not a like-for-like comparison to an authored item bank's cue-based
classification, so no agreement/kappa figure is reported. The CRR mean (0.448) sitting centrally in the
Medium band is at least broadly consistent with a Medium-heavy corpus not being an outright modeling error,
but this is a weak signal, not a validation.

Load: `docs/research/apbio_difficulty_calibration_2026_09_22/APPRECALC_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv`
(117 rows, `content_key`/`item_type`/`difficulty`/`basis`), loaded into `app.content_item_difficulty` in 4
batches of 27-30 rows (`apprecalc_difficulty_batch_01` through `batch_04`; local files
`supabase/migrations/20260925231000` through `20260925231300`), `proposal_run =
'apprecalc_tier3_2026_09_25'`. Cumulative count verified after every batch: 30, 60, 90, 117. Final
distribution in Production: Easy 1, Medium 96, Hard 20 = 117. `basis` values follow the table's check
constraint: `calibrated_task_verb` (72 rows, confidence `medium`) for cue-matched items, `calibrated_judgement`
(45 rows, confidence `low`) for the no-cue-matched default-Medium items. `attainment_ratio` is null for all
117 rows (no CRR point maps cleanly to a specific `content_key`) — an honest null with an explaining
`rationale`, not a fabricated ratio, per DECISION-0061's own stated preference.

**Coverage gap / low-confidence items** — the 45 `calibrated_judgement` (no-cue) items, reported by exact
`content_key` per the task's requirement:
`apprecalc-frq-u12-002`, `apprecalc-frq-u12-003`, `apprecalc-frq-u12-012`, `apprecalc-frq-u12-014`,
`apprecalc-frq-u12-020`, `apprecalc-mcq-004`, `apprecalc-mcq-006`, `apprecalc-mcq-007`, `apprecalc-mcq-008`,
`apprecalc-mcq-010`, `apprecalc-mcq-011`, `apprecalc-mcq-013`, `apprecalc-mcq-014`, `apprecalc-mcq-015`,
`apprecalc-mcq-016`, `apprecalc-mcq-017`, `apprecalc-mcq-018`, `apprecalc-mcq-019`, `apprecalc-mcq-020`,
`apprecalc-mcq-022`, `apprecalc-mcq-023`, `apprecalc-mcq-024`, `apprecalc-mcq-027`, `apprecalc-mcq-028`,
`apprecalc-mcq-029`, `apprecalc-mcq-032`, `apprecalc-mcq-033`, `apprecalc-mcq-034`, `apprecalc-mcq-035`,
`apprecalc-mcq-036`, `apprecalc-mcq-037`, `apprecalc-mcq-038`, `apprecalc-mcq-040`, `apprecalc-mcq-041`,
`apprecalc-mcq-043`, `apprecalc-mcq-045`, `apprecalc-mcq-047`, `apprecalc-mcq-np2-001`,
`apprecalc-mcq-np2-002`, `apprecalc-mcq-np2-004`, `apprecalc-mcq-np2-005`, `apprecalc-mcq-np2-006`,
`apprecalc-mcq-np2-007`, `apprecalc-mcq-np2-008`, `apprecalc-mcq-np2-010`. All were still assigned Medium
(the documented default for "no verb anchor available," matching `calibrated_judgement`'s definition) and
loaded — this is a coverage-confidence gap, not a missing row.

### Ready for cross-QA

All 49 `content_taxonomy_labels` rows and all 117 `content_item_difficulty` rows created today are keyed
respectively on `model_run_id = 'serving-units-mcp-2026-09-25-20260926030633'` and `proposal_run =
'apprecalc_tier3_2026_09_25'` — a reviewer can pull the exact sets with those two keys. Per the paired plan,
Codex should independently review a sample of this output (spot-check the held-item reasoning above, the
Precalculus-specific difficulty cue design, and a handful of the 45 judgement-basis Medium defaults) once
its own AP Calculus AB half lands; Claude does not cross-QA its own work here.

## Cross-QA and remediation status (updated 2026-09-26)

Both halves have now been independently cross-QA'd and remediated: AP Calculus AB by Claude (PR #199,
follow-up fixes PR merged), AP Precalculus by Codex (PR #198 review) with remediation by Claude (see the
"remediated 2026-09-26" section above and `docs/content/CLAUDE_QA_REMEDIATION_APPRECALC_2026_09_26.md`). PR
#198 remains open (not merged) pending final review of the remediation.

## Not started

- Pair 3 (AP Physics 1 + AP Physics 2), Pair 4 (AP Physics C: Mechanics + AP Physics C: E&M), and AP
  Calculus BC (solo or paired with whichever finishes first).
