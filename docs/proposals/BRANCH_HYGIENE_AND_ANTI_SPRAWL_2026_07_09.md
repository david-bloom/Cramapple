# PROPOSAL (v3) — Branch-Sprawl Resolution & Prevention

**Status:** **Proposed — Awaiting Owner Approval.** R1–R7 were approved by David in
chat (2026-07-09), but per governance (GitHub is source of truth; chat-only
decisions are not valid records) this is **not durable until David records
approval on this PR**. When he does, it flips to Approved and the adoption PR
carries the formal `APPROVAL-NNNN` **and** `DECISION-NNNN`.
**Reconciled from:** Claude v1 → Codex second-opinion → PR #54 review (all 8
change requests incorporated here).
**Decision owner:** David Bloom (Product Owner).
**Adoption is a HARD GATE:** it changes `docs/team_charter/AI_COLLABORATION_RULES.md`
(§"In-Progress Drafts and Branches") + session prompts — recorded in
`team_charter/CHANGELOG.md` against both the `APPROVAL-NNNN` and `DECISION-NNNN`.
**Why now:** recurring branch sprawl caused real work loss (grading docs orphaned
across branches, recovered from commits `e15d64b`/`a9e6ea4`/`a7438da`).

---

## 1. Evidence (audit refreshed 2026-07-26)

- **20 local branches; 21 remote (+ `origin/HEAD`); 9 worktrees** (3 detached,
  1 `prunable`); **6 local branches already merged into `origin/main`.**
- The grading checkout had **62 changed/untracked paths** → cleanup from *there* is
  dangerous. `origin/main` @ `23525c0` (#53); recovery progressed via
  **PRs #44–#53** (#50–#52 still open at review time).
- Scar-tissue names: `recovery/*-20260721` (×3), `_tmp_orphan_landing`,
  `claude/orphan-branch-recovery-storage`, `backup/task-0012-pre-rebase-20260630`,
  duplicate `*-local` branches, per-session random suffixes.

## 2. Root cause (multi-agent orchestration, not git)

1. **Branches are per-session, not per-task** (random suffixes ⇒ one task fragments
   across branches). **Primary driver.**
2. **No fast integration to trunk** (work diverges, duplicates, gets re-"recovered").
3. **No cleanup discipline** — merged branches undeleted; worktrees unpruned;
   **uncommitted/unpushed** work orphaned. *(Detached HEAD is normal for some Codex
   worktrees and is NOT itself the risk; uncommitted/unpushed work is.)*

## 3. Proposed rules (R1–R7) — awaiting durable owner approval

| # | Rule |
|---|---|
| **R1** | A branch = **one independently reviewable task/slice**, named `<agent>/<task-or-work-id>-<slug>` (a `task-or-work-id` covers un-numbered work like proposals/chores; no random session suffixes). A new session on an in-flight slice **continues that branch, doesn't fork.** |
| **R2** | **Continuation is driven by the canonical task record**, which carries `branch`, `PR`, and `task/status`, and MAY record a Codex task/thread ID. **Machine-local worktree paths/IDs stay ephemeral — never canonicalized in the task record.** |
| **R3** | **Integrate completed slices regularly via small PRs.** Stacked PRs only for a *real* dependency; **no standing task-family integration branches.** |
| **R4** | **Session close:** commit-and-**push** checkpoints whenever possible; if interrupted, an **explicit dirty-state handoff** in the task/handoff record — a stash is NOT durable; never leave silent orphaned changes. |
| **R5** | **Readiness judgment and merge execution are separated:** (a) a **human/conductor records governance readiness**; (b) **automation verifies objective gates** (checks green, required approvals present, no conflicts) **and executes the merge**; (c) **automation never infers approval from prose and never makes an ambiguous risk decision** — if a gate is not mechanically satisfiable, it escalates to the human. |
| **R6** | **Delete-on-merge for the *remote* head branch** (GitHub auto-delete). **Local** branch/worktree cleanup **cannot** be centrally automated across machines — it is a client-side action gated by the R7 preflight. Archive-tag only unique unmerged/superseded work — not every merged branch. |
| **R7** | **Worktree/branch removal preflight — verify ALL THREE:** (1) no uncommitted changes, (2) no unique commits, (3) no unpushed refs. Only then remove. |
| **—** | **Trunk protection:** no normal direct commits to `main`; emergency = **human-only, auditable break-glass.** |

**Correction:** `main` owns **integrated truth**, not active work. Active work lives
on a narrowly scoped task branch **until reviewable**, then integrates.

**Highest-leverage: R1 + R2** (branch-per-slice + task-record continuation).

## 4. One-time resolution (do NOT run from the dirty grading checkout)

1. From a **clean checkout of `origin/main`**, delete the 6 verified-merged branches.
2. Remove stale/`prunable` worktrees **only after the R7 three-check preflight**;
   then `git worktree prune`.
3. Triage each unmerged branch → **merge via PR** / **archive-tag then delete** /
   **keep**. Let recovery PRs #50–#52 finish first; reconcile so nothing is
   double-handled.

## 5. Adoption steps (Hard Gate — follow-up PR)

1. Record durable owner approval on this PR (§ Status), then encode R1–R7 in
   `AI_COLLABORATION_RULES.md` §In-Progress Drafts and Branches + the session
   start/close prompts; log in `team_charter/CHANGELOG.md` against **both** the
   `APPROVAL-NNNN` and `DECISION-NNNN`.
2. GitHub: protect `main` (PR-only, required checks); enable auto-delete-head-on-merge.
3. Stand up the R5 automation (objective-gate verify + execute; human records readiness).
4. Run §4 one-time resolution from a clean checkout.

## 6. This PR (self-durability first)

Lands **only this proposal file** on a clean branch off `origin/main`, separated
from the sprawl it resolves. It **demonstrates clean slice scope** (single-purpose,
off `main`, pushed, no orphaned worktree) but **predates formal naming enforcement**
— the branch `claude/branch-hygiene-proposal` has no `task-or-work-id`; enforcement
of the R1 naming format begins at adoption (§5).

## 7. Review-response log (PR #54 review → v3)

All 8 change requests incorporated: (1) audit re-dated to 2026-07-26; (2) status →
Proposed—Awaiting Owner Approval (no chat-only approval claim); (3) adoption
requires both APPROVAL + DECISION records; (4) R1 naming relaxed to
`task-or-work-id`, worked-example claim corrected; (5) R5 split into
readiness-judgment vs gate-verify-and-execute, no prose-inferred approval; (6) R6
scoped auto-delete to remote heads, local cleanup client-side; (7) R7 three-check
preflight; (8) local worktree paths kept ephemeral in R2.

## 8. Decisions

1. Approve R1–R7 (Hard Gate)? — **Pending durable owner approval on this PR** (chat
   approval 2026-07-09 is not yet a valid record).
2. Merge/readiness model? — **Gated automation with readiness/execution split (R5)**
   (chat-approved 2026-07-09; confirm on-PR).
3. Execute §6 (land this proposal)? — **Done** (this PR).
