# Gold-Set Exemplar Grading Pipeline Review — AP Statistics — 2026-08-17

**Status:** Review complete. No code, data, or Production changes made in this
session — this is a read-only synthesis for continuity across a context reset.
**Author:** Session review, requested by David Bloom.
**Scope:** DECISION-0045's AI-generation + multi-model-verification +
reader-certification gold-set pipeline, as piloted on **AP Statistics**
(both Set A and Set B). AP Physics (also part of the pilot) is covered only
where needed for context; it is not separately reviewed here.
**Primary sources:**
`docs/activity_log/DECISIONS_LOG.md` (DECISION-0045),
`docs/research/GOLD_SET_GENERATION_PROTOCOL.md` (§8 live corpus status),
`docs/research/GOLD_SET_PILOT_STATS_PHYSICS_2026_08_03.md` (pre-registered
pilot design and decision rule),
`docs/activity_log/ACTIVITY_LOG.md` (2026-08-03 pilot build/seed entry,
2026-08-06/07 TASK-0022 entry, 2026-08-08 rubric-ordering-defect entry),
`docs/tasks/TASK-0022-AP-STATISTICS-MULTIPOINT-RUBRIC-DEFECT.md`.

---

## 1. Question this review answers

Is the AP Statistics gold-set exemplar-grading pilot producing signal, and
what should run next to find out whether the pipeline is certifiable? This
was requested ad hoc; it is not itself a new protocol document and creates no
new decision. It is the record of what was found so the next session does not
have to re-derive it.

---

## 2. What the pipeline is (for context)

**DECISION-0045** (2026-08-03, approved by David) replaced all-human gold-set
authoring — estimated ~94 reader-hours, which was not going to get finished —
with a three-part model:

1. **Generation.** Gold-set answers are written by AI, not readers. A writer
   model produces one answer per each of 8 fixed "answer types" (A1–A8) per
   item, with a target present/absent script assigned by the harness *before*
   any text exists (so compliance is measured, not self-reported). A2 tests
   full credit for unconventional/non-textbook phrasing; A6 tests that
   plausible-sounding-but-wrong text does *not* earn credit. These two are
   the reason the whole exercise exists.
2. **Verification.** Two independent, non-OpenAI model families (never
   sharing a family with the writer, never sharing a family with the grader
   under test, which is OpenAI `gpt-4.1-mini`/`gpt-5.5`) check the answer
   blind. Agreement between script and both verifiers → `provisional_accept`.
   Verifier split → `reader_queue`. Both verifiers disagree with the script →
   `discard`.
3. **Certification.** A human reader (Jill Schmidlkofer for Statistics,
   Muhammad Saood for Physics) marks a sample **cold** — no script, no
   verifier output, no grader output, no indication of which route an answer
   took — at the rubric-element level (present/absent, never a score). The
   automated path is certified by comparing the reader's cold marks to the
   automated route on a **pre-registered gate**:

   | Upper 95% bound on false-accept rate | Outcome |
   |---|---|
   | ≤ 5% | Certified. Production sampling replaces 100% reader review. |
   | 5–15% | Not certified. Diagnose by writer family / answer type / subject; fix; re-pilot. |
   | > 15% | Rejected. Revert to full reader verification. |

   Reader effort thereby decouples from corpus size — it verifies the
   *pipeline*, once, rather than every answer forever.

AP Statistics was chosen for the pilot specifically because it is the
cleanest test of the machinery: complete canonical-answer coverage (15/15
items at pilot time), a single strong dedicated reader (Jill), and — along
with Physics — the simplest rubric shape (Set B, single-point independent
criteria, no element-decomposition step to worry about).

The pilot design (`GOLD_SET_PILOT_STATS_PHYSICS_2026_08_03.md`) is explicit
that **Stage 1 (Statistics, 48 answers) alone cannot certify** — zero reader
disagreements across the ~34 auto-accepted answers in that stage only bounds
the false-accept rate at ~8%, which fails the ≤5% gate on its own. The
protocol's original design computes certification on **Stage 1 + Stage 2
(Physics) combined, ~110 answers**, against the same unchanged gate.

---

## 3. Learnings to date

### 3.1 Script compliance was much worse than assumed going in

