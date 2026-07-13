# AP Statistics 2026-27 Content Rebuild — Multi-Model Orchestration Spec (v2)

**Status:** Design spec, v2. Codex G1 verdict on v1 was "return for targeted revision, then approve"; this version incorporates those required corrections. Still **not run** — blocked on the revised gate sequence below (G−1 → G0A/G0B → G1 → G1.5, then a vertical slice before any bulk generation).
**Owner:** David Bloom (Product Owner)
**Curriculum Owner:** Orly Bloom
**Independent reviewer:** Codex (plan + vertical-slice + batch QA — see Codex Checkpoints)
**Related:** `DECISION-0036`, `DECISION-0034`, `DECISION-0035`, `DECISION-0031`, `project_ap_stats_2027_format_change` memory, `docs/product/TUTOR_REVIEWER_QUICKSTART.md`
**Prepared:** 2026-07-13 (v1) · **Revised:** 2026-07-13 (v2, post-Codex-G1)

## Changelog v1 → v2 (Codex G1 corrections incorporated)

1. Five removed topics are recorded as **confirmed College Board facts**, not "decisions for Orly" (verified against the CB revision page 2026-07-13).
2. Authoring input is a **human-reviewed CED fact pack**, not the full 244-page PDF (which contains official questions/scoring guidelines).
3. Added **G−1 current-corpus containment/disposition** phase.
4. **Split curriculum authoring (Claude) from verifier implementation (Codex/TASK-0016).** The cascade now emits a *verifier-requirements manifest*; it no longer edits `statistics-verifier.ts` or production verifier config.
5. **Stage once, package-complete only.** Item + rubric + repair are assembled into one immutable bundle that stages after the whole package passes. Records the `content_ingest_rows.frq_form` schema gap (short/long only) as a G1.5 blocker.
6. **Strengthened correctness independence:** deterministic recomputation of every numeric claim; Codex reviews 100% of the vertical slice and 100% of inference FRQs / high-risk criteria in the first batch before any sampling.
7. **Deterministic scripts own counts/coverage/validation**; Haiku is narrative-only.
8. **Full provenance + run controls** with concrete numbers; "no-CB lint" reframed as a risk control, not proof of originality.
9. **Vertical slice before bulk generation.**
10. **Response-modality tags** on every item; hand-drawn work labeled supplemental, not exam-simulating.
11. **Grading-quality gate (G4B)** added, separate from content clearance (G4A), before publication (G5).

## Why this exists

