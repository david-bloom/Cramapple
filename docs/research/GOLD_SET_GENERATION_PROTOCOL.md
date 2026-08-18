# Gold-set generation protocol — AI authoring, multi-model verification, reader certification

**Version 1.0 — 2026-08-03**
**Status:** Adopted (DECISION-0045). Pilot pre-registration:
[`GOLD_SET_PILOT_STATS_PHYSICS_2026_08_03.md`](GOLD_SET_PILOT_STATS_PHYSICS_2026_08_03.md)
**Reader-facing companion:** [`GOLD_SET_AUTHORING_GUIDE.md`](GOLD_SET_AUTHORING_GUIDE.md) v2.0
**Supersedes:** the all-human authoring model in `GOLD_SET_AUTHORING_GUIDE.md` v1.0

This document is the operational protocol: what happens, in what order, under whose
hand. The reader-facing guide explains the two jobs readers actually do. Where the two
disagree, this document governs the machine steps and the guide governs the reader steps.

---

## 1. Why this replaced all-human authoring

The v1.0 plan was 330 answers × (12 min write + 5 min verify) ≈ **94 hours of reader
time**, against a roster that is already the binding constraint on content review. It
would not have been finished.

The substitution is not "AI does the work." It is: **AI produces the corpus, and reader
attention moves off production and onto certifying the machine that produces it.** The
reader hours that remain are spent where reader judgement is irreplaceable and where the
error, if it happened, would be invisible.

The property that makes this worth doing is that reader cost **decouples from corpus
size**. The audit sample is sized by the confidence bound required, not by how many
answers exist. Going from 112 answers to 3,000 costs approximately nothing in reader
time — which is what makes the previously-descoped subjects affordable.

---

## 2. Set partition — what a gold set is a set *of*

A gold set is a regression suite for the grader. It must cover each distinct **code path
× rubric shape**, not each subject. Subject is a stratum inside a set, sized to catch
subject-specific breakage; it is not a set boundary.

Verified against Production `pcntajvbdfqhbeewmdry` on 2026-08-03 (published,
non-retired FRQ items carrying criteria):

| Set | Engine / evaluator | Criterion structure | Population | Status |
|---|---|---|---|---|
| **A** | 1 — `llm_discrete_text` | multi-point | Biology 36 items / 158 criteria; Chemistry 5 / 30; Calculus AB/BC 14 / 42 | Active, after Set B certifies |
| **B** | 1 — `llm_discrete_text` | single-point independent | Physics ×4 35 / 113; Statistics 15 / 60; Precalculus 11 / 66; Calculus AB/BC 59 / 465 | **Active — pilot** |
| **C** | 4 — `spatial` / `human_shadow` | single-point | Statistics 33 / 132 | Deferred until Engine 4 leaves shadow |
| — | 3 — formula/ECF/symbolic | — | **zero published items** | No set until content routes there |

**`[UPDATED 2026-08-04]`** Calculus AB/BC previously read "3 items, all
multi-point, too small to stratify — folds into Set A" (see the struck text
below). That was accurate against the population at the time; a same-day
content-review push took AB from 6 published items to 47 `reviewed_approved`
and BC from 2 to 34, and re-counting against the current population shows
Calculus is **92% single-point** (465 of 507 criteria across 59 items) —
structurally Set B, not Set A. A residual multi-point slice (14 items, 42
criteria) does belong to Set A. Calculus therefore needs its own subject
stratum inside **both** sets, sized independently — it does not inherit
certification from Statistics (Set B) or Biology/Chemistry (Set A) just
because it shares their rubric shape; §5's subject-effect rule requires each
subject's own sample. ~~Calculus AB/BC (3 items, all multi-point) is too small
to stratify; it folds into Set A.~~

Consequences worth stating plainly:

- **There is no per-subject gold set.** Physics and Statistics grade through identical
  code with identical rubric shape; separate sets would measure the same thing twice.
- **There is no math-vs-science split.** That axis cuts across the real one — chemistry
  stoichiometry and biology prose share a rubric type; Statistics spatial items do not.
- **Engine 3 gets no set yet — and the reason is structural, not a backlog item.** There
  is no `rubric_type` value that routes to it; the only values in the database are
  `discrete_text`, `mcq`, `spatial`, and NULL. It is reached solely through a hardcoded
  five-key map in `_shared/math-verifier.ts`, and none of those five items was ever
  published (three `reviewed_approved`-but-unpublished, one `reviewed_disapproved`, one
  still `assigned`; all from the retired 9-unit Statistics taxonomy). A gold set cannot
  be built for a path no response can reach. See `GRADING_PROGRAM.md` §1.
- Calculus AB/BC (3 items, all multi-point) is too small to stratify; it folds into Set A.

