# AP Statistics 2026-27 — Content-Bank Inventory Split (proposal for Orly's G0A OK)

**Status:** ✅ APPROVED 2026-07-13 by Orly (Curriculum Owner), relayed by David — recorded as
`APPROVAL-0036`. FRQ split recorded as the recommended inference-weighted option (14/16/22/18);
amend `APPROVAL-0036` if the even exam-mirror alternative was intended. Approval covers counts/plan
only — bulk authoring (G2) still gated on tutor G0A + slice G3V.
**Prepared:** 2026-07-13 · **Related:** `DECISION-0036`, `DECISION-0037`, `TASK-0017`, `APPROVAL-0036`, rebuild orchestration.

## Target (per Orly, 2026-07-13)

**100 MCQ + 70 FRQ** for the AP Statistics 2026-27 practice **content bank**. This supersedes the
fact-pack §9.5 placeholder (71 MCQ / 33 FRQ). These are *authoring-bank* counts (how many distinct
items to write), **not** per-exam-form counts — one practice exam form is 42 MCQ + 4 FRQ (fact-pack §1).

## MCQ — 100 items across the 5 units, by CED MC exam weight

Allocation uses each unit's CED MC weight band midpoint, normalized to 100. Every resulting share
lands inside the CED band, so a bank drawn on these counts mirrors real exam emphasis.

| Unit | Title | CED MC weight band | Proposed MCQ | % of bank | In band? |
|------|-------|--------------------|--------------|-----------|----------|
| 1 | Exploring One-Variable Data & Collecting Data | 20–30% | **26** | 26% | ✅ |
| 2 | Probability, Random Variables, Distributions | 15–25% | **21** | 21% | ✅ |
| 3 | Inference for Categorical Data: Proportions | 15–25% | **21** | 21% | ✅ |
| 4 | Inference for Quantitative Data: Means | 10–20% | **16** | 16% | ✅ |
| 5 | Regression Analysis | 10–20% | **16** | 16% | ✅ |
| | **Total** | | **100** | 100% | |

Within each unit, distribute across that unit's topics (fact-pack §3) and tag by MC practice weight
(P1 5–10% · P2 20–30% · P3 25–35% · P4 25–35%, fact-pack §4). Author only against the retained
topic map; the five removed topics (§8) are excluded.

## FRQ — 70 items across the 4 archetypes

The exam presents exactly one of each archetype per form, but inference (Q3/Q4-style) spans the two
deepest units (3 & 4) and is where students most need volume. **Recommended (inference-weighted):**

| Archetype | Exam slot | Primary units | Proposed FRQ |
|-----------|-----------|---------------|--------------|
| `frq-practices-1-2` | Q1 | Unit 1 | **14** |
| `frq-practices-3-4` | Q2 | Units 1, 2, 5 | **16** |
| `frq-inference` | Q3 | Units 3, 4 | **22** |
| `frq-multifocus-2-3-4` | Q4 | Units 2, 3, 4 | **18** |
| | | **Total** | **70** |

Rationale: `frq-inference` at 22 lets the bank cover one-proportion, two-proportion, one-mean,
two-mean, and chi-square (homogeneity/independence) procedures each as both a confidence interval and
a significance test with enough repetition for practice; `frq-multifocus` at 18 spans the mixed
Unit 2–4 content. **Alternative (exam-mirror, even):** 18 / 18 / 17 / 17 = 70, if Orly prefers the
bank to mirror the exam's equal archetype representation rather than weight toward inference.

Suggested per-unit FRQ coverage (approximate, since multifocus/inference cross units): Unit 1 ~18,
Unit 2 ~12, Unit 3 ~20, Unit 4 ~14, Unit 5 ~6 — Orly to adjust.

## Modeling flag for Codex / TASK-0017 (not Orly's call)

The subject package's `inventory.targets` currently carries **per-exam-form** counts (42 MCQ, 4 FRQ)
that match `blueprint.sections[].item_count`. This **bank** target (100/70) is a different quantity.
Before these numbers go into a SubjectPackage, the harness needs to distinguish *bank/authoring
target* from *per-form blueprint count* — otherwise proposed compiler gap **B**
(blueprint↔inventory reconciliation, see `SUBJECT_HARNESS_COMPILER_INTEGRITY_CHECKS_SPEC_2026_07_13.md`)
would fire a false mismatch (100 ≠ 42). Recommend either a separate `authoring_targets` block or an
explicit `inventory.kind: "bank" | "per-form"` discriminator. Raised for Codex; does not block Orly's
count decision.

## Decision requested

1. Approve the **100 MCQ** per-unit split (26/21/21/16/16) or amend.
2. Choose the **70 FRQ** split: **inference-weighted (14/16/22/18)** [recommended] or exam-mirror (18/18/17/17).
3. Confirm the per-unit FRQ coverage targets (or hand back adjusted numbers).

Nothing is authored in bulk until this split is approved (G0A) and the vertical slice clears G3V
(orchestration gate sequence). The four slice FRQs in `docs/content/ap_statistics_2026_27_slice/`
are the pre-G0A drafts that exercise this plan end-to-end.
