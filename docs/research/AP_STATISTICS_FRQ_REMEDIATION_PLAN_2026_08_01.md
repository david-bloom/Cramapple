# AP Statistics FRQ Remediation — Plan for Independent Review

**Date:** 2026-08-01
**Status:** EXECUTED 2026-08-01. See §11 for the execution record, what changed
from the plan as reviewed, and what remains outstanding.
**Author:** Claude (Opus 5) session, Cramapple content-review session. Independently
reviewed by a second model (Sonnet) across two rounds before execution.
**Purpose of this document:** originally to obtain a second opinion from a different
model before any of it was acted on; now the record of what that review produced and
what was executed as a result.

**Revision 2 (2026-08-01, after independent review by Claude Sonnet).** The reviewer
confirmed the arithmetic, performed both checks §7 flagged as undone, and contributed
one finding the plan lacked (§2.4). Follow-up verification by the author then found a
**blocking defect in the plan's own Phase 2** (§3.4) that neither the plan nor the
review had caught. Phase 2 has been rewritten. Phase 1 is unaffected and still stands.
Changes are marked **[R2]**.

---

## 0. How to review this document

You are being asked to challenge this plan, not to improve its prose. The author has
a stake in the plan being right; you do not. Specifically:

1. **Attack the central claim first** (§3.1). If it is wrong, the whole plan is wrong.
2. **Check the arithmetic** against the SQL in §9 — every number here came from those
   queries and they are reproducible.
3. **Read §7 (what I may have wrong) before §5 (the plan).** The author has listed the
   weaknesses he is aware of; the useful contribution is the ones he isn't.
4. Treat the recommendation in §5 as one option among the four in §4, not as settled.

The plan proposes retiring 90 content items (19 of them published) in a production
database. Errors are recoverable but disruptive. Bias toward challenge.

---

## 1. Background

Cramapple is an AP exam-prep product. AP Statistics is one of its subjects. There are
currently **zero active students**, so nothing below has live learner exposure — this
lowers the risk tier but does not make the changes free.

**The precipitating change.** The College Board revised the AP Statistics course
effective Fall 2026 (first exam May 2027). Two changes matter here:

- The course went from **9 units to 5 units**.
- Section II went from **6 free-response questions** to **4 free-response questions
  worth 10 points each**. Each of the 10 points is scored independently.

The four questions are fixed archetypes:

| Q | Description (College Board) |
| --- | --- |
| Q1 | Multi-part, **primarily** assesses Practices 1 and 2 |
| Q2 | Multi-part, **primarily** assesses Practices 3 and 4 |
| Q3 | Focuses on inference; assesses the inference skills associated with Practices **2, 3, and 4** |
| Q4 | Multi-part, focus on multiple content areas; assesses Practices **2, 3, and 4** |

Cramapple's beta cohort sits the **May 2027** exam, so the 5-unit / 4×10-point
structure is the only one that matters. The existing AP Statistics bank was authored
against the retired 9-unit structure.

**The trigger.** On 2026-08-01 the AP Statistics reviewer (Jill, the only Statistics
reviewer) submitted five findings. All five were verified and confirmed. The relevant
one here is her third: too many items are "not FRQ-type questions but just ask a
question that requires a short answer," which she recommended minimizing. Full triage:
`docs/research/AP_STATISTICS_REVIEWER_FEEDBACK_2026_08_01.md`.

**Prior approved work.** A full AP Statistics rebuild is already approved
(`DECISION-0036`, `APPROVAL-0036`) targeting **100 MCQ / 70 FRQ**, with the 70 FRQs
split 14/16/22/18 across the four archetypes. It is gated on **G0A** — subject-tutor
sign-off on `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`, which currently exists
only on branch `codex/five-subject-harness-and-content` (commit `e0bf685`). **The
rebuild has produced 12 draft items in a markdown file and nothing in the database.**
This matters: the plan below cannot assume replacement content is arriving soon.

---

## 2. Verified current state

Production Supabase project `pcntajvbdfqhbeewmdry`. AP Statistics items span three
content-key prefixes (`APSTAT`, `APSTATS`, `STATS`) — **276 items total**.

### 2.1 FRQ pool — 158 items

Classified by actual point total and criterion count from `frq_criteria` on each
item's latest version.

| Category | Items | Published | In pipeline | Retired/disapproved | Criteria |
| --- | ---: | ---: | ---: | ---: | ---: |
| **A.** One-point, single-criterion short answer | 90 | 19 | 68 | 3 | 90 |
| **B.** Four-point multi-part (18 short + 5 long) | 23 | 15 | 4 | 4 | 92 |
| **C.** Undersized "long" FRQ (2, 3, or 5 pt) | 5 | 1 | 3 | 1 | 15 |
| **D.** Hand-drawn graph drill, 4 pt (`APSTATS-HDG-*`) | 40 | 32 | 1 | 7 | 160 |
| **Total** | **158** | **67** | **76** | **15** | **357** |

