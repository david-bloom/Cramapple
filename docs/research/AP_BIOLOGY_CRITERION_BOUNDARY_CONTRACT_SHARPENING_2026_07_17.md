# AP Biology Criterion-Boundary Contract Sharpening — Proposal, 2026-07-17

**Task:** TASK-0010 (Grader Confidence and Calibration), Phase 2 → boundary-contract sharpening
**Status:** ADOPTED (guard rails) — **DECISION-0042 (2026-07-17)** adopted the depth-threshold policy, approved `L-001/b` (1/2), resolved `L-009/b` (1/2, Orly's call, with a two-gap coaching contract), and executed the `L-001/a_i` variant-scope fix. All four ranked decisions are resolved. Labels still lock only through the human dual-blind pass (§12.1); one emphasis-only coaching confirmation remains on `L-009/b`.
**Authority:** These are *proposed* dispositions authored against each item's rubric
`evidence_requirements`. They are not `adjudicated_gold` and do not set labels. Each
adopted revision is a **C2 change** under `../architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`
§16.3, requires **Learning Quality (Orly) sign-off**, and — per
`../architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §11 — **Product Owner
(David) approval** before it lowers or changes any grading gate.
**Inputs:** the 9-item adjudication queue in
`ap_biology_gold_set_candidate_2026_07_08/provisional_labels.json`; the consolidated
triage in `grading_label_adjudication_queue_2026_07_08.md`; the third-opinion pass in
`THIRD_OPINION_GRADING_ISSUES_2026_07_08.md`.
**Contract structure:** every draft below follows the seven required elements of a
criterion-boundary contract (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §9.1).

---

## Why this document exists

The triage queue (`grading_label_adjudication_queue_2026_07_08.md`) got the AP Biology
disputes to "human decides / human sets the boundary." It stopped short of *drafting the
boundary language itself*. This document does that next step: for each flagged AP Biology
(item, criterion) pair, it proposes the §9.1 contract text and a recommended disposition,
so the human Lead adjudicator is signing off on concrete rules rather than starting from a
blank sheet. It also adds `APBIO-FRQ-L-017 / a`, which is in the provisional-label
adjudication queue but was not carried into the earlier triage table.

**What a sign-off produces:** the boundary contracts here become the guard rails the
adjudicated gold set is scored against, which is the review that unblocks
`AP_BIOLOGY_VERIFICATION_PROFILE.json` (`blocked_until` → "adjudicated AP Biology gold-set
calibration review").

---

## The one decision that resolves five of the nine items

Five queue items are the **same question wearing different biology**: on a 2-point
*describe / explain / trace* criterion, a response gives the correct direction/outcome and
names the correct actors, but omits a finer mechanistic step the `evidence_requirements`
also lists. Does it earn full, partial, or nothing?

Answering this once, consistently, is worth more than nine separate calls — and AP Readers
already work this way (point-per-required-element, "explain" points require the causal
link, a missing *distinct step* is treated differently from a missing *fine detail*).

### Governing policy — "depth threshold for explanation criteria" — ✅ ADOPTED (DECISION-0042, 2026-07-17)

> A required element earns its point when the response **(1) names the correct actor(s)
> and (2) states the correct causal relationship, direction, or outcome that the element
> tests.** Omitting a finer sub-mechanistic intermediate that the rubric lists as
> *enrichment* does **not** void the point.
>
> A required element does **not** earn when the response:
> - **(a)** states the wrong direction/outcome (a fluent, complete, confident wrong answer
>   still earns nothing — self-reported model confidence is not evidence, per TASK-0010
>   Phase 3 and the SP-1 finding), **or**
> - **(b)** gives only a definitional restatement in place of the required causal link, **or**
> - **(c)** omits a *distinct required transformation/step* (not merely a finer detail of a
>   step it already has).

The per-item drafts below apply this policy. If Learning Quality adopts a stricter or looser
threshold, the five dispositions move together and stay consistent — that is the point of
deciding it once.

### Disposition summary

| # | Item / criterion | Response type | AI provisional | **Proposed disposition** | vs AI | Governed by |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | `L-001` / `a_i` | partially_correct | partially_earned | **partially_earned (1/2)** | concur | depth policy (b) + variant-scope fix |
| 2 | `L-001` / `a_ii` | subtly_wrong | not_earned | **not_earned (0/2)** | concur | depth policy (a) — negative anchor |
| 3 | `L-001` / `b` | subtly_wrong | not_earned | **partially_earned (1/2)** | **move-candidate ↑** | element independence + voiding rule |
| 4 | `L-009` / `a` | subtly_wrong | partially_earned | **partially_earned (1/2)** | concur (already corrected) | element independence |
| 5 | `L-009` / `b` | borderline | partially_earned | **partially_earned (1/2)** | concur | depth policy (c) + organism-name call |
| 6 | `L-017` / `a` | borderline | earned | **earned (2/2)** | concur | depth policy (enrichment) |
| 7 | `L-033` / `b` | borderline | partially_earned | **partially_earned (1/2)** | concur | depth policy (b) |
| 8 | `L-033` / `c` | borderline | partially_earned | **partially_earned (1/2)** | concur | depth policy (a/b) — near partial/zero line |
| 9 | `L-033` / `d` | subtly_wrong | not_earned | **not_earned (0/2)** | concur | contradiction void — negative anchor |

**All four ranked decisions resolved (DECISION-0042).** `L-001/b` (#3) approved at 1/2;
`L-009/b` (#5) resolved at 1/2 (Orly) with a two-gap coaching contract; the depth policy is
adopted; the `L-001/a_i` fix is executed. Everything else concurs with the AI provisional label
or confirms an already-converged correction. No ranked decision remains open — only the human
dual-blind pass (to lock labels) and one emphasis-only coaching confirmation on `L-009/b`.

---

## Per-criterion boundary-contract drafts

Each block is proposed §9.1 contract text for the named criterion. "Worked examples" cite
responses already in the candidate set so the contract is self-guarding.

### 1. `APBIO-FRQ-L-001 / a_i` — light compensation point: identify + explain

- **Decision rule (independently decidable):** Two independently-awardable points.
  **P1 (identify):** states compensation point = 75 µmol photons/m²/s. **P2 (explain):**
  states that *at that point the rate of O₂ produced by photosynthesis equals the rate of
  O₂ consumed by respiration* (gross photosynthesis = respiration).
- **Evidence that must appear to earn P2:** an explicit *rate-equality* statement — "photosynthesis
  rate = respiration rate," or "gross photosynthesis (~2.0 µmol O₂/m²/s) offsets dark
  respiration."
- **Accepted equivalents (P2):** "gross photosynthesis = respiration"; "photosynthetic O₂
  output balances respiratory O₂ uptake."
- **Related-but-insufficient — must NOT earn P2, with reason:** "net O₂ = 0," "the line crosses
  zero," "no net gas exchange." *Reason:* net O₂ = 0 is the **definition** of the compensation
  point; the criterion asks what that point *indicates about the two rates*. A definitional
  restatement is not the required causal statement (depth policy case **b**).
- **✅ Variant-scope fix — EXECUTED 2026-07-17 (DECISION-0042).** `"net O2 is zero"` was
  removed from the criterion's `accepted_variants`, and an explicit boundary clause was added
  to `evidence_requirements` ("stating only 'net O2 = 0' or 'the line crosses zero' identifies
  the compensation point but does NOT satisfy the explanation requirement…"). Applied to all
  four artifacts that carried the inconsistent list: `ap_biology_frq_bootstrap_corpus_2026_07_07.json`,
  `ap_biology_frq_full_export_2026_07_07.json`, `apbio_frq_tutor_ready_packet.json`, and the
  candidate package's `provisional_labels.json`. The definitional phrasing now supports **P1
  (identify)** via the value `75` in `evidence_requirements`, but no longer earns **P2 (explain)**.
- **Contradicting evidence that voids:** asserting the rates are *unequal* at the compensation
  point voids P2.
- **Worked near-boundary positive (P2 earns):** `L-001 / fully_correct / a_i` — "the rate of
  O₂ produced by photosynthesis exactly equals the rate of O₂ consumed by cellular respiration
  (gross photosynthesis = respiration)."
- **Worked near-boundary negative (P2 does not earn):** `L-001 / partially_correct / a_i` —
  "75 … that's where the net O2 exchange line crosses zero." P1 earns, P2 does not → **1/2**.
- **Guarding case IDs (post-gold):** positive `L-001/fully_correct/a_i`; negative
  `L-001/partially_correct/a_i`.

### 2. `APBIO-FRQ-L-001 / a_ii` — effect of doubling CO₂ on compensation point

- **Decision rule:** earns only if the response predicts the compensation point **DECREASES**
  (shifts to lower light) **and** ties it to CO₂ no longer limiting the Calvin cycle. Wrong
  direction → 0/2 regardless of explanation fluency.
- **Evidence that must appear:** "compensation point decreases / shifts left" + "more CO₂ →
  Calvin cycle faster at a given light level → less light needed to offset respiration."
- **Accepted equivalents:** "shifts to lower light intensity"; "CO₂ no longer limiting, so
  less light needed."
- **Related-but-insufficient / must NOT earn:** any prediction of **increase**, however
  well-argued. This is the canonical **confidently-wrong-but-complete** failure: the flagged
  response predicts an increase with plausible "higher ATP/NADPH demand" reasoning. Depth
  policy case **(a)** — wrong direction is dispositive.
- **Contradicting evidence that voids:** predicting the point rises / needs more light.
- **Worked positive:** `L-001 / fully_correct / a_ii` — "would decrease … Calvin cycle no
  longer as CO₂-limited … lower light intensity sufficient."
- **Worked negative:** `L-001 / subtly_wrong / a_ii` — "would actually increase … needs
  higher light intensity to keep up with carbon fixation demand." → **0/2**.
- **Guarding case IDs:** negative `L-001/subtly_wrong/a_ii` (flagship confidence-vs-correctness
  anchor for the confidence-calibration work in Phase 3).

### 3. `APBIO-FRQ-L-001 / b` — light reactions → ATP (✅ APPROVED at 1/2 — DECISION-0042)

- **Disposition APPROVED (2026-07-17):** `partially_earned` (1/2), the independent-element reading below. One step up from the AI provisional `not_earned`. Labels still lock only through the human dual-blind pass.
- **The dispute:** the response names the ETC (PSII → PSI) correctly **and** names the proton
  gradient + ATP synthase + chemiosmosis + ADP+Pi — but **reverses the proton-pump direction**
  (says H⁺ pumped lumen→stroma, then flowing stroma→lumen; both backwards). AI = not_earned
  (med confidence); the earlier Claude re-grade leaned partially_earned. **This is the one
  genuine up-or-hold call in the set.**
- **Root ambiguity to resolve (the real C2 decision):** the rubric says *"Two of these three
  elements required for full credit."* The boundary contract must state whether **one** clean
  required element earns **1 pt (partial)** or whether the criterion is all-or-nothing at the
  two-element threshold.
- **Proposed decision rule:** scored as up to two points. Element 1 (light excites electrons →
  ETC from PSII to PSI) and Element 3 (chemiosmosis: H⁺ flows down its gradient through ATP
  synthase to phosphorylate ADP) are **independently awardable, 1 pt each, capped at 2**. A
  reversed proton-pump / reversed chemiosmotic direction **voids the element it describes**
  (Element 2/3) but **does not retract a separately-correct element**.
- **Applying it to the flagged response:** Element 1 is stated correctly and independently →
  **1 pt.** Element 3 is *voided* by the reversed direction (pumping into the stroma with ATP
  synthesis driven by flow into the lumen is not chemiosmosis — it is its inverse). Net →
  **partially_earned (1/2)**, i.e., **one step up from the AI label.**
- **Related-but-insufficient / must NOT earn:** naming "ATP synthase" and "proton gradient" as
  vocabulary while describing flux in the wrong direction does not earn the chemiosmosis point.
- **Contradicting evidence that voids:** reversed transport direction voids only the coupling
  element, per the rule above.
- **Worked positive:** `L-001 / fully_correct / b` — correct PSII→ETC→PSI and H⁺ pumped stroma→lumen.
- **Worked negative (voided element):** `L-001 / subtly_wrong / b` — proton direction reversed.
- **Note for the Lead:** if Learning Quality prefers the stricter all-or-nothing reading (need
  two *fully correct* elements for any credit), the disposition holds at not_earned (0/2). The
  contract must pick one; the recommendation is the independent-element reading, which matches
  AP Reader convention and how the other 2-point criteria in this set are already worded.

### 4. `APBIO-FRQ-L-009 / a` — ecological efficiency: calc + explain + calc

- **Decision rule:** P1 = correct efficiency calculations (42/500 = 8.4%; 4.2/42 = 10%).
  P2 = correct phytoplankton mass (50,000 kg = 50 ÷ 0.1³, three transfers) **with** at least
  one valid energy-loss mechanism.
- **Element-independence rule (the anchor this case establishes):** **P1 earns on its own merits
  even when P2's explanation contains a misconception and P2's arithmetic is wrong.** A correct
  element is not retracted by an unrelated wrong element in the same criterion.
- **Related-but-insufficient / must NOT earn P2:** "bigger animals waste more energy just
  existing" (body-size/complexity misconception — not a valid loss channel); tuna mass counting
  only two transfers (5,000 kg).
- **Contradicting evidence that voids:** none affecting P1; P2 fails on its own.
- **Worked positive (P1):** the flagged response itself — "42/500 = 8.4% … 4.2/42 = 10%."
- **Worked negative (P2):** same response — "50 × 10 × 10 = 5,000 kg … counting two transfers"
  + body-size loss claim. → **partially_earned (1/2)**.
- **Status:** already corrected in the label-robustness pass; Claude re-grade and Codex
  third-opinion **converge**. Included to *encode the independence rule*, not to relitigate.

### 5. `APBIO-FRQ-L-009 / b` — trace a nitrogen atom (✅ RESOLVED 1/2 — Orly's call, DECISION-0042)

- **Disposition RESOLVED (2026-07-17, Orly / Learning Quality):** **partially_earned (1/2).**
  P1 (process backbone) earns; P2 is withheld. Recorded per DECISION-0042 — closes the last of
  the four ranked decisions.
- **Decision rule:** P1 = correctly name & sequence fixation → nitrification → uptake →
  assimilation. P2 = include plant uptake **+ nitrate reduction + amino-acid synthesis** and
  the named organisms.
- **Why 1/2 (product rationale, not only rubric purity):** the grading engine's coaching path
  (`grading-feedback.ts` → `highest_value_gap`, ranked by `points_possible /
  estimated_repair_effort` and surfaced with `minimum_fix` + `predicted_improvement`) is built
  to push students to their cheapest next point. A whole-pathway response scored **1/2** reads
  as "you are one specific addition from a point" — exactly the high-leverage, low-effort repair
  the ranking prioritizes; **0/2** makes the same content look like a vaguer rebuild and muddies
  that signal. 1/2 also matches the real modern AP Bio standard (process points generally are
  not gated on memorized genus names) and still flags incompleteness (not 2/2), preserving
  coaching pressure.

#### Coaching contract for `L-009/b` (authored per DECISION-0042)

The score does not coach — the `minimum_fix` does. Coaching for this criterion **must name BOTH
point-2 gaps** so the student can capture the whole second point, not one half of it:

1. **Nitrate-reduction step** — the concrete missing element and the point-securing one in
   *either* reading: NO3- taken up by the roots is reduced back to NH4+ in the plant before
   amino-acid synthesis.
2. **Organism naming** — *Rhizobium* (fixation), *Nitrosomonas / Nitrobacter* (nitrification).

**Framing of the organism gap follows one factual input — does the operational AP standard for
this content require genus names?**
- **If required →** imperative: *"you must name the organisms (Rhizobium, Nitrosomonas) and
  include the nitrate-reduction step."*
- **If enrichment →** *"naming the organisms strengthens this; the missing point is the
  nitrate-reduction step"* — so we do not send students to memorize genus names they do not need.

**Working default = enrichment** (recommended, moderate-high confidence): released AP Biology
nitrogen-cycle scoring has historically credited "bacteria" / "nitrogen-fixing bacteria" for the
process points without requiring specific genera. The live `minimum_fix` (updated 2026-07-17)
uses an **enrichment-safe** wording — names both gaps, makes nitrate-reduction the point-securing
element, frames organisms as "strengthen further" **without asserting they are optional** — so it
stays correct even if the standard turns out stricter. **One confirmation flips it to imperative:**
Orly confirming the target standard requires genera → change "strengthen further by naming…" to
"you must name…" (a one-line C2 edit). This is the only residual on this item, and it changes
emphasis, not the 1/2 score or the student-facing behavior.

- **Related-but-insufficient / must NOT earn P2:** naming uptake + protein synthesis while
  skipping nitrate reduction and all organisms.
- **Worked negative:** the flagged borderline response — "fixation … nitrification … plants
  take up … make amino acids and proteins," no organisms, no nitrate reduction.
- **Cross-check (do not conflate):** the `subtly_wrong` variant of `L-009/b` is a *different*
  and clearly-wrong response ("N₂ → nitrate directly … built into proteins without further
  conversion") — not part of this borderline call; it is not_earned on its own facts.

### 6. `APBIO-FRQ-L-017 / a` — insulin signaling cascade (added; not in earlier triage)

- **Decision rule:** P1 = RTK activation (receptor kinase activation / auto-phosphorylation →
  IRS-1 phosphorylation). P2 = the PI3K → Akt → GLUT4 relay ending in increased glucose uptake.
- **Depth-policy application (the reason this is `earned`):** the two rubric points are named at
  the level of "RTK activation" and "PI3K→…→GLUT4 mechanism." **PIP2→PIP3 and AS160 are
  enrichment detail, not required gates.** The flagged response names the full required relay
  (receptor kinase → IRS-1 → PI3K → Akt → GLUT4 → glucose uptake) with the correct direction
  and outcome for both points.
- **Proposed disposition:** **earned (2/2)** — concur with AI. This is the clearest positive
  test of the depth policy: correct actors + correct outcome earn even when sub-molecular
  intermediates are omitted.
- **Related-but-insufficient / must NOT earn:** naming only "insulin activates a pathway that
  increases glucose uptake" without the intermediary relay actors (IRS-1, PI3K, Akt) → the
  actors *are* the required content.
- **Contradicting evidence that voids:** routing insulin through cAMP/PKA (the epinephrine
  pathway) voids the mechanism. (The flagged response correctly reserves cAMP/PKA for
  epinephrine in part b.)
- **Worked positive:** the flagged response — full relay named.
- **Consistency guard:** if Learning Quality instead rules PIP2→PIP3/AS160 *required*, then the
  depth policy tightens and **`L-033/b,c` and `L-009/b` must move in lockstep.** Do not tighten
  one criterion's depth bar without the others.

### 7. `APBIO-FRQ-L-033 / b` — pathway producing CO₂ in yeast + why

- **Decision rule:** P1 = identify glycolysis + **alcoholic (ethanol) fermentation**. P2 =
  explain CO₂ is released at the **decarboxylation of pyruvate → acetaldehyde** (pyruvate
  decarboxylase), the step specific to ethanol fermentation.
- **Depth-policy application (case b):** the flagged response — "fermenting … releases CO₂ …
  along the way to making alcohol" — identifies the correct pathway (P1 ✓) but does **not
  explain why** CO₂ is released (no decarboxylation). The prompt explicitly asks to *explain
  why*.
- **Proposed disposition:** **partially_earned (1/2)** — concur with AI. Identify earns; the
  causal "why" does not.
- **Related-but-insufficient / must NOT earn P2:** "CO₂ is a byproduct of fermentation" as a
  bare assertion; naming lactic-acid fermentation (which does not release CO₂ — voids P1, see
  the subtly_wrong variant).
- **Contradicting evidence that voids:** attributing the CO₂ to lactic-acid fermentation.
- **Worked negative (P2 not earned):** the flagged borderline response.
- **Worked contradiction (whole-criterion void):** `L-033 / subtly_wrong / b` — "lactic acid
  fermentation … CO₂ from this lactate-forming step" (factually impossible).

### 8. `APBIO-FRQ-L-033 / c` — CO₂ with O₂ present (near the partial/zero line)

- **Decision rule:** P1 = predict a **shift toward aerobic respiration** (Pasteur effect).
  P2 = explain the CO₂/energetics: **more CO₂ per glucose** (6 from Krebs vs effectively 2
  from fermentation) **and/or** NADH now oxidized by the ETC instead of reducing acetaldehyde.
- **Depth-policy application (cases a + b):** the flagged response — "regular cellular
  respiration … usually makes more energy, so CO₂ … a bit different" — earns P1 (names the
  aerobic shift + more ATP) but P2 fails: "a bit different" states **no clear direction** and
  gives **no quantitative or NADH-fate reasoning**.
- **Proposed disposition:** **partially_earned (1/2)** — concur with AI, but flag: this sits
  right on the partial/not-earned line. If Learning Quality requires a *committed CO₂ direction*
  for P1 (not just "shift to respiration"), it drops to 0/2. Recommend holding at 1/2 (the
  aerobic-shift identification is genuine content).
- **Related-but-insufficient / must NOT earn P2:** "CO₂ would be a bit different"; "more energy"
  with no link to CO₂ yield or NADH fate.
- **Contradicting evidence that voids P2:** claiming aerobic respiration produces **no** CO₂
  (see the subtly_wrong variant's part c) — factually wrong, voids.
- **Worked negative:** the flagged borderline response.

### 9. `APBIO-FRQ-L-033 / d` — distinguish fermentation-CO₂ from aerobic-CO₂

- **Decision rule:** earns for proposing a *valid discriminating measurement* — measure ethanol
  (≈1:1 with fermentation CO₂) alongside CO₂, or monitor O₂ consumption.
- **Proposed disposition:** **not_earned (0/2)** — concur with AI. The flagged response proposes
  "measuring CO₂ alone is enough," which distinguishes nothing.
- **Contradicting / self-voiding evidence (the anchor this case establishes):** the proposal
  rests on the response's own **contradicted premise** — its part b claims lactic-acid
  fermentation (no CO₂), so part d concludes "any CO₂ must be aerobic." The experiment's entire
  premise is that fermentation produces the measured CO₂. **This is the runtime
  internal-contradiction target** for `AP_BIOLOGY_VERIFICATION_PROFILE.json` → `required_checks`
  → "internal-contradiction check (an otherwise-earning claim voided by a contradicting
  statement elsewhere in the response)." Use this response as the profile's contradiction-check
  regression fixture.
- **Related-but-insufficient / must NOT earn:** "just measure CO₂"; any method that does not add
  an ethanol or O₂ signal.
- **Worked negative:** `L-033 / subtly_wrong / d`.

---

## Deterministic-layer hand-offs

Two queue items double as verification-profile fixtures (zero-API-cost checks, independent of
the boundary contracts):

1. **`L-033 / subtly_wrong / d`** — internal-contradiction check regression fixture (lactic-acid
   premise in part b propagates to part d). Add to the profile's contradiction-check test set.
2. **`L-009 / subtly_wrong / a`** — the tuna calc (5,000 kg, two transfers) is a
   calculation/trophic-transfer check candidate, though the Biology slice was scored as
   judgment-heavy; log as a *possible* deterministic target, not a required one.

---

## What sign-off unblocks / does not

**On adoption (Learning Quality + Product Owner), this enables:**
- Encoding these seven §9.1 contracts into the AP Biology FRQ packages (C2 changes, §16.3).
- Scoring the adjudicated gold set against fixed guard rails → the calibration review that
  clears `AP_BIOLOGY_VERIFICATION_PROFILE.json`'s first `blocked_until`.

**This does NOT:**
- Upgrade the candidate package to `adjudicated_gold` — that still requires **two qualified
  human Grading Validators scoring blind + Lead adjudication** (§12.1). These drafts are
  *inputs* to that pass, not a substitute for it.
- Set any release-threshold quality claim. Labels remain `calibration` until the human pass.

## Open decisions for Learning Quality (ranked)

1. ~~**Adopt the depth-threshold policy?**~~ — ✅ ADOPTED, DECISION-0042 (2026-07-17).
2. ~~**`L-001/b` up-or-hold**~~ — ✅ APPROVED at 1/2 (independent-element reading), DECISION-0042.
3. ~~**`L-009/b` organism-name strictness**~~ — ✅ RESOLVED at 1/2 (Orly's call), DECISION-0042. Coaching contract authored (names both point-2 gaps; enrichment-default framing). Sole residual: Orly confirming whether the target standard requires genera flips the organism wording from "strengthen further" to "you must name" — a one-line C2 edit, no score/behavior change.
4. ~~**`L-001/a_i` variant-scope fix**~~ — ✅ EXECUTED, DECISION-0042 (all four corpus artifacts).

**All four ranked decisions are now resolved.** Remaining for the human dual-blind pass: all nine dispositions lock as labels only after two qualified Grading Validators score blind + Lead adjudication (§12.1); the calls above set the guard rails that pass is scored against.

## Claims supported / not supported

**Supported:** each draft is traceable to the item's `evidence_requirements` and a specific
in-corpus response; the depth policy makes the five depth items mutually consistent; the two
deterministic-layer hand-offs are concrete.

**Not supported:** any `adjudicated_gold` status; any release recommendation; any disposition
as *final* — all nine are proposals pending the human dual-blind pass and the two named
approvals.
