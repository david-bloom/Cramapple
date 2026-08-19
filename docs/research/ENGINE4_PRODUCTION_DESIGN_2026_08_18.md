# Engine 4 (Spatial / Hand-Drawn Grading) — Production Design Synthesis

**Written:** 2026-08-18
**Status:** Proposed design synthesis, not an approved plan. No DECISION or APPROVAL entry
exists for anything in this document. Written per the handoff doc's own instruction
(`docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` §4): "read those docs and write a scope
note before any build work." This is that scope note, expanded to cover architecture,
deployment model, and the concrete gap-closing sequence, using everything measured through
2026-08-18 (`docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md`).

**UPDATE, same day:** the full-scale (105/105) escalation run finished after this document
was first drafted. It reverses the 21-photo controlled test's "escalation genuinely works"
verdict — see §1 below, now corrected in place, and
`docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md` §"Escalation at full
scale" for full detail.

**UPDATE 2026-08-19:** Statistics got its first accuracy measurement — see new §1b. A
deliberate, owner-directed exception to this document's own Biology-first sequencing (§9);
findings and a new standing design principle (precompute deterministic facts) folded into
§8's next steps as items 11-14.

Evidence-class labels follow repo convention (Live verified / Deployed verified /
Repository only / Prototype-research only / Proposed / Not verified).

---

## 0. Current verified state (Live verified, re-queried 2026-08-18)

| Fact | Value |
|---|---|
| `evaluator_strategy = 'human_shadow'` content item versions | **59** (2 `assigned`, 24 `published`, 27 `retired`, 6 `reviewed_disapproved`) |
| `evaluator_strategy = 'python_symbolic_ecf'` (Engine 3) | 1 `published`, 0 attempts against it |
| Real students graded by any engine, ever | **0** — see [[project_production_zero_real_students]] / handoff UPDATE 2026-08-18b |
| Real-photo accuracy corpus | 200 photos, 3 archetypes (`CAT`/`SER`/`EST`), gold is single-pass `ai_provisional`, NOT dual-human-adjudicated |

The handoff doc's "40 `human_shadow` items" figure (§0/§4, dated ~2026-07-27/28) is stale —
an 2026-08-14 migration retagged 18 more `APBIO-HDG-2026-GRAPH-*` rows from `discrete_text`
to `spatial`/`human_shadow`. **59 is the current live count; re-verify with the query above
before citing a number in a future session, this moves.**

---

## 1. Recommended architecture (Proposed, updated with the full-scale escalation number)

**Primary grading model:** `openai/gpt-5.2`, joint perception+judgment call (single request,
full image, full rubric), NOT the decomposed perception-then-judgment pipeline the original
2026-06-13 architecture review recommended. This is a **deliberate, evidence-based
deviation** from that review, not an oversight: the 2026-08-18 investigation directly tested
decomposition (extraction-only probe) and found it strictly worse (20.2% point-match vs.
73.8% joint on the same criterion) — perception errors compound rather than isolate when
split into a separate stage. Record this reasoning in this doc so a future session doesn't
"fix" the architecture back toward the original recommendation without re-reading why it was
changed.

**Escalation: blanket escalation is NOT recommended — the full-scale number reverses the
21-photo read.** Ran all 105 of `gpt-5.2`'s medium-confidence responses through `gpt-5.2-pro`
(`maxOutputTokens: 1200`; 0 failures, $4.85 spend). At full scale, on the same 105-photo
population: FAR improves (25.3%→14.8%) but **FRR nearly doubles** (11.5%→21.5%), and
whole-corpus F1 actually **drops** (93.3%→91.0%) once escalated results are substituted in.
The 21-photo test's clean win (FAR 50.0%→18.8%, FRR 13.4%→8.7%, F1 86.6%→93.1%) did not
generalize — a 7-per-archetype sample was too small to see the real, archetype-dependent
split:

| Archetype | Effect | 
|---|---|
| `continuous_relationship_graph_derived_estimate` (`EST`) | **Real win** — FP 25→8, FN 22→34; net improvement, exact match 8/38→14/38. Also the archetype carrying `PLOT_VALUES`, the largest remaining error source. |
| `categorical_comparison_supplied_uncertainty` (`CAT`) | Net loss — FN roughly doubles (10→21), FP only modestly better (10→7). |
| `continuous_measured_series_supplied_uncertainty` (`SER`) | **Large net loss** — FN roughly doubles (39→79), FP barely moves. Accounts for most of the whole-corpus FRR increase. |