### 2.2 MCQ pool — 118 items

16 published · 34 reviewed_approved · 60 draft · 1 changes_requested · 6 retired ·
1 reviewed_disapproved.

### 2.3 Other verified defects (context, mostly out of scope for this plan)

- **19 items test removed or never-in-scope content** (slope inference, chi-square
  goodness-of-fit, re-expression, combining random variables, geometric distribution,
  multiple regression). 2 published, 3 reviewed_approved, 14 already dead.
- **5 of 7 mosaic-plot items are defective** (equal or partly equal group totals,
  which collapses a mosaic plot into a segmented bar chart). All 7 additionally ask
  students to read a raw *count* off a proportions display.
- **The 9-unit taxonomy is baked into three places**: the reviewer UI unit picker
  (`src/data/taxonomy.ts` in `david-bloom/exam-buddy-wireframe`, present on
  `origin/main`), `content_labels` definitions for AP Statistics Units 1–9 with **200
  Stats items tagged** (22 of them to the now-nonexistent Unit 9), and 19 reviewer
  `topic_selections` on review decisions.
- **At least 3 of the category-A items reference a display that does not exist** —
  stems opening "This tree diagram shows…", "This residual plot shows…" with an empty
  `stimulus` and null `stimulus_image_path`. These are unanswerable as published.

### 2.4 [R2] No AP Statistics FRQ is servable today

Contributed by the independent review and verified by the author against the live
function definition.

The only FRQ practice RPC in the database is `public.select_practice_frqs`. Its
predicate is a strict equality match with no NULL fallback:

```sql
and ci.practice_format = _practice_format
and _practice_format in ('targeted_drill', 'full_exam_frq')
```

**Every one of the 158 AP Statistics FRQs — all four categories, all statuses,
including all 67 published — has `practice_format IS NULL`.** In SQL `NULL = 'targeted_drill'`
is never true, so no AP Statistics FRQ can be returned by this RPC under either
accepted value. The frontend's FRQ session route defaults the format parameter to
`targeted_drill`, so a student starting an AP Statistics FRQ practice session today
gets zero results.

Stated at the precision it deserves: an RLS policy (`content_items_select_published`)
would permit some other surface to read `content_items` directly and bypass this RPC.
Neither the reviewer nor the author found such a surface, but absence of evidence is
not proof. **The dedicated practice-session path is definitively dead for this
subject; other paths cannot be ruled out.**

This materially reframes Phase 2. It is not cosmetic relabeling for future clarity —
it is the change that would make 48 already-published items reachable by the
application for the first time. The claim "AP Statistics FRQ content is live" is
currently false in practice, and is the kind of statement that gets repeated in a
status update by someone who does not know that.

### 2.5 [R2] Grading does key on per-criterion points

Verified in response to the plan's own §3.2 invitation to check this.
`attempt_criterion_results` stores `points_awarded` per `criterion_key`. Per-criterion
points are therefore load-bearing in the grading path, not merely descriptive.

---

## 3. The central finding

### 3.1 No existing FRQ aligns with the four question types

The four archetypes are **10-point** multi-part questions. **The highest-scoring item
in the entire AP Statistics bank is worth 5 points.** Alignment therefore fails on
shape alone, before content is considered.

A strict instruction to "remove everything that does not align with the four question
types" would retire **100% of the FRQ pool (158 items), including all 67 published
items**, leaving AP Statistics with 16 published MCQs and no free-response content at
all — with no rebuilt content ready to replace it.

**This is the claim to attack first.** It rests on one premise: that alignment
requires the 10-point archetype shape. If a reviewer accepts a 4-point multi-part item
as a legitimate "compact Q2," the finding weakens substantially and the plan changes.
The author's position is that the premise holds because College Board is explicit and
unhedged about the 10-point structure and about independent scoring of each point, but
this is a judgment call and is the highest-leverage thing to disagree with.

### 3.2 Rescaling points is not a viable shortcut

The question was raised whether a 5-point item could simply be relabeled as 10 points.
The author's position is no, for three reasons:

1. **Points are a count of independently-earnable criteria, not a scale factor.** A
   5-point item has 5 rows in `frq_criteria`. Relabeling produces either 5 unearnable
   points or criteria worth 2 points each, which breaks per-criterion granularity.
2. **Grading depends on it.** `attempt_criterion_results` and the criterion-boundary
   contracts key on per-criterion points. Rescaling silently changes scoring behavior
   across the grading engines.
3. **Score estimates are corrupted.** A student earning 3 of 5 criteria would display
   6/10, implying 60% performance on an exam-shaped question they never attempted.
   This feeds the estimated-AP-score feature, which carries explicit calibration
   requirements.

