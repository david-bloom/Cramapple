# Gold-set pipeline pilot — AP Statistics + AP Physics (Set B)

**Date prepared:** 2026-08-03
**Status:** PRE-REGISTERED, NOT YET RUN. Written before generation so the result cannot
be rationalised after the fact.
**Protocol:** [`GOLD_SET_GENERATION_PROTOCOL.md`](GOLD_SET_GENERATION_PROTOCOL.md)
**Reader guide:** [`GOLD_SET_AUTHORING_GUIDE.md`](GOLD_SET_AUTHORING_GUIDE.md) v2.0
**Decision:** DECISION-0045
**Readers:** Jill (AP Statistics), Muhammad Saood (AP Physics 1 / 2 / C-Mech / C-E&M)

---

## 1. Question

**Can AI generation plus two-family blind machine verification produce gold-set labels a
qualified reader agrees with often enough to stop reading every one?**

This is a pilot of the *pipeline*, not a production run of a gold set. The Set B corpus
it produces is a by-product; if the pipeline fails certification, the corpus is discarded
along with it.

**Hypothesis under test:** the false-accept rate of the automated path — answers where
the writer's script and both machine verifiers agree, but a reader working cold marks
differently — has an upper 95% bound at or below 5%.

---

## 2. Pre-registered decision rule

Fixed before generation. Copied from protocol §5; restated here so the pilot cannot be
graded against a moved bar.

| Upper 95% bound on false-accept rate | Outcome |
|---|---|
| **≤ 5%** | Certified. Set B production proceeds on ~100-answer sampling per set. Set A pilots next. |
| **5–15%** | Not certified. Diagnose by writer family, answer type, and subject; fix; re-pilot. Do not proceed on the theory the errors are benign. |
| **> 15%** | Rejected for Set B. Revert to reader verification of every answer and re-scope the programme. |

**Stage 1 alone cannot certify, and must not be reported as if it could.** 48 answers
yields roughly 34 on the auto-accept path; zero reader disagreements across 34 bounds the
false-accept rate at only ~8%, which fails the ≤5% gate. Certification is computed once on
Stage 1 + Stage 2 combined (~110 answers) against this unchanged gate. What Stage 1 buys
is the cheaper and more urgent answer: **does the generator follow its own script?** The
only prior measurement is 5 of 10 answers failing their own script. If that reproduces,
the programme needs rework before any reader time is spent at scale — which is exactly the
outcome worth learning for four hours of one reader's time.

**Secondary measures, reported regardless of outcome:**

- Script-compliance discard rate (Phase 3 route 2) — the v1.0 measurement was 5/10.
- Reader-queue rate (Phase 3 route 3, verifiers split) — expected to concentrate on
  ambiguous criteria; each instance is a rubric finding.
- Per-answer-type false-accept rate, with **A2 and A6 reported separately.** These are the
  probes the whole exercise exists for; a pipeline that is accurate on A1/A8 and wrong on
  A2/A6 has failed even if the aggregate clears 5%.
- Subject effect: Statistics vs Physics, and across the four Physics courses.

---

## 3. Why Statistics and Physics

Not because they need gold sets most — because they are the cleanest test of the machinery
and they hold the best readers.

- **Both are Set B** (Engine 1, `llm_discrete_text`, single-point independent criteria).
  They are the same rubric shape and grade through identical code, which is exactly why
  they belong in one set rather than two.
- **Canonical-answer coverage is complete** — 15/15 Statistics, 35/35 Physics — so every
  A1 comes from the bank rather than from generation. Chemistry (4/8) could not do this.
- **Reader quality is the binding constraint on a certification pilot.** Jill is the sole
  Statistics reviewer and produced the five findings that drove the 2026-08-01 FRQ
  remediation; Saood carries all four Physics courses. A pilot verified by weak readers
  certifies nothing.

---

## 4. Frozen slice

14 items / 52 criteria / **112 answers** (8 per item). Published, non-retired,
`rubric_type='discrete_text'`, `evaluator_strategy='llm_discrete_text'`, all carrying
`canonical_answer_1`. Verified against Production `pcntajvbdfqhbeewmdry` 2026-08-03.