Stage 1 generation (2026-08-03): 48 answers (6 Statistics items × A1–A8),
writer rotated round-robin across Anthropic/Google/DeepSeek.

| route | n | meaning |
|---|---:|---|
| `provisional_accept` | 30 | script = verifier 1 = verifier 2 |
| `reader_queue` | 10 | verifiers split — rubric-boundary findings |
| `discard` | 8 | both verifiers agree the text missed its own script |

**Script compliance: 30/48 = 62.5%**, against the only prior (informal)
measurement of 5/10 (50%). By answer type: A1 6/6, **A2 6/6**, A3 4/6, A4
1/6, A5 5/6, **A6 1/6**, A7 4/6, A8 3/6. By writer family: Google 12/16,
Anthropic 11/16, **DeepSeek 7/16**.

- **A2 succeeding 6/6 is the strongest positive signal in the pilot.** A2 is
  the probe for full credit under unconventional student phrasing — the
  exact behavior that originally caught the production grader awarding full
  marks to only 7 of 10 genuinely complete answers (cited as the reason A2
  exists in DECISION-0045). The generator reliably produced genuine
  student-voice paraphrase for it (example on record: "that 41 minute
  student really stretches out the data, making it look all lopsided to the
  right").
- **A6 at 1/6 is the expected hard case**, and the entry notes several of
  the A6 verifier splits are legitimate rubric-boundary questions rather
  than generator failures — i.e., some of that 5/6 "failure" rate is
  actually the pipeline correctly routing ambiguous cases to a human rather
  than silently guessing.
- **DeepSeek is the weak writer**, not the weak verifier — it was kept only
  because Phase 0.2's empirical test eliminated Kimi entirely (see 3.2), not
  because it tested well.

### 3.2 Kimi was empirically eliminated as a candidate third model family

Phase 0.2's gate (20 verification calls against the real schema, pass at
≥19/20 valid) was run: `anthropic/claude-sonnet-4.5` 20/20,
`anthropic/claude-haiku-4-5` 20/20, `google/gemini-2.5-flash` 20/20,
`deepseek/deepseek-v3.2` 20/20, and **`moonshotai/kimi-k2` 0/20 — every call
rejected "Bad Request."** This settles, with a measurement, something that
had previously existed only as an unwritten recollection
(`GRADING_PROGRAM_LEDGER_2026_07_27.md`: "Do not cite Kimi performance as
measured"). DeepSeek took the third verifier slot as the protocol's named
alternate.

### 3.3 The pilot surfaced a structural defect the pipeline was never built to survive

TASK-0022 (opened 2026-08-06/07) found that **all 573 published AP Statistics
FRQ criteria, across all 182 published item-versions, are uniformly
`points_possible=1`** — no bundled 2pt/3pt criteria anywhere, unlike Biology,
Chemistry, and Calculus AB/BC, which all carry genuine multi-point criteria
matching real AP scoring conventions. No decision record, authoring brief, or
CED fact pack documents this as intentional.

This matters specifically for the gold-set pipeline: Phase 0.5's
element-decomposition-confirmation step (the "highest-judgement,
highest-blast-radius reader step," per the pilot doc's own §6 caveat) can
only run against multi-point criteria, and it had **never once run for
Statistics** as a result. A Set B (single-point) certification pass does not
license unsupervised Set A (multi-point) generation — this was already
called out as a limit in the pilot's pre-registration, and the audit
confirmed the limit was real, not theoretical.

Remediation executed in the same task:
- A 4-item pilot slice (`APSTATS-SFRQ-007/008/009/010`) was re-decomposed
  into genuine mixed 1/2/3pt criteria (e.g. "compute mean + SD together,"
  "describe the sampling distribution"), published, and run through the real
  pipeline: 32 answers generated, 25 `provisional_accept` / 5 `reader_queue`
  / 2 `discard`, 30 loaded to `app.gold_set_answers` under `set_key='A'` and
  assigned to both Jill and Saood.
- A pass-2 full-corpus scoping pass reviewed all 178 Statistics FRQ
  item-versions across every status (49 published, 24 reviewed_approved, 94
  retired, 8 disapproved, 2 draft) and found only 12 of the 45 remaining
  published items are the `discrete_text`/`llm_discrete_text` short-FRQ
  family this defect applies to (the other 32 are `rubric_type='spatial'`
  hand-drawn-graph items on a different engine, out of scope). Of those 12,
  **9 were restructured** into genuine bundles (inference-procedure
  "mechanics" bundles, boxplot holistic-construction bundles) and published;
  **3 were left unchanged** because they already reflect standard atomic AP
  scoring and bundling them would manufacture a defect rather than fix one.

### 3.4 The reader caught a real, live defect — direct evidence the human-in-the-loop step is doing work

On 2026-08-08, Jill found a rubric-answer-ordering defect in gold-set
question 37 of 66 (`APSTATS-SFRQ-010`) with specific renumbering
instructions. Root cause: `gold_set_elements.element_index` restarts at 1 per
criterion, so when a multi-point criterion's elements interleaved with a
later criterion's single element, naive display order scrambled the
part-order shown to reviewers. Traced beyond her one item to 4 more affected
published items, all from the 2026-08-07 TASK-0022 redecomposition
(`apstats-frq-u12-005`, `APSTATS-SFRQ-007/008/009`). Fixed by renumbering
`element_index` to be globally sequential per item; verified against the
entire gold set afterward (0 remaining defects among items with genuine
multi-element criteria); verified Saood's 30 already-submitted marks against
the same 4 items were unaffected (marks join on stable
`gold_set_element_id`, not display position, so no rework was needed).

This is direct, dated evidence that the "reader verifies cold" design step is
not theater — a real defect that would have corrupted certification data was
caught before it propagated.

### 3.5 Current data completeness (as of the 2026-08-12 sweep)

From `GOLD_SET_GENERATION_PROTOCOL.md` §8 (live corpus status, snapshot
against Production `pcntajvbdfqhbeewmdry`):

| Subject | Criterion structure | Answers created | Assigned | Reviewed | Pending |
|---|---|---:|---:|---:|---:|
| AP Statistics | Multiple (Set A) | 30 | 60 | **60** | **0** |
| AP Statistics | Single (Set B) | 48 | 80 | **80** | **0** |
| AP Calculus AB | Single (Set B) | 22 | 44 | 22 | 22 |
| AP Calculus BC | Single (Set B) | 27 | 46 | 23 | 23 |
| AP Physics 1 | Single (Set B) | 23 | 24 | 8 | 16 |
| AP Physics 2 | Single (Set B) | 29 | 26 | 8 | 18 |
| AP Physics C: E&M | Single (Set B) | 29 | 30 | 4 | 26 |
| AP Physics C: Mechanics | Single (Set B) | 23 | 28 | 0 | 28 |
| AP Precalculus | Single (Set B) | 44 | 1 | 1 | 0 |

**AP Statistics is the only subject in the entire corpus that is fully
reviewed with zero pending, in both Set A and Set B.** Every other subject,
including Physics — the pilot's other co-equal arm — is well behind (Physics
C: Mechanics has 0 of 28 reviewed).

---

## 4. The gap: certification was never computed

The pre-registered decision rule from §2 above (upper-95%-bound false-accept
rate against the ≤5% / 5–15% / >15% gate) **has not been run for Statistics,
despite the reader data being 100% complete.**

Evidence this is a real gap, not an oversight in this review:
- `TASK-0022-AP-STATISTICS-MULTIPOINT-RUBRIC-DEFECT.md`'s own acceptance
  criteria list **"False-accept rate computed once both readers complete
  their pass"** as unchecked (`- [ ]`), and **"Certifying the automated
  gold-set path for Set A"** is explicitly listed under "Out of Scope" for
  that task.
- No file matching a certification report, `pilot_results.jsonl`, or
  computed false-accept-rate output exists anywhere in the repository. A
  repo-wide search for `false-accept` / `false_accept` outside the protocol
  and pilot-design documents themselves returns nothing for this pipeline
  (the only numeric `false_accept_rate` hits in the repo belong to the
  unrelated hand-drawn-graph benchmark).
- The 2026-08-03 session closeout explicitly left this as open item #6:
  "Stage 2 (Physics) after the early-year push. Certification needs Stage 1
  + 2 combined (~110 answers); Stage 1's 40 cannot certify on its own (~8%
  bound against a ≤5% gate)." That framing assumed certification requires
  combining Statistics with Physics. Physics has since fallen far behind
  (Physics 1/2/C-E&M/C-Mech collectively only ~20/108 reviewed), while
  Statistics alone has grown past the original combined target (140
  Statistics answers reviewed today vs. the ~110 combined figure the
  original design was budgeting for). Nobody has revisited whether Statistics
  alone can now support its own bound, independent of Physics.