Separately, rescaling does not touch the practice-coverage problem (§3.3): a one-point
"calculate the z-score" is Practice 3 only, and calling it 10 points does not add
Practice 2 or Practice 4.

**[R2] This reasoning has now been checked and holds, on firmer evidence than the
original draft claimed.**

- Objection 2 is **verified**: `attempt_criterion_results.points_awarded` is stored
  per `criterion_key` (§2.5).
- A further precedent was found: `app.validate_full_exam_frq_version` enforces a real
  points-and-part-shape contract for `full_exam_frq` items — exact point totals and
  exact part splits per archetype (e.g. Mathematical Routines = 10 points in a `[7,3]`
  split), with each part's criteria required to sum to that part's points. **Physics is
  therefore working proof that exam-shaped FRQs need a purpose-built, enforced
  part/criterion contract rather than a relabeled existing item.**

One precision the reviewer's framing over-reached on, corrected here: the Physics
trigger supports objections 1 and 3 (points are structural, independently earned) and
supplies the precedent argument above. It is **not** itself evidence for objection 2 —
it is publish-time validation, not grading behavior. Objection 2 stands on §2.5
independently. The distinction matters because the two claims would need different
evidence to overturn.

### 3.4 [R2] BLOCKER — Phase 2 as originally written cannot execute

Found by the author after the review, and present in neither the original plan nor the
review. This is the most consequential item in Revision 2.

`app.content_items` carries this trigger:

```sql
CREATE TRIGGER prevent_live_frq_reclassification
BEFORE UPDATE OF practice_format, frq_archetype, frq_form ON app.content_items
FOR EACH ROW WHEN (old.item_type = 'frq')
EXECUTE FUNCTION app.prevent_live_frq_reclassification()
```

It raises `published_frq_reclassification_requires_retirement` whenever
`practice_format`, `frq_archetype`, or `frq_form` changes on an item that has any
published version. **Setting `practice_format='targeted_drill'` on the 48 published
category-B/C/D items will hard-fail.**

The intended workflow is encoded in the exception name: retire first, reclassify, then
re-publish. But the return path is also gated. `app.tg_content_pipeline_guard_publish`
permits a transition to `published` **only from `reviewed_approved`**:

```sql
if new.status = 'published' and old.status is distinct from 'published' then
  if old.status is distinct from 'reviewed_approved' then
    raise exception 'content_pipeline_guard: cannot publish from status % ...';
```

So restoring each of the 48 items requires walking it back through review approval —
48 re-approvals through a pipeline whose publication-trust defect is a known open P0.
What looked like a metadata backfill is in fact an unpublish/re-review/re-publish
cycle.

**Phase 1 is unaffected.** Setting `status='retired'` touches none of the three guarded
columns and is not a transition *to* `published`, so neither trigger fires.

---

### 3.3 A related constraint that affects the rebuild, not the cleanup

College Board hedges Q1 and Q2 ("**primarily** assesses…") but not Q3 and Q4, which
assess Practices 2, 3, **and** 4. For those two, three-practice coverage is
structural. There is a trap: **verifying conditions is skill 4.E — Practice 4, not
Practice 2.** Practice 2's inference skills are 2.C (identify the appropriate method),
2.D (error types), 2.E (state hypotheses). An author who writes "check conditions →
compute → interpret" covers only P3 and P4 while believing otherwise.

Applying this to the 12 drafted rebuild items: **draft Q3 passes; draft Q4 fails** —
it has no Practice 2 part at all, and computes a standardized statistic without ever
stating hypotheses. This is not part of the cleanup plan below but is recorded because
it affects the rebuild the plan hands off to.

---

## 4. Options considered

| # | Option | Retires | Keeps live | Assessment |
| --- | --- | ---: | ---: | --- |
| 1 | **Strict alignment** — retire all 158 | 158 (67 published) | 0 FRQs | Literal execution of the instruction. Leaves the subject with 16 published MCQs and no FRQ content for an unknown period, since the rebuild is gated at G0A with nothing in the database. |
| 2 | **Retire A only**, reclassify B/C/D as `targeted_drill` | 90 (19 published) | 68 (48 published) | Recommended. See §5. |
| 3 | **Retire A and C**, reclassify B/D | 95 (20 published) | 63 (47 published) | Marginal difference from option 2; C is only 5 items. Defensible — C items are mislabeled `long` at 2–5 points — but they can equally be relabeled as drills. |
| 4 | **Classify only**, no writes | 0 | 158 | Defer all disposition until G0A and the format decision are settled, so the bank is dispositioned once against the rebuilt content rather than twice. |

Option 4 deserves more weight than it may appear to get below. Its argument: every
item in categories B, C, and D is going to be re-examined anyway when the rebuilt bank
lands, so touching them now is work performed twice. Its cost: the 19 published
category-A items — including the ones referencing nonexistent displays — stay live in
the meantime.

---

## 5. Recommended plan

