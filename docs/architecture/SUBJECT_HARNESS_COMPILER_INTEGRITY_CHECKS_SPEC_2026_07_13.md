# Subject-Harness Compiler — Cross-Package Integrity Checks (Codex handoff spec)

**Prepared:** 2026-07-13 · Author: Claude (H0/H1 contract lane)
**For:** Codex (owns `scripts/subject-harness/compiler.ts`, verifier registry, tests)
**Task:** TASK-0017 · Related: `DECISION-0037`, `DECISION-0039`, `DECISION-0040`
**Status:** Partially adopted — **A, B, and the archetype-granularity of C/D remain open and are routed back to Codex** (Product Owner decision, 2026-07-13).

## Adoption status (2026-07-13, after Codex's TASK-0017 "done")

Codex's final harness (verified at HEAD `a1cc743`; DB evidence packet PASS at `4b1bc07`) **added**
an item-modality check — `capability.item_modality_undeclared` (+ `capability.item_modality_not_supported`)
in `compiler.ts` `walkParts` — validating each item part's `response_modalities` against the
**subject's** `capabilities.required_response_modalities` and the platform registry. That partially
covers gap D at the *subject* level.

**Still open (routed back to Codex):**
- **A** — inventory targets are never resolved against archetypes (`grep inventory scripts/subject-harness/` = 0 hits).
- **B** — blueprint `item_count` is never reconciled with summed inventory `target_count`.
- **C** — archetype `response_modalities` are still not constrained to `capabilities.required_response_modalities`.
- **D (archetype granularity)** — a part can still use a modality its **own archetype** does not declare,
  as long as the subject supports it; Codex's new check is subject-level, not archetype-level.

The four AP Statistics 2027 slice items in `docs/content/ap_statistics_2026_27_slice/` compile green
under the current checks, so none of these gaps is blocking that content today — they remain
authoring footguns to close when convenient.

## Why

The H0/H1 contract is structurally sound: `compilePlan` already validates exam-pack match,
archetype resolution + item-type agreement, taxonomy resolution, source refs, rubric point
reconciliation (criteria → part → archetype), stimulus refs, deterministic-check-type
allow-listing, `content_sha256`, capability preflight, taxonomy-parent resolution, blueprint
section-weight sums, and academic-year consistency. All six existing tests pass.

