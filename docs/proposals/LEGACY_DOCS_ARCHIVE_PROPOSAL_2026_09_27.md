# Proposal: Legacy-docs handling — archive vs. annotate-in-place

STATUS: DECIDED 2026-09-27 (DECISION-0075) — **Option A chosen: annotate-in-place, no move.** Nothing moved or deleted.
DATE: 2026-09-27
AUTHOR: doc-cleanup session (Claude)

> **OUTCOME (2026-09-27, DECISION-0075):** David chose **Option A**. Superseded docs stay in place with
> supersession banners and the `docs/INDEX.md` list; no `docs/legacy/` tree is created. Options B/C below
> are retained only as the path to follow if physical separation is ever revisited.

## The question

Should superseded design/architecture docs be **physically moved** into a `docs/legacy/` (or
`docs/archive/`) tree that is excluded from normal AI search/context unless explicitly requested — or
is the **annotate-in-place + INDEX** approach (already applied this session) enough?

## What "ignored unless needed" would mean mechanically

There is no reliable harness-level "don't read this folder" switch in Claude Code / the session
tooling — read scoping isn't a permission the way write/exec are. So "ignored unless needed" in
practice means:

1. A folder convention (`docs/legacy/`), and
2. A one-line instruction in the session-start doc / `docs/INDEX.md` / (if created) a root `CLAUDE.md`:
   *"Do not read `docs/legacy/**` unless a task explicitly asks for historical research."*

That is a **soft** exclusion (a norm an agent follows), essentially the same enforcement strength as
the INDEX's "superseded/historical — do not treat as current" list that already exists. A physical
move mainly helps *humans* browsing the tree and reduces the chance an agent stumbles into a stale doc
via `ls`/`grep`; it does not hard-block reads.

## What qualifies as legacy vs. still load-bearing

**Candidate legacy (superseded, safe-ish to archive):**

| Doc(s) | Why legacy | Link/cite risk if moved |
| --- | --- | --- |
| `product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF.md` (v1) | Superseded by `new_design/` | Low — cited mainly as "historical input" |
| `product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md` (v2) | Superseded by `new_design/` | Low |
| `product/USE_MODES_STRATEGIC_RECONCILIATION.md` | Superseded by consolidation + single-mode | Low–medium (cited by consolidation plan §; that link would need updating) |
| `product/DESIGN_SYSTEM_CUTOVER_PLAN.md` | Palette/frame stale | **Medium** — `APP_REBUILD` §15 cites it as a source; its gap-analysis structure is still useful |
| `teaching/COURSE_MODE_*` tree (~55 files: pilot specs, rederivation records, work orders, pilot logs) | Course Mode retired as a *mode* | **Medium–high** — some are content-creation protocols/rederivation records that other content docs or QA may still reference; needs a link/cite audit before moving |

**Explicitly NOT legacy — keep in place (per `APP_REBUILD` §10, still live):**

- Reviewer/admin portal docs (`product/QUESTION_AND_ANSWER_REVIEW_PORTAL_DESIGN.md`,
  `CONTENT_OPERATIONS_ADJUDICATION_RELEASE_DESIGN.md`, etc.) — the double-approve publication flow runs
  through the reviewer routes; these are current.
- `exam-buddy-wireframe` (stays deployed for the reviewer portal until rehomed).
- `APP_REBUILD_MIGRATION_PLAN.md`, `new_design/`, `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md`,
  `LAUNCH_*`, the new one-pager and `docs/INDEX.md` — all current.

## Risks of a hard move

- **Burying a cited doc.** `APP_REBUILD` §15 lists the cutover plan and consolidation-adjacent docs as
  sources; several `COURSE_MODE_*` files are cross-referenced by content/QA docs. Moving them breaks
  those references silently unless every referrer is updated in the same pass.
- **Relative-link breakage.** Any `../` link inside a moved doc, and any link *to* it, changes.
- **Re-derivation records have residual value.** The `COURSE_MODE_STATS_*` rederivation records are
  evidence artifacts; archiving is fine, deleting would lose audit trail. (This proposal is archive, not
  delete — deletion is not proposed.)
- **Low marginal benefit over what's already done.** The banners + INDEX already route an agent to
  current content in one hop and flag legacy explicitly.

## How banners + INDEX already reduce the need

This session applied `STATUS:`/CORRECTION banners to every stale canonical doc and listed them in
`docs/INDEX.md`'s "Superseded / historical — do NOT treat as current" table. An agent entering via
`PROJECT_SETUP.md` → `docs/INDEX.md` is steered correctly without any file moving. That is the bulk of
the value a `docs/legacy/` move would provide, at zero link-break risk.

## Recommendation

**Recommended: Option A — annotate-in-place, no move now.** Keep the banners + INDEX as the mechanism.
It achieves the discoverability goal with no link-break risk and no audit-trail disturbance. Add the
one-line "don't read `docs/legacy/**` unless asked" norm only if/when a legacy folder is actually
created.

If David wants a physical separation anyway, do it in the **lowest-risk staged** form:

- **Option B (staged, medium):** create `docs/legacy/` and move only the four low-risk files (v1, v2
  briefs, `USE_MODES_STRATEGIC_RECONCILIATION.md`, and — after checking `APP_REBUILD` §15 — the cutover
  plan), updating every referrer in the same commit. Leave the `COURSE_MODE_*` tree in place pending a
  link/cite audit.
- **Option C (full, higher risk):** additionally move the whole `COURSE_MODE_*` tree — only after a
  grep-based link/cite audit confirms no current doc depends on them. More discoverability, more work,
  more breakage surface.

**None of B or C is executed without David's explicit sign-off**, and even then as its own reviewable
task (per `DEFINITION_OF_DONE.md`), not folded into this docs-cleanup pass.

## Decision requested

- [x] **A** — keep annotate-in-place (recommended); no move. **← chosen (DECISION-0075)**
- [ ] **B** — create `docs/legacy/`, move the 4 low-risk files with referrer updates.
- [ ] **C** — B plus the `COURSE_MODE_*` tree after a link audit.
