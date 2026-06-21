# Bio Reference Layer Reporting Standard

**Status:** Draft standard for Product Owner review
**Owner:** Product Owner with Learning Quality Owner
**Created Date:** 2026-06-18
**Applies To:** All bio reference-layer experiment reports going forward
**Related:** `docs/research/bio_reference_layer_next_experiment_plan.md` (§8 Required
Measurements, §12 Analysis Plan)

## 1. Purpose

Make experiment reports comparable across runs and resistant to overclaiming.

This standard exists because a prior pilot report summarized only latency and
schema validity, omitted strict agreement entirely, and described the result as
"promising" from an n=6 deliberately adversarial sample with a broken cost
calculation and an inverted escalation condition. None of that was caused by
bad faith — it happened because no fixed format required those numbers and
checks to be present. This standard closes that gap structurally.

Every report covered by this standard must include the three layers below, in
order: run metadata, integrity gate, required tables. A report missing any
required section is incomplete, not abbreviated.

## 2. Run Metadata (required header)

Every report opens with this block:

| Field | Requirement |
| --- | --- |
| Protocol doc + version | Link to the experiment protocol this run tests |
| Script + commit hash | Exact code version that produced the raw results |
| Run date, owner | — |
| Raw results path | Path to the underlying JSONL/data file |
| Sample selection method | `random` or the specific selector (e.g. `selectHardSet`); these are not comparable distributions and must never be silently mixed |
| n per arm, response IDs | Enough for a reader to independently verify pairing |
| Gateway used? | `true`/`false`. If `false`, state the fallback path and reason |
| Read tier | See §3. Set this before writing the rest of the report |

## 3. Read Tier (gates the claims, not just the data)

The read tier is decided by sample size per arm and caps what language the
report is allowed to use. Pick the tier before drafting the Executive Summary,
not after.

| Tier | n per arm | Permitted claims | Prohibited claims |
| --- | --- | --- | --- |
| **Smoke Test** | < 10 | "Harness runs end-to-end," "schema-valid output achieved," "latency in expected range" | "promising," "beats control," any agreement/quality comparison between arms |
| **Directional** | 10–29 | "Suggests X," "worth scaling to confirm" | Cannot be cited to promote or kill an arm under the protocol's §9–10 success/kill criteria |
| **Decision-Grade** | ≥ 30 | Full application of the protocol's pre-registered success and kill criteria | — |

A report that wants to say an arm is "promising" or "beats control" must be
Directional or Decision-Grade. A Smoke Test report that uses that language is
non-compliant with this standard and should be revised before circulation.

## 4. Integrity Gate (must run and be printed before any metric is trusted)

Print this checklist, with pass/fail per item, immediately after the run
metadata block and before the Executive Summary:

- [ ] Token usage is nonzero for at least one row where a billed call
      succeeded (catches usage-field extraction bugs)
- [ ] Cost is greater than $0 for at least one successful row
- [ ] If escalation rate is nonzero, the report states which condition fired
      and on how many rows — not just the aggregate count
- [ ] The same response-ID set was used across all arms being compared
      (true pairing, not coincidental overlap)
- [ ] p95 is computed on at least 20 samples, or is explicitly labeled
      "single-point, not a real percentile" if below that
- [ ] Schema-invalid rows are listed by response ID with their raw error,
      not only counted

Any failed item must be named in a **Known Issues** section that appears
before the metrics tables, not appended as a closing caveat. A report may
still be published with failed integrity items, but the failure must be
visible before a reader reaches any number it would invalidate.

## 5. Required Tables

### 5.1 Per-Arm Metrics

One row per arm, columns in this fixed order so reports diff cleanly across
runs:

| Arm | n | Routing | Strict agreement | Clear-subset agreement | Schema valid | Under-credit | Over-credit | p50 latency | p95 latency | Avg input tok | Avg output tok | Avg reasoning tok | Avg cost | Escalation rate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

### 5.2 Paired Changes vs. Control

One row per non-control arm:

| Arm | Fixed (control wrong, arm right) | New errors (control right, arm wrong) | Unchanged | Regressions in frozen boundary cluster |
| --- | --- | --- | --- | --- |

### 5.3 Claims Supported / Claims Not Supported

Two short lists closing the report. Existence of this section is mandatory
even when one list is empty.

- **Supported by this run:** — only claims consistent with the read tier in §3
- **Not supported by this run:** — anything the run could be mistaken for
  testing but didn't (e.g. "provider comparison" when gateway auth was
  unavailable and only one provider ran)

## 6. Mechanics

- Every experiment script should emit a machine-readable `summary.json`
  alongside the raw JSONL, and the tables in §5 should be generated from that
  file rather than hand-transcribed into prose. This removes the chance of a
  summary silently dropping a column or miscomputing an aggregate.
- File naming follows the existing convention:
  `docs/research/<topic>_<arm-set>_<date>_report.md` with a sibling
  `<topic>_<arm-set>_<date>_summary.json`.
- A report that supersedes an earlier invalid run must say so explicitly in
  the run metadata block (`Supersedes:` field), and the superseded raw file
  must not be deleted.

## 7. Non-Negotiables

- Never report a quality or speed comparison from a Smoke Test tier run.
- Never omit the integrity gate, even when every item passes — a passing gate
  is itself information.
- Never average across sample-selection methods (e.g. mixing `random` and
  `selectHardSet` rows in one aggregate row).
- Never describe gateway-unavailable, single-provider runs as testing
  provider comparison (H5-style hypotheses) in the Executive Summary or
  Claims Supported section.
