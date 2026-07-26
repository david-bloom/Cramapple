# PROPOSAL (v2) — Branch-Sprawl Resolution & Prevention

**Status:** **APPROVED — R1–R7 adopted by David Bloom (2026-07-09).** Charter
encoding + formal `APPROVAL-NNNN`/`CHANGELOG` entry follow in a separate adoption
PR (this PR lands the proposal record only; see §6).
**Reconciled from:** Claude v1 draft + Codex second-opinion review (2026-07-09).
**Decision owner:** David Bloom (Product Owner).
**Adoption is a HARD GATE:** it materially changes
`docs/team_charter/AI_COLLABORATION_RULES.md` (§"In-Progress Drafts and Branches")
and the session start/close prompts — to be recorded in `team_charter/CHANGELOG.md`
against the adoption `APPROVAL-NNNN`.
**Why now:** recurring branch sprawl caused real work loss (grading docs orphaned
across branches, recovered from commits `e15d64b`/`a9e6ea4`/`a7438da`) — the latest
of several incidents (the `recovery/*`, `orphan-*`, `_tmp_orphan_*`, `backup/*`
branches are the scar tissue).

---

## 1. Evidence (audit, 2026-07-09)

- **20 local branches; 21 remote (+ `origin/HEAD`); 9 worktrees** (3 detached,
  1 `prunable`); **6 local branches already merged into `origin/main`.**
- The grading checkout had **62 changed/untracked paths** → cleanup from *there* is
  dangerous (Codex). `origin/main` @ `23525c0` (#53); recovery progressing via
  **PRs #44–#53** (#50–#52 still open at review time).
- Scar-tissue names: `recovery/*-20260721` (×3), `_tmp_orphan_landing`,
  `claude/orphan-branch-recovery-storage`, `backup/task-0012-pre-rebase-20260630`,
  duplicate `*-local` branches, per-session random suffixes.

## 2. Root cause (multi-agent orchestration, not git)

1. **Branches are per-session, not per-task** (random suffixes ⇒ one task fragments
   across branches). **Primary driver.**
2. **No fast integration to trunk** (work diverges, duplicates, gets re-"recovered").
3. **No cleanup discipline** — merged branches undeleted; worktrees unpruned;
   **uncommitted/unpushed** work orphaned. *(Per Codex: detached HEAD is normal for
   some Codex worktrees and is NOT itself the risk; unpushed/uncommitted work is.)*

## 3. Adopted rules (R1–R7 — APPROVED 2026-07-09)

| # | Rule | Reconciliation note |
|---|---|---|
| **R1** | A branch = **one independently reviewable task/slice**, named `<agent>/<task-id>-<slug>` (no session suffixes). A new session on an in-flight slice **continues that branch, doesn't fork.** | Codex: *slice*, not a growing task-family branch. |
| **R2** | **Continuation is driven by the canonical task record**, carrying `branch`, `PR`, `task/status`, and (optionally) the Codex task/worktree ID. Naming alone is insufficient. | Codex (v1-Q2): the mechanism, not just the name. |
| **R3** | **Integrate completed slices regularly via small PRs.** Stacked PRs only for a *real* dependency; **no standing task-family integration branches.** | Codex (v1-Q1). |
| **R4** | **Session close:** commit-and-**push** checkpoints whenever possible; if interrupted, an **explicit dirty-state handoff** in the task/handoff record — a stash is NOT durable; never leave silent orphaned changes. | Codex: v1's "never end uncommitted" was too absolute. |
| **R5** | **Merge/readiness = a GATED merge-automation agent** (David-approved 2026-07-09): a conductor/agent may merge **only after** approvals + checks + review gates are mechanically satisfied; post-merge cleanup (delete/prune) is automated. | Codex (v1-Q4) + David's decision to automate. |
| **R6** | **Delete-on-merge** for verified-merged branches. **Archive-tag** only *unique unmerged/superseded* work — not every merged branch. | Codex refinement (v1-Q5). |
| **R7** | **Trunk protection:** no normal direct commits to `main`; emergency = **human-only, auditable break-glass.** | Codex (v1-Q6). |

**Correction (v1 overstated it):** `main` owns **integrated truth**, not active work.
Active work lives on a narrowly scoped task branch **until reviewable**, then
integrates. ("Which branch owns grading" ⇒ a scoped task branch now, `main` after
integration.)

**Highest-leverage: R1 + R2** (branch-per-slice + task-record continuation) — the
root cause, and they would have prevented the loss that triggered this.

## 4. One-time resolution (do NOT run from the dirty grading checkout)

1. From a **clean checkout of `origin/main`**, delete the 6 verified-merged branches.
2. `git worktree prune` + remove stale/`prunable` worktrees, after confirming no
   unique **unpushed** work in each.
3. Triage each unmerged branch → **merge via PR** / **archive-tag then delete** /
   **keep**. Let recovery PRs #50–#52 finish first; reconcile so nothing is
   double-handled.

## 5. Adoption steps (Hard Gate — follow-up PR)

1. Encode R1–R7 in `AI_COLLABORATION_RULES.md` §In-Progress Drafts and Branches +
   the session start/close prompts; log in `team_charter/CHANGELOG.md` against the
   adoption `APPROVAL-NNNN`.
2. GitHub: protect `main` (PR-only, required checks); enable auto-delete-head-on-merge.
3. Stand up the **gated merge-automation agent** (R5) with its approval/check gates.
4. Run §4 one-time resolution from a clean checkout.

## 6. This PR (self-durability first)

Per Codex's "most useful next action," this PR lands **only this proposal file**
on a clean branch off `origin/main` — separated from the sprawl it resolves, and
serving as the first worked example of R1–R4. The charter encoding + formal
approval/CHANGELOG entries are a **separate adoption PR** (§5).

## 7. Reconciliation log (v1 → v2)

Branch rule tightened to *reviewable slice* [R1]; added task-record continuation
mechanism [R2]; softened "never uncommitted" → push-checkpoints + explicit dirty
handoff [R4]; worktrees kept (detached-HEAD reframed as normal); merge automation
gated + archive-tags scoped to unique unmerged work [R5,R6]; direct-to-main →
human-only break-glass [R7]; corrected "main owns grading" → integrated truth.

## 8. Decisions

1. Approve R1–R7 as the operating-model change (Hard Gate)? — **APPROVED (David, 2026-07-09).**
2. Human conductor vs gated merge-automation agent for R5? — **APPROVED: gated merge-automation agent.**
3. Execute §6 (clean branch + commit + push + PR for this proposal)? — **APPROVED; this PR.**