The AP Statistics *CED, Effective Fall 2026* (exam May 2027 — the Aug-2026-beta cohort's actual exam) restructures the course: 9 modules → 5 units; FRQ section 6×~4pt → 4×10pt multi-part questions (Q1 Practices 1&2; Q2 Practices 3&4; Q3 inference; Q4 multi-area, all Practices 2/3/4); 42 MCQ + 4 FRQ; MC/FRQ weighted 50/50. New MC weights: U1 20–30%, U2 15–25%, U3 15–25%, U4 10–20%, U5 10–20%. Cramapple's existing module-tagged ~4pt content is largely mis-shaped and, in places, tests removed material.

### Confirmed removed content (College Board facts — not open questions)

Verified against the CB AP Statistics revision page (2026-07-13). These are removals of record; they are not Orly's to decide:

1. Analyzing departures from linearity (old **2.9**)
2. Combining random variables (old **4.9**)
3. Geometric distribution (old **4.12**)
4. Chi-square goodness-of-fit test (old **8.2/8.3**)
5. Inference for slopes — the entire old **Unit 9** (Inference for Quantitative Data: Slopes)

**Retained (confirmed from the new CED, Topic 5.4):** residual plots and curvature analysis stay in the course — only the old "departures from linearity" framing is removed. Do not conflate the two.

What Orly *does* decide (G0A): whether a given legacy item truly tests a removed concept or can be remapped; whether removed-topic material survives as clearly labeled supplemental enrichment; and the residual-plot remap rules given the retained-but-reframed status.

## Governance context (binding on every item)

Per `DECISION-0036`, Anthropic models lead content *authoring* for this rebuild. That does not weaken these standing rules:

1. **No College Board material** as model input, exemplar, or seed. Authoring works from the **CED fact pack** (below), never the full PDF or any official question/scoring language.
2. **AI output is candidate content, not cleared content** (`feedback_governance`: QA-pass ≠ launch approval). Clearing is human tutor review (G4A) or an explicit `DECISION-0035` waiver recorded per batch.
3. **No auto-publish.** Cascade writes to staging only; promotion (G5) is Product-Owner-gated.
4. **Every FRQ criterion needs an authored boundary contract** (`DECISION-0034` standard 1); the deterministic verification layer is version-pinned to match (standard 3) — but implemented by Codex/TASK-0016, not by this cascade.

### CED fact pack (authoring input — human-reviewed, no official items)

Claude authors from a curated fact pack containing only: the 5-unit / topic map with learning-objective IDs; the 4 practices and skills; unit/practice weights; exam timing and structure; the 4 FRQ archetypes; task-verb definitions; digital-response constraints; and the confirmed removals above. The full 244-page CED PDF (which contains official questions and scoring guidelines) is **not** a cascade input. Drafting this fact pack is a G0A deliverable (Claude may draft it from CED metadata for Orly's confirmation — see open question Q7).

## Responsibility boundary (per Codex correction 4)

- **Claude (Anthropic models):** curriculum blueprint, authored items, rubrics/boundary contracts, student repair text, and a *verifier-requirements manifest*.
- **Codex / implementation (TASK-0016):** schema and ingestion adapters, verifier **code** and config (`statistics-verifier.ts`, `AP_STATISTICS_VERIFICATION_PROFILE.json`), tests, migrations, integration.
- **Codex QA:** independent recomputation and adversarial review at G1/G3V/G3.
- **AP Statistics subject tutor:** the review chain — fact pack (G0A, incl. remap rules) → content (G4A, against the approved fact pack) → grading & repair (on content **released to the tutor**, i.e. pre-student). Reassigned from Orly per David (2026-07-13); "released" = handed to the tutor for review, never a student-facing publish, so the non-waivable grading-calibration gate (G4B) is unchanged. **Orly** remains Curriculum Owner.
- **David:** scope, supplemental policy, live-content disposition, waiver, publication, launch.

## Model tiering (corrected cascade)

Generation is not the hardest step; verifying a statistical rubric is at least as hard. The strongest model authors and adversarially verifies correctness; the mid tier does conformance and bulk transforms; **deterministic scripts** (not a model) own counts/coverage/validation; the light tier writes narrative only.

| Tier | Model | ID | Role |
|---|---|---|---|
| Author / correctness verifier | Opus 4.8 | `claude-opus-4-8` | Author items, boundary contracts, repair text; run independent adversarial-semantic correctness pass (fresh context, skeptical, abstains-to-flag) |
| Conformance / bulk transform | Sonnet 5 | `claude-sonnet-5` | Task-verb↔criterion match, field completeness sanity, bulk re-tagging of remappable legacy items; may add *independent* correctness evidence but is never the sole correctness gate |
| Deterministic checks | — (scripts) | n/a | Numeric recomputation, formula-equivalence, error-carried-forward, schema validity, duplicate-key/missing-field detection, coverage matrices, gap math |
| Narrative reporter | Haiku 4.5 | `claude-haiku-4-5-20251001` | Human-readable summaries, defect grouping, report prose — **not** authoritative counts |

**Independence rule:** the correctness verifier is a *separate Opus invocation with fresh context*, never the authoring thread. Both Opus passes share model-family failure modes, so deterministic recomputation and Codex review — not model agreement — are the real correctness backstop.

**Preflight:** confirm actual account/harness access to all three model IDs before the first run (documentation listing ≠ provisioned access).

## Revised gate sequence

| Gate | Owner | Condition |
|---|---|---|
| **G−1 — Freeze & classify current content** | David + Claude/scripts | Freeze new AP Stats publication; inventory every live/draft item; assign each `remap` / `rewrite` / `retire` / `supplemental-only` / `adjudicate`; decide disposition of the confirmed removed-topic items currently live (see Q2). |
| **G0A — Curriculum fact pack** | **AP Stats subject tutor** reviews/approves (Claude drafts) | 5-unit/topic/practice fact pack, LO IDs, weights, FRQ archetypes, task verbs, confirmed removals, remap rules. |
| **G0B — Scope & policy** | David | Inventory target, supplemental-content policy, live-content disposition, waiver posture. |
| **G1 — Codex plan + slice review** | Codex | Review of this revised spec and the planned vertical slice. |
| **G1.5 — Technical readiness** | Codex/TASK-0016 | Exam-pack/taxonomy versioning; **FRQ-archetype schema** (fixes `content_ingest_rows.frq_form` = short/long only, which cannot represent Q1–Q4 archetypes) or a validated `row_payload` adapter; ingestion adapter. Must precede any DB staging. |
| **G2V — Vertical slice** | Claude | Produce the slice (below). |
| **G3V — Codex slice QA** | Codex | 100% independent review of the slice end-to-end. |
| **G2 — Bulk authoring** | Claude | Only after slice passes and remediation lands. |
| **G3 — Codex batch QA** | Codex | 100% of inference FRQs + high-risk criteria; MCQ sampling only after measured defect rates justify it. |
| **G4A — Content clearance** | AP Stats tutor (or PO waiver) | Tutor reviews content **against the approved fact pack** (`TUTOR_REVIEWER_QUICKSTART.md`), then reviews **grading & repair** on content released to the tutor (pre-student). Content-clearance may be PO-waived (`DECISION-0035`); grading is not (G4B). |
| **G4B — Grading clearance** | TASK-0016 | Verifier sync, boundary tests, adjudicated/held-out response evidence, launch-threshold report. `DECISION-0035` waives tutor review, **not** grading calibration. |
| **G5 — Publish** | David | Promote staged bundles to published. |

## Vertical slice (before any bulk spend)

One 3-question MCQ set; one standalone MCQ per unit (5); one complete 10-point Q1, Q2, Q3, and Q4. Run the slice through the full pipeline — authoring → deterministic checks → adversarial verify → package assembly → staging adapter → Codex QA → reviewer workflow → grading dry-run. **Bulk generation (G2) begins only after the slice clears G3V.**

## Orchestration A — Item Re-Creation

Produces MCQ + FRQ items on the 5-unit / 4×10pt structure. Items pipeline independently. **Nothing stages until its full package (Orchestration B) also passes** — see "package-complete, stage once."

| Phase | Owner | Input | Output |
|---|---|---|---|
| A1 · Blueprint expansion | Opus 4.8 | Fact pack + FRQ archetypes + per-unit MC weights + inventory target (**71 MCQ / 33 FRQ**, distributed across the 5 units by MC weight and the 4 FRQ archetypes) | Per-item authoring briefs (unit/topic, practice(s), task verbs, part structure, difficulty, **modality tag**) |
| A2 · Author | Opus 4.8 | One brief | Draft item authored from fact pack only |
| A3 · Deterministic check | scripts | Draft item | Recomputed numerics, one-correct-answer (MCQ), part-answerability, schema validity |
| A4 · Adversarial correctness | Opus 4.8 (fresh ctx) | Draft item + deterministic results | Semantic refutation attempt, verdict, defect list |
| A5 · Conformance | Sonnet 5 | Draft item | Tag validity, task-verb sanity, no-CB-material lint (risk control, not proof), completeness |

Failing items return to A2 with defects (bounded retries — see run controls). Passing items hold for package assembly, they do **not** stage yet.

## Orchestration B — Rubric & Repair Refresh

For every FRQ, produces the criterion-boundary contract and student-facing repair feedback aligned to the independent-point / task-verb model, plus a **verifier-requirements manifest** (not code).

| Phase | Owner | Input | Output |
|---|---|---|---|
| B1 · Contract authoring | Opus 4.8 | FRQ item + boundary-contract standard + task-verb semantics | Per criterion: independently-earnable point, evidence requirements, accepted variants, counterexamples, `minimum_fix` |
| B2 · Repair-text authoring | Opus 4.8 | Contract | Student repair feedback: smallest concrete fix to earn the missed point, grounded in the criterion |
| B3 · Deterministic + adversarial verify | scripts + Opus 4.8 (fresh ctx) | Contract + repair | Over/under-credit boundary probing, double-barreled check, task-verb↔demand match, repair-sufficiency |
| B4 · Conformance | Sonnet 5 | Contract + repair | Every criterion has evidence + counterexample + `minimum_fix`; positive totals; example phrasings present |
| B5 · Verifier-requirements manifest | Opus 4.8 | Approved contracts | Versioned manifest of the deterministic checks the Stats verifier must implement — **handed to Codex/TASK-0016**, which owns the actual `statistics-verifier.ts` / profile changes and their tests |

## Package-complete, stage once

```
Author item (A) → verify item → author rubric/boundary/repair (B) → verify complete package
→ assemble immutable bundle (item + choices/parts + criteria + repair + provenance)
→ stage once (content_ingest_rows via the G1.5 archetype-aware adapter)
```

Incomplete FRQs never touch the database. Drafts live as versioned workflow artifacts until the whole bundle passes. Revisions create new immutable versions that re-enter G3/G4.

## Provenance & run controls

Every staged artifact records: model ID + provider; prompt/template version; **CED fact-pack version**; run/invocation ID; input+output hashes; token usage + cost; retry count + defect history; author↔verifier separation proof; final disposition + clearing path.

**Run controls (proposed defaults):** batch size 25 items; concurrency ≤ 8 (per subagent harness cap; Q4 = app/subagents); **max retries = 2** per item then flag-for-human (not silent drop); usage bounded by subscription/subagent limits rather than API spend; stop conditions — halt the batch if deterministic-check defect rate > 20% or no-CB-lint hits cluster, and escalate.

## Response-modality tagging (per Codex correction 10)

Every item is tagged exactly one of: `exam_aligned_digital` (matches the May-2027 Bluebook format — keyboard/symbols-menu entry, Desmos available, minimal symbolic entry), `supplemental_typed`, or `supplemental_hand_drawn`. Hand-drawn graph practice stays valuable (no Desmos-equivalent exists, per David) but is **labeled supplemental — it must not be represented as simulating the real exam**. The blueprint accounts for digital-entry constraints in exam-aligned items.

## Codex checkpoints (independent, outside the cascade)

- **G1:** review this revised spec + the planned vertical slice.
- **G3V:** 100% independent review of the vertical slice.
- **G3:** 100% of inference FRQs + high-risk criteria in the first full batch; independent recomputation; drop to sampling of lower-risk MCQs only after measured defect rates justify it.

Codex's correctness review is a *separate* check from the in-cascade Opus verifier — two independent organizations, not a rerun.

## Scope decisions (David, 2026-07-13)

- **Q1 — Inventory target: RESOLVED → match old counts, 71 MCQ / 33 FRQ**, re-shaped to the new 5-unit structure (not the old 9-module split). A1 blueprint expansion distributes these across the 5 units by the new MC weights and the 4 FRQ archetypes.
- **Q2 — Live removed-topic items: RESOLVED → leave public until replaced.** The confirmed-obsolete published items stay live during the rebuild rather than being hidden now; they are retired as their replacements land. *Accepted interim risk:* students may practice off-syllabus (removed-topic) content until then. Consistent with the pre-payment feedback/recruiting posture in `DECISION-0033`/`0035`. G−1 still inventories and labels them so the disposition is tracked; a fast-follow retirement pass is expected as replacements clear.
- **Q3 — Removed-topic / hand-drawn material: DEFAULT stands → keep as clearly labeled supplemental** (pending Orly), not retired outright.
- **Q4 — Execution path: RESOLVED → Claude app / subagents** (the expanded subscription). Run controls are bounded by app/subagent limits; the per-batch cost ceiling is expressed in subscription usage rather than API spend. Preflight the three model IDs' availability in the app/subagent harness before the first run.
- **Q5 — Keying: DEFAULT stands (Codex rec) → new May-2027 content keys / explicit exam-pack-version binding**, so historical 2026 content remains auditable.
- **Q6 — Waiver scope: DEFAULT stands → decide the tutor-review waiver after the vertical slice** and tutor availability, not up front for the whole batch.
- **Q7 — Fact pack: RESOLVED → Claude drafts the G0A CED fact pack; the AP Statistics subject tutor reviews/approves it** (reassigned from Orly per David, 2026-07-13). The same tutor then reviews content (G4A) and grading & repair — all pre-student, so the grading-calibration gate (G4B) is unchanged.

## Not in scope / dependencies

- G0A curriculum fact pack (Orly) and G1.5 schema/adapter (Codex/TASK-0016) are hard prerequisites.
- AP Biology is unaffected.
- Bluebook/Desmos UI build is separate; only its *authoring implications* (modality tags, digital-entry constraints) are in scope here.

## Execution readiness

On owner approval and after G−1 → G1.5 clear, this becomes a runnable multi-agent workflow, executed **vertical-slice-first**. Bulk authoring waits for the slice to pass Codex G3V.
