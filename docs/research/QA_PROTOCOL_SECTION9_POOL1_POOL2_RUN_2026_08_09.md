# §9 independent re-derivation — Pool 1 / Pool 2 run, 2026-08-09

**Trigger:** Owner-directed run of `docs/research/CONTENT_AUTHORING_AND_QA_PROTOCOL.md` §9
("Existing-content QA — independent re-derivation") against the two pools defined in
§9.3's yield table: Pool 1 ("single `approve`, never edited, never repaired") and Pool 2
("single `approve_with_edits`, repaired against the reviewer's own note"). Both pools were
previously piloted at n=25 on Physics only (§9.3); this run samples n=25 from each pool
**across all 10 subjects**, the first time this method has been run outside Physics.

**Scope:** Production (`pcntajvbdfqhbeewmdry`). Read-only throughout — no content row,
review assignment, or decision was inserted, updated, or deleted while producing this
report.

## 1. Pool definitions and population sizes

- **Pool 1** — `content_item_versions` where exactly one `tutor_question`-stage decision
  was ever recorded, that decision was `tutor_score=1` (approve), the version is
  `version_num=1`, no later version exists, and `status='published'`. **Population: 138**
  items across 8 subjects.
- **Pool 2** — a `tutor_score=2` (approve_with_edits) decision recorded on some version,
  where a later version (`version_num+1`) exists and is currently `status='published'`.
  **Population: 298** items across 10 subjects.

