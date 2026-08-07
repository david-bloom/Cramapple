# Content authoring & QA protocol — canonical, v0.2 draft

**Status:** Draft, not yet adopted. Proposed for the pipeline that produces and reviews
`app.content_items` (exam questions: MCQ/FRQ stems, choices, rubric criteria). This is a
different pipeline from `GOLD_SET_GENERATION_PROTOCOL.md`, which produces **student
answers** to test the grader. The two share conventions (multi-family independence,
blind verification, grep-verify before trusting a model's citation claim) but are not the
same process — do not merge them.

**Revision note (v0.2):** incorporates an independent review (Opus 4.8, 2026-08-06) that
caught a factual error in v0.1's fact-pack claim (§1.6, §7.3), an under-specified publish
predicate (§7.2), and the fact that §3.2 silently depends on §7.1. It also reframes
Phase 7(b) after David's observation that **published content does not drift** — only the
checker model, the fact pack, or a re-authored version can change, so re-checking is
event-driven, not periodic (§6 Phase 7, §7 P0 ranking).

**Why this document exists:** there is currently no single place that states what has to
be true before a batch of questions gets written, which model does which job and why,
what gates a question before it reaches a student, and what closes the loop after
publish. What exists instead is a set of conventions applied ad hoc, rediscovered
mid-incident, or written into one-off SQL scripts. This draft is that convention set,
made explicit, plus the gaps that need engineering work before it can be **enforced**
rather than just followed.

**The two things that gate everything are schema changes, not process (see §7):**
**P0-A — authoring provenance columns (§7.1)**, without which §3.2's writer-independence
rule is inert and no event-driven re-check (Phase 7) can compute its target set; and
**P0-B — a publish gate defined against `review_status` (§7.2)**, without which the
disapproved-but-published bug recurs (it already has, once). Everything else is
secondary to these two.

---

## 1. Current state, stated plainly

This is what the pipeline actually does today, verified against the repo and Production
(`pcntajvbdfqhbeewmdry`) this session — not the aspirational version.

1. **Authoring is ad hoc and per-batch.** Content is written in batch folders named by
   subject/unit/date (`scripts/content-seed/calc-ab-bc-units1-3-frq-2026-08-03/`,
   `physics1-2-cmech-cem-units1-3-frq-2026-08-03/`, etc.). Each folder's
   `generate-sql.mjs` turns an already-written JS/JSON literal of questions into `INSERT`
   SQL — it does not call a model. The actual drafting happens upstream of the repo (an
   authoring session, not a logged pipeline step), so **there is no record in the
   database or the repo of which model wrote a given item, what source material it was
   grounded in, or whether it was shown the CED fact pack at all.** That is P0-A (§7.1).
2. **No fact-pack-grounding requirement is enforced at write time.** Nothing checks that
   an authoring pass was given the CED fact pack, let alone the full one.
3. **Human tutor review is real, is a multi-stage state machine, and is where quality
   control currently lives.** It is not the single black box "human review" implies.
   `supabase/functions/review-decision/index.ts` runs it: a **blind group of two tutors**
   (`review_stage='tutor_question'`) each submit a `tutor_score` (1/2/3); the server
   **aggregates** the two (`advanceWorkflow`, lines 117–213) — sum 2 advances to a
   `reader_question` stage, sum 3 → `modification_reserved`, sum 4–6 → `excluded`. The
   reader stage then approves (FRQ → `question_review_approved`; MCQ → fan out
   `tutor_answer` ×4 choices ×2 tutors), recycles (`modification_reserved`), or excludes
   (`excluded`). The outcome of all this lands in **`content_item_versions.review_status`**.
4. **Publishing is a separate, disconnected step, and it reads the wrong column.**
   `review-decision/index.ts` writes `review_status` and never touches
   `content_item_versions.status`. Every `published` transition observed this session
   happened via a hand-run SQL script flipping `status`, with **no code path checking
   `review_status` first.** That is P0-B (§7.2), and it is not hypothetical: this session
   found and repaired 8 AP Biology FRQs, plus flagged (not yet repaired) 1 Chemistry and
   2 Statistics items, that were `status='published'` while their `review_status` was a
   rejection state. The same bug was fixed once before, 2026-07-31 (`ACTIVITY_LOG.md`,
   "7 Disapproved Items Unpublished"), and recurred — because the fix was a one-time SQL
   cleanup, not a standing constraint. **Note the two-column trap:** "disapprove" is not a
   single field. It is an *aggregate* of two blind `tutor_score`s (or a reader
   `disagree`) that resolves to `review_status IN ('excluded','modification_reserved')`.
   A gate written against "latest `tutor_score` = 3" would miss an item excluded by two
   `score=2`s summing to 4 — exactly the class this bug is about. §7.2 specifies the
   predicate correctly.
5. **There is no automated CED-conformance check in production.** The blind dual-model
   check developed this session (§4) is a research prototype run by hand against
   `docs/product/*_CED_FACT_PACK.md`, not a pipeline stage.
6. **Fact-pack depth is uneven — but less uneven than v0.1 claimed.** Corrected after
   direct grep of all nine packs this session:
   - **Deep (topic map + explicit exclusion boundaries + Relevant Equations):** Biology
     (1007 lines, inline `*Exclusion:*` tags and equation blocks per EK), Chemistry
     (177 lines, dedicated "High-risk exclusion boundaries" section, 15 statements).
   - **Partial (topic map + course-level removals/exclusions, but no per-topic inline
     exclusions or equation blocks):** Statistics (164 lines, `## 8. Confirmed removals —
     do NOT author these`, 5 removed topics + "do not conflate" clarifications), Calculus
     AB/BC (155 lines, "AB scope excludes all of Units 9 and 10, linear partial fractions,
     and improper integrals"; "Practice 4 is not assessed in the MCQ section"),
     Precalculus (117 lines, Unit 4 "Not assessed on the AP exam").
   - **Bare (topic titles only, zero exclusions, zero equations):** Physics 1, Physics 2,
     Physics C Mechanics, Physics C E&M (55–64 lines).

   The conformance check (§4) **can run today** for the partial tier against those
   course-level removal lists — it will catch authoring a wholesale-removed topic, though
   not fine-grained within-topic overreach. It **cannot run meaningfully for the four
   Physics packs** — a model asked to find scope violations against a bare topic list has
   nothing to check against and will either hallucinate coverage or under-flag by default.
   This reshapes §7.3: build 4 Physics packs from scratch; deepen 3 partial packs later;
   do not fund a five-subject rebuild.

---

## 2. Inputs the protocol requires before a batch starts

Authoring should not start on a subject/unit until these exist. "Fact-pack tier" uses the
three-way classification from §1.6, not a binary — it determines whether Phase 4 can run,
not whether authoring can start.

| Input | Current status | Owner |
|---|---|---|
| CED fact pack, and its **tier** (deep / partial / bare per §1.6) | Deep: Bio, Chem. Partial: Stats, Calc AB/BC, Precalc. Bare: Physics ×4 | Content ops |
| Target item-type distribution and count for the batch (MCQ vs FRQ, unit coverage) | Set informally per batch folder name; not written down anywhere durable | Content ops |
| Confirmed-reachable writer/verifier model roster for the batch (§3) | Ad hoc per script; no standing smoke test (§7.4) | Eng |
| Reviewer roster with subject qualifications (`validator_qualifications`) and queue depth | Exists, used for assignment (`feedback_content_review_assignment_policy` memory) | Content ops |

A batch against a **partial or bare** fact pack can still be **authored** (the topic map
is enough to write a plausible in-scope question) but Phase 4's coverage is limited
(partial) or impossible (bare). Record the fact-pack hash and tier at check time (§7.1)
so a later fact-pack upgrade knows exactly which items to re-check (§6 Phase 7).

---

## 3. Model role assignment — and why each rule exists

Two **separate** independence constraints apply. They protect against different failures
and have different reference points; do not conflate them.

**3.1 Grader-independence** (fully specified in `GOLD_SET_GENERATION_PROTOCOL.md` §3,
R1–R5): applies only when a model's output will later be **graded** by the production
grader (OpenAI). Not in scope for question authoring today; becomes relevant if a future
step has a model draft a **canonical answer** — at which point no OpenAI-family model may
write or verify it. Pointer only; that document governs.

**3.2 Writer-independence** (this pipeline, CED-conformance checking): applies to the
check in §4 — verifying a written question stays inside the CED's declared scope. The
reference point is the **item's own author**, not the grader.

- **The conformance-check model must not share a family with whatever authored the item.**
  Same-family author and checker share a notion of what counts as "close enough" to a
  fact-pack example, so the check inherits the writer's blind spot instead of catching it.
- **Two independent families check every item, not one.** A single model's verdict cannot
  gate a publish decision — §5 documents the measured, systematic failure modes of both
  models used this session. This is the direct answer to "can we just run one model and
  trust it": no, because each family's errors are systematic, not random noise a bigger
  sample averages out.
- **Confirmed checker families today:** Anthropic `claude-haiku-4-5` and DeepSeek
  `deepseek-v3.2` (Vercel AI Gateway, `scripts/vercel-gateway-check/`). `moonshotai/kimi-k2`
  is confirmed broken for structured-schema `generateObject` on this path (100% failure,
  verified twice) — excluded until independently reproduced fixed. Gemini 2.5 Flash is
  reachable and is the candidate third family when the panel must grow (see next point).

> **⚠ §3.2 is currently inert, and depends on P0-A.** Writer-independence requires knowing
> who authored the item — which §7.1 says is **not recorded anywhere**. You cannot
> guarantee non-overlap with an author you did not log. Worse: the confirmed checker
> roster is exactly **two** families. If a batch was authored by Claude or DeepSeek,
> writer-independence drops the usable panel to **one** checker — which §5 says is unsafe.
> So until provenance exists (§7.1) **and** a third checker family is confirmed (Gemini),
> §3.2 cannot be honored for a batch authored by a checker-family model. This is the
> strongest reason P0-A ranks first.

**3.3 What the adjudicating model (Sonnet, in this conversation) is and isn't.** Sonnet
acted as tie-breaker this session — but **not as a third independent vote.** Every
adjudication was a direct grep of the fact pack against the disputed claim, not a third
opinion. That distinction is load-bearing: a third model's disagreement resolves nothing
(§3.2's whole point is that model disagreement is expected and uninformative on its own);
a grep against the source document resolves it, because the fact pack — not any model's
reading of it — is the authority. §5's adjudication step is **"verify against source,"
not "get a third opinion."** A protocol that resolves disagreement by adding a third model
vote just adds a third systematic bias to reconcile.

---

## 4. The conformance check itself

Prototype, run by hand this session: Biology (8-item pilot, then 20-item random sample)
and Chemistry (20-item random sample); attempted against Physics and found not meaningful
(§1.6). Scripts: `scripts/vercel-gateway-check/apbio_ced_conformance_sample20.mjs`,
`apchem_ced_conformance_sample20.mjs`.

**Per item, blind to the model:** stem, stimulus, rubric criteria (or MCQ choices), and
the **full text** of the subject's CED fact pack. Not shown: which reviewer(s) touched the
item, what decision they made, whether it was flagged before, or the other verifier's
output.

**Ask the model for:** `scope_verdict` (`fully_in_scope` / `contains_out_of_scope_content`
/ `uncertain`); `out_of_scope_concepts` (specific facts/terms the item requires that are
absent from, or explicitly excluded by, the fact pack); `internal_consistency_issues`
(contradictions inside the item — e.g. this session's `apchem-frq-l-010` rubric requiring
"delocalized electrons in molten NaCl", which is chemically wrong); `confidence`;
`reasoning`.

**One prompt rule, learned from observed false positives, that must be pinned in one
place.** The line: *"Do not flag a specific numeric value, named object, or illustrative
example as out-of-scope merely because it isn't verbatim in the fact pack — flag it only
if the underlying mechanism/concept it requires is absent or explicitly excluded."*
Without it, DeepSeek over-flags illustrative examples (§5.2); with it, every flag in the
Chemistry run was grep-confirmed real. **This string is load-bearing and is currently
duplicated across both `_sample20.mjs` scripts.** If it drifts between copies or is
reworded, the false-positive rate silently returns. → Action: extract it (and the schema)
to one shared module both scripts import, so there is a single source of truth.

---

## 5. What the two-model check actually catches — measured this session

Do not run this with one model and treat the output as ground truth. Both models ran
against the identical 20-item Biology sample and agreed on only **60% of verdicts**, and
each has a *different, identifiable, systematic* bias — not independent random noise more
calls would average out.

**These measurements are from one session, one 20-item sample, on pinned versions
(`claude-haiku-4-5`, `deepseek-v3.2`). They are not permanent protocol constants** — the
two-family rationale rests on them, so they must be **re-validated on any checker-slate
change** (§7.4), the way the gold-set protocol re-certifies on a model-slate change.

**5.1 Haiku — visible-and-rationalized, not blind.** Haiku does not miss exclusion text;
it quotes it correctly, then argues why it doesn't apply. Grep-confirmed:
`APBIO-FRQ-L-026` (cleared `fully_in_scope`; excluded cluster — effective population size,
MVP, purging hypothesis, MHC alleles — present in item, absent from pack; caught by
DeepSeek on rerun); `apchem-frq-l-021` (cleared while its own reasoning cites fact-pack
line 139's "do not assess... the formal concept of state functions," then argues part (d),
which requires exactly that, is "not the same as" the excluded thing — it is; caught by
DeepSeek); `apchem-sfrq-035` (same pattern against line 139's buffer-pH-change clause).
Implication: Haiku alone is unsafe — its failure looks like careful reasoning, so
spot-checking the reasoning text rather than the underlying claim won't catch it.

**5.2 DeepSeek — verbatim-matching over-strictness.** Flags ~2–3× more items than Haiku,
often conceding the general principle is in scope one sentence before flagging because a
named example/equation wasn't verbatim. Grep-confirmed false positives:
`APBIO-MCQ-093` ("trophic cascade" is at pack line 974, EK 8.5.B.3), `APBIO-MCQ-002`
(amylase/starch/iodine test naming an in-scope enzyme-substrate principle),
`APBIO-FRQ-L-008` (water-potential equation, an explicitly listed Relevant Equation).
Implication: a DeepSeek-only flag is not sufficient grounds to fail an item without a
grep check.

**5.3 The adjudication rule — the vote is not load-bearing; the grep is.**

| Signal | Action |
|---|---|
| Both models flag the same item | High-confidence real defect. **Still grep-verify the specific claim** before repairing — models cite specifics that can be wrong even when the verdict is right (`apchem-frq-l-010`'s exact wording needed correction, not just confirmation it existed). |
| One flags, one clears | **Not resolvable by model count.** Grep the pack for the specific concept/exclusion named. If the exclusion text exists and the item requires the excluded concept, the flag is real regardless of which model raised it (`apchem-frq-l-021`, `apchem-sfrq-035` were correct single-model flags). If it's a named example of an in-scope principle, it's a false positive regardless of which model raised it. |
| Both clear | Provisionally accept; note it is unverified by a third path (cheap to be wrong — nothing prompted a check). |

---

## 6. Proposed end-to-end sequence

Each phase gates the next **except where noted** — the human-review phase runs as an
autonomous state machine, so Phase 4's scheduling relative to it is specified explicitly.

```
Phase 0  Preconditions       Fact pack present; its tier (§1.6) determines whether Phase 4
                             can run for this batch. Writer/verifier roster confirmed
                             reachable (§7.4 smoke test, once it exists).

Phase 1  Authoring           Model drafts item against the FULL fact-pack text (not a
                             summary). RECORD: authoring model, fact_pack_hash, batch_id.
                             [Blocked on P0-A / §7.1 — not recorded today.]

Phase 2  Structural QA       Mechanical, no model: non-blank stem/choices; correct choice
                             count; each criterion's points_possible present and the
                             criteria sum to the item's declared max points (not an
                             arbitrary target); no competing published version for the
                             same content_key. (Pattern already in every repair script.)

Phase 3  Human review        The review-decision state machine (§1.3): blind tutor pair →
                             aggregate → reader stage → terminal review_status. Runs to
                             completion autonomously via advanceWorkflow.

Phase 4  AI CED-conformance   Two independent-family models, blind (§4). Runs only where
                             Phase 0's tier allows (deep/partial). SCHEDULING: run in
                             PARALLEL with Phase 3, not gated behind it — the two are
                             independent signals (machine-scope vs human-judgment) and
                             serializing them wastes the wall-clock of whichever is slower.
                             Both must clear before Phase 6. Where the tier is bare, skip
                             with an explicit "human-only, not AI-checked" flag on the item.

Phase 5  Disagreement         Grep-adjudicate per §5.3. Never repair on a model's unverified
         adjudication         citation — confirm the specific claim against the source first.

Phase 6  Publish gate         status='published' allowed ONLY from an allowlist of
                             terminal-approved review_status values (§7.2). Blocked for any
                             rejection or in-progress state. [Blocked on P0-B / §7.2.]

Phase 7  Event-driven         NOT a periodic resample — published content does not drift.
         re-check             The only things that change are the checker model, the fact
                             pack, or the item version, so re-check is triggered by events,
                             and P0-A's provenance makes each target set a query:

                             (a) disapproved-but-published cross-check — TEMPORARY net
                                 until P0-B's constraint exists; then belt-and-suspenders.
                             (b) fact pack version changes → re-check every published item
                                 whose recorded fact_pack_hash != the new hash
                                 (WHERE fact_pack_hash = <old>). This is what a corrected
                                 Biology pack, or newly-built Physics packs, triggers.
                             (c) item gets a new version (edit/remediation) → that version
                                 re-enters Phase 4. This is just the forward path, not a
                                 sweep.
                             (d) backfill — items published before any check, or checked
                                 against a shallower pack tier: one-time, converges to zero,
                                 identified by "no conformance record at current tier."

                             A checker-MODEL change does NOT trigger a content re-check
                             (the content didn't change; a new model's flags are its own
                             biases, §5). It triggers re-validation of the §5 bias table
                             instead (§7.4).
```

---

## 7. Gaps that block enforcing this — ranked

### P0-A — No authoring provenance (§7.1)

Nothing records which model wrote an item, against which fact-pack version, in which
batch. Consequences: §3.2 (writer-independence) is inert (§3.2 callout); Phase 7's
event-driven re-check has no way to compute "which items were checked against the now-stale
pack" (Phase 7b/d); and no audit can distinguish an authoring-prompt fix from a one-off
content fix. **Minimal fix:** columns on `content_item_versions` (or a sidecar table) for
`authored_by_model`, `fact_pack_hash`, `fact_pack_tier`, `batch_id`, plus
`conformance_checked_at` / `conformance_result` once Phase 4 is wired. This is the
first-priority change because two other rules depend on it existing.

### P0-B — Publish is not gated on review outcome (§7.2)

The concrete, recurring bug (§1.4). **Specify the gate against `review_status`, as an
allowlist, not a denylist:**

- **Publishable review_status (allowlist):** `question_review_approved` (FRQ terminal
  approve) and the MCQ answer-review terminal state reached after the `tutor_answer`
  fan-out completes. Confirm the exact MCQ terminal value against `advanceWorkflow` /
  the `tutor_answer` completion path before writing the constraint — it is not one of the
  values shown in the tutor/reader excerpt (`ap_reader_pending`,
  `answer_tutor_review_pending`, `difficulty_discussion`, `question_review_approved`,
  `modification_reserved`, `excluded`), which are intermediate or rejection states.
- **Everything else is blocked**, including in-progress states — an allowlist fails safe
  when a new `review_status` value is added later; a denylist of `('excluded',
  'modification_reserved')` would silently pass a future rejection state nobody remembered
  to add.

**Implement as one of:** (1) a trigger/constraint on `content_item_versions` refusing
`status='published'` unless `review_status` ∈ allowlist; or (2) move the publish
transition into `advanceWorkflow` (`review-decision/index.ts`) as one more state
transition, since it already computes the terminal `review_status` — one code path
instead of ad hoc SQL scripts each re-implementing (or forgetting) the check. Option (2)
is the more durable home. Phase 7(a) stays as a detection net even after the gate exists —
defense in depth, not a substitute.

### P1 — Fact-pack depth for the Physics tier (§7.3)

Corrected scope after §1.6: **the four Physics packs** (55–64 lines, zero exclusions,
zero equations) need building from scratch to the deep bar before Phase 4 can run for them
at all. **Statistics, Calculus AB/BC, and Precalculus already have course-level removal/
exclusion lists** and can be conformance-checked against those today (partial coverage);
deepening them to per-topic inline exclusions is a later improvement, not a blocker. Do
not fund a five-subject rebuild — it is a four-subject build plus a three-subject deepen,
sequenced by which subject has the most content already published against its current
pack (uncounted — see §8).

### P2 — No standing model-roster smoke test (§7.4), and no bias re-validation

Two related pipeline-health gaps: (a) borrow the gold-set protocol's Phase 0.2 pattern
(≥19/20 schema-valid calls before trusting a checker family) as a standing gate — Kimi's
100% failure was found by ad hoc testing, and the next broken family will be too without
this. (b) On any checker-slate change (new family, version bump, swap), **re-validate the
§5 bias table** on a fresh sample before relying on the documented Haiku/DeepSeek behavior
— those numbers are version-specific and will go stale. Neither is release-blocking, but
both erode silently if left to memory.

---

## 8. Explicit non-goals

- Does not cover the grading/gold-set pipeline (`GOLD_SET_GENERATION_PROTOCOL.md` governs
  that) — shared conventions, not shared process.
- Does not decide **which** flagged-but-unrepaired items get fixed now vs. batched
  (`apchem-frq-l-001`, `APSTATS-MCQ-015`, `APSTATS-SFRQ-018`, plus Chemistry's three §5
  conformance findings: `apchem-frq-l-010`, `-021`, `-035`) — a scheduling decision.
- Does not pick which Physics pack is built first, or which partial pack is deepened first
  (§7.3) — depends on published-item counts per subject, which nobody has counted yet.