**Re-frozen 2026-08-03 to early-year units**, on David's priority: content students meet in
Aug–Oct ships first, and content that is months away can wait. The original slice was
picked for reader quality and criterion balance and included Unit 12 magnetism, Unit 10
capacitors and Unit 9 thermodynamics — a certification on those says little about the
Units 1–3 material students actually hit in September. Nothing had been generated, so
re-picking cost nothing.

**Stage 1 — AP Statistics (Jill) — 6 items, 24 criteria, 48 answers. Elements seeded.**

| content_key | ver | unit | criteria | points | content_hash |
|---|---:|---:|---:|---:|---|
| `APSTATS-SFRQ-001` | 1 | 1 | 4 | 4 | `99ffea1ddbf2` |
| `APSTATS-SFRQ-002` | 1 | 1 | 4 | 4 | `accf82300d7a` |
| `APSTATS-SFRQ-003` | 1 | 2 | 4 | 4 | `c832b32bf29c` |
| `APSTATS-SFRQ-004` | 1 | 2 | 4 | 4 | `843d94157f65` |
| `APSTATS-SFRQ-005` | 1 | 3 | 4 | 4 | `f713c464df16` |
| `APSTATS-SFRQ-006` | 1 | 3 | 4 | 4 | `1821d8705800` |

Two items per unit across 1–3, uniform 4 criteria / 4 points, all carrying
`canonical_answer_1`. All 24 elements seeded via
`app.seed_gold_set_elements_single_point`.

**Taxonomy caveat.** These unit tags are the **retired 9-unit** AP Statistics numbering
(the published bank still contains units 6 and 7). Under the current 5-unit CED,
"early-year" as defined by the 2026-08-03 packet script is units 1–2, which would be 4
items rather than 6. Units 1–3 is used here to reach a workable slice size; the extra two
items are one taxonomy step outside the strict early-year boundary.

**Retired Statistics FRQs were evaluated as a source and rejected.** The 90
single-criterion FRQs retired on 2026-08-01 are Set B shape and were retired for
*structure* (not FRQ-like) rather than for being wrong, which made them look promising.
They are unusable: **0 of 90 carry a `canonical_answer_1`**, they are unit-untagged, and
only 31 were ever tutor-approved. Without a canonical answer there is no A1 seed and no
ground-truth anchor, so an answer set built on them would have nothing to be scripted
against. The *reclassified* half of that remediation is already in use — the 68 items
retagged `targeted_drill` include SFRQ-001…006 above.

**Stage 2 — AP Physics, deferred.** Reader assignment has moved: Saood is on early-year
Calculus and Ghazanfar Ali on early-year Physics. Physics 2 and C-E&M have **zero**
published early-year items, so a Stage 2 slice can only come from Physics 1 (6 items /
19 criteria) and C-Mechanics (5 / 15). Stage 2 is scheduled after the early-year review
push, with its reader to be confirmed.

**AP Physics (Saood) — 8 items, 28 criteria, 64 answers.** Two per course, one
higher-criteria and one minimal, so criterion count is not confounded with course.

| content_key | course | ver | criteria | points |
|---|---|---:|---:|---:|
| `apphy1-frq-025` | Physics 1 | 2 | 6 | 6 |
| `apphy1-frq-002` | Physics 1 | 2 | 2 | 2 |
| `apphy2-frq-027` | Physics 2 | 3 | 6 | 6 |
| `apphy2-frq-001` | Physics 2 | 1 | 2 | 2 |
| `apphycm-frq-019` | C-Mechanics | 3 | 4 | 4 |
| `apphycm-frq-002` | C-Mechanics | 2 | 2 | 2 |
| `apphycem-frq-019` | C-E&M | 2 | 4 | 4 |
| `apphycem-frq-003` | C-E&M | 2 | 2 | 2 |

`content_hash` per item is captured at freeze time (protocol 0.3). Any item edited during
the run invalidates its eight answers; they are regenerated against the new hash, not
patched.

---

## 5. Model slate

Grader under test: OpenAI (`gpt-4.1-mini`, `gpt-5.5`). Per protocol R1, no OpenAI model
appears anywhere below.