**Revised recommendation, now confirmed:** escalate `EST` responses on medium confidence
only; leave `CAT`/`SER` on `gpt-5.2`'s primary call. Tested at zero additional API spend
(the escalation results for all 105 already existed) — full 200-photo corpus, EST-gated vs.
`gpt-5.2`-alone baseline: exact match 38.5%→**41.5%**, F1 93.3%→**93.4%** (flat, still clears
DR-1), FAR 19.0%→**13.6%** (real win, still fails the ≤2% ceiling), FRR 8.0%→**9.0%**
(near-flat — none of blanket escalation's damage). This is a clean, near-strict improvement
over baseline and is now the recommended escalation policy — not blanket escalation, not no
escalation. Script: `scripts/vercel-gateway-check/hand_drawn_graph_escalation_archetype_gated_report.mjs`.
FAR still fails DR-1 by a wide margin under any policy tested so far; a working `PLOT_VALUES`
fix (concentrated in `EST`) remains the more direct lever on FAR specifically, complementary
to — not competing with — this escalation policy.

**Rejected/deferred candidates:**
- `gpt-4o-mini` (`VISION_FAST_ESC`, the pre-2026-08-18 production candidate) — fails all four
  DR-1 thresholds by a wide margin (23.0% exact / 84.5% F1 / 30.6% FAR / 20.5% FRR). Not a
  viable primary model.
- `gemini-3.1-pro-preview` as an escalation candidate — highest raw perceptual quality
  measured (59.9% point-match) but only 52% structured-output reliability on the simpler
  extraction schema, and 0/3 (even with retries, multiple token budgets) on the heavier joint
  schema. Reliability, not quality, rules it out.
- Image crop/resolution preprocessing — narrow win on `estimate_ok` (28.6%→57.1%) but flat or
  net-negative on point-match and exact match (a 20-photo smoke test at gpt-5.2 tier went
  30.0%→10.0% with crop — model got more conservative, recall dropped). Not adopted.
- `PLOT_VALUES` tolerance-calibration prompt fix — reverted (net FAR/FRR regression). The
  largest remaining error source is still open; needs a second controlled run or a narrower
  fix, not a repeat of the same general-leniency instruction.

---

## 1b. Statistics — first accuracy measurement (2026-08-19), a deliberate deviation from the Biology-first sequencing mandate

§9 below records the original architecture review's mandate: Biology quantitative graphs
first, other archetypes explicitly out of scope for this design pass. This section is a
deliberate, logged exception — done at the owner's direct request in the same session, not a
scope drift — because Statistics turned out to hold the majority of `human_shadow` content
(the biggest blind spot cited in the handoff doc) with zero accuracy work of any kind.
Full detail: `docs/research/apstats_hdg_graph_real_photo_smoke_2026_08_19/README.md`.

**Method:** genuine per-photo gold (direct visual inspection, same standard as Biology's),
`openai/gpt-5.2`, single-pass joint-judgment — same architecture as §1 recommends for
Biology. Scaled in two tiers (10 → 28 photos) specifically to avoid trusting a small-sample
directional read, the same lesson §1's escalation reversal already taught this program once.

**Result, confirmed stable across two independent full runs on all 28 real Stats photos that
exist (the ceiling without new photo capture):**

| Metric | Value |
|---|---:|
| Exact criterion-vector match | 64.3% (both runs) |
| Per-criterion F1 | 94.8% / 94.2% |
| False-accept rate | **15.4% (2/13)**, identical two cases in both runs |
| False-reject rate | 8.1% / 9.1% |

Against the same DR-1 thresholds §1/§2 use for Biology (≥95% exact / ≥90% F1 / ≤2% FAR /
≤5% FRR): F1 clears, the other three do not — same overall shape as Biology (F1 is the
easiest bar, FAR is the hard one), and roughly comparable magnitude to Biology's `gpt-5.2`
result (18.4% FAR / 7.9% FRR there vs. 15.4%/8.1-9.1% here). **Statistics is not meaningfully
easier or harder than Biology to grade with this architecture** — worth knowing before
assuming either subject needs a different approach.

**A distinct, reproducible model defect found and partially fixed, generalizable beyond this
one corpus:** on criteria requiring the model to compare a drawn image against a fact
computable from the stimulus table (mosaic-plot column-width proportions, dotplot dot
counts), the model's own stated reasoning was reliably correct (100% arithmetically correct
across every sample checked) while its final categorical verdict frequently contradicted that
same reasoning, or fabricated an extra disqualifying detail not present in its own stated
observations. **Precomputing the fact in plain code (from the same table already in the
prompt) and handing it to the model as a given, rather than asking it to both derive and
visually verify it in one pass, is a real, reproducible fix** — targeted-criteria accuracy
rose from ~0-33% (baseline, reproducibly wrong) to ~78% average (fixed, confirmed across two
full-corpus runs) — but it is not a general accuracy lever: applied to a criterion that didn't
have this specific failure shape (dotplot axis scale), it produced no measurable change,
positive or negative. **Recommendation: any production Statistics grading path should
precompute deterministic facts from the stimulus data for every criterion where that's
possible, not just pass the raw table and rely on the model to do the arithmetic itself** —
this is a design principle for the eventual real build, not just a research finding.

**Also confirmed, not yet exploited:** cross-model disagreement between `gpt-5.2` and
`claude-sonnet-4.5` is a real, usable escalation-routing signal at small scale (96.7%
selective accuracy at 75% coverage when only auto-grading on agreement) — but naively
resolving disagreements toward the more generous verdict is a trap that silently inherits
whichever model is more lenient, confirmed by data, not just argued.

**Not yet done for Statistics, mirroring §4/§5 below for Biology:** dual-human-adjudicated
gold (this smoke test's gold is single-pass, same `ai_provisional` tier as Biology's), the
6th archetype (`boxplot_construction_interpretation` — wait, this is now covered, 5 of 7 items
photographed and graded; 2 boxplot items and roughly 1-2 items in several other archetypes
still lack a real photo), and the precompute-fix pattern has not been tried on
`ASSOCIATION_DESCRIPTION`/`SHAPE_DESCRIPTION`-style free-text criteria, only on
numeric/countable ones.

---

## 2. Deployment / authority model — owner decision, not resolved here

Per handoff §"Concrete gap to production" item 5, this is a product/policy call. Options,
restated with what's now known:

| Option | Coverage | Quality | Notes |
|---|---|---|---|
| (a) Unconditional single-model (`gpt-5.2` on everything) | 100% | Weakest — 38.5% exact match, FAR/FRR both fail DR-1 | Simplest; not recommended as a sole launch shape given FAR fails 9x over ceiling |
| (b) Confidence-gated selective automation + human review for the rest | ~40.5% hands-off at response level (26.5% of all 200 both hands-off AND correct — do not cite the 70% criterion-level figure as a response-level guarantee) | Best quality on the automated slice (F1 97.4%, FRR 2.8% clear DR-1; FAR 10.9% still fails) | Protects quality, costs coverage; needs a human-review queue capable of absorbing 59.5%+ of volume |
| (c) Blanket escalation (gpt-5.2 → gpt-5.2-pro on ALL medium-confidence) | Full corpus, no shrinking | **Tested at full scale, rejected** — whole-corpus F1 93.3%→91.0% (worse), FRR 8.0%→13.3% (worse); only FAR improves (19.0%→13.6%, still 7x over ceiling) | Reversed from the 21-photo read; see §1 |
| (c') Archetype-gated escalation (escalate `EST` only) | Full corpus | **Tested, confirmed, recommended** — exact match 38.5%→41.5%, F1 93.3%→93.4% (flat), FAR 19.0%→13.6% (real win), FRR 8.0%→9.0% (near-flat). Zero additional API cost to test since the data already existed. | Clean win over both baseline and blanket escalation; still fails FAR/exact-match/FRR DR-1 ceilings, just less badly |
| (d) Hybrid: (c') first, then confidence-gate the result before treating it as authoritative | Between (b) and (c') | Unmeasured — no experiment has tested gating on top of (c')'s output | Worth testing next, now that (c') is confirmed as the escalation baseline to gate on top of |

**None of these clears all four DR-1 thresholds at full coverage today — including (c'), the
best option found so far.** The real question — explicitly per the handoff doc — is whether
a partial-coverage authoritative slice is an acceptable interim launch shape, and that is an
owner call this document does not make. **Recommendation for the owner conversation:**
present (c') — EST-gated escalation — as the current best-known escalation policy, with (a)
as the no-escalation floor and (b) as the quality-protecting alternative if the owner decides
FAR's remaining gap is unacceptable even after (c').

---

## 3. Async/latency architecture (Repository only — this is new design, nothing like it exists yet)

**This is a genuine greenfield gap**, confirmed by direct search: `evaluate-attempt` calls
its grading model synchronously in-request (`AbortSignal.timeout` + one retry, ~500ms
backoff). There is no `EdgeRuntime.waitUntil` usage, no `pg_cron`/`pgmq` job queue, and no
async-dispatch pattern anywhere in `supabase/functions/` today. `review-queue` is a
human-reviewer assignment/dashboard mechanism, not a compute-dispatch mechanism — it does not
transfer to this problem.

A `gpt-5.2-pro` escalation call measured 23-36s in testing (4-5x `gpt-5.2`'s latency). That
cannot sit in the synchronous student-facing request path the way `evaluate-attempt`
currently works, or the existing p50/p95 latency budget (§0 of the main handoff doc) is blown
badly on every escalated response — which, at the current ~52.5% medium-confidence rate, is
over half of all Engine 4 traffic.

**Proposed shape (not built, not reviewed):**
1. `evaluate-attempt` runs the `gpt-5.2` primary call synchronously as today, returns
   immediately with either a final `graded` result (high/low confidence, no escalation
   needed) or a `pending_escalation` status plus the primary result as a provisional value.
2. On `pending_escalation`, kick off the `gpt-5.2-pro` call via `EdgeRuntime.waitUntil` (or a
   dedicated background-invocation edge function triggered by a lightweight queue row) so the
   student-facing request is not held open for 23-36s.
3. A new `app.grading_escalations` (or similarly named) table tracks
   `attempt_response_id`, `primary_result`, `escalation_status` (`pending`/`complete`/
   `failed`), `escalation_result`, timestamps.
4. Client polls or subscribes (Supabase Realtime on the escalation row) for the final result;
   UX shows the provisional grade with a "still checking" indicator until escalation
   resolves, then upgrades the displayed grade if it changed.
5. Escalation failure handling: if `gpt-5.2-pro` fails (or times out) after retries, fall back
   to the primary `gpt-5.2` result rather than leaving the student with no grade — needs an
   explicit design decision on whether this fallback is flagged for human review or served
   as-is.

This needs its own design review before being built — it touches student-facing latency
guarantees and a new failure mode (escalation never resolves) that doesn't exist in any
current engine. Flagging it here as the concrete next design task, not attempting to fully
spec it in this pass.

---

## 4. Gold-set requirement — the real blocker before any launch claim

`CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2 requires, before first production release of an
AP Biology grader: **≥300** independently-sourced responses, **≥40 per FRQ archetype**
(so ≥40 each of `CAT`/`SER`/`EST`), ≥25 positive/≥25 negative per criterion where feasible,
≥15% partial-credit, ≥10% equivalent-language, ≥10% contradictory, ≥10%
ambiguous/adversarial/abstention-worthy. §10.5 is explicit: **"Author-generated samples are
development cases. They do not establish a human gold set... Gold evidence requires blind
independent human scoring and adjudication."**

The current 200-photo real-photo gold (`real_photo_gold_labels_2026_08_18.json`) is
single-pass `ai_provisional` — 20 independent AI graders, one pass each, no human involved,
no adjudication. **This does not satisfy §12.2 today, regardless of how good the accuracy
numbers on it look.** Every metric in this document and the source research doc is a strong
R&D signal, not a launch-qualifying number, until a real dual-human-adjudicated pass exists.

**This competes for scarce reviewer time** (per [[feedback_content_review_assignment_policy]]
and DECISION-0045's reviewer-scarcity framing) — sequencing this against existing reviewer
commitments is itself an owner call, not something to assume is free capacity.

---

## 5. Corpus cleanup — before treating the 200-photo set as any kind of benchmark reference

Independent of grading accuracy, real defects were found in the corpus itself:
1. **Systematic axis-tick corruption on 11 `EST` items** — a shared template/printing defect
   (confirmed via duplicate photos sharing identical corrupted values), not a drawer error.
2. **29/200 photos** show `not_earned` on missing axis units — near-universal, worth checking
   whether this is a real rubric gap or a corpus-wide capture/printing issue.
3. **≥7 likely-misfiled photos** (wrong item's content under a given item's filename).
4. **Packet 2 (floral-background scans)** systematically lower quality than packets 1/3.

None of this should block the escalation full-scale run (item 1 below is already in flight
and doesn't depend on corpus cleanup), but any number computed on this corpus that will be
shown to an owner as a launch-readiness signal should be re-run defect-excluded first, or at
minimum caveated.

---

## 6. Open governance question, not resolved here

Whether `ZERO_INTERCEPT_ANNOTATION` should credit a corrupted-axis item when the student's
demonstrated work is otherwise correct (strict-verification-against-the-printed-axis vs.
fair-to-the-student standards). Real arguments both ways, documented in the source research
doc. Flagged for owner/adjudicator decision; gold left unchanged pending that call. Do not
resolve this unilaterally in a future session — it was deliberately left open once already.

---

## 7. Mapping current state onto the QR → observation → gold → abstention → shadow sequence

The ledger's standing instruction (`GRADING_PROGRAM_LEDGER_2026_07_27.md` line 76/289) is to
continue Engine 4 only through this sequence — no shortcuts. Here is where each phase
actually stands as of this design pass:

| Phase | Status | Evidence |
|---|---|---|
| **QR (capture)** | Built but **not wired to canonical content** | TASK-0020 finding: the deployed QR/photo capture UI is real, but feeds a client-side placeholder generator (`placeholder-handdrawn-*`), not real content. `app.response_versions` has no image-attachment column in schema at all. **This is a separate, still-open blocker** from anything in this design doc's accuracy work — the accuracy investigation ran entirely against a static offline photo corpus, never through this capture path. |
| **Observation (perception)** | Engineering-validated, not governance-approved | Joint-vs-decomposed perception tested and resolved (joint wins); model-backbone ablation resolved (`gpt-5.2` clears F1); OCR probe explored as a supplementary lead (promising for equations, not for the point-detection problem graphs need). No formal observation bake-off against a held-out set has been run per the original architecture review's Phase 2 definition. |
| **Gold** | **The concrete next blocker** | 200-photo `ai_provisional` gold exists; §12.2's dual-human-adjudicated requirement (≥300, ≥40/archetype) is not started. See §4 above. |
| **Abstention / confidence calibration** | Partially done, incomplete | Selective-prediction re-analysis shows criterion-level gating clears F1/FRR (not FAR) at ~40.5% response-level coverage. Escalation-as-alternative-to-gating is the open lever (§0-1 above), full-scale number pending. |
| **Shadow** | **Not started for real traffic** | 59 `human_shadow`-tagged content item versions exist in the DB (24 published), but — consistent with the Engine 1/3 zero-real-student finding confirmed the same day (handoff UPDATE 2026-08-18b) — Engine 4 has never graded a real student response. "Shadow" here currently means "tagged in the DB," not "running against live traffic in shadow mode." |

**Do not report Engine 4 as being "in shadow"** without qualifying that no real student
traffic has ever reached it — the tag exists, the mode doesn't yet.

---

## 8. Ordered next steps

Supersedes/refines handoff §"Concrete gap to production" with this design pass folded in:

1. **DONE.** Full-scale escalation run completed same day (105/105, $4.85, 0 failures) —
   blanket escalation reverses the 21-photo read (rejected); see §1/§2 above.
2. **DONE.** Archetype-gated escalation (EST only) tested at zero additional spend and
   confirmed as a clean win — exact match 38.5%→41.5%, FAR 19.0%→13.6%, F1 flat, FRR
   near-flat. This is now the recommended escalation policy (option c' in §2).
3. **Plan the dual-human-adjudicated gold pass** (§4) — scope it against reviewer capacity
   before committing a date; this is likely the longest-pole item, not the escalation number.
4. **Resolve the `ZERO_INTERCEPT_ANNOTATION` corrupted-axis policy question** (§6) via real
   adjudication.
5. **Corpus cleanup** (§5) — fix or exclude the 11 corrupted-axis `EST` items and the ≥7
   misfiled photos before this corpus is cited as an official benchmark reference.
6. **Design-review the async escalation architecture** (§3) before building it — it's a new
   failure-mode surface (latency guarantee, escalation-never-resolves handling) that doesn't
   exist anywhere else in the codebase yet.
7. **Unblock the QR capture → canonical content path** (separate from this doc's scope, but a
   hard prerequisite before Engine 4 can grade anything real regardless of model accuracy) —
   this is TASK-0020's Program B finding, still launch-blocked as of 2026-08-03/04.
8. **`PLOT_VALUES` fix, take two** — largest remaining error source, one attempt already
   reverted. Needs a second controlled run or a narrower-scoped fix.
9. **Optional, separate track:** formalize the OCR-for-equations finding (§ investigation
   item 6) into a real Engine 3 pilot. Not a continuation of Engine 4's graph work — don't let
   it consume Engine 4 sequencing.
10. **OCR-for-graphs value assessment** — a full experiment design now exists:
    `docs/research/OCR_VALUE_ASSESSMENT_EXPERIMENT_DESIGN_2026_08_18.md`. Scopes OCR alone,
    OCR-as-escalation-trigger, and OCR-as-primary-with-`gpt-5.2`-escalation, criterion-level
    (OCR can only ever reach ~2-5 of 6-9 criteria per archetype — axis scale/unit and the
    written estimate value, never shape/mark/category judgment). Blocked on an
    orientation-invariant axis-role-assignment fix (the same bug the full-scale OCR probe
    reproduced) before any of the three configurations produce a trustworthy number.
11. **Statistics (§1b): adopt "precompute deterministic facts from the stimulus table" as a
    standing design principle** for any production grading prompt-builder, not just a one-off
    fix for mosaic plots — apply it wherever a criterion asks the model to compare a drawing
    against something arithmetically derivable from data already in the prompt.
12. **Statistics: dual-human-adjudicated gold**, same requirement and same gap as Biology's
    §4 — the 28-photo smoke-test gold is single-pass, not the governance-required standard.
13. **Statistics: photograph the remaining uncaptured items** (2 boxplot items, a handful
    across other archetypes) — 28 of 40 corpus items have a real photo today; this smoke test
    already used every one that exists.
14. **Statistics: extend the precompute-facts fix to `ASSOCIATION_DESCRIPTION`/
    `SHAPE_DESCRIPTION`-style criteria** — untested territory; the fix so far only covers
    numeric/countable criteria (`WIDTHS_BY_TOTAL`, `DOT_COUNTS`), not free-text descriptive
    ones, which showed their own (different, boundary-clarity-shaped) disagreements this
    session.

## 9. Explicit non-goals for this design pass

- Image annotation/overlays on student photos — deferred per the original architecture
  review pending a localization benchmark that has never been run. Not reconsidered here.
- Non-Biology archetypes (e.g. Econ multi-curve graphs) — explicitly out of scope per the
  original architecture review's sequencing mandate (AP Biology quantitative graphs first).
  **Exception, logged: Statistics was measured 2026-08-19 at the owner's direct request —
  see §1b. That was a deliberate, in-session deviation from this sequencing mandate, not a
  reversal of it; other non-Biology archetypes remain out of scope until the owner extends
  the exception explicitly.**
- Vendor lock to any single model provider before a held-out bake-off — the model-backbone
  ablation in this investigation is real evidence but was run on one corpus with AI-provisional
  gold; do not treat "gpt-5.2/gpt-5.2-pro" as a permanent commitment ahead of the adjudicated
  gold pass.

---

**See also:** `docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md` (parent handoff doc),
`docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md` (source evidence),
`docs/research/DRAWN_RESPONSE_ARCHITECTURE_REVIEW.md` (original architecture mandate),
`docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` §12.2/§10.5 (gold-set requirement).
