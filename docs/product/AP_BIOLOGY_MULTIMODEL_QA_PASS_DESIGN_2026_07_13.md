# AP Biology — Multi-Model Content QA Pass (design)

**Status:** DESIGN for Product-Owner review. Not yet run.
**Prepared:** 2026-07-13 · Author: Claude (content lane)
**Scope:** the 254 draft AP Biology `content_items` (≈100 MCQ + ≈142 FRQ), all `status='draft'`,
0 tutor-approved (see `project_ap_biology_publish_gap`).
**Related:** `DECISION-0036` (AI-led authoring/verification cascade), `DECISION-0034` (grading
standards), `AP_STATISTICS_2027_CONTENT_REBUILD_ORCHESTRATION.md` (same gate cascade — Bio reuses it),
`AP_BIOLOGY_VERIFICATION_PROFILE.json`, `AP_BIOLOGY_CED_FACT_PACK.md`.

## Purpose

Run a calibrated, multi-model QA pass over the existing Bio corpus to (1) catch factual, curriculum,
and exam-relevance defects **before** human review, and (2) produce a **confidence-tiered ranking** so
the AP Biology tutor reviews and publishes a vetted subset incrementally, fastest-and-cleanest first.

## Non-negotiables (governance)

- **QA-pass ≠ launch approval.** No number of agreeing models publishes anything. AI QA *feeds and
  accelerates* the human gate; it does not replace it.
- **G4A (human content clearance) and G4B (grading calibration, non-waivable)** still gate publication.
- Publication runs only through the **P0-hardened fail-closed path** with recorded evidence.
- **No verbatim College Board content** enters QA (`DECISION-0031`/`0033`); checks are against the CED
  framework/fact pack, not CB questions/keys.
- A **Bio-qualified tutor is required** and is **not yet onboarded** (current tutors are Stats-oriented) —
  this is the critical-path dependency, not the model pass.

## Division of labor

| Role | Owner |
|------|-------|
| Multi-model content QA (factual / curriculum / exam-relevance / answer-key & rubric correctness) | **Claude/Anthropic models** (Opus, Sonnet, Haiku), orchestrated by Claude |
| Independent recomputation, adversarial re-check, structural/schema/harness conformance | **Codex** (independent QA lane; author≠verifier) |
| Gold-set labeling, **G4A** content clearance, **G4B** grading calibration | **Human AP Biology tutor** |
| Scope/batch cadence, publish decision + recorded `DECISION`/`APPROVAL` | **David (Product Owner)** |
| Orchestration, running the Claude-model pass, evidence assembly | **Claude** |

## QA dimensions (the rubric each model applies)

Per item, each model returns a structured verdict per dimension: `pass | flag | fail`, the specific
defect, a confidence, and a citation to the fact pack / CED unit-topic-skill.

1. **Factual accuracy** — the biology is correct; for FRQ, the **answer key + rubric criteria** are
   correct and the boundary contracts hold (`DECISION-0034`); for MCQ, the **keyed option is correct
   and the distractors are wrong** (and defensibly so).
2. **Curriculum alignment** — maps to a valid CED unit/topic/science-practice; the item's tags match
   its actual content; it tests **in-scope** material only.
3. **Exam relevance** — exam-appropriate archetype (long/short FRQ, 4-option MCQ), task-verb ↔ criterion
   match, plausible difficulty, no off-syllabus or trivia content.
4. **Safety/PII** — no personal data, no unsafe or biased content (feeds the `security_privacy` gate).

## Pipeline

**Tier 0 — deterministic pre-checks (no model, cheap).** Schema/structure; curriculum-tag validity
against the CED taxonomy; MCQ exactly-one-correct-answer sanity; duplicate/near-duplicate detection;
PII regex scan. Bio FRQ metadata gaps (100 short FRQs have empty `prompt_json`) get flagged here as
*missing tags to establish first*. Structural/harness conformance is Codex's part of Tier 0.

**Tier 1 — multi-model, adversarial, per item.** Each item is assessed **independently by ≥3 diverse
model configurations**, each prompted to **refute** (actively hunt the error), not to confirm — this is
the guard against sycophantic false-confidence. Model roles map to `DECISION-0036`:
- **Opus** — deep correctness + adversarial refutation (the hardest lens; 100% of FRQs and inference-
  heavy items).
- **Sonnet** — curriculum alignment + exam-relevance conformance at scale.
- **Haiku** — cheap first-pass triage, cataloging, and tag/format checks.

**Tier 2 — consensus + adjudication.** Aggregate the N verdicts into a tier:
- **GREEN** — all models agree `pass` on all dimensions.
- **YELLOW** — any disagreement or `flag` (the high-value signal: models disagreeing = human attention).
- **RED** — any `fail` or majority-defect.
Disagreements are a feature: they concentrate scarce tutor time where it matters.

**Tier 3 — Codex independent recomputation.** Codex, independent of the Claude pass, re-runs the
deterministic checks and adversarially spot-checks a sample **plus 100% of high-risk items** (the hard
cases named in `AP_BIOLOGY_VERIFICATION_PROFILE.json`). Author≠verifier separation at the QA layer.

**Tier 4 — calibration against a tutor gold set (the crux).** *Before* trusting the tiers, the tutor
labels a **stratified gold sample** (~40–60 items across units, item types, and difficulty). Measure
the pass's **precision/recall**: what fraction of AI-GREEN items the tutor confirms clean (the
**false-clear rate** — the number that actually justifies publishing), and whether the pass catches the
tutor-known defects. Only a measured false-clear rate below an agreed threshold converts "AI says
GREEN" into "expected defect rate < X%." This is the calibration that makes "confidence to publish"
a real, defensible claim rather than an assertion.

**Tier 5 — human review + incremental publish.** The tutor reviews the **GREEN tier first** (fast,
because it's pre-vetted and defect-concentrated elsewhere), confirms, and publishes that subset through
the hardened path with recorded G4A + G4B evidence. YELLOW → deeper review; RED → fix (re-enters the
pass as a new version) or drop. The corpus grows as review proceeds — "publish during review."

## Outputs (become the publish-gate evidence)

- **Per-item QA record**: all model verdicts, defects, citations, consensus tier — feeds the evidence
  the P0 publish path now requires.
- **Confidence-tiered manifest** (GREEN/YELLOW/RED) with per-item rationale.
- **Defect taxonomy + report** (what's wrong, by unit/type) — also a signal on authoring quality.
- **Calibration report**: measured precision/recall vs the tutor gold set, with the false-clear rate.

## Success criteria

- Measured false-clear rate on the gold set below the agreed threshold (tutor sets it).
- Inter-model agreement rate and per-tier defect rates reported.
- A publishable GREEN subset sized and evidenced for a first `APPROVAL`-gated release.

## Decisions / dependencies needed from you

1. **Bio tutor onboarding** — the human gate can't run without one; this is the true bottleneck.
2. **Scope & cadence** — full 254 in one pass, or a first batch (e.g., one strong unit) to prove the
   pipeline end-to-end (recommended: a vertical slice first, mirroring Stats G2V→G3V)?
3. **Model set & execution mechanism** — Opus/Sonnet/Haiku via the Claude app/subagent harness
   (`DECISION-0036` path) or a local multi-agent workflow; add a non-Anthropic independent lens via
   Codex for family diversity.
4. **Thresholds** — the acceptable false-clear rate and the consensus rule (unanimous vs K-of-N).

## What this is not

Not a publish authorization, not a substitute for G4A/G4B, and not a re-authoring effort. It is a
calibrated triage-and-confidence instrument that makes human review fast and publication incremental
and evidenced.