**Net effect:** the expensive part of the pilot (AI generation, blind
multi-model verification, and 100% cold reader marking across 140 answers)
is done and paid for. The analytical step that turns that data into an
actual go/no-go decision on the pipeline has not been taken. Right now,
nobody knows whether the Statistics automated grading path is certified,
needs diagnosis, or should be rejected — despite already having the data
needed to answer that.

---

## 5. Recommended next tests, in priority order

1. **Compute the false-accept rate on the existing Statistics data now.**
   This requires no new API calls and no new reader time — the reader marks
   already exist in `app.gold_set_verification_assignments` for all 140
   reviewed Statistics answers (60 Set A + 80 Set B). Report against the
   exact DECISION-0045 gate (≤5% / 5–15% / >15%), broken out by:
   - answer type, with **A2 and A6 reported separately** (the pilot doc is
     explicit these are the two probes the whole exercise exists to test,
     and an aggregate pass that hides a per-probe failure would be an
     over-claim);
   - writer family (DeepSeek already looks like the weak link on script
     compliance; check whether that carries through to false-accept rate);
   - Set A vs. Set B separately, since Set A now has actual
     element-decomposition data to check for the first time.
   This is the single highest-leverage next step and is overdue relative to
   the data already collected.
2. **Resolve whether Statistics-only data can support its own certification
   bound**, rather than assuming the original Stage-1-plus-Physics design is
   still the right unit of analysis. The original ~110-answer combined
   target was set when Statistics alone had only 48 answers; Statistics now
   has 140 reviewed on its own. Redo the statistical-power arithmetic
   (95% upper bound on false-accept rate given the current Statistics-only n
   and observed disagreement count) before deciding Physics completion is a
   blocking prerequisite.
