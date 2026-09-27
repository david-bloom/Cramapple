# QA Sign-off — AP Biology FRQ Canonical-Answer Segmentation

Reviewer: Claude (independent QA). Date: 2026-09-22.
Builder: Codex, `codex/apbio-canonical-qa-path` @ `9df597c` (segmentation v2, after the ca2 fix).
Independent second run: Claude builder subagent (`apbio_frq_segmentation.claude.jsonl`, the 52 ca2 items).
Method: every structural claim recomputed independently from the artifacts; Production cross-checks read-only. No builder file was modified.

## Decision

**ACCEPTED — the `canonical_answer_2` reuse fix and the structural correctness of the segmentation.**
(David, 2026-09-22.)

**NOT in scope of this acceptance:** the drafted answer content is a proposal only and is **not**
ratified for serving. The content-alignment problem below is open and must clear human
double-approval (INV-3) before any of this reaches students.

## What was accepted (verified independently on v2, all 75 records)

| Check | Result |
| --- | --- |
| Spans concatenate exactly to `full_text` | 75 / 75 ✓ |
| Every rubric criterion has ≥1 span | 75 / 75 ✓ |
| No span invents a criterion outside the rubric | 0 ✓ |
| `canonical_answer_1` reused verbatim | 0 failures ✓ |
| **`canonical_answer_2` reused verbatim (was 0/52 in v1)** | **52 / 52 ✓** |
| Source split | existing 27 / completed 41 / drafted 7 |
| Per-span provenance recorded (`criteria_from_canonical_answer_1/2`, `criteria_drafted`) | present ✓ |

The v1 defect (F1 — `canonical_answer_2` ignored, 49 items re-drafted) is **resolved**. Confirmed
twice: Codex v2, and an independent Claude re-run that reuses the same ca2 text verbatim on the
same items (S-031, S-007, S-017, S-036, S-063…). Two models, same fix.

## Open (not blocked by this acceptance) — content alignment, cross-model corroborated

The segmentation exposed that the stored Biology canonical answers are substantially misaligned
with their rubrics. Both independent runs agree:

- **118 of 278 rubric criteria (42%) required freshly drafted content** — neither ca1 nor ca2
  covers them. (Claude run corroborates heavy drafting on its 52.)
- **18 items had every criterion drafted** — stored answers do not match the rubric at all
  (S-021, S-025, S-026, S-052, S-058, S-066, S-071, S-074, S-076, S-094, S-097, S-101/102/103, and
  the 4 graph items).
- **15 items carry a `canonical_answer_2` that satisfies no stored criterion** (preserved verbatim
  as uncredited context): S-021, S-025, S-026, S-028, S-032, S-033, S-040, S-051, S-052, S-058,
  S-066, S-071, S-081, S-086, S-097.
- Both runs flag the **same worst-aligned items** — a real content-integrity issue, not a model
  artifact.

Carryovers (unchanged, still open): **9 point-total mismatches** (`total_points=8` vs rubric 9;
L-004/006/012/013/015/016/017/019/021 — confirmed in Production); **4 drawn-graph items** needing a
spatial canonical (HDG-GRAPH-002/003/008/010); **7 items with no canonical answer at all**
(fully drafted, highest generation risk); the **whitespace-on-removal** renderer note (low).

## Recommended next steps (post-acceptance)

1. Route the content-alignment batch (118 drafted criteria, 18 all-drafted items, 15 off-rubric
   ca2, 7 no-canonical) to content authoring/review; it belongs in the content-gaps list.
2. Reconcile the 9 point-total mismatches and the 4 drawn-graph items.
3. Human double-approval (INV-3) before any drafted content serves.

The ca2 reuse fix and the segmentation structure are sound and accepted; the drafted content is the
next gate.