| Role | Families |
|---|---|
| Writer | Anthropic, Google, Moonshot — **rotated across answers** |
| Verifier panel | The two families that did not write that answer |
| Reader | Jill, Saood |

**Phase 0.2 blocker — the third family.** Anthropic and Google are wired and confirmed
in `scripts/vercel-gateway-check/`. The third slot is unresolved:

- The repo records the Kimi arms as **pre-registered and never run**
  (`GRADING_PROGRAM_LEDGER_2026_07_27.md`: *"Do not cite Kimi performance as measured"*).
  No schema-incompatibility finding is recorded anywhere in the repo; the belief that one
  exists appears to be session memory that was never written down.
- The constraint that shaped the grading arms — a 5-field verdict object
  (`status`/`confidence`/`evidence_quote`/`minimal_fix`/`gate`) under a 4–8 s criterion
  timeout — does not obviously transfer. Verification asks for
  `[{element_id, present, evidence_quote}]` and runs offline in batch, so a
  parse-repair-retry loop is affordable where it was not in production grading.
- **Resolution:** 20 verification calls against the real schema. Pass at ≥19/20 valid
  after at most one repair retry. Fail → DeepSeek under the same test. Both fail → the
  pilot does not run, because two families cannot produce unanimity-of-two once the
  writer takes one.

This is a hard gate, not a preference. It is the one thing that can stop the pilot before
it starts, and it is cheap to settle.

---

## 6. What this pilot does not test

Stated up front so the certification is not over-claimed later.

1. **Element decomposition.** Set B has zero multi-point criteria, so protocol 0.5 never
   fires. Decomposition is the highest-judgement, highest-blast-radius reader step, and
   it remains completely unmeasured. **Set A must be certified separately** — a Set B pass
   does not license generating Biology unsupervised.
2. **Full exam-form FRQs.** Every item in the slice is `practice_format='targeted_drill'`.
   There are **no `full_exam_frq` items published in any subject**, so nothing else was
   available. The certification therefore covers short drill items only. The AP Statistics
   2027 form — 4 questions × 10 independently-scored points — does not yet exist as content
   and cannot be piloted.
3. **Engines 3 and 4.** Engine 3 has no published content. Engine 4 is 33 Statistics
   spatial items in `human_shadow`, i.e. not automated. Neither is in scope.
4. **The grader's accuracy.** The pilot certifies the *labels*. Measuring the grader
   against them is Phase 5, and it is a separate report.

---

## 7. Reader load

| reader | answers | criterion-level marks | est. |
|---|---:|---:|---:|
| Jill (Statistics) | 48 | 192 | ~4 h |
| Saood (Physics) | 64 | 224 | ~5 h |

**Readers verify 100% of provisional accepts in the pilot.** That is the design: the
false-accept rate cannot be estimated from a sample of the thing being estimated. Sampling
starts only after certification.

Blindness conditions (protocol 4.1) apply without exception — no script, no verifier
output, no grader output, no indication of which route an answer took. Answers from the
reader queue (verifiers split) are interleaved with provisional accepts and are
indistinguishable to the reader.

---

## 8. Outputs

1. `pilot_results.jsonl` — one row per answer: item, type, writer family, script, both
   verifier markings, reader marking, route, agreement.
2. **Certification report** — false-accept rate and 95% bound, per answer type, per
   subject, per writer family; the §2 outcome; and the implied production sampling rate.
3. **Rubric findings** — every criterion that put an answer in the reader queue, with the
   disagreement. These feed content review independently of the certification result.
4. Either a frozen Set B corpus, or a written discard.

---

## 9. Open items carried into execution

- **Phase 0.2 third-family resolution** (§5) — blocking.
- **Reader scheduling.** Jill's availability is already contended; the 2026-08-02 decision
  deferred her §3 skill-tag confirmation for exactly this reason. This pilot is a ~4 h ask
  and needs to be sequenced against that deferral, not stacked on top of it.
- **8 published FRQ items carry `rubric_type IS NULL` / `evaluator_strategy IS NULL`**
  (7 Biology, 1 Statistics; 30 criteria). They cannot be assigned to a set until
  backfilled. Out of scope for this pilot — the Statistics item is not in the slice — but
  it blocks a complete Set A population count.