**Option 2.** Three phases, strictly ordered. Nothing in Phase 2 or 3 should begin
until Phase 1 is reviewed.

### Phase 1 — Retire category A (90 items)

**What:** set `status = 'retired'` on the 90 one-point, single-criterion items.

**Why these and not others:** they are neither exam-shaped nor multi-part drills. A
single-criterion item cannot exercise a practice *span*, cannot be consolidated into a
10-point question without full rewriting, and is precisely what the reviewer described
as "not FRQ-type questions but just ask a question that requires a short answer." At
least 3 are unanswerable due to missing stimuli.

**Selection rule (must be stated in the migration, not hand-listed):** AP Statistics
items where `item_type='frq'`, the latest version has exactly one row in
`frq_criteria`, and `content_key` does not match `APSTATS-HDG-%`.

**Status choice:** `retired`, never `DELETE`. `retired` is in the existing status
constraint, is already used by 15 Stats items, and is reversible with a single UPDATE.
Phase 1 triggers none of the guards in §3.4.

**[R2] Audit notes to carry into the migration comment:**

- **3 of the 90 items carry real grading-pilot history.** The independent review
  traced all 19 published category-A items through `attempts`, `response_versions`,
  and `grading_results` and found 15 attempt records against 3 content_keys, all from
  a single synthetic account (`grading-pilot-20260728-…+test`, dated 2026-07-28). Not
  a blocker and not real students, but it should be noted so nobody later wonders why
  retired keys appear in an old pilot log.
- **2 items are richer than the rest and may be worth keeping as consolidation seeds:**
  `STATS-MOD4-M009` (matched-pairs design) and `STATS-MOD3-H006` (bimodality). The
  review recommends retiring them with the rest rather than carving out exceptions,
  since `retired` is reversible and Phase 3 can pull them back. The author agrees.

### Phase 2 [R2, REWRITTEN] — Reclassify categories B, C, D (68 items)

**Goal unchanged:** give the 68 non-exam-shaped items their correct home,
`practice_format = 'targeted_drill'` — which per §2.4 is also what makes them
servable at all. **Method changed**, because the original one-line UPDATE is blocked
by §3.4.

**Why not retire them instead:** the schema already provides the correct home for
non-exam-shaped practice content, and AP Physics already uses it for 112 items. The
CED fact pack §7 further specifies that hand-drawn work (category D) is tagged
supplemental and never presented as simulating the real exam — and the Product Owner
ruled on 2026-07-13 that hand-drawn graph practice **stays in scope**. Retiring
category D would contradict that ruling.

The 68 split into two populations with very different costs:

| Population | Items | Blocked? | Cost |
| --- | ---: | --- | --- |
| Not published (draft / approved / assigned / dead) | 20 | No | One UPDATE |
| Published | 48 | **Yes** — §3.4 | Unpublish → re-review → re-publish, ×48 |

Three ways to handle the 48. **They are not equivalent and this is a decision, not an
implementation detail.**

- **2a — Backfill the 20 only.** Leave the 48 as `NULL`. Cheap, unblocked, zero risk.
  But it leaves 48 published items unservable (§2.4), so it does not fix the actual
  bug. Reasonable as an interim step, not as an endpoint.
- **2b — Full cycle for the 48.** Retire, reclassify, re-approve, re-publish each.
  Honors the pipeline exactly as designed. Costs 48 review approvals from a reviewer
  who is already the G0A bottleneck, and routes 48 items through a pipeline with an
  open publication-trust P0.
