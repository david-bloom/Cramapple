# Cramapple AI Collaboration Rules

**Status:** Approved
**Owner / Product Owner:** David Bloom
**Canonical Folder:** `docs/team_charter/`

## Purpose

This document defines how humans and AI agents collaborate on Cramapple.

GitHub documentation is the source of truth. Chat is useful for discussion, but durable project state must be written into GitHub.

## Roles

### Product Owner / Final Approver

David Bloom holds this role.

Owns:

- Product direction.
- Scope decisions.
- Priority decisions.
- Task approval.
- Risk acceptance.
- Done decisions.
- Launch/deployment decisions unless delegated.

### Functional Co-Founders — Delegated Domain Approvers

- Orly Bloom owns learning, curriculum, teaching design, and expert-validation leadership.
- Micah Bloom owns marketing, brand, user acquisition, and go-to-market leadership.
- Content operations and implementation/release operations are domains the Product Owner holds directly unless explicitly delegated.

**Domain approval authority.** Within their named domain, a Functional Co-Founder may clear a hard gate without routing it through the Product Owner first. A decision stays in its domain lane by default. It escalates to the Product Owner only when it visibly:

1. touches a second named domain,
2. touches money, legal, privacy, or production, or
3. the domain approver explicitly punts it.

This is the mechanism that keeps the Product Owner from becoming the bottleneck for every hard call — see `STANDING_APPROVAL_LANES.md` for how domain approvals are recorded. Functional ownership does not replace Product Owner approval where one of the three escalation conditions applies.

### Strategy Advisor

Owns:

- Working with David and the co-founders to develop plans.
- Challenging assumptions and identifying alternatives.
- Supporting market, product, operating, and business decisions.
- Recording recommendations, rationale, risks, and unresolved questions.

The Strategy Advisor is advisory. The role does not independently approve scope, implementation, spending, risk acceptance, Done decisions, or launch.

### Main Conductor

Owns:

- Source-of-truth orientation.
- Approval boundaries.
- Agent coordination.
- Final QA verdicts.
- GitHub publishing.
- Setting a task's status to `Done` after integrating the QA Agent's recommended verdict and verifying evidence. This is the only role that may make that transition — see QA Agent below.

### Implementation Agent

Owns:

- Execution against approved scope.
- Implementation notes.
- Test results.
- Deviation reports.
- Remediation.

### QA Agent

Owns:

- Proposed findings.
- Evidence review.
- Blocking/non-blocking risk separation.
- Proposed verdict only.

The QA Agent **may** set a task's status to `Blocked` when QA cannot proceed (missing evidence, blocked dependency, environment issue), and may populate the task's `QA Result` and `Test Results` fields with proposed findings, evidence, and a recommended verdict (`Pass` / `Fail`).

The QA Agent **must not** set status to `Done` or `Do Not Do`, approve, close, publish final decisions, deploy, migrate, alter live state, or otherwise mark a task passed as final. Those are Main Conductor or Product Owner actions.

## Source-of-Truth Rule

If it is not written in GitHub, it does not exist for operating purposes.

Every project document retained in the local workspace must also be committed
and pushed to `david-bloom/Cramapple`. A document change is not durably complete
while it exists only on one machine.

Agents must:

- include new and modified project documents in the relevant Git commit;
- push the commit to GitHub before reporting synchronization complete;
- verify the remote branch contains the commit;
- report any local document that could not be pushed;
- exclude temporary renders, caches, editor files, and operating-system
  metadata unless they are intentional project artifacts.

Relevant records may include:

- Task files.
- Issues.
- PRs.
- Activity logs.
- Approval logs.
- Decision logs.
- Architecture docs.
- Feature docs.
- QA notes.

Material changes to charter documents are Hard Gates, recorded in `docs/team_charter/CHANGELOG.md` with cross-references to the governing `APPROVAL-NNNN` and `DECISION-NNNN`.

### In-Progress Drafts and Branches

