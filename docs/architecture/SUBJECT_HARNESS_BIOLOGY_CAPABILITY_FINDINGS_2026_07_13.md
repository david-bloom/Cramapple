# AP Biology Harness Onboarding — Capability Findings (Codex + product)

**Prepared:** 2026-07-13 · Author: Claude (content-lane extensibility probe)
**For:** Codex (capability registry, compiler, grading engine) + Product Owner (graph-capture decision)
**Task:** TASK-0017 · Related: `TASK-0016` (grading engine), `DECISION-0036`, `project_ap_biology_publish_gap`
**Probe:** `docs/content/ap_biology_harness_probe/` — reproduce with
`deno run --allow-read docs/content/ap_biology_harness_probe/compile-check.ts`

## Summary

An AP Biology extensibility probe (1 SubjectPackage + 3 item-packages: long FRQ, short FRQ, graph
FRQ) was compiled through the **unmodified** `scripts/subject-harness/compiler.ts`. Outcome:

- **The harness is extensible to Bio's structure with no schema/compiler change.** It accepted the
  `create-subject` operation, heterogeneous **long (8 pt) + short (4 pt)** FRQ archetypes, an 8-unit /
  6-practice taxonomy, and mixed modalities. The long and short FRQ items produced **zero** issues.
- Onboarding Bio for real is **correctly blocked** on two capability investments the compiler flagged.
  A control run (same package, both capabilities marked `supported`) compiles green — proving
  capability is the *sole* blocker, not package structure.

Exact Run A output (real registry):

```
capability.not_supported               /capabilities/response-modality/graph    : experimental
capability.missing                     /capabilities/grader/biology-frq-rubric  : unregistered
capability.item_modality_not_supported /items/2/parts/0                         : graph
```

## Finding 1 — `graph` response modality is `experimental` (Codex + product)

**Where:** `schemas/subject-onboarding/platform-capabilities.v1.json` →
`response_modalities.graph = "experimental"` (also `drawing`, `file-upload`).

**Why it matters:** AP Biology FRQs are **exam-aligned graphing** (hybrid paper booklets; Cramapple's
hand-drawn-graph capture applies to Bio, unlike Stats where HDG is supplemental). A Bio SubjectPackage
that declares `graph` in its required capabilities — and any item whose part uses the `graph` modality —
is blocked until the platform can actually render/collect/grade a graph response.

**Action (do NOT just flip the flag):** promoting `graph` to `supported` must reflect a *real*
capability — otherwise onboarding Bio would fail-open and break at runtime. This is a product +
engineering decision on graph capture (ties to the existing HDG workstream), then a registry update.
Until then, the harness is right to block. If a near-term Bio pilot needs it, scope the minimum
graph-capture path first.

## Finding 2 — no `biology-frq-rubric` grader registered (Codex / TASK-0016)

**Where:** `platform-capabilities.v1.json` → `graders` has `mcq-key`, `statistics-frq-rubric` only.

**Why it matters:** Bio needs its own FRQ grader; reusing the Stats grader would be incorrect. This is
the multi-subject grading strategy (differentiate grading by subject/content type) meeting the harness
capability gate.

**Action:** register a `biology-frq-rubric` grader (TASK-0016 grading-engine lane) and mark it
`supported` once it exists. The harness's `verification.required_check_types` for Bio also assume a
`content-correctness` check (present in the registry) rather than Stats' `statistical-correctness`.

## What is NOT needed

No change to `compiler.ts`, the SubjectPackage/item-package schemas, or the A–D integrity checks. The
contract handled a structurally different second subject as-is. The four remaining authoring footguns
tracked in `SUBJECT_HARNESS_COMPILER_INTEGRITY_CHECKS_SPEC_2026_07_13.md` are unaffected by this probe.

## Lane split

| Item | Owner |
|------|-------|
| Graph-capture product decision + real rendering/grading capability | Product Owner + Codex |
| `platform-capabilities.v1.json` registry updates (once capabilities are real) | Codex |
| `biology-frq-rubric` grader | Codex (TASK-0016) |
| Probe scaffolding / any Bio content | Claude (content lane) — gated on Bio fact-pack anchoring + tutor review |

This finding does not authorize any registry change, grader deployment, or Bio content publication —
it reports what Bio onboarding requires. Repository/local only.
