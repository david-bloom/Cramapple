# Claude New Session Prompt

```text
Read `docs/team_charter/CRAMAPPLE_SESSION_START.md` for authority order, approval boundaries, and
source-of-truth rules. Apply the tier-first reading rules below when satisfying its Session-Start
Procedure. Do not rely on prior chat memory unless it has been recorded in GitHub.

David Bloom is the Product Owner and final approver. Strategy Advisor is an advisory role that
supports David and the co-founders but does not independently approve product scope or execution.

Use relevant project skills only when the task clearly matches them; do not load skill docs as
startup ceremony.

Precondition: this protocol assumes root `AGENTS.md` exists and `docs/activity_log/ACTIVITY_LOG.md`,
`APPROVALS_LOG.md`, and `DECISIONS_LOG.md` each contain an `<!-- INDEX_END -->` marker after their
Index section. If either is missing, say so before relying on the index-marker or forbidden-paths
rules below.

## Startup Rule — classify before you read

Do not load the full project operating stack before classifying the task. In order:

1. Read `docs/team_charter/CRAMAPPLE_SESSION_START.md`.
2. Read the named task record, issue, PR, handoff, or work order, if one exists.
3. Classify the task's Tier — Micro / Standard / Hard-Gate. If the tier is not obvious from the
   request, read only the Task Tiers section of `docs/team_charter/AGENT_OPERATING_MODEL.md`
   before classifying. Use no other test for tier; if this prompt and that section ever disagree,
   that section governs.
4. Identify the task area (code, docs, launch, content, Supabase, Stripe, Lovable/frontend,
   governance, QA, or general analysis).
5. Read the reading set below for that Tier. Treat it as a ceiling, not a target — read less if
   the task is narrower than the tier implies.

## Micro tasks

Bounded questions, small edits, typo fixes, local explanations, single-file changes, narrow
debugging, non-durable analysis — anything that is standing-approved, reversible, and low blast
radius per the Task Tiers definition.

Required reading:

- `docs/team_charter/CRAMAPPLE_SESSION_START.md`
- the named task/file/work order, if provided
- `docs/INDEX.md`, only if the correct canonical source is unknown

Do not read by default: full activity/approval/decision logs, launch readiness docs, full
architecture docs, old prompts, research archives, or any other part of the full governance stack.

If a Micro task turns out to touch production, payments, privacy/legal, secrets, migrations,
launch status, approvals, task closure, or any other higher blast-radius surface, it is no longer
Micro — re-classify per Task Tiers and follow the Escalation Rule below before continuing.

## Standard tasks (including broad or unclear-scope work)

Meaningful implementation, QA, product docs, task execution, branch work, durable project
updates — and any task whose scope or area is not yet clear enough to know what "Micro" reading
would cover.

Required reading:

- `docs/team_charter/CRAMAPPLE_SESSION_START.md`
- the named task, issue, PR, handoff, or work order
- `docs/INDEX.md`
- the canonical docs `docs/INDEX.md` names for the task's area
- `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`, only for architecture, design,
  frontend, session-mode, or launch work (per DECISION-0078's required first-read)

If `docs/INDEX.md` has no entry for the task's area, say so and name the nearest canonical doc
you're relying on instead of guessing silently.

If activity, approval, or decision logs are needed: read only through each file's `INDEX_END`
marker first, then search by exact task ID, approval ID, decision ID, date, or keyword. If that
targeted search finds nothing relevant, say so explicitly and read further into the log before
concluding nothing exists — do not report absence on the strength of an index-only read.

## Hard-Gate tasks

Production changes, migrations, deployments, secrets, Stripe/payments, privacy/legal, launch
decisions, approval changes, closing tasks as Done, or other irreversible actions.

Required reading:

- `docs/team_charter/CRAMAPPLE_SESSION_START.md`
- `docs/team_charter/AI_COLLABORATION_RULES.md`
- `docs/team_charter/TASK_WORKFLOW.md`
- `docs/team_charter/AGENT_OPERATING_MODEL.md`
- `docs/team_charter/STANDING_APPROVAL_LANES.md`
- the relevant task, approval, decision, PR, issue, or handoff record
- the directly relevant canonical product, architecture, service, or launch docs

Same log discipline as Standard: index markers and exact-ID search first, full-log reads as a
last resort, and never report absence without reading past the marker first.

## Escalation Rule

If work started as one Tier turns out to need a higher one, stop and say:

"This now appears to require Standard/Hard-Gate [tier]. I need to read these additional
sources: [list]."

Then read only those named sources. Escalating tier also changes the task's required approvals
and status path (see `TASK_WORKFLOW.md`), not just its reading list — apply both.

## Forbidden by default

Do not broadly scan, list, or read: `docs/research`, `docs/teaching`, `prompts`, `tmp`, `output`,
`.worktrees`, `.claude/worktrees`, `node_modules`, `.venv`, generated SQL/output folders, raw
`.jsonl` model-call logs, image/PDF corpora, or archived activity logs — unless directly relevant
or explicitly requested. Use exact filenames, task IDs, dates, or narrow search terms instead of
listing these paths. Prefer targeted searches over repo-wide scans anywhere in the repo; cap
command output; inspect large files by line range; search logs by exact ID before opening them.
(Full detail: root `AGENTS.md`.)

## Report at the end of orientation

1. Current task or issue, and its Tier (Micro / Standard / Hard-Gate).
2. Approval state.
3. Whether Product Owner or Delegated Domain Approver sign-off is required.
4. Open risks/blockers.
5. Next recommended action.
6. Handoff packet if execution, QA, frontend handoff, or side-agent coordination is next — skip
   this for Micro-tier work.

## Operating model

- Main Conductor owns source-of-truth, approval boundaries, integrated recommendations, and
  GitHub publishing. Only the Main Conductor sets a task's status to Done. David owns final
  product decisions; Orly and Micah hold delegated approval authority within their named domains
  (see `AI_COLLABORATION_RULES.md`).
- Source / Live-State Agent provides implementation evidence.
- QA Agent proposes findings only, may set status to Blocked, and must run as a fresh, independent
  context — not a continuation of the implementation thread.
- UX / Prompt Agent handles frontend prompts and route behavior where relevant.

Model/effort: use the fast/default tier for drafting and routine work; reserve the strongest
available reasoning tier for QA verdicts, hard-gate classification, and Main Conductor judgment
calls; prefer a deterministic script over narrated compliance wherever the check can be mechanical
(e.g. `scripts/verify-sync.sh`).

## Manual sync handshake

If the owner sends `SYNC`, re-read the current GitHub source-of-truth docs/issues/logs (including
`docs/team_charter/CHANGELOG.md` for anything new) for the active work and report state, blockers,
approval boundaries, and next action. Use the same tier, index-marker, and exact-ID search
discipline during SYNC — do not full-read logs unless targeted search fails and the missing
record is necessary. Treat the trigger as sync/review only, not approval to execute.

Follow standing approval lanes. Ambiguous-but-reversible work gets a clarifying question, not an
automatic hard gate. Stop at hard gates.

Branch hygiene (R1–R7; `AI_COLLABORATION_RULES.md` §In-Progress Drafts and Branches): work on one
reviewable slice per branch, named `<agent>/<task-or-work-id>-<slug>`; continue an in-flight
task's existing branch instead of forking a new one; commit-and-push a checkpoint before closing
or handing off, recording an explicit dirty-state handoff if interrupted. For branch creation,
commit, push, PR, or handoff work, read only the branch-hygiene section of
`AI_COLLABORATION_RULES.md` unless the task otherwise requires the full file.
```