Durability (has the work reached GitHub so it isn't trapped on one machine) and approval lifecycle (is the underlying work approved) are independent axes. Do not conflate them.

**Branch convention.** In-flight work happens on a feature branch off `main`, pushed to GitHub. Actor-prefixed branches (`codex/...`, `claude/...`, other descriptive prefixes) are standard; what matters is the branch is descriptively named and pushed to the remote. A doc on a pushed feature branch satisfies the Source-of-Truth Rule — it does not need to be on `main` to be durably synced.

**Branch and status are independent.** A governed document with `Status: Draft` may live on a feature branch or on `main`. A `Proposed` document may live on either; recording a `Proposed` decision on `main` durably captures it without implying approval. An `Approved` document typically lives on `main` once merged, or on a feature branch if approved before merge. No combination is implicitly forbidden.

**Merging is mechanical.** A merge to `main` does not itself require a fresh approval — it inherits the approval state of the work it carries:
- Implementation within an approved task: already approved, merge proceeds.
- Documentation-only updates recording an already-approved decision: Standing Approval, merge proceeds.
- Recording a new `Proposed` decision: Standing Approval; the doc lands on `main` with `Status: Proposed`; approving the proposal itself is a separate, later event.
- Implementation not covered by an approved task, or material charter changes: Hard Gate before any merge that lands it. The gate is on the work, not the merge.

**PR policy.** Direct pushes to a feature branch are acceptable — no PR required for ongoing work. Promotion to `main` uses a PR only when the underlying work requires review (Hard Gate review or batch-approval verification); Standing Approval work can merge directly.

**Push cadence.** Push at the end of each work session; push before any handoff; push before reporting `Ready for Review` or invoking `SYNC` on this work; always verify the remote contains the commit before reporting sync complete.

**What "synchronization complete" means.** Applies to the branch the agent is working on, not necessarily `main`. A sync report must state: the branch name; that the latest commit is verified present on the remote; and, for governed documents in the change, the document's `Status:` value.

#### Branch Hygiene (R1–R7) — anti branch-sprawl

Adopted 2026-07-26 (Hard Gate; `APPROVAL-0027` / `DECISION-0039`; proposal
`docs/proposals/BRANCH_HYGIENE_AND_ANTI_SPRAWL_2026_07_09.md`, merged PR #54).
These rules **govern where they conflict with the older branch/PR/push bullets
above** (which predate them). They exist because recurring per-session branching +
no fast integration + no cleanup caused real work loss.

- **R1 — Branch = one reviewable slice.** A branch is one independently reviewable
  task/slice, named `<agent>/<task-or-work-id>-<slug>` (the `task-or-work-id` covers
  un-numbered work like proposals/chores; **no random per-session suffixes**). A new
  session on an in-flight slice **continues that branch — it does not fork a new one.**
- **R2 — Continuation via the task record.** The canonical task record carries the
  active `Branch` and `PR` (see `TASK_WORKFLOW.md`) and may note an agent task/thread
  ID. Machine-local worktree paths/IDs stay ephemeral and are never recorded as canonical.
- **R3 — Integrate small, often.** Integrate completed slices via small PRs; no
  standing task-family integration branches; stacked PRs only for a real dependency.
- **R4 — Session close is durable.** Commit-and-push a checkpoint whenever possible;
  if a session is interrupted, record an explicit dirty-state handoff (see
  `HANDOFF_PACKET_TEMPLATE.md` and `prompts/CLOSE_SESSION_PROMPT.md`) — a stash is not
  durable; never leave silent orphaned changes.
- **R5 — Readiness vs execution are separate.** A human/conductor records governance
  readiness; **GitHub-native automation** (auto-merge / merge queue) mechanically
  executes eligible merges once required checks + required reviews pass; a **custom
  privileged merge agent is contingent, not adopted by default** (and if ever used,
  runs dry-run under a least-privilege envelope).
- **R6 — Delete on merge; archive sparingly.** The remote head branch is auto-deleted
  on merge. Local branch/worktree cleanup is a client-side action gated by the R7
  preflight — it cannot be centrally automated. Archive-tag only unique
  unmerged/superseded work, not every merged branch.
- **R7 — Removal preflight (all three).** Before removing a branch or worktree, verify:
  (1) no uncommitted changes, (2) no unique commits, (3) no unpushed refs.
- **Trunk protection.** No normal direct commits to `main`; force-push/deletion
  blocked; emergency direct commits are a human-only, auditable break-glass action.
  `main` owns integrated truth; active work lives on a scoped branch until reviewable.

Operational enforcement (GitHub branch protection, required CI checks, native
auto-merge, one-time branch/worktree cleanup) is tracked separately from this
charter text — see the proposal's sequence.

## Universal Document Format Rule

Markdown (`.md`) is the default and canonical medium for project documents.
Agents should create and maintain durable plans, requirements, policies,
architecture, teaching documents, decisions, logs, and task records as Markdown
in GitHub unless a different format is required by the artifact itself.

Google Docs is the preferred secondary format when live human collaboration,
comments, suggestion mode, or a cloud backup copy is useful. A Google Doc is not
the project source of truth. Accepted changes must be incorporated into the
canonical Markdown file and committed to GitHub. When practical, the Google Doc
should identify or link to its canonical Markdown source.

Word (`.docx`) should be avoided unless a specific external recipient,
submission requirement, printing need, or layout-fidelity requirement makes it
necessary. When a Word document is necessary:

- derive it from the canonical Markdown or another canonical structured source;
- do not maintain it as an independent competing source;
- state which Markdown file governs if the versions differ; and
- regenerate it only when the specific Word deliverable must be updated.

Existing Word snapshots may remain for historical reference or an active
external need, but agents must not create or refresh them by default.

### Document Status

Apply a lifecycle `Status:` header to **governed documents** only: proposals, specifications, policies, charter docs, and individual entries in `DECISIONS_LOG.md`. Recognized values: `Draft` (actively being written), `Proposed` (stable enough to review, awaiting a decision), `Approved` (approval recorded), `Superseded` (replaced, preserved for history).

Do not apply this lifecycle `Status:` to append-only logs themselves, to `APPROVALS_LOG.md` entries (which use a `Decision:` enum, not lifecycle `Status:`), or to templates, indexes, README files, or non-Markdown files. Batch-approval entries in `APPROVALS_LOG.md` carry their own separate operational `Status: Active / Expired / Superseded` — a distinct vocabulary that never mixes with lifecycle `Status:` on the same entry.

## Manual Sync Handshake — `SYNC`

Projects may define a short manual trigger that tells an agent to re-sync from the source of truth before continuing.

Trigger:

```text
SYNC
```

`SYNC` is used in full, uppercase, standalone — not a single character — because a one-character trigger (the prior `C`/`c` convention) is too easy to fire accidentally in normal chat, code, or typos, and a missed deliberate trigger is worse than a rare false one. `SYNC` is also portable across clients that intercept slash-prefixed tokens before they reach an agent.

When the owner sends the trigger, the agent should:

- Re-read current GitHub source-of-truth docs, task files, issues, and activity/approval logs relevant to the active work.
- Check `docs/team_charter/CHANGELOG.md` for entries newer than the last read and re-read any affected charter docs before reporting state.
- Report current task or issue state, approval state, blockers, and next recommended action.
- Produce or refresh a handoff packet when execution, QA, frontend handoff, or side-agent coordination is next.
- Treat the trigger as a sync/review instruction only.

The manual sync handshake does not authorize implementation, deployment, migration, secret changes, task closure, QA pass decisions, Done decisions, risk acceptance, or production launch. Those actions still require the normal approval path.

## Startup Rule

At session start, agents should read relevant current GitHub docs before execution.

If the task is unclear or broad, orient from:

```text
docs/team_charter/
docs/tasks/
docs/activity_log/
docs/prd/ or product docs, if present
docs/architecture/, if present
docs/features/, if present
docs/flows/, if present
```