**Data-hygiene finding, out of scope here but logged:** 7 Biology and 1 Statistics
published FRQ items carry `rubric_type IS NULL` and `evaluator_strategy IS NULL`,
falling through to default routing. Their 30 criteria have no declared engine, so they
cannot be assigned to a set until the columns are backfilled.

---

## 3. The independence constraint

The grader under test is OpenAI — `gpt-4.1-mini` and `gpt-5.5` in
`supabase/functions/_shared/`. Everything below follows from that.

**R1 — No OpenAI model may write or verify gold-set answers.** If the writer shares a
family with the grader, A2 (full credit in unconventional phrasing) gets written in the
grader's own idiom and stops probing anything. A2 is the probe that caught the grader
awarding full marks to only 7 of 10 complete answers; losing it costs more than the
whole exercise saves.

**R2 — No verifier may share a model family with the writer of the answer it is
verifying.** Same-family writer and verifier read an answer the same wrong way, the
label encodes that reading as truth, and the set reports the grader as accurate
regardless of what the grader does.

**R3 — Verifiers are blind to the script, to the grader's output, and to each other.**
A verifier that has seen any of the three is disqualified for that answer.

**R4 — The writer never verifies its own output**, including self-check or
self-critique passes within the same call chain.

**R5 — Three non-OpenAI families are required.** Writer takes one; the remaining two
form the panel. With only two families, unanimity-of-two is unobtainable and the
automated path cannot exist.

**Model slate.** Anthropic (`claude-*`) and Google (`gemini-*`) are wired and confirmed
in `scripts/vercel-gateway-check/`. The third slot is Moonshot (`moonshotai/kimi-k2*`),
alternate DeepSeek — resolved empirically at Phase 0 step 0.2, not from memory. The
repo record shows the Kimi arms were **pre-registered and never run**; no schema
incompatibility finding is recorded anywhere, and the constraint that applied to
production grading (5-field verdict object under a 4–8 s criterion timeout) does not
obviously apply to a 3-field verification object running offline in batch.

---

## 4. The pipeline, in order

### Phase 0 — Preconditions. Nothing generates until all five pass.

| # | Step | Gate |
|---|---|---|
| 0.1 | Freeze the grader configuration under test — model IDs, prompt version, boundary contracts — and record the hashes. | The set is a regression suite *for a specific configuration*. Without this, later disagreement is unattributable. |
| 0.2 | **Model-slate conformance smoke test.** 20 verification calls per candidate family against the real verification schema. | ≥19/20 schema-valid after at most one repair retry. Third family confirmed, or DeepSeek substituted, or the protocol stops. |
| 0.3 | Freeze the item slice: published, non-retired, tutor-approved, carrying criteria and `canonical_answer_1`. Record `content_key` + `content_hash` per item. | An item edited mid-run silently invalidates every answer written against it. |
| 0.4 | Extract `canonical_answer_1` for each frozen item. | These become the **A1 seeds** — A1 is not generated, it is taken from the bank. |
| 0.5 | **Set A only:** element decomposition — AI drafts one breakdown per multi-point criterion; a reader confirms or corrects it. | Skipped entirely for Set B (single-point criteria have no breakdown). See §6. |

### Phase 1 — Generation

| # | Step | Rule |
|---|---|---|
| 1.1 | Write the **script** — which elements the answer will contain and which it will omit — in a call that produces no answer text. | Script is committed and hashed **before** any text exists. A script written after the fact is not a test, it is a description. |
| 1.2 | Write the **answer text** in a separate call, against the committed script. | Writer family rotates across answers per R2/R5, so no single family authors the corpus. Rotation is itself the A2 mechanism: different families phrase differently. |
| 1.3 | Produce the eight answer types per item (A1–A8) per the recipe in the reader guide §4. | A1 comes from 0.4, not from generation. A7 (error carried forward) is skipped where the item has no dependent parts; substitute a second A3-style answer. |
| 1.4 | No self-check pass. | R4. |

### Phase 2 — Machine verification

| # | Step | Rule |
|---|---|---|
| 2.1 | Two verifier families per answer, drawn from the families that did not write it. | R2, R5. |
| 2.2 | Each verifier marks, per criterion, which elements the answer actually satisfies, with an evidence quote. Present/absent only — **never a score, never points**. | A verifier that assigns points is doing the grader's job and contaminates the comparison. |
| 2.3 | Verifiers run independently: no shared context, no visibility of each other's output, no script, no grader output. | R3. |

### Phase 3 — Routing

Compare three independent judgements: the writer's script, verifier 1, verifier 2.

