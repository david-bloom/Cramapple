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

**PR policy.** Direct pushes to a feature branch are acceptable — no PR required for ongoing work. Promotion to `main` is **always** by PR (see Trunk protection under R1–R7 below); what the underlying work's approval state changes is whether that PR needs review, not whether a PR is used.

**Push cadence.** Push at the end of each work session; push before any handoff; push before reporting `Ready for Review` or invoking `SYNC` on this work; always verify the remote contains the commit before reporting sync complete.

**What "synchronization complete" means.** Applies to the branch the agent is working on, not necessarily `main`. A sync report must state: the branch name; that the latest commit is verified present on the remote; and, for governed documents in the change, the document's `Status:` value.

### Branch Hygiene — R1–R7 (canonical)

Adopted 2026-07-26 as a Hard Gate under `APPROVAL-0027` / `DECISION-0039` (proposal PR #54, governance PR #55); restated and operationalized under `DECISION-0043` / `APPROVAL-0040`. **This section is the canonical
statement of R1–R7.** Source proposal (evidence and rationale, not authority):
`docs/proposals/BRANCH_HYGIENE_AND_ANTI_SPRAWL_2026_07_09.md`. Any other document
that describes these rules must reference this section rather than restate it.

| # | Rule |
|---|---|
| **R1** | A branch is **one independently reviewable task or slice**, named `<agent>/<task-or-work-id>-<slug>`. The `task-or-work-id` covers un-numbered work (proposals, chores) — **no random session suffixes**. A new session on in-flight work **continues that branch; it does not fork a new one.** |
| **R2** | **Continuation is driven by the canonical task record**, which carries `branch`, `PR`, and `task/status`, and may record an agent task/thread ID. **Machine-local worktree paths and IDs stay ephemeral — never write them into the task record.** |
| **R3** | **Integrate completed slices regularly via small PRs.** Stacked PRs only for a genuine dependency. **No standing task-family integration branches.** |
| **R4** | **Session close: commit and *push* checkpoints wherever possible.** If interrupted, write an **explicit dirty-state handoff** into the task or handoff record. A stash is not durable. Never leave silent orphaned changes. |
| **R5** | **Merge readiness is GitHub-native, not a custom agent.** (a) a human or conductor records governance readiness; (b) GitHub-native automation (auto-merge / merge queue) mechanically executes eligible merges once required checks and reviews pass; (c) **custom privileged automation is contingent and NOT adopted by default** — if ever introduced it starts dry-run, least-privilege, with no branch-protection bypass. |
| **R6** | **Delete-on-merge for the remote head branch** (GitHub auto-delete). Local branch and worktree cleanup **cannot** be centrally automated across machines — it is client-side, gated by R7. **Archive-tag only unique unmerged or superseded work**, not every merged branch. |
| **R7** | **Removal preflight — verify all three before deleting a branch or worktree:** (1) no uncommitted changes, (2) no unique commits, (3) no unpushed refs. Only then remove. |

**Trunk protection.** No normal direct commits to `main`; force-push and branch
deletion are blocked. Emergency access is **human-only, auditable break-glass** —
never an agent action.

**Why this exists.** Branch sprawl has recurred twice. The failure mode is not
having many branches; it is that **work stops reaching `main`**, so later sessions
cannot see it and re-derive it. R1+R2 are the highest-leverage pair. A concrete
cost, recorded 2026-08-01: the AP Statistics CED fact pack sat unmerged on a
93-commit branch, invisible from `main`, and was independently re-derived more
than once as a result.

**Archiving unmerged work.** Preserve it as a tag, not a branch:

```
git tag archive/<work-id> <branch> && git branch -D <branch>
```

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
