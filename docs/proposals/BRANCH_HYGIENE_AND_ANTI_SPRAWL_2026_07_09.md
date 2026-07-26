# PROPOSAL (v4) — Branch-Sprawl Resolution & Prevention

**Status:** **Proposed — Awaiting Owner Approval.** R1–R7 were approved by David in
chat (2026-07-09), but per governance (GitHub is source of truth; chat-only
decisions are not valid records) this is **not durable until David records
approval on this PR, citing the final commit SHA of these amendments.** When he
does, it flips to Approved and the adoption PR carries the formal `APPROVAL-NNNN`
**and** `DECISION-NNNN`.
**Reconciled from:** Claude v1 → Codex second-opinion → PR #54 review round 1
(8 change requests) → PR #54 review round 2 (R5 + sequence refinements). All
incorporated here.
**Decision owner:** David Bloom (Product Owner).
**Adoption is a HARD GATE:** it changes `docs/team_charter/AI_COLLABORATION_RULES.md`
(§"In-Progress Drafts and Branches") + related charter docs + session prompts —
recorded in `team_charter/CHANGELOG.md` against both the `APPROVAL-NNNN` and
`DECISION-NNNN`.
**Why now:** recurring branch sprawl caused real work loss (grading docs orphaned
across branches, recovered from commits `e15d64b`/`a9e6ea4`/`a7438da`).

---

## 1. Evidence (audit refreshed 2026-07-26)

- **20 local branches; 21 remote (+ `origin/HEAD`); 9 worktrees** (3 detached,
  1 `prunable`); **6 local branches already merged into `origin/main`.**
- The grading checkout had **62 changed/untracked paths** → cleanup from *there* is
  dangerous. `origin/main` @ `23525c0` (#53); recovery progressed via
  **PRs #44–#53** (#50–#52 still open at review time).
- **No CI exists** (no `.github/workflows`) — so gated merge automation has nothing
  to gate on until a required check is established.
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
| **R5** | **Merge/readiness — GitHub-native, not a custom agent by default:** (a) a **human/conductor records governance readiness**; (b) **GitHub-native automation** (auto-merge / merge queue) **mechanically executes eligible merges** once required checks + required reviews pass; (c) **custom privileged automation is contingent — NOT adopted by default.** If ever needed, it starts **dry-run** under a least-privilege envelope: no branch-protection bypass; machine-readable readiness label or explicit approval+decision IDs; required checks passing; non-draft; no unresolved threads; sensitive-path escalation; full audit log. |
| **R6** | **Delete-on-merge for the *remote* head branch** (GitHub auto-delete). **Local** branch/worktree cleanup **cannot** be centrally automated across machines — it is a client-side action gated by the R7 preflight. Archive-tag only unique unmerged/superseded work — not every merged branch. |
| **R7** | **Worktree/branch removal preflight — verify ALL THREE:** (1) no uncommitted changes, (2) no unique commits, (3) no unpushed refs. Only then remove. |
| **—** | **Trunk protection:** no normal direct commits to `main`; force-push/deletion blocked; emergency = **human-only, auditable break-glass.** |

**Correction:** `main` owns **integrated truth**, not active work. Active work lives
on a narrowly scoped task branch **until reviewable**, then integrates.

**Highest-leverage: R1 + R2** (branch-per-slice + task-record continuation).

## 4. One-time resolution (do NOT run from the dirty grading checkout)

From a **clean checkout of `origin/main`**: delete the 6 verified-merged branches;
remove stale/`prunable` worktrees **only after the R7 three-check preflight**, then
`git worktree prune`; triage each unmerged branch → **merge via PR** /
**archive-tag then delete** / **keep**. Let recovery PRs #50–#52 finish first;
**separate grading-doc recovery from executable Phase C artifacts.**

## 5. Adoption details (Hard Gate — governance/docs-only PR)

- **Scope** (one cohesive governance slice): `AI_COLLABORATION_RULES.md` (canonical
  R1–R7); `TASK_WORKFLOW.md` (+ branch / PR / task-thread fields for R2);
  `HANDOFF_PACKET_TEMPLATE.md` (R4 dirty-state handoff); Codex + Claude
  session-start prompts; **`CLOSE_SESSION_PROMPT.md` — reference & operationalize
  the canonical R4 policy, do NOT maintain a competing definition**; `APPROVALS_LOG.md`
  + `DECISIONS_LOG.md`; charter `CHANGELOG.md`. **No repo settings or merge bot in
  this PR** — those are separately verifiable operational actions.
- **Numbering:** allocate `APPROVAL-NNNN` + `DECISION-NNNN` from `origin/main` by
  **parsing the full logs (not their indexes)**; **recheck open PRs immediately
  before merge**; `main` remains authoritative; on collision the **later-merging
  branch renumbers**.
- **CI:** first **inventory existing test commands**; create **one fast,
  deterministic, secret-free** workflow (not every checker blocking); establish it
  on `main`, observe it passing reliably, and **only then** make it a required check.

## 6. This PR (self-durability first)

Lands **only this proposal file** on a clean branch off `origin/main`, separated
from the sprawl it resolves. It **demonstrates clean slice scope** but **predates
formal naming enforcement** — the branch `claude/branch-hygiene-proposal` has no
`task-or-work-id`; R1 naming enforcement begins at adoption (§5).

## 7. Recommended sequence (Codex round 2)

1. Amend PR #54; request Codex re-review.
2. David posts durable approval **citing the final SHA**.
3. Merge #54; delete its remote branch.
4. Open the governance-only adoption PR with both `APPROVAL-NNNN` + `DECISION-NNNN`.
5. Enable PR-only `main`; block force-push/deletion; retain human-only admin bypass.
6. Merge and stabilize the minimal CI workflow.
7. Make its stable checks required; require appropriate review.
8. Enable remote-head auto-deletion and native auto-merge.
9. Use a merge queue **only if** concurrent merges create a real stale-base problem.
10. Phased cleanup; separate grading-doc recovery from executable Phase C artifacts.

## 8. Review-response log

Round 1 (8 change requests) + Round 2: R5 recast as **GitHub-native by default,
custom agent contingent** with readiness/execution split; trunk protection adds
force-push/deletion block; numbering refined (parse full logs, recheck before
merge, later-merger renumbers); CI refined (inventory first, one deterministic
required check, observe-then-require); close-session prompt references (not
redefines) canonical R4; sequence set to the 10 steps in §7; owner approval must
cite the final commit SHA.

## 9. Decisions

1. Approve R1–R7 (Hard Gate)? — **Pending durable owner approval on this PR, citing
   the final SHA.**
2. Merge/readiness model? — **GitHub-native auto-merge/merge-queue with the R5
   readiness/execution split; custom privileged agent contingent, not default.**
3. Execute §6 (land this proposal)? — **Done** (this PR; amended per review rounds).