Per §9.5, this method is not meant to run as a periodic full-corpus sweep — pool selection
is what drives yield, not blind resampling. Consistent with that and with the original
pilot's own sample size, **25 items were randomly sampled from each pool** (`order by
random() limit 25`), stratified naturally by whatever the random draw produced. Not
exhaustive; if a full-population pass is wanted later, the population counts above are the
starting point.

## 2. Method

Each item's stem/stimulus/rubric-criteria-or-choices was read exactly as stored (for Pool
2, the CURRENT post-repair version). The independent-re-derivation discipline (§9.2) was
followed throughout: the correct answer/rubric was **worked out from scratch first** —
solving the actual math/physics/chemistry/biology/statistics problem — before comparing to
the stored key. Work was split across 8 agents grouped by subject (4 Pool-1 groups, 4
Pool-2 groups) to parallelize; each agent's full per-item work is in its own completion
report (not reproduced here in full — see §4/§5 for the confirmed findings, and ask if the
full per-item derivations are wanted).

## 3. Results — Pool 1 (single approve, never edited/repaired), n=25

**25 of 25 CLEAN.** No confirmed defects. By subject: AP Biology (7), AP Precalculus (6),
AP Statistics (7), AP Calculus BC (5) — every independent re-derivation (biology
mechanisms, algebra/trig work, statistics recomputation, calculus derivatives/limits/series)
matched the stored answer key or rubric criterion.

One non-scoring note: `APBIO-FRQ-S-070`'s internal answer-key narration
(`canonical_answer_2`) names "Lotka-Volterra dynamics" explicitly — a specific mathematical
model not named in the AP Biology CED (which covers logistic growth / carrying capacity /
density-dependent factors, not the named equations). It doesn't appear in the
learner-facing criterion text or scoring requirement, so it isn't a scoring defect, but is
borderline off-CED framing if that internal text is ever surfaced.

This adds 25 more clean items to Pool 1's track record (previously n=25, Physics-only, 0
confirmed defects) — the low-yield finding holds outside Physics too, across Biology,
Precalculus, Statistics, and Calculus BC.

## 4. Results — Pool 2 (approve_with_edits, repaired), n=25

**22 of 25 CLEAN. 3 confirmed DEFECTS, all one defect class.**

| content_key | Subject | Defect |
|---|---|---|
| `apchem-mcq-030` | AP Chemistry | Stem-embedded choice B text ≠ `mcq_choices` row B text (different sentences under the same key) |
| `apchem-mcq-042` | AP Chemistry | Stem-embedded choice D text ≠ `mcq_choices` row D text (D in `mcq_choices` is an unrelated, chemically nonsensical distractor — no H₂O in the reaction) |
| `apphycem-mcq-027` | AP Physics C: E&M | Stem-embedded choices C/D text ≠ `mcq_choices` rows C/D text |

All three are the **stem/`mcq_choices` desync bug** already named in the QA protocol's
v0.4 revision note — not a new defect class, but a new set of instances not covered by the
63-item desync-fix batch in David's 08-08 owner-remediation pass (that batch was
Physics-only across 4 pools; these 3 are 2 Chemistry + 1 additional Physics C instance).
In all three, the **answer key itself is correct** — independently re-derived and
confirmed — the defect is that the option text a student reads in the stem and the option
text stored in `app.mcq_choices` (what's actually graded) diverge.

Two additional non-defect notes, not rising to the same bar:
- `apcalcbc-frq-u13-014`: math and rubric are both correct, but the item's `prompt_json`
  topic tag ("2.1 Defining Average and Instantaneous Rates of Change," a Unit 2 skill)
  doesn't match what Part C actually requires (the Mean Value Theorem, CED topic 5.9, Unit
  5). A scope/tagging mismatch, not a correctness defect.
- `apchem-sfrq-015`: the rubric's accepted answer for the qualitative collision-frequency
  comparison is directionally correct but stops short of the fully quantitative conclusion
  an independent derivation reaches. Not chemically false — under-specified, not wrong.

By subject: AP Chemistry (8, 2 defects), AP Physics 2 (5, 0), AP Physics C: Mechanics + E&M
(6, 1 defect), and a mixed Calc AB/Precalculus/Physics 1/Calc BC group (6, 0 defects, 1
tagging note).

This confirms §9.3's core finding again on a new, cross-subject sample: Pool 2's yield
(3/25 = 12%) is meaningfully higher than Pool 1's (0/25) — repaired content is where this
method's cost is worth spending, not blanket resampling of never-touched approvals.

## 5. Follow-up mechanical scan — sizing the desync bug

Since all 3 confirmed defects were the same mechanical signature (stem embeds a lettered
option list that can drift independently of `app.mcq_choices`), a scan for that signature
was run against every published MCQ in Production, not just the 50-item sample — matching
the Chemistry agent's own recommendation and the protocol §9.3's finding that pattern
scans outperform blind resampling.

**Step 1 — how many published MCQs embed a lettered A/B/C/D list in the stem at all**
(the architectural precondition for this bug — a stem that duplicates option text is
itself the risk factor, since the app should be rendering options from `mcq_choices`, not
from the stem):

| Subject | Items with embedded option list |
|---|---:|
| AP Chemistry | 68 |
| AP Physics 1 | 27 |
| AP Physics C: E&M | 26 |
| AP Physics C: Mechanics | 23 |
| AP Physics 2 | 23 |
| AP Calculus BC | 22 |
| AP Precalculus | 19 |
| AP Calculus AB | 16 |

**Step 2 — of those, how many actually have a text mismatch between the stem's embedded
option and the stored `mcq_choices.choice_text` for the same letter** (regex-extracted and
compared per item):

| Subject | Items checked | Items with a mismatch |
|---|---:|---:|
| AP Chemistry | 68 | **18** |
| AP Physics C: E&M | 26 | 3 |
| AP Precalculus | 19 | 2 |
| AP Physics C: Mechanics | 23 | 1 |
| AP Calculus BC | 22 | 1 |
| AP Physics 2 | 23 | 0 |
| AP Physics 1 | 27 | 0 |
| AP Calculus AB | 16 | 0 |

**25 published MCQs total have a confirmed stem/choice-text desync right now** (18
Chemistry + 3 E&M + 2 Precalculus + 1 Mechanics + 1 Calc BC), including the 3 found by
independent re-derivation above (`apchem-mcq-030`, `apchem-mcq-042`, `apphycem-mcq-027`) —
consistent cross-check, same method converges on the same items.

**A striking pattern in the data: every one of the 25 flagged items is `version_num >= 2`
— none are an original, never-repaired version 1.** This defect is not something authoring
introduces; it's something the **repair process** introduces (or leaves stale) when a
version is edited: whichever of {stem, `mcq_choices`} gets touched during a repair doesn't
always get the other updated in lockstep. The full list is in the raw query output;
Chemistry (18) and Physics C: E&M (3, including `apphycem-mcq-027` from a version
originally repaired 08-08) carry the bulk of it.

## 6. What this means for the answer keys

In every confirmed instance (the 3 from independent re-derivation, cross-checked against
all 25 from the mechanical scan's `is_correct` flags), the **stored `is_correct` flag and
canonical answer are right** — this is a presentation/grading-text-consistency defect, not
a wrong-answer-key defect. Students see one distractor's wording in the rendered stem and
a different wording for the same lettered choice in whatever surface reads
`app.mcq_choices` directly (or vice versa) — confusing, and a real defect, but not one that
changes which choice is scored correct.

## 7. Follow-ups

- **Remediate the 25 stem/`mcq_choices` desync items** (§5's list) through the same
  new-version → review → approval → publish path already used for the prior 63-item
  desync-fix batch — same defect class, different instances.
- **Fix at the source, not just the instances:** since 100% of flagged items are
  `version_num >= 2`, whatever code path creates a new content version during repair
  should either (a) stop letting stems embed a duplicate option list at all — render
  options from `mcq_choices` only — or (b) if the embedded list is intentional, regenerate
  it from `mcq_choices` on every version bump instead of hand-editing both independently.
  Option (a) removes the defect class entirely rather than requiring discipline to keep two
  copies in sync.
- **Pool 1's 0/25 result (now 0/50 across two runs, 4 subjects added) supports the
  protocol's standing recommendation**: don't spend more of this method's cost on blind
  Pool-1 resampling. If more §9 budget is available, spend it on more Pool 2 sampling
  (298-item population, only 8% sampled so far) or on named-pattern scans like §5's, not on
  Pool 1.
- Route `apcalcbc-frq-u13-014`'s topic-tag correction and `apchem-sfrq-015`'s rubric
  tightening as low-priority content-ops cleanup — neither is student-facing wrong, both
  are worth fixing opportunistically.