- **2c — Narrow the trigger, then backfill (author's recommendation).** Amend
  `prevent_live_frq_reclassification` to permit the transition when
  `old.practice_format IS NULL`. The trigger's purpose is to stop a live item being
  *re*-classified from one format to another; these items were never classified at
  all. Backfilling a NULL is not reclassification, and treating it as such is
  arguably a defect in the trigger rather than a rule being worked around. After the
  amendment, all 68 update in one statement.

**2c requires its own review** — it is a schema change to a guard, and guards exist
for reasons. The narrow form (`old.practice_format IS NULL` only) preserves the
trigger's protection against every genuine reclassification, including
`targeted_drill` → `full_exam_frq`, which is the transition that actually matters for
exam integrity. A reviewer should confirm that reading before it is adopted.

**Explicitly not done in any variant:** no `frq_archetype` is assigned to any existing
item. The constraint `content_items_full_exam_archetype_check` requires
`practice_format='full_exam_frq'` ⟹ `frq_form='long'` **and** a non-empty
`frq_archetype`. Nothing in the bank is exam-shaped, so no item qualifies. **The
instruction to "apply the four-type labeling to the entire pool" is therefore not
executable against current content, and this plan does not pretend otherwise.**

**Explicitly not done:** no `frq_archetype` is assigned to any existing item. The
table constraint `content_items_full_exam_archetype_check` requires
`practice_format='full_exam_frq'` ⟹ `frq_form='long'` **and** a non-empty
`frq_archetype`. Since nothing in the bank is exam-shaped, no item qualifies.
Archetype labels become assignable only when rebuilt content exists. **The instruction
to "apply the four-type labeling to the entire pool" is therefore not executable
against current content, and this plan does not pretend otherwise.**

### Phase 3 — Hand off to the rebuild (no database writes)

1. Report the resulting counts (§6).
2. Record that consolidation — merging several existing items onto one shared stimulus
   and adding the missing Practice 2 part — is the cheapest source of genuine 10-point
   items, since it reuses statistics the reviewer has already validated.
3. **Consolidation ceiling, stated as an optimistic upper bound, not a plan:**
   excluding hand-drawn items, existing content carries 197 criteria (90 + 92 + 15).
   At ~10 criteria per exam-shaped question that is **at most ~19 items**, against a
   70-FRQ target, and only where contexts can be unified — which they currently are
   not, since each item has its own stimulus. Realistic yield is materially lower.
   This number should not be used for planning without a sampling study.

---

## 6. Expected end state

**[Execution]** 2c was chosen and executed in full. Table below is the actual
end state, verified against Production 2026-08-01 (not a projection).

| | Before | After (executed) |
| --- | ---: | ---: |
| FRQs, total | 158 | 158 |
| FRQs, published | 67 | 48 |
| FRQs, retired | ~~15~~ **7** | ~~91~~ **94** |
| FRQs tagged `targeted_drill` | 0 | 68 |
| **FRQs actually servable by the app** (§2.4) | **0** | **48** |
| FRQs tagged `full_exam_frq` | 0 | 0 |
| FRQs carrying a Q1–Q4 archetype | 0 | 0 |
| MCQs, published | 16 | 16 (untouched) |

**[R3 — Opus validation]** Both the projection and the post-execution figure were
wrong. The verified count is **94**, and the "Before" figure was **7**, not 15.

The pre-execution baseline of 15 was *retired plus reviewed_disapproved* combined;
true pre-existing `status='retired'` was **7** (3 category A, 1 category B, 3
category D). All 90 category-A items are now retired, of which 3 already were, so
Phase 1 changed 87 rows. Adding the 4 pre-existing retired items outside category A
gives **90 + 4 = 94**.

The post-execution note above identified only `APSTATS-SFRQ-018` as pre-existing
retired and missed the 3 retired hand-drawn items. Both the original projection (105)
and the execution-time correction (91) are superseded by 94. The **data is correct** —
only these two documents were wrong.

### Counts by category after the plan

| Category | Disposition | Items | Published after |
| --- | --- | ---: | ---: |
| A. One-point short answer | retired | 90 | 0 |
| B. Four-point multi-part | `targeted_drill` | 23 | 15 |
| C. Undersized long | `targeted_drill` | 5 | 1 |
| D. Hand-drawn graph | `targeted_drill` | 40 | 32 |

---

## 7. What I may have wrong — challenge these

**[R2] Resolved by the independent review — no longer open:**

- ~~Item 2 (classification is structural, not semantic).~~ The reviewer read all 19
  published category-A stems and criteria in full. They are genuinely uniform — blank
  stimulus, one fact or one computation, no scaffolding — spanning different cognitive
  demands but identical structural shape. No hidden good item that Phase 1 would
  wrongly kill.
- ~~Item 3 (do the 19 published items connect to anything live?).~~ Traced through
  `attempts`, `response_versions`, `grading_results`. Only synthetic test-account
  records found. Carried into Phase 1 as an audit note. **Partially resolved only:**
  this check covers *runtime attempt data*. It does not cover a `content_key`
  hardcoded in frontend code or an edge function, which would appear in neither table.
  That narrower check remains outstanding.
- ~~Item 7 (`targeted_drill` semantics assumed, not verified).~~ Now fully resolved,
  and the answer was worse than assumed — see §2.4. The field is not ignored by the
  app; it is the sole selector, and NULL makes items invisible.

**Still open, most-likely-to-matter first:**

1. **The 10-point premise (§3.1).** If a 4-point multi-part item counts as an
   acceptable compact Q2 for *practice* purposes — as distinct from exam simulation —
   then category B is not misaligned at all and the framing is too strict. This is the
   single biggest thing to disagree with.
2. **The classification is structural, not semantic.** Items were binned by point
   total and criterion count. **No item was read in full.** An item with 4 rich
   criteria that genuinely constitutes a good compact question is binned identically
   to a weak one. Before Phase 1 executes, a sample of category A should be read to
   confirm the 90 are as uniform as the structure implies.
3. **I did not check what references the 19 published category-A items.** If the
   homepage demo FRQ, the free-score-check funnel, or any seeded session references a
   specific `content_key` among them, retiring breaks that surface. **This is a
   required pre-execution check and it has not been done.**
4. **The removed-topic sweep (§2.3) is regex-based** and both over- and under-
   inclusive. An earlier version of it wrongly flagged retained residual-plot curvature
   as out of scope; that was corrected, but other false positives and negatives are
   likely. Those 19 items are context here, not part of this plan, but should not be
   acted on from the regex alone.
5. **The consolidation ceiling is optimistic arithmetic**, not a feasibility study. It
   assumes criteria are freely recombinable across items that currently share no
   context.
6. **Option 4 may simply be better.** If the rebuild is close, doing this cleanup now
   is duplicated work. The counter-argument is that the rebuild is gated on a sign-off
   that has not been requested yet, so "close" is not evidenced.
7. **[R2] Whether amending `prevent_live_frq_reclassification` (option 2c) is
   legitimate or is rule-bending.** Resolved by owner decision, not by further
   analysis — David Bloom chose 2c on 2026-08-01 with the narrow-carve-out reading
   stated above. See §11.
8. ~~[R2] Whether any `content_key` among the 90 is hardcoded in application code.~~
   **[Execution] Resolved 2026-08-01.** Grepped `.worktrees/*` (frontend checkouts)
   and `supabase/functions/` for all 90 keys. Every hit is either a frozen research
   JSON snapshot (bootstrap corpus, verification profile, gold-set candidates,
   frozen-arm manifests — point-in-time records, unaffected by a later status change)
   or one unrelated test fixture (`reviewer-queue-filters.test.ts` uses
   `STATS-MOD1-E001` as an arbitrary distinguishing string in a mock object; the test
   never queries the database). No hardcoded reference in live app or edge-function
   code.
9. ~~[R2] Whether other surfaces read published FRQs outside `select_practice_frqs`.~~
   **[Execution] Resolved 2026-08-01.** `free-score-check` (edge function + frontend
   route) is the one surface found reading `content_items`/`content_item_versions`
   directly — but it is hardcoded to `subject_key: "biology"` in three places
   (including the exported PDF filename), so it cannot reach an AP Statistics row.
   `use-published-mcq.ts` filters `content_items.item_type = 'mcq'` explicitly and
   structurally cannot read FRQ rows. Remaining direct reads (`dashboard.functions.ts`,
   `review.functions.ts`) are admin/reviewer-portal surfaces, not student
   content-selection. §2.4's premise — that a NULL-`practice_format` item was never
   served under an implied format — holds for AP Statistics specifically.
10. **[Execution] A second boundary case beyond `GRAPH-005`.** Re-deriving the "48
    published" population precisely turned up `APSTATS-SFRQ-018` (status `retired`,
    category B) also carrying a `content_item_versions` row with `status='published'`
    from before it was retired — so it trips the same guard as the 48 currently-live
    items despite not being currently published. Corrected count: the clean,
    no-guard-interaction population for 2a is **18**, not 20; the population needing
    2b/2c is **50** (48 published + `GRAPH-005` + `SFRQ-018`), not 48. Neither R1 nor
    R2 caught this — it only surfaces if you check `content_item_versions.status`
    directly rather than trust `content_items.status`.