3. **If Physics is still required for the combined bound**, finishing Stage
   2 is the clear blocker: Physics C: Mechanics is at 0/28 reviewed and the
   other three Physics courses are 20–30% reviewed. This is reader-time-bound
   on Saood's availability, not a pipeline question, so it should be
   sequenced accordingly rather than treated as equivalent-priority to step 1.
4. **A2/A6-targeted regeneration test, no reader cost.** Since script-compliance
   failures concentrate in specific answer types (A4 1/6, A6 1/6) and one
   writer family (DeepSeek 7/16), re-run generation with a prompt-level fix
   aimed at A4/A6 and measure the compliance-rate change using only the
   existing blind two-verifier check — this validates or refutes the
   standing hypothesis ("the fix is prompt-level, not model-level," recorded
   2026-08-03) before spending any more of Jill's or Saood's time.
5. **Gate full-corpus Statistics remediation on the certification result, not
   ahead of it.** 178 Statistics FRQ items still carry uniform 1pt
   atomization (169 after the 9 already fixed in TASK-0022 pass 2); deciding
   whether to remediate the rest is explicitly out of scope until Set A
   certification lands. Running that remediation before certification would
   spend more generation/reader effort on a pipeline whose accuracy is still
   unmeasured.

---

## 6. What this review does not settle

- Whether the current 140-answer Statistics sample is *itself* large enough
  to produce a meaningful 95% bound at all subject-specific error rates —
  that's arithmetic step 2 above, not yet performed.
- Whether the TASK-0022 element decompositions Jill is reviewing are
  actually correct. "Reviewed" in §8's table means her pass is complete, not
  that she confirmed every decomposition without dispute — that outcome
  should be checked specifically, since this is the first real use of the
  element-decomposition-confirmation step for this subject.
- Whether the DeepSeek writer-quality gap generalizes to other subjects, or
  is Statistics-specific.
- Anything about Physics's own certification status beyond the completion
  percentages already public in §8 — Physics was out of scope for this
  review by request.
