# Draft-content QA, assignment, and full survey — 2026-08-09

**Trigger:** Owner directed: QA the 30 physics FRQs sitting in draft (identified in the
prior turn), then assign them to Muhammad Saood; then assess every other question still
in draft status and report the situation.

## 1. The 30 physics FRQs — QA'd, repaired, assigned

**Identity:** `apphy2-frq-049..058`, `apphycem-frq-049..058`, `apphycm-frq-049..058` — the
second half of a 60-item batch orphaned by a 2026-08-08 withdrawal bug (see
`docs/activity_log/ACTIVITY_LOG.md`, "Ghazanfar Withdrawal Orphan Bug Found and Fixed").
The other half (`*-frq-039..048`) was assigned to Ahmed Ali that same day; these 30 were
deliberately left as "clean draft items available for future assignment."

**§9 independent re-derivation (3 parallel agents, one per subject):**

| Subject | n | Clean | Defects |
|---|---:|---:|---:|
| AP Physics 2 | 10 | 10 | 0 |
| AP Physics C: E&M | 10 | 10 | 0 |
| AP Physics C: Mechanics | 10 | 7 | 3 |

**The 3 Mechanics defects share one root cause:** `apphycm-frq-052/054/056` each have a
stem part (a) that says "design a feasible procedure ... identifying the independent
variable, the dependent variable, and one control variable" — but the stored rubric only
graded the three variable identifications, never the procedure itself. A student could
earn full marks on part (a) without describing any actual measurement method.

**Fixed** (edit-in-place, not a new version — these are unreviewed drafts with no decision
on record to preserve, so the "never edit reviewed content" discipline doesn't apply):
added a 4th `a-procedure` criterion to each (1 point), grading the specific measurement
method each experiment actually needs (timing terminal fall speed via photogate/video;
stopwatch-timed stair climb; photogate-measured block speed at spring's natural length),
and updated `prompt_json.total_points` to match (052/054: 4→5; 056: 6→7).

**Assigned:** all 30 to Muhammad Saood (`review_stage='tutor_question'`,
`assignment_purpose='subject_review'`). `content_items.status` moved from `draft` to
`assigned`. Combined with his existing physics queue, his `-np1-` batch review, and
whatever else is outstanding, this adds 30 new items to his plate.

Script: `scripts/content-seed/reviewer-qa-remediation/20260809_physics_draft_frq_qa_and_assign.sql`.

## 2. Full draft-status survey — everything else

After the above, exactly **71 items remain at `status='draft'`**, across two subjects,
neither touched by today's work:

### AP Calculus AB — 23 items (8 FRQ, 15 MCQ)

`apcalcab-frq-029..036`, `apcalcab-mcq-036..050`. All created 2026-07-28, structurally
complete (each FRQ has 9 criteria summing to 9 points per the AB CED's fixed FRQ
structure; each MCQ has 4 choices/1 correct).

**Origin:** the validated "2026-07-27 AP Calculus AB Content Batch"
(`docs/research/AP_CALCULUS_AB_CONTENT_BATCH_2026_07_27.md`) — 30 MCQ + 20 FRQ, generated
against the verified CED fact pack, checked by a deterministic structural verifier and an
independent calculation regression suite (`scripts/calculus-ab-content-2026-07-27/`)
before insertion. The load script
(`scripts/calculus-ab-content-2026-07-27/load-production-drafts.sql`) explicitly loaded
the whole batch as **"unassigned Production drafts"** by design — most of the batch has
since moved through review/publish (seen this session as `apcalcab-frq-u13-*` and other
already-published/`-np2-` items elsewhere in the corpus), but these 23 were never picked
up for assignment.

**Situation:** not stuck, not defective as far as the batch's own pre-insertion
verification goes — just never entered the review queue. No §9 independent re-derivation
has been run on this specific subset yet (the batch doc's own math-regression suite is a
different, narrower check). **Needs an assignment decision, and ideally a §9 pass first**
if the same QA-before-assign bar from today's physics batch is meant to apply going
forward.

### AP Statistics — 48 items (47 MCQ, 1 FRQ)

`APSTATS-MCQ-010-CAL`, `APSTATS-MCQ-016-CAL`, and 45 more (`APSTATS-MCQ-037` through
`-100`, non-sequential — the gaps are numbers that already moved through review/publish),
plus `APSTAT-MOD7-H002-INV` (FRQ). All created **2026-07-11 — the oldest stale draft
content found this session, ~29 days old.** Structurally complete (4 choices/1 correct
each for the MCQs; 4 criteria for the FRQ).

**Origin:** tagged `phase_c_publish_packet: 2026-07-11` in `prompt_json`. Several carry a
`collision_resolution: renamed_with_cal_suffix_to_avoid_published_smoke_batch_collision`
note (e.g. `APSTATS-MCQ-010-CAL`'s `source_content_key` is `APSTATS-MCQ-010`, which was
already taken by an earlier "smoke batch" item) — confirming these are leftover, never-
promoted duplicates/originals from a batch whose other members already went through
review and publish (that's why the numbering has gaps: most of `APSTATS-MCQ-001` through
`-100` is already elsewhere in the pipeline; only this subset stalled).

**Situation:** same as Calc AB — structurally fine, never assigned, no evidence of a
content defect holding them back, just an old batch that was never fully worked through.
**Needs an assignment decision, and a §9 pass**, same as Calc AB.

## 3. Summary table

| Subject | n | Age | Structural state | §9 QA status | Blocker |
|---|---:|---|---|---|---|
| AP Physics 2/C:E&M/C:Mechanics FRQ | 30 | 6 days | Clean | **Done today** (3 repaired) | None — assigned to Saood |
| AP Calculus AB FRQ+MCQ | 23 | 12 days | Clean | Not run | Needs assignment decision |
| AP Statistics MCQ+FRQ | 48 | 29 days | Clean | Not run | Needs assignment decision |

**Total draft backlog before today: 101 items. After today: 71**, both remaining batches
structurally sound and simply unassigned — no evidence either is being deliberately held
back for a content reason, in contrast to the physics batch's real (now-fixed) defect.
