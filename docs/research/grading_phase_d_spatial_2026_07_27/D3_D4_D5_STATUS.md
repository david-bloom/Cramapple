# TASK-0016 Phase D — D3/D4/D5 Status and Evidence Mapping

**Written:** 2026-08-19. Purpose: honestly reconcile what the Phase D execution prompt specifies
for Stages D3 (real handwritten evidence + locked gold), D4 (observation bake-off in gates), and
D5 (calibrated abstention) against what this program's existing research already provides —
without re-running expensive experiments just to produce artifacts under the exact filenames the
prompt names, and without silently claiming a stage is "done" when it isn't.

---

## D3 — Real handwritten evidence and locked gold

**Method superseded, not the requirement itself.** The Phase D prompt's original D3 spec (blind
dual-human labeling, two independent qualified reviewers, lead-reviewer adjudication) was retired
for Engine 4 specifically by `DECISION-0050`/`APPROVAL-0045` (2026-08-19), replaced by
`DECISION-0045`'s AI-generation/verification + reader-certification model. **The AI-verification
half of that replacement method has been executed** against both real-photo corpora that exist:

- Biology: 200 photos, `decision_0045_verification_2026_08_19/` (91.5%/89.7% verifier agreement,
  88.5% unanimity, 31 flagged discrepancies).
- Statistics: 28 photos, same directory name under the Statistics research folder (87.5%/72.3%
  agreement, 71.4% unanimity, 6 flagged discrepancies).

**Still genuinely blocked, and not something an AI agent can supply:**

1. **Human reader-certification** — both corpora have a ready-to-run audit-sample package (see
   each verification README's "outstanding" section); this needs a qualified human reader's time.
2. **Corpus volume.** The Phase-1 spec's release-corpus target is 300 responses, 100 per archetype
   (3 archetypes), split 90 development / 60 calibration / 120 locked holdout / 30 challenge.
   Current real-photo counts are 200 (Biology, ungated across all archetypes — not evenly
   distributed 100/archetype) and 28 (Statistics, a different subject's archetype set entirely,
   not additive toward Biology's target). **Neither corpus is close to the target volume**, and
   closing that gap requires *more real people photographing more real handwritten responses* —
   this is physical data collection, not something any amount of AI compute substitutes for. If
   this becomes a priority, the concrete next step is scoping how many additional real responses
   per archetype are needed and who produces them (the same creator pool already confirmed for
   the existing corpus: owner, Orly Bloom, Micah Bloom, contracted freelancers).

**D3 status: partially satisfied under the new method, volume-blocked, reader-time-blocked.** Not
"done," but the blocking items are now precisely scoped rather than vague.

---

## D4 — Observation bake-off in gates

**Not run as the prompt's exact 4-arm gated structure** (D4a no-cost regression → D4b small paid
confirmation on ≥12 dual-human-labeled responses → D4c calibration expansion → D4d one-time locked
holdout, each with pre-registered cost caps and owner sign-off before opening). **But the core
question that structure exists to answer — does representation/architecture choice matter, and
which wins — has a real, evidence-backed answer already, established in the 2026-08-18
investigation:**

| D4's 4 arms | What was actually tested | Result |
|---|---|---|
| 1. Direct multimodal criterion grading (control) | `gpt-5.2`, joint perception+judgment, single call | **Winner** — 73.8% point-match |
| 2. Multimodal observation → separate criterion grading | Explicit extraction-only probe (perception, then judgment as a separate stage) | Strictly worse — 20.2% point-match. Perception errors compound rather than isolate when split. |
| 3. Deterministic geometry/OCR → separate criterion grading | OCR explored as a supplementary lead, not a full pipeline arm | Confirmed as speed-only (300ms, free, local), not a judgment source, in three separate tests (alone / as a publish-early gate / as primary-with-escalation) — all negative as a decider |
| 4. Hybrid observation reconciliation | Not run | Genuinely untested |

Also covered, beyond D4's literal scope but answering the same underlying question: a
model-backbone ablation (`gpt-4o-mini` vs. `gpt-5.2` vs. `gemini-3.1-pro-preview`, `gpt-5.2` wins
on quality, `gemini` loses on structured-output reliability) and an escalation-policy study
(archetype-gated `EST`-only escalation to `gpt-5.2-pro` is the confirmed-best policy, tested at
zero additional cost since the underlying data already existed).

**What's genuinely missing relative to D4's letter:** arm 4 (hybrid reconciliation) was never
tried; none of this was run against a *locked, pre-registered* holdout partition the way D4d
requires — every result above was measured against corpora that were also used for iteration
(EST tolerance-clause fixes, PLOT_VALUES prompt attempts), which is exactly the methodological
discipline D4's staging exists to prevent. **This is a real gap**, not just a paperwork one — it
means the numbers above are good engineering evidence, not a certified release number.

**Recommendation: do not re-run D4a-c from scratch** (that would be spending real money to
reproduce a conclusion — joint beats decomposed — that's already answered with a clear margin).
**Do** treat a genuinely locked, held-out D4d-style pass (once D3's volume/reader-certification
gaps close and a real holdout partition can be frozen) as the actual remaining D4 work, and
optionally try arm 4 (hybrid reconciliation) then, since it's the one arm with zero evidence
either way.

---

## D5 — Calibrated abstention

**Not packaged as `ABSTENTION_CALIBRATION.md`/`abstention_thresholds.json` in the prompt's exact
form, but the coverage-vs-error tradeoff analysis it asks for has real data behind it:**

- Confidence-gated selective automation (`ENGINE4_PRODUCTION_DESIGN_2026_08_18.md` §2 option b):
  ~40.5% response-level hands-off coverage, F1 97.4% and FRR 2.8% clear the DR-1 bar on that
  automated slice, FAR 10.9% still fails it. This is a real coverage-vs-error curve point, not a
  single aggregate number.
- Self-consistency (3x majority-vote) as an alternative/complementary lever: FAR 33.3%→21.4% at
  a measured cost, piloted at n=39, **not yet confirmed at full corpus scale** — this program
  already learned once (the 21-photo escalation pilot) that small-sample directional reads can
  reverse at scale, so this specific number should not be cited past pilot tier without a
  full-corpus confirmation run.
- Adversarial re-check as a candidate abstention/re-verification mechanism was tested and
  **decisively rejected** — solves FAR but destroys F1/exact-match (5:1 collateral damage). Do
  not revisit this without new evidence; the failure looks mechanistic, not tunable.
- Archetype-gated escalation (§ D4 above) is itself a form of calibrated, criterion-aware
  abstention/escalation policy, already confirmed at full corpus scale.

**What's genuinely missing:** a formal `abstention_thresholds.json` artifact per-criterion/
per-archetype, and confirmation of the self-consistency number at full scale. Both are buildable
from data that mostly already exists (the self-consistency confirmation needs a real, bounded
paid run; the thresholds file is a repackaging exercise, not new research).

**D5 status: substantially answered in substance, not formally packaged.** Recommend building the
formal artifact from existing data plus the one outstanding confirmation run, rather than
redesigning the calibration approach from scratch.

---

## Net effect on Phase D sequencing

D3's volume/reader-certification gaps are the actual long pole — D4's remaining gap (a genuine
locked holdout, arm 4) and D5's remaining gap (thresholds packaging, self-consistency
confirmation) are both realistically sequenced *after* D3 closes further, not blocking Stage D2
(capture MVP) or Stage D1 (already complete) in the meantime. This matches the Phase D prompt's
own intent — D2 (capture) and D3 (evidence) can and are proceeding in parallel this session, D4/D5
correctly wait on D3's volume.
