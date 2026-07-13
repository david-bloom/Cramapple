# Subject-Harness Compiler — Cross-Package Integrity Checks (Codex handoff spec)

**Prepared:** 2026-07-13 · Author: Claude (H0/H1 contract lane)
**For:** Codex (owns `scripts/subject-harness/compiler.ts`, verifier registry, tests)
**Task:** TASK-0017 · Related: `DECISION-0037`, `DECISION-0039`, `DECISION-0040`
**Status:** **A, C, D adopted by Codex; B decided by Claude (2026-07-13) — lower-bound rule in §B, ready for Codex to implement.**

## Adoption status (2026-07-13, after Codex's TASK-0017 "done")

Codex's final harness (verified at HEAD `a1cc743`; DB evidence packet PASS at `4b1bc07`) **added**
an item-modality check — `capability.item_modality_undeclared` (+ `capability.item_modality_not_supported`)
in `compiler.ts` `walkParts` — validating each item part's `response_modalities` against the
**subject's** `capabilities.required_response_modalities` and the platform registry. That partially
covers gap D at the *subject* level.

Codex subsequently adopted **A, C, and D** with fatal, machine-readable compiler checks and
negative regression coverage. The checks resolve inventory target archetype keys and item types,
constrain archetype modalities to subject capabilities, and recursively constrain part/subpart
modalities to the exact resolved archetype version.

**Claude's B decision (2026-07-13) — resolves Codex's deferral:** `inventory.targets` is an
*authoring bank* (Orly-approved 100 MCQ / 70 FRQ, `APPROVAL-0036`), **not** an exam form. B is
therefore **not** an equality check. Use the **lower-bound** rule in §B
(`inventoryDemand(T) >= formDemand(T)`, error `inventory.below_form_demand`): it never rejects the
approved bank, needs no schema change, and still catches an inventory that cannot fill one exam form.
Ready for Codex to implement; not yet in the compiler.

The four AP Statistics 2027 slice items in `docs/content/ap_statistics_2026_27_slice/` compile green
under the current checks, so none of these gaps is blocking that content today — they remain
authoring footguns to close when convenient.

## Why

The H0/H1 contract is structurally sound: `compilePlan` already validates exam-pack match,
archetype resolution + item-type agreement, taxonomy resolution, source refs, rubric point
reconciliation (criteria → part → archetype), stimulus refs, deterministic-check-type
allow-listing, `content_sha256`, capability preflight, taxonomy-parent resolution, blueprint
section-weight sums, and academic-year consistency. All six existing tests pass.

Four cross-package invariants were identified. A, C, and D are now enforced; B awaits the inventory
semantics decision described above. This spec defines the rule, error
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

## B — Inventory must be able to fill at least one exam form (FATAL) — REVISED 2026-07-13

**Revised per Codex's correct objection (2026-07-13).** The original rule required
`inventoryDemand(T) == blueprintDemand(T)`. That is **wrong**: `inventory.targets` is an *authoring
bank* (Orly-approved 100 MCQ / 70 FRQ, `APPROVAL-0036`), while `blueprint.sections[].item_count`
(42 MCQ / 4 FRQ) describes *one exam form*. Equality would reject correct packages. **Do not
implement the equality version.** Use the lower-bound below, which is correct whether `inventory`
holds bank counts or per-form counts, and still catches the real defect (an inventory that cannot
even assemble one form).

**Gap:** nothing checks that the authored inventory can supply a full exam form. An inventory
summing to 3 FRQ under a 4-FRQ form passes.

**Rule (lower-bound):** For each `item_type T`:
- `inventoryDemand(T)` = Σ `target_count` over `inventory.targets` with `item_type == T`.
- `formDemand(T)` = Σ `item_count` over `blueprint.sections` whose `item_types` **equals `[T]`
  exactly** (single-type sections only).
- If at least one single-type section exists for `T`, require `inventoryDemand(T) >= formDemand(T)`.
- Any section with more than one entry in `item_types` makes its counts unattributable per type;
  emit a non-fatal advisory and skip that section from `formDemand`.

**Errors:**
| code | severity | path | message |
|------|----------|------|---------|
| `inventory.below_form_demand` | FATAL | `/inventory/targets` | `item_type <T>: inventory <n> < one form needs <m>` |
| `blueprint.mixed_section_unreconciled` | ADVISORY (record, do not fail) | `/blueprint/sections/{i}` | `section <key> mixes item_types; counts not reconciled` |

Advisories: if the compiler has no advisory channel yet, add an `advisories: Issue[]` field to
`CompiledPlan` rather than pushing to `issues`. Do not fail the build on an advisory.

**Placement:** after A, before the per-item loop.

**Baseline:** current fixture (per-form-style inventory) — mcq 42 ≥ 42, frq 4 ≥ 4 → green. Also
green once inventory carries the approved bank — mcq 100 ≥ 42, frq 70 ≥ 4.

**Test:** set an frq `inventory.targets[].target_count` so the frq sum is `3` → 3 < 4 →
`inventory.below_form_demand`.

**Optional (only if the team wants bank vs form modeled explicitly):** add an
`inventory.kind: "bank" | "per-form"` discriminator (default `per-form` for back-compat). The
lower-bound above is correct without it; the discriminator would only enable a stricter *equality*
check for `per-form` inventories if ever desired. Not required to unblock A/C/D.

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
