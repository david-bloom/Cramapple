# AP Biology — Harness Extensibility Probe (not a content push)

**Status:** ⚠️ **Harness extensibility probe. Pre-review, not content.** Authored by Claude (content
lane) to test whether the TASK-0017 H0/H1 contract is as subject-agnostic as designed, by driving a
**second, structurally different** subject through the *same* `scripts/subject-harness/compiler.ts`.
This is deliberately minimal (1 SubjectPackage + 3 representative items), **not** an AP Biology
content build. The AP Biology fact pack is itself draft/unanchored
(`docs/product/AP_BIOLOGY_CED_FACT_PACK.md`), so all values here are provisional probe scaffolding,
not authored content and not tutor-reviewed.

## What this probes (that the AP Statistics slice did not)

1. **Heterogeneous FRQ archetypes** — Bio mixes **long (8 pt)** and **short (4 pt)** FRQs in one
   exam, versus Stats' uniform 4×10. Tests the archetype/blueprint/inventory model on non-uniform
   points/counts.
2. **`create-subject`** operation — Stats used `create-exam-pack-version`; this exercises the other
   schema branch (onboarding a subject the harness doesn't yet model).
3. **Non-text response modality → capability preflight** — one item deliberately uses the `graph`
   modality (Bio graphing is *exam-aligned*, not supplemental). The registry marks `graph` as
   `experimental`, so this is expected to trip the harness's capability gate.
4. **A second subject's grader need** — Bio requires a `biology-frq-rubric` grader absent from the
   registry (only `statistics-frq-rubric` exists), exercising the missing-capability path.

## Contents

| File | Item | Archetype | Pts | Modalities |
|------|------|-----------|-----|-----------|
| `ap-biology.subject-package.json` | SubjectPackage (`create-subject`) | 4 archetypes, 8 units, 6 practices | — | declares `graph` + `biology-frq-rubric` |
| `ap-biology-long-frq.item-package.json` | Long FRQ — interpret experimental results | `frq-long-experimental-analysis` | 8 | typed-text, typed-math |
| `ap-biology-short-frq.item-package.json` | Short FRQ — conceptual analysis | `frq-short-conceptual` | 4 | typed-text |
| `ap-biology-graph-frq.item-package.json` | Long FRQ — construct/interpret a graph | `frq-long-model-graph` | 8 | typed-text, **graph** |

## Run

```
deno run --allow-read docs/content/ap_biology_harness_probe/compile-check.ts
```

Two runs:
- **Real registry** → expected to **fail**, and the failure should contain *only* capability issues
  (`capability.not_supported` for `graph`, `capability.missing` for `biology-frq-rubric`,
  `capability.item_modality_not_supported` on the graph part). The long and short FRQ items
  contributing **no** issues is itself the proof their heterogeneous structure is accepted.
- **Control registry** (same package, but `graph` and `biology-frq-rubric` marked `supported`) →
  expected **green**, isolating that the package is fully valid and platform capability is the sole
  blocker.

## Expected finding

The harness is extensible to Bio's structure (create-subject, mixed long/short FRQ, second taxonomy),
and it **correctly blocks** onboarding on two real capability investments Bio needs: promote `graph`
from experimental to supported (or a graph-capture product decision), and register a `biology-frq-rubric`
grader. Those fixes are Codex + product lane, not content.