---

## 8. Out of scope for this plan

Recorded so the reviewer does not assume they were forgotten. Each is a separate
decision in the triage document:

- The 9-unit → 5-unit taxonomy fix in the frontend repo, and the remap of 200 item
  labels, the Unit 1–9 label definitions, and 19 review decisions.
- Disposition of the 19 removed-topic items (2 published, 3 approved).
- Regeneration of the 5 defective mosaic items and the task rewrite on all 7.
- Publishing any of the ~94 MCQs sitting in draft/approved.
- Adopting the four archetype slugs and the Q3/Q4 practice-span validator. **[R2]
  Prerequisite discovered during review, and a live landmine:**
  `app.validate_full_exam_frq_version` returns immediately without validating anything
  unless `exam_code` is one of the four AP Physics codes. Statistics is not in that
  list, so today a Statistics item published as `full_exam_frq` receives **no shape
  validation at all** — silent, and nothing checks it. Worse, if someone later adds
  Statistics to the `exam_code` allow-list *without* also adding `case` branches for
  the Statistics archetype slugs, the `else` branch raises
  `full_exam_frq_invalid_archetype` on **every** publish attempt, hard-blocking the
  rebuild at the worst possible moment. Whoever implements the archetype slugs must
  extend this function in the same change. Note also that the Physics contract expects
  a specific `prompt_json` payload shape (`part_key` matching `^part-[a-d]$`,
  criterion keys `part-X-criterion-%`); a Statistics analog needs the equivalent
  defined, and all four Statistics archetypes are 10 points, unlike Physics's
  10/12/10/8.
- Getting the CED fact pack in front of the reviewer for G0A sign-off — which the
  triage document argues is the highest-leverage action available and is not this
  plan.