Four cross-package invariants are **not** enforced today. Each lets a malformed package compile
clean, and each is a mistake real content authoring will make. This spec defines the rule, error
`code`/`path`/`message` (following the compiler's existing `<namespace>.<detail>` convention),
where in `compilePlan` to add it, severity, and a test. All are additive; none change existing
passing behavior on the current AP Statistics fixtures.

Baseline reference (current green fixtures):
`schemas/subject-onboarding/fixtures/ap-statistics-2026-27.subject-package.json` +
`ap-statistics-q1..q4.item-package.json`. Every check below must leave those green.

---

## A — Inventory targets must resolve against archetypes (FATAL)

**Gap:** `inventory.targets[]` is never read by any harness script. A target whose `archetype_key`
does not exist, or whose `item_type` disagrees with the referenced archetype, compiles clean.

**Rule:** For each `inventory.targets[i]`:
1. If `archetype_key` is present, it must match some `archetypes[].archetype_key`.
   (Targets reference archetype **key** only, not version — resolve against the set of keys.)
2. If `archetype_key` is present, `targets[i].item_type` must equal that archetype's `item_type`.

**Errors:**
| code | path | message |
|------|------|---------|
| `reference.inventory_archetype_not_found` | `/inventory/targets/{i}/archetype_key` | `<archetype_key>` |
| `reference.inventory_item_type_mismatch` | `/inventory/targets/{i}` | `target item_type <T>, archetype <key> is <U>` |

**Placement:** after the `archetypes` map is built (~compiler.ts:244), before the per-item loop.

**Test:** clone the AP Stats subject package; set `inventory.targets[1].archetype_key` to
`frq-does-not-exist` → expect `reference.inventory_archetype_not_found`. Separately set
`inventory.targets[0].item_type` to `frq` (archetype `mcq-four-option` is `mcq`) → expect
`reference.inventory_item_type_mismatch`.

---

## B — Blueprint item counts must reconcile with inventory (FATAL where unambiguous)

**Gap:** `blueprint.sections[].item_count` and summed `inventory.targets[].target_count` are never
compared. A blueprint promising 4 FRQs with an inventory summing to 3 passes.

**Rule:** For each `item_type T`:
- `inventoryDemand(T)` = Σ `target_count` over `inventory.targets` with `item_type == T`.
- `blueprintDemand(T)` = Σ `item_count` over `blueprint.sections` whose `item_types` **equals `[T]`
  exactly** (single-type sections only).
- If at least one single-type section exists for `T`, require `inventoryDemand(T) == blueprintDemand(T)`.
- Any section with more than one entry in `item_types` makes its counts unattributable per type;
  emit a non-fatal advisory and skip that section from `blueprintDemand`.

**Errors:**
| code | severity | path | message |
|------|----------|------|---------|
| `blueprint.inventory_count_mismatch` | FATAL | `/inventory/targets` | `item_type <T>: inventory <n>, blueprint <m>` |
| `blueprint.mixed_section_unreconciled` | ADVISORY (record, do not fail) | `/blueprint/sections/{i}` | `section <key> mixes item_types; counts not reconciled` |

Advisories: if the compiler has no advisory channel yet, add an `advisories: Issue[]` field to
`CompiledPlan` rather than pushing to `issues`. Do not fail the build on an advisory.

**Placement:** after A, before the per-item loop.

**Baseline:** current fixture — mcq 42==42, frq 4==(1+1+1+1); both sections single-type → stays green.

**Test:** set `inventory.targets[1].target_count` to `2` → frq inventory 5 ≠ blueprint 4 →
`blueprint.inventory_count_mismatch`.

---

## C — Archetype modalities must be declared in subject capabilities (FATAL)

**Gap:** capability preflight compares only the `capabilities.*` block to the registry. An archetype
may declare a `response_modalities` value absent from `capabilities.required_response_modalities`, so
the subject asserts it doesn't need a modality it actually uses.

**Rule:** For each `archetypes[i]`, every entry in `response_modalities` must be present in
`capabilities.required_response_modalities`.

**Error:**
| code | path | message |
|------|------|---------|
| `capability.archetype_modality_undeclared` | `/archetypes/{i}/response_modalities` | `<modality> not in capabilities.required_response_modalities` |

**Placement:** in the existing archetype loop (~compiler.ts:245–258), alongside `practice_refs`
resolution.

**Baseline:** every archetype modality (`choice`, `typed-text`, `typed-math`, `table`) is in the
subject's `required_response_modalities` → stays green.

**Test:** add `graph` to `archetypes[0].response_modalities` without adding it to capabilities →
`capability.archetype_modality_undeclared`.

---

## D — Item part modalities must be within the item's archetype (FATAL)

**Gap:** an item's `parts[].response_modalities` are validated by JSON Schema (enum) but never checked
against the archetype the item binds to. A part can demand `drawing` under a `typed-text`-only
archetype; the runtime then can't collect or grade that response.

**Rule:** For each item, resolve its archetype (already done at ~compiler.ts:337). For every part and
subpart, each entry in `response_modalities` must be present in that archetype's
`response_modalities`. Recurse through `subparts` (mirror `verifyPart`'s recursion).

**Error:**
| code | path | message |
|------|------|---------|
| `reference.part_modality_not_in_archetype` | `/items/{i}/parts/{p}[/subparts/{s}]/response_modalities` | `<modality> not permitted by archetype <key>` |

**Placement:** thread the resolved archetype's modality set into `verifyPart` (add a
`Set<string> allowedModalities` parameter), or run a small dedicated recursive pass in the per-item
loop after archetype resolution. Prefer threading it into `verifyPart` to reuse the subpart walk.

**Baseline:** Q1–Q4 parts use only `typed-text` (and Q's that bind `frq-practices-3-4` /
`frq-multifocus-2-3-4` may use `typed-math` / `table`), all within their archetypes → stays green.
**Verify against Q2–Q4 before shipping** — if any current fixture part already exceeds its archetype's
modality set, that is a real fixture bug to fix, not a reason to weaken the check.

**Test:** set `parts[0].response_modalities` on the Q1 fixture (archetype `frq-practices-1-2`,
`typed-text` only) to `["drawing"]` → `reference.part_modality_not_in_archetype`.

---

## E — Taxonomy-weight coverage/satisfiability (ADVISORY, optional)

**Gap (latent):** `blueprint.taxonomy_weights` only checks referenced-node existence and
`minimum ≤ maximum`. It does not check that Σminimum ≤ 1 ≤ Σmaximum (an unsatisfiable envelope), nor
that all `unit` nodes are covered. Latent today because the fixture uses trivial 0–1 ranges.

**Rule (proposed, advisory):**
- `blueprint.weight_envelope_unsatisfiable` if Σminimum > 1 or Σmaximum < 1 over weighted nodes.
- `blueprint.unit_uncovered` (advisory) for any `node_type == "unit"` absent from `taxonomy_weights`.

Ship only if cheap; A–D are the priority.

---

## Acceptance for this spec

1. All six existing tests still pass unchanged.
2. New negative tests for A, B, C, D (one each minimum) pass.
3. Current AP Statistics fixtures still compile green (no new FATAL on the baseline).
4. Any advisory channel added is non-fatal and does not alter `plan_sha256` inputs unless Codex
   deliberately includes advisories in the canonical plan (recommend: exclude advisories from the
   hashed plan to keep determinism decoupled from non-fatal notes).

## Out of scope / notes

- No schema (`*.schema.json`) change is required for A–E; these are compiler-level cross-package
  invariants. If Codex prefers to encode any as schema, that is Codex's call, but the cross-package
  ones (A, B, D) cannot be expressed in single-document JSON Schema.
- This spec does not authorize any Dev/Production application. Repository + local verification only,
  consistent with `DECISION-0040`.
