repo: david-bloom/Cramapple
branch: main
path: docs/product

## Last sync

date: 2026-09-21T18:22:22Z

### Updated in this project

- Connected the repo as this design system's source of truth.
- Read the canonical visual identity briefs (v1 and v2) and both repo READMEs.
- Found that `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md` conflicts with this system (emerald green, Plus Jakarta Sans, dark-first, gold for full marks). **David's call: this design system supersedes it.**
- Recorded two David decisions: **dark mode retired** (light-only, superseding v2's dark-first requirement) and **the no-scroll plate held as-is** pending real AP Biology content, with the page-length tension documented rather than resolved.
- Wrote `docs/new_design/` as a commit-ready replacement — README with a v2-vs-built diff table and five open decisions, VISUAL_IDENTITY, CONTENT_AND_PEDAGOGY, COMPONENT_INVENTORY, TOKENS, HANDOFF, plus the token CSS.

Notes: the repo has no frontend — it is content packages, grading engines, prompts and Supabase migrations. No `tailwind.config`, no CSS, no `.tsx` anywhere (verified by regex across all 2,285 files), so there is no upstream token source to diff against. The visual system lives in prose in `docs/product/`.

No `commit:` recorded — the tree read resolved to `4dc0f74ce94a`, which is a tree hash, not a commit sha.

## Screen map

Every screen here was built from the four uploaded `.dc.html` working templates, **not** from repo files. The repo documents below govern them and are the reconciliation targets.

| Project screen | Repo files that govern it | Status |
| --- | --- | --- |
| `ui_kits/open-hand-frq/` | `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md`, `docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md` | Built from template; not reconciled with brief |
| `ui_kits/frq/` | `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md`, `CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md` | Built from template; not reconciled |
| `ui_kits/open-hand-mcq/` | `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` | Built from template; not reconciled |
| `ui_kits/mcq/` | `docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` | Built from template; not reconciled |
| `ui_kits/home/` | `docs/product/STUDENT_PORTAL_INTERACTION_DESIGN.md`, `docs/product/PROGRESS_DASHBOARD_V1_PLAN_2026_08_21.md` | Invented from parts; neither doc read yet |
| `tokens/`, `guidelines/` | `docs/new_design/` (supersedes `CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md`) | Canonical here; awaiting commit upstream |
| Sample content (AP Stats Unit 2) | `docs/product/AP_STATISTICS_UNIT2_TOPIC_POINT_BRIEFS.md` | Written by hand; not sourced from the pack |

## To commit upstream

`docs/new_design/` in this project is written to land at `docs/new_design/` in the repo verbatim. I can read the repo but cannot push, so David commits it. Once committed, mark v1 and v2 as superseded in `docs/README.md`'s folder list and log the decision in `docs/activity_log/DECISIONS_LOG.md`.

## Sync history

None — this is the first sync.