| Condition | Route |
|---|---|
| Script = V1 = V2 on every element | **Provisional accept** → Phase 4 audit pool |
| V1 = V2, both disagree with the script | **Discard and regenerate.** The writer failed to follow its own script — the known failure mode, measured at 5/10 in v1.0 testing. Regeneration is free; never argue the answer back in. |
| V1 ≠ V2 | **Reader queue.** Genuine ambiguity, which is itself a finding — log whether the criterion wording caused it. |

Track the discard rate. It is the headline health metric for the generator, and a rising
discard rate is the earliest signal that a writer model or prompt has drifted.

### Phase 4 — Reader certification

This is the load-bearing phase. Everything upstream is unverified machinery until it runs.

| # | Step | Rule |
|---|---|---|
| 4.1 | Readers verify answers **cold**: no script, no verifier output, no grader output, no indication of which route the answer took. | A reader who knows an answer was auto-accepted is no longer an independent check on auto-acceptance. |
| 4.2 | Readers mark elements present/absent with evidence, on exactly the terms in 2.2. | Identical task to the machine verifiers — that is what makes the comparison meaningful. |
| 4.3 | **Pilot:** readers verify **100%** of provisional accepts. **Production:** readers verify a random sample sized by the bound established in the pilot. | The pilot exists to measure the machine's error rate; you cannot measure it from a sample of itself. |
| 4.4 | Compute the false-accept rate of the automated path and its upper 95% bound. Check for a subject effect within the set. | See §5 for the gate. |

### Phase 5 — Freeze and measure

| # | Step |
|---|---|
| 5.1 | Freeze the set. Record item hashes, model IDs, prompt versions, and the certification bound. |
| 5.2 | Run the frozen grader configuration against it. Report over-credit and under-credit **per criterion and per subject stratum** — the first real measurement of grading quality. |
| 5.3 | The set becomes a permanent regression suite. Every future grader change re-runs against it. |
| 5.4 | **Never tune the grader on this set.** Cheap generation makes this more tempting, not less. It has been the mistake twice already. |

---

## 5. The certification gate

Pre-registered before the pilot runs, so the result cannot be rationalised afterward.

Let *p* be the false-accept rate of the automated path: answers that reached provisional
accept but that a reader, working cold, marks differently.

**Two readers per answer — how *p* is computed.** Amended 2026-08-04, before any
disagreement data existed. The Statistics pilot now has both readers marking the same 40
answers rather than one subject each, which §5 as originally written does not define a
rule for. Three definitions were available; the one adopted is **reader consensus**:

- An answer counts toward *p* only when **both readers, independently and cold, mark it
  differently from the script.** That keeps *p* measuring machine-vs-human, which is what
  the gate is for.
- Where **the two readers disagree with each other**, the answer does **not** count toward
  *p*. It is logged as a rubric-ambiguity finding and reported separately, on the same
  reasoning as Phase 3's `V1 ≠ V2` route: two qualified readers reading a criterion
  differently is a finding worth having, not noise to be averaged away.
- Reader-vs-reader disagreement rate is reported alongside *p*, never folded into it. A
  high rate does not fail the gate — it says the criterion wording is the problem, and a
  gate that conflated the two would send us to fix the generator when the rubric is at
  fault.

The rejected alternatives, recorded so the choice cannot be relitigated after the numbers
land: *either reader disagrees* (strictest — roughly doubles the chance of tripping the
≤5% bound, and lets a single reader's outlier reading fail a pipeline that is working),
and *both readers must disagree with each other's marking discarded* (loosest — throws
away the ambiguity signal entirely).

This is a pilot-stage choice on a single set. If reader-vs-reader disagreement turns out
to be common enough that consensus rarely forms, the definition is revisited **before**
Set A, not mid-set.

| Upper 95% bound on *p* | Outcome |
|---|---|
| **≤ 5%** | Automated path **certified** for this set. Production runs on sampling at the rate §5.1 implies. |
| **5–15%** | **Not certified.** Diagnose before rerunning: is it one writer family, one answer type, one subject? Fix and re-pilot. Do not proceed on the theory that the errors are benign. |
| **> 15%** | Automated path **rejected** for this set. Revert to reader verification of every answer, and reconsider whether the set is affordable at all. |

**Sampling rate implied by certification.** With the bound established, production
sampling is set so the bound holds at the set level — approximately 100 reader
verifications per set, independent of set size. Zero disagreements in 100 bounds *p* at
≈3%; zero in 50 bounds it at ≈6%.

**Re-certification triggers.** The bound is a property of the pipeline, not of the
corpus. Re-audit on: a new set, a change to the writer or verifier model slate, a change
to the generation prompts, or a criterion-structure change within a set. Not on merely
adding more items of the same shape to a certified set.

**Subject effect.** Within a set, check whether the false-accept rate differs by subject
stratum. If it does, the set is certified only for the subjects whose strata were
audited, and the outlier subject gets its own stratum sample — not its own gold set.

---

