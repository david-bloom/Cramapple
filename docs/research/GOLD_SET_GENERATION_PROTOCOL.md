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
| **A** | 1 — `llm_discrete_text` | multi-point | Biology 36 items / 158 criteria; Chemistry 5 / 30 | Active, after Set B certifies |
| **B** | 1 — `llm_discrete_text` | single-point independent | Physics ×4 35 / 113; Statistics 15 / 60; Precalculus 11 / 66 | **Active — pilot** |
| **C** | 4 — `spatial` / `human_shadow` | single-point | Statistics 33 / 132 | Deferred until Engine 4 leaves shadow |
| — | 3 — formula/ECF/symbolic | — | **zero published items** | No set until content routes there |

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
