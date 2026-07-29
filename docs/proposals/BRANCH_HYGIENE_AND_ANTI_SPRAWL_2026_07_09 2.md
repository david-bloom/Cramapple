# PROPOSAL (v2) — Branch-Sprawl Resolution & Prevention

**Status:** Proposed. **Reconciled from Claude's v1 draft + Codex's second-opinion
review (2026-07-09).**
**Decision owner:** David Bloom (Product Owner).
**Adoption is a HARD GATE:** it materially changes
`docs/team_charter/AI_COLLABORATION_RULES.md` (§"In-Progress Drafts and Branches")
and the session start/close prompts — recorded in `team_charter/CHANGELOG.md`
against an `APPROVAL-NNNN`.
**Why now:** recurring branch sprawl caused real work loss (grading docs orphaned
across branches, recovered from commits `e15d64b`/`a9e6ea4`/`a7438da`). This is the
latest of several incidents (the `recovery/*`, `orphan-*`, `_tmp_orphan_*`, and
`backup/*` branches are the scar tissue).

---

## 1. Evidence (audit, 2026-07-09)

- **20 local branches; 21 remote (+ `origin/HEAD` alias); 9 worktrees** (3 detached,
  1 flagged `prunable`); **6 local branches already merged into `origin/main`.**
- Current grading checkout has **62 changed/untracked paths** → cleanup from *here*
  is dangerous (Codex). `origin/main` @ `23525c0` (#53); recovery is progressing via
  **PRs #44–#53** (#50–#52 still open).
- Scar-tissue names: `recovery/*-20260721` (×3), `_tmp_orphan_landing`,
  `claude/orphan-branch-recovery-storage`, `backup/task-0012-pre-rebase-20260630`,
  duplicate `*-local` branches, and per-session random suffixes
  (`-9lkjqc`, `-ob26x7`, `-mlr0o1`, `-y9x86f`).

## 2. Root cause (multi-agent orchestration, not git)

1. **Branches are per-session, not per-task** (random suffixes ⇒ one task fragments
   across branches). **Primary driver.**
2. **No fast integration to trunk** (work diverges, duplicates, gets re-"recovered").
3. **No cleanup discipline** (merged branches undeleted; worktrees unpruned;
   **uncommitted/unpushed** work orphaned — *note per Codex: detached HEAD is normal
   for some Codex worktrees and is NOT itself the risk; unpushed/uncommitted work is*).

## 3. Adopted rules (v2 — Claude ⇄ Codex reconciled)

| # | Rule | Reconciliation note |
|---|---|---|
| **R1** | **A branch = one independently reviewable task/slice**, named `<agent>/<task-id>-<slug>` (no session suffixes). A new session on an in-flight slice **continues that branch, doesn't fork.** | Codex refinement: *slice*, not an indefinitely growing task-family branch. |
| **R2** | **Continuation is driven by the canonical task record**, which carries `branch`, `PR`, `task/status`, and (optionally) the Codex task/worktree ID. Naming convention alone is insufficient. | Codex answer to v1-Q2 — the mechanism, not just the name. |
| **R3** | **Integrate completed slices regularly via small PRs.** Stacked PRs only for a *real* dependency; **no standing task-family integration branches.** | Codex answer to v1-Q1. |
| **R4** | **Session close:** commit-and-**push** checkpoints whenever possible; if interrupted, an **explicit dirty-state handoff** (recorded in the task/handoff) — a stash is NOT durable; never leave silent orphaned changes. | Codex refinement: v1's "never end uncommitted" was too absolute for interrupted sessions. |
| **R5** | **Merge ownership:** a conductor decides *readiness*; automation may merge **only after** approvals + checks + review gates are mechanically satisfied. Post-merge cleanup (delete/prune) can be automated. | Codex answer to v1-Q4. |
| **R6** | **Delete-on-merge** for verified-merged branches. **Archive-tag** only *unique unmerged/superseded* work — not every merged branch. | Codex refinement to v1-Q5 (don't over-archive). |
| **R7** | **Trunk protection:** no normal direct commits to `main`; emergency direct commit = **human-only, auditable break-glass.** | Codex answer to v1-Q6. |

**Correction (v1 overstated it):** `main` owns **integrated truth**, not active work.
Active grading (and any) work lives on a narrowly scoped task branch **until
reviewable**, then integrates. "Which branch owns grading" ⇒ a scoped task branch
now, `main` after integration.

**Highest-leverage rule: R1 + R2** together (branch-per-slice + task-record
continuation) — the root cause, and they would have prevented today's loss.

## 4. One-time resolution (do NOT run from the 62-change checkout)

Per Codex: do not begin deletion/worktree removal from the current dirty grading
checkout. Instead:
1. From a **clean checkout of `origin/main`**, delete the 6 verified-merged branches.
2. `git worktree prune` + remove the stale/`prunable` worktrees, after confirming
   no unique **unpushed** work in each.
3. Triage each unmerged branch → **merge via PR** / **archive-tag then delete** /
   **keep** (active). Let recovery PRs #50–#52 finish first; reconcile with them so
   we don't double-handle.
4. Then declare a single canonical branch policy per R1–R3 going forward.

## 5. Adoption steps (Hard Gate)

1. David approves R1–R7 → encode in `AI_COLLABORATION_RULES.md` §In-Progress Drafts
   and Branches + the session start/close prompts; log in `team_charter/CHANGELOG.md`.
2. GitHub: protect `main` (PR-only, required checks), enable auto-delete-head-on-merge.
3. Add a recurring conductor "integrate-ready → prune" routine (human or gated agent).
4. Run §4 one-time resolution from a clean checkout.

## 6. Make THIS proposal durable first (Codex's most-useful-next-action)

The proposal must not repeat the failure it describes. Next action: **create a clean
proposal-specific branch from `origin/main`, copy ONLY this file into it, commit +
push as `Status: Proposed`, open a PR** — separated from the sprawl it resolves. No
other repo files touched. (Claude to execute on David's go-ahead; push/PR is
outward-facing and awaits approval.)

## 7. Reconciliation log (what changed from v1)

- Branch rule tightened to *reviewable slice* (not task-family). [R1]
- Added the **task-record-as-registry** continuation mechanism. [R2]
- Softened "never uncommitted" → **push-checkpoints + explicit dirty handoff**. [R4]
- Worktrees: **keep**; detached-HEAD reframed as normal, not the risk.
- Merge automation gated on approvals/checks; archive-tags scoped to unique unmerged
  work only. [R5, R6]
- Direct-to-main → **human-only break-glass**. [R7]
- Corrected "main owns grading" → main owns integrated truth.
- Added the Hard-Gate framing + the self-durability step (§6).

## 8. Open decisions for David

1. Approve R1–R7 as the operating-model change (Hard Gate)?
2. Human conductor vs a gated merge-automation agent for R5?
3. Go-ahead to execute §6 (clean branch + commit + push + PR) for this proposal?