---

## 9. Reproducing the numbers

Every figure above comes from these queries against `pcntajvbdfqhbeewmdry`. A reviewer
should re-run them rather than trust the tables.

**Category classification and counts:**

```sql
with latest as (
  select ci.id, ci.content_key, ci.status,
         (select v.id from public.content_item_versions v
          where v.content_item_id=ci.id order by v.version_num desc limit 1) as vid
  from public.content_items ci
  where ci.item_type='frq'
    and split_part(ci.content_key,'-',1) in ('APSTAT','APSTATS','STATS')
), agg as (
  select l.content_key, l.status,
         count(fc.id) as n_crit, coalesce(sum(fc.points_possible),0) as pts,
         (l.content_key like 'APSTATS-HDG-%') as is_hdg
  from latest l
  left join public.frq_criteria fc on fc.content_item_version_id = l.vid
  group by 1,2,5
)
select case when is_hdg then 'D. Hand-drawn graph drill (4pt)'
            when pts=1 then 'A. One-point short answer'
            when pts=4 and n_crit=4 then 'B. Four-point multi-part'
            else 'C. Undersized long FRQ (2-5pt)' end as category,
       count(*) as items,
       count(*) filter (where status='published') as published,
       sum(n_crit) as criteria
from agg group by 1 order by 1;
```

**Confirming no item reaches 10 points:**

```sql
select max(pts) from ( /* the `agg` CTE above */ ) t;
```

**Unit-label exposure:**

```sql
select cl.label_name, ci.item_type, count(*) as items,
       count(*) filter (where ci.status='published') as published
from public.content_item_labels cil
join public.content_labels cl on cl.id = cil.content_label_id
join public.content_items ci on ci.id = cil.content_item_id
where cl.label_type='unit' and cl.label_name like 'AP Statistics%'
group by 1,2 order by 1,2;
```

**Relevant schema constraints** (`app.content_items`):

```
content_items_frq_form_check:
  CHECK (frq_form = ANY (ARRAY['short','long']))
content_items_practice_format_check:
  CHECK (practice_format IS NULL
         OR (item_type='frq' AND practice_format = ANY (ARRAY['targeted_drill','full_exam_frq'])))
content_items_full_exam_archetype_check:
  CHECK (practice_format <> 'full_exam_frq'
         OR (frq_form='long' AND frq_archetype IS NOT NULL AND btrim(frq_archetype) <> ''))
content_items_status_check:
  CHECK (status = ANY (ARRAY['draft','assigned','changes_requested',
                             'reviewed_approved','reviewed_disapproved','published','retired']))
```

---

## 10. Execution controls (for whenever this is approved)

Not performed. Recorded so the plan is complete.

- Delivered as a migration under `supabase/migrations/`, not as ad-hoc SQL, so the
  change is versioned and reviewable — relevant given the open publication-trust
  defect (admin-content publishes before validating gates).
- Selection by rule, not by a pasted list of 90 keys, so the migration is auditable
  and re-derivable.
- Rollback: a single `UPDATE … SET status='published'` over the affected keys, and
  `practice_format = NULL` for Phase 2. Capture the pre-change `content_key`/`status`
  pairs into a scratch table or the migration comment first.
- **[R2]** Pre-execution checks still outstanding: §7 items 8 and 9 (hardcoded
  `content_key` references in application source; other read paths bypassing
  `select_practice_frqs`). §7 items 2, 3, and 7 were closed by the independent review.
- **[R2]** Phase 2 cannot be written as a migration at all until the §3.4 blocker is
  resolved by choosing 2a, 2b, or 2c. A migration attempting the original one-line
  UPDATE against published items will abort with
  `published_frq_reclassification_requires_retirement`.

---

## 11. Execution record (2026-08-01)

Executed by Claude (Sonnet) against Production `pcntajvbdfqhbeewmdry`, as four
tracked migrations, in this order. Each was verified against actual row counts
before the next was written.

**Pre-execution:** closed §7 items 8 and 9 (source-code hardcoding, RLS-bypass
surfaces) — both clean, see above. Discovered the `SFRQ-018` boundary case (item
10) while re-deriving the exact population for each migration's WHERE clause.

1. **`retire_ap_statistics_single_criterion_frqs`** — Phase 1. Rule-based (exactly
   one `frq_criteria` row, non-HDG). 90 rows → `status='retired'`. Verified: 90/90,
   no other status touched.
2. **`backfill_practice_format_unpublished_stats_drills`** — Phase 2a. Rule-based
   (category B/C/D by point-total/criterion-count; `status <> 'published'`; no
   `content_item_versions` row with `status='published'`). 18 rows →
   `practice_format='targeted_drill'`. Verified: 18/18.
