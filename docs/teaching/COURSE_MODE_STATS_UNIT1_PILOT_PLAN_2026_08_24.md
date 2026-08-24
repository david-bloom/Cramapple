# Course Mode — AP Statistics Unit 1 Pilot Plan

STATUS: plan (PLAN, not execute) | DATE: 2026-08-24 | AUDIENCE: David (decision-maker) + the next session (LLM-first).

This is the launch plan for **going live with Course Mode**, using **AP Statistics Unit 1
("Exploring One-Variable Data & Collecting Data") as the pilot unit**. It names every gate,
who owns it, and the exact pilot content scope. It **executes nothing** — no content is
authored, no migration is applied, no switch is flipped by the act of writing this doc.

Companion docs (read for context, not duplicated here):
- `COURSE_MODE_RELEASE_PATH_DECISION_BRIEF.md` — the generic "merged hook → student sees a
  graded cell update" path and its gates (D8, CM-D19, security, serving form).
- `COURSE_MODE_STATUS_AND_HANDOFF.md` — the living state map.
- `COURSE_MODE_PILOT_BUILD_PLAN.md` — the D-number build stages.
- `COURSE_MODE_LEARNING_MODEL.md` — decisions/invariants (CM-D##).

---

## 0. Decisions already taken (David, 2026-08-24)

1. **Pilot scope: a credible subset (~8–12 cells)** of AP Statistics Unit 1 — enough that a
   student gets a real practice experience across the unit's core skills, not just a loop demo.
2. **Dev-first, then Prod** — prove the whole Course Mode loop on Dev with Unit 1 (as was done
   for the single Unit-5 `lsrl_predict` template), then promote to Prod once solid.
3. **The Course Mode student front-end is NOT built yet** — the Unit-5 proof ran a locally-run
   front-end pointed at Dev. There is no shipped Course Mode *student* experience today.

Decision (3) is the load-bearing one: it means there are **two parallel critical paths**, and
the front-end is the longer pole. Content can be fully authored and released on Dev and still
show a student nothing until the Lovable Course Mode UX exists.

---

## 1. Live state snapshot — verified against Production `pcntajvbdfqhbeewmdry`, 2026-08-24

Read directly from the live DB this session (not inferred from the migration ledger):

| Fact | Verified value | Implication |
|---|---|---|
| AP Statistics exam-pack versions | `548f06be…` (`2026`, **published**, 296 items / 193 published) and `7c5a2975…` (`2026-27`, **draft**, the 3 Unit-5 `lsrl` items) | The Course-Mode pack (`7c5a2975`) is the draft `2026-27` one; the classic 296-item pack is separate. |
| `home_release_manifest` rows | 10 (one per live subject). AP Statistics row is on the **classic** pack `548f06be`, `quick_start_enabled=true`, `allowed_units={1,2,3,4,5}` | The manifest that exists is for the classic direct-read path, **not** the Course-Mode pack. |
| `home_release_manifest` for `7c5a2975` (Course-Mode pack) | **none** | Course Mode pack is not wired to serve. |
| Stats Unit 1 taxonomy cells | **28** (topics 1.1–1.13) | See §3 for the full cell map. |
| Stats Unit 1 cells with Course-Mode content | **0 of 28** | The pilot's content is authored from zero. |
| CM-D19 template releases (all subjects) | **1** — `lsrl_predict` (Unit 5) only | No Unit-1 template released anywhere. |
| The 3 released Unit-5 items on Prod | `status=published`, `review_status=question_review_approved`, but **`rubric_type=null`** and **no serving taxonomy label** | Even the one released template can't serve/grade correctly on Prod yet (see §5, §6). |
| Validated serving taxonomy labels, all subjects | **8 total** — the 8 Orly Calc AB/BC items | The human-validation lane has essentially never been run at scale (see §6). |

---

## 2. The two critical paths

**Path A — Backend / content (LLM-drivable on Dev; Prod steps held for David).**
Author → property-test → SME review → CM-D19 release → wire serving on Dev → prove the loop →
promote to Prod. Every Dev step is reversible and learner-invisible until released.

**Path B — Front-end / Course Mode student UX (Lovable; needs David).**
The unit view, the cell/tier mastery display, and the practice → grade → mastery-update loop UI.
Nothing student-facing exists. **This is the gating pole for "go live"** — Path A can finish and
students still see nothing without it. Recommend kicking this off in parallel immediately.

---

## 3. AP Statistics Unit 1 — full 28-cell map (taxonomy verified on Prod)

Topic 1.1–1.9 = "Exploring One-Variable Data"; 1.10–1.13 = "Collecting Data". Skill codes:
1.x/2.x = conceptual (identify/describe data & design), 3.A = construct graphs/tables,
3.B = calculate summary statistics, 4.x = interpret/compare/justify.

- 1.1 Introducing Statistics — 1.A, 2.A
- 1.2 Variables — 2.A
- 1.3 Tabular Rep & Summary Stats, one categorical — 3.A, 4.A
- 1.4 Graphical Rep, one categorical — 3.A, 4.A, 4.B
- 1.5 Graphical Rep, one quantitative — 3.A
- 1.6 Describing a quantitative distribution — 4.A, 4.B
- 1.7 Summary Statistics, one quantitative — **3.B**, 4.A, 4.B
- 1.8 Graphical Rep of Summary Stats — 3.A, 4.A
- 1.9 Comparing distributions — **3.B**, 4.A, 4.B, 4.C
- 1.10 Investigative Question & Data Collection — 1.A, 2.A, 2.B
- 1.11 Random Sampling — 2.A, 2.B
- 1.12 Problems with Sampling — 2.A
- 1.13 Experimental Design — 2.A, 2.B

Only two cells are computational (3.B: 1.7×3.B, 1.9×3.B). The rest are conceptual/graphical/
interpretive — best served as **MCQ (choice-match grading)** for a reliable pilot.

---

## 4. Proposed pilot cell set (~10 of 28) — for David's approval

Chosen for (a) spread across the unit and (b) grading paths that already work. Skill-4
free-response cells that would need the R&D-tier LLM grader are deliberately excluded; where a
skill-4 idea is included it is served as MCQ (interpret-and-pick), not open FRQ.

| # | Cell | Topic | Skill | Serving / grading | Notes |
|---|---|---|---|---|---|
| 1 | 1.7×3.B | Summary Statistics (quant) | calculate | numeric-entry / deterministic | Draft template `summary_stats` exists |
| 2 | 1.9×3.B | Comparing distributions | calculate | numeric-entry / deterministic | Computational comparison |
| 3 | 1.2×2.A | Variables | identify | MCQ | Categorical vs quantitative |
| 4 | 1.5×3.A | Graphs for a quant variable | represent | MCQ | Read/choose histogram/dotplot/stemplot |
| 5 | 1.6×4.A | Describe a distribution | interpret | MCQ | Shape / center / spread / outliers |
| 6 | 1.8×3.A | Boxplots | represent | MCQ | Five-number summary → boxplot |
| 7 | 1.11×2.A | Random sampling | describe | MCQ | SRS / stratified / cluster / systematic |
| 8 | 1.12×2.A | Problems with sampling | describe | MCQ | Bias types |
| 9 | 1.13×2.A | Experimental design | describe | MCQ | Confounding / control / randomization |
| 10 | 1.9×4.B | Comparing distributions | justify | MCQ | Draft slot-frame exists |

Two computational + eight MCQ — a credible Unit 1 experience with only proven grading paths.
Swap-in candidates if David wants different coverage: 1.3×4.A (categorical proportions),
1.7×4.A (interpret summary stats), 1.11×2.B, 1.13×2.B.

---

## 5. Grading correctness gate

- **`rubric_type='mcq'` fix.** MCQ items must carry `rubric_type='mcq'` so the grading router
  picks the choice-match path, not the numeric verifier (which abstains on a choice answer →
  `content_uncertain` → no mastery evidence). Proven on Dev for Unit 5; **unapplied on Prod**
  (the 3 released items still show `rubric_type=null`). The pilot's MCQ generator output must
  set this at authoring time, and the fix must be applied wherever MCQ items are served.
- **Numeric-entry items** (1.7×3.B, 1.9×3.B) grade via `content_item_checks` (deterministic),
  the path already proven by `lsrl_predict`.

---

## 6. Serving-path question to resolve FIRST (before scaling authoring)

Two serving paths exist and they impose different requirements — this must be settled in
Phase 1, because it determines whether the validated-label pipeline is even on the critical path:

- **Unit-gated selector `select_unit_gated_practice_items`** — serves only items with a
  `label_scope='serving'`, `label_status='validated'` taxonomy label (+ taxo-hash match +
  `max_required_unit` gate). Today **zero** Stats items (and only 8 items product-wide) are
  validated, and even the released Unit-5 items have **no serving label at all** — so this path
  currently serves nothing for Stats.
- **Direct RLS read (`usePublishedMcqs`-style)** — serves published items in the active pack,
  needs only cell tags, **no validated label**. This is what the live classic experience uses,
  and what the Unit-5 Dev proof used.

**Action:** confirm which path the Course Mode student front-end will call. If direct-read, the
validated-label lane is *not* a launch blocker (only cell-tagging + publish are). If the
unit-gated selector, then CM-D19 release must reliably stamp a `validated` serving label, and we
must fix why the released Unit-5 items lack one. **Recommendation:** resolve this before Phase 1
authoring so we don't build toward a validation requirement the serving path may not use.

---

## 7. Phased plan

**Phase 0 — Decisions & unblock (David):**
- SME sign-off on the Unit 1 CED fact-pack (currently deferred; gates bulk authoring).
- Approve/adjust the §4 cell set.
- Kick off the Lovable Course Mode student UX (Path B — the long pole).

**Phase 1 — Content on Dev (LLM):**
- Resolve the §6 serving-path question.
- Per pilot cell: author a generator template → property-test (≥100 instances / 0 rejects) →
  David's D8 SME 20-instance review → `cm_d19_release_template(...)` → items land published,
  cell-tagged, and (per §6 outcome) serving-labeled. Start with 1.7×3.B (draft exists) as the
  reference pattern, then fan out.

**Phase 2 — Serving on Dev (LLM; David's go):**
- Apply `rubric_type='mcq'` to MCQ items; deploy `evaluate-attempt` hook to Dev (if not current);
  add `1` to the Course-Mode pack's `home_release_manifest.allowed_unit_numbers`; publish the
  Dev Course-Mode pack; point a test student's `active_exam_pack_version_id` at it.

**Phase 3 — Prove the loop on Dev (LLM + David):**
- David answers pilot items in the (new) front-end; verify serve → grade → `student_cell_state`
  promotion across all pilot cells and both grading paths. The Unit-5 proof, widened to a real unit.

**Phase 4 — Promote to Prod (David's go):**
- Same switches on Prod: publish `7c5a2975`, manifest row with the pilot units, deploy the hook
  (CLI/human), set entitlements. Held for explicit go; Prod untouched until then.

---

## 8. What is held for David / needs a human (not LLM-executable here)

- Every **Prod** switch (pack publish, manifest, active-epv, entitlement).
- The **`evaluate-attempt` hook deploy** (CLI-only; the MCP path cannot ship the ~287KB function).
- **SME attestations** (Unit 1 fact-pack sign-off; the D8 20-instance reviews).
- The **Lovable front-end** build (Path B).

## 9. Open items carried forward

- §6 serving-path resolution (blocks nothing in Phase 0, but gates Phase 1 scale).
- Why the released Unit-5 items lack a serving label on Prod — bug in CM-D19 stamping, or a
  separate step never run? Answer informs whether Unit 1 releases will serve.
- Prod `rubric_type='mcq'` fix (and folding it into the generator for all future MCQ items).