## 6. Element decomposition (Set A only)

74% of multi-point criteria (455 of 617) do not state how their points divide. A 3-point
criterion reading only *"diversity and evenness increase from Plot A to Plot C…;
explanation connects community assembly…"* cannot be scripted into a 2-of-3 answer until
someone decides what the three things are.

- AI drafts one breakdown per multi-point criterion, one element per point.
- A reader confirms or corrects it. This is the highest-value reader minute in the whole
  protocol: it is reused across all eight answers for that item, and an error here
  corrupts every one of them identically and invisibly.
- Genuine rubric ambiguity is **flagged, not resolved**. A criterion two qualified
  readers read differently is a finding worth having; averaging it away destroys it.
- This is not a request to rewrite the rubric. Adding breakdowns to the rubric was
  measured and does not improve grading.

**Set B does not exercise this step at all.** Single-point criteria have no breakdown to
decompose. This is the principal limit of the Statistics/Physics pilot: it certifies
generation, machine verification, and reader audit, but says nothing about decomposition.
Set A therefore needs its own certification pass regardless of how well the pilot goes,
and that pass is the one where the reader bill is real.

---

## 7. What can still go wrong

1. **Correlated blind spots inside the panel.** R1/R2 remove family-level correlation with
   the grader and the writer, not the possibility that all frontier models misread the
   same criterion the same way. The reader audit is the only control for this, which is
   why 4.1's blindness conditions are not negotiable.
2. **Generated answers that read like generated answers.** If the corpus drifts toward
   tidy model prose, the set stops resembling what 2,500 teenagers will submit and the
   measurement stops transferring. Writer-family rotation helps; reader spot-checks for
   realism during the audit are the check.
3. **A2 collapse.** The most valuable probe is the easiest to degrade into a reworded A1.
   Track it: if A2 answers stop failing the grader at a meaningfully different rate from
   A1, the probe has stopped working.
4. **Item drift.** Content items are actively edited. 0.3's hashes are the guard; an
   unhashed run is unattributable.
5. **The set being used to tune.** §5.4. Structural, not a matter of discipline —
   the frozen set should live where tuning workflows cannot reach it.

---

## 8. Live corpus status by subject

Snapshot against Production `pcntajvbdfqhbeewmdry` (`app.gold_set_answers` /
`app.gold_set_verification_assignments`), taken during the 2026-08-12 reviewer QA sweep
(`docs/Q&A/REVIEWER_QA_SWEEP_2026_08_12.md`). "Answers created" is distinct rows in
`gold_set_answers`; "Assigned" is verification-assignment rows against those answers
(an answer can carry more than one reviewer assignment); "Reviewed" is the subset with
`status='submitted'`. This table is a point-in-time reading, not part of the protocol
itself — refresh it each sweep rather than editing the pipeline sections above.

| Subject | Criterion structure | Answers created | Assigned | Reviewed | Pending |
|---|---|---:|---:|---:|---:|
| AP Statistics | Multiple (Set A) | 30 | 60 | 60 | 0 |
| AP Calculus AB | Single (Set B) | 22 | 44 | 22 | 22 |
| AP Calculus BC | Single (Set B) | 27 | 46 | 23 | 23 |
| AP Physics 1 | Single (Set B) | 23 | 24 | 8 | 16 |
| AP Physics 2 | Single (Set B) | 29 | 26 | 8 | 18 |
| AP Physics C: Electricity and Magnetism | Single (Set B) | 29 | 30 | 4 | 26 |
| AP Physics C: Mechanics | Single (Set B) | 23 | 28 | 0 | 28 |
| AP Precalculus | Single (Set B) | 44 | 1 | 1 | 0 |
| AP Statistics | Single (Set B) | 48 | 80 | 80 | 0 |
| **Set A total** | Multiple | **30** | **60** | **60** | **0** |
| **Set B total** | Single | **245** | **279** | **146** | **133** |

Two things worth flagging from this reading, not just reporting it:

- **AP Precalculus (Set B) has 44 answers created but only 1 assignment.** 43 written
  answers are sitting with no reviewer assigned at all — the largest unassigned backlog
  in the corpus by a wide margin, and worth a targeted assignment pass rather than
  waiting for it to surface again next sweep.
- **AP Physics C: Mechanics (Set B) has 0 of 28 assignments reviewed** — every assigned
  answer for that subject is still pending; combined with AP Physics C: E&M (4/30
  reviewed) and AP Physics 1/2 (8/24, 8/26), the Set B physics subjects are the least
  caught-up of the corpus even though generation for them is essentially complete.
- Set A is currently AP Statistics only (30/30 answers, fully reviewed) — Biology and
  Chemistry, called out in §2's Set A population, have no rows in `gold_set_answers` yet;
  Set A generation for those subjects has not started.