3. **`scope_reclassification_guard_null_practice_format_backfill`** — the 2c trigger
   amendment. `CREATE OR REPLACE FUNCTION app.prevent_live_frq_reclassification()`,
   adding exactly the carve-out specified in review: skip the raise when
   `old.practice_format IS NULL AND new.frq_archetype IS NOT DISTINCT FROM
   old.frq_archetype AND new.frq_form IS NOT DISTINCT FROM old.frq_form`. Every other
   path through the function — including any `frq_archetype` or `frq_form` change,
   on any item, regardless of `practice_format` — raises exactly as before.
4. **`backfill_practice_format_remaining_stats_drills`** — Phase 2, the 50 items §3.4
   blocked. Same category rule as migration 2, this time against all remaining
   `practice_format IS NULL` category B/C/D rows (48 published + `GRAPH-005` +
   `SFRQ-018`). 50 rows → `practice_format='targeted_drill'`. Verified: 50/50, and
   confirmed no item unintentionally in scope (the 90 Phase-1 retirements and any
   other category-A row are excluded by the same category rule).

**Decision point:** the choice between 2a / 2b / 2c (§7 item 7, "the single largest
judgment call in the plan") was put to David Bloom explicitly rather than decided by
the executing model. He chose **2c**.

**Final verified state** (query re-run post-execution): 158 total FRQs unchanged; 90
retired via Phase 1 plus 1 pre-existing (`SFRQ-018`) = 91 retired; 68 tagged
`targeted_drill`; 48 published, **all 48 now servable** through
`select_practice_frqs` (0 were servable before); 0 tagged `full_exam_frq`; 0 carrying
a Q1–Q4 archetype (correctly — no rebuilt content exists yet to justify one). Matches
§6 exactly.

> **[R3 — Opus validation, 2026-08-01] Correction to the two sentences above.**
> The retired total is **94, not 91**, and it does **not** match §6 — because §6 was
> itself wrong. Independently re-queried post-execution:
>
> | Category | Retired now | `practice_format` |
> | --- | ---: | --- |
> | A (one-point) | 90 | NULL |
> | B (four-point) | 1 | `targeted_drill` |
> | D (hand-drawn) | 3 | `targeted_drill` |
> | **Total** | **94** | |
>
> The §11 arithmetic counted only `SFRQ-018` as pre-existing-retired. There were
> **seven** pre-existing retired FRQs (3 in category A, 1 in B, 3 in D), so Phase 1
> changed 87 rows' status while correctly matching all 90 — an `UPDATE … SET
> status='retired'` over a 90-row rule reports 90 whether or not 3 were already
> retired, which is why the migration's own "90/90" check did not surface this.
>
> §6's predicted "15 → 105" was an **error in the original plan, authored by Opus,
> not introduced by the executing model**: it used 15 (retired *plus*
> reviewed_disapproved) as the pre-state baseline when true pre-existing `retired`
> was 7. The correct prediction was 94, which is exactly what happened. **The
> database is right; two documents were wrong.** No remediation to data is needed.

> **[R3] Outstanding: the four migrations are not in the repository.**
> All four are recorded in Production's `supabase_migrations.schema_migrations`
> ledger (`20260802014841`, `…014901`, `…015030`, `…015050`), but
> `supabase/migrations/` contains no corresponding files and `git status` shows none
> added. §10 of this plan specified delivery "as a migration under
> `supabase/migrations/`, not as ad-hoc SQL, so the change is versioned and
> reviewable," and project governance treats GitHub as the source of truth.
>
> This matters most for migration 3, the trigger amendment. Production's
> `app.prevent_live_frq_reclassification` now carries a carve-out that the repo
> baseline `20260731160000_schema_baseline.sql` does not — verified: the baseline
> references the function but contains no `practice_format is null` branch. Anyone
> diffing repo against Production, regenerating a baseline, or reconciling the repo
> forward could silently revert the carve-out and re-block the backfill path.
>
> **Fix:** commit the four migration files to `supabase/migrations/` with the same
> version stamps as the ledger, so repo and Production agree. This document and the
> triage document are also still untracked and should be committed with them.

**Not executed, and deliberately so:**

- No `frq_archetype` was assigned to anything (§5, "explicitly not done" — still
  true; nothing in the bank is exam-shaped).
- The two published/approved out-of-scope items, the 5 defective mosaic items, the
  9→5 unit taxonomy remap, and everything else in §8 remain untouched. This
  execution was Phase 1 + Phase 2 of *this* plan only.
- Phase 3 (consolidation into real 10-point FRQs) is unchanged from a plan into
  action — no items were consolidated or authored.

**What this execution does not resolve:** the subject still has zero exam-shaped
(`full_exam_frq`) content and zero items tested against the four archetypes. It makes
48 already-published items reachable by the app and removes 90 items that were
neither exam-shaped nor useful drills. It is real progress on Jill's finding 3 and on
the §2.4 servability bug, not a substitute for the rebuild.
