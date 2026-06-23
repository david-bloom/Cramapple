# Kit Simplification Memo

**Status:** Proposed — Pending Owner Review  
**Date:** 2026-06-23  
**Author:** Codex (drafted); revised by Claude with cross-checks against the 2026-06-14 proposal  
**Audience:** David Bloom  
**Subject:** Simplify the AI Project Operating Kit so it helps us ship faster with fewer moving parts

## Bottom Line

The kit is useful, but it is carrying too much ceremony for the amount of product work we are doing.

It helps most when it:
- protects source of truth,
- makes approvals explicit,
- separates implementation from QA,
- and gives us a clean way to start and stop work.

It hurts when it:
- duplicates the same rule in multiple places,
- creates too many role labels for the same people,
- adds approval steps for low-risk work,
- or turns routine coordination into process overhead.

The kit should be a force multiplier, not a management tax.

## Merged Assessment

The strongest shared conclusion from the two reviews is simple: the kit is applying high-stakes machinery too broadly.

The fix is not to remove rigor. The fix is to make rigor conditional on actual risk.

That means:
- ambiguous but reversible work should get a clarifying question, not a hard gate;
- domain-specific hard decisions should go to delegated approvers, not always to the Product Owner;
- small reversible work should skip heavy ceremony;
- sync should be verified, not narrated;
- logs should be rotated before they become unreadable;
- QA should stay independent and fresh;
- model choice should be simple and portable.

## Relationship to the 2026-06-14 Team Charter Improvements Proposal

A more developed, already-reviewed proposal covering significant parts of this same ground already exists: `docs/proposals/2026-06-14-team-charter-improvements.md` (v2.2, status: Proposed — Pending Owner Review, reviewed by Codex across two passes, with several items already resolved in a prior owner review round).

Three items below overlap directly with that proposal and defer to it rather than re-deriving a fix:

- Sync handshake duplication → its Proposal 1 (replace `C`/`c` with `SYNC`).
- `SKILLS_GUIDE.md` duplicating role rules → its Proposal 3 (scope to tool/integration skills, rename to `TOOL_AND_INTEGRATION_GUIDE.md`).
- Handoff packet template field bloat → its Proposal 7 (mark which prompt slot(s) apply, omit the rest).

This memo's genuinely new contributions — delegated domain-approval lanes, risk/size tiering, rollout sequencing, success metrics, the log-count question, and the move-faster ideas — are not covered by the 06-14 proposal and stand on their own.

**Worth stating plainly:** the 06-14 proposal has been sitting in "Pending Owner Review" for about a week as of this memo. It is itself a governance-friction-reduction proposal, stuck in the same approval queue it's trying to shorten. That is a live, concrete instance of the bottleneck problem this memo exists to fix — not a hypothetical.

**Recommendation:** resolve the two proposals together, not in sequence. Both touch `STANDING_APPROVAL_LANES.md`, `TASK_WORKFLOW.md`, and `AI_COLLABORATION_RULES.md`; reviewing them separately risks two conflicting edits landing on the same files.

**Known conflicts and gaps requiring reconciliation before adoption** (detailed treatment inline in each numbered section):

1. **Status taxonomy** (section 10) vs. its **Proposal 5** (reserves `QA Passed` as a distinct status) and **Proposal 8** (formally defines `Do Not Do` and keeps `Blocked`/`QA Blocked` distinct) — pick one direction, not both.
2. **Log count** (section 11) vs. its **Proposal 2**, which builds dedicated structure (a `Decision` enum, batch-approval entry format, expiration rules) specifically on `APPROVALS_LOG.md` staying its own file.
3. **Status taxonomy, third touch point** — its **Proposal 9f** (push cadence) names `Ready for QA` and `Ready for Owner Review` as explicit push triggers. Both names disappear under section 10's collapse. Same conflict as #1, but a third file/line that needs updating, not just two.
4. **Section 5 ("narrow the approval lanes") risks silently dropping real, already-adopted hard gates.** Its example list (privacy, security, data model changes, production launches, spending, legal exposure, user-visible irreversible changes) omits its **Proposal 4**'s addition ("material changes to `docs/team_charter/` are Hard Gates") and several items already in Cramapple's actual `STANDING_APPROVAL_LANES.md` Lane 3 — content licensing/copyrighted material (added after a real incident: the human-abstraction-firewall decision in `DECISIONS_LOG.md` rejecting an official-derived FRQ), public performance claims, expert-quality-gate acceptance, and "Done decisions/closing tasks." If section 5's list is read as a *replacement* rather than a floor, it quietly removes protections that exist for documented reasons.
5. **Section 6 (verify-sync.sh) is underspecified relative to its Proposal 9e's branch model.** "Local `HEAD` equals `origin`" could be misread as requiring `HEAD == origin/main`. That would contradict Proposal 9's branch model (9a–9e), which deliberately makes in-progress work on a feature branch fully sync-compliant without ever touching `main`.
6. **Section 3 (delegated domain-approval lanes) cites a recording format that can't represent it yet.** Its **Proposal 2**'s `Decision` enum (`Approved / Rejected / Approved with Notes / Done / Not Done / Do Not Do / Approved (Batch)`) has no value for "a domain delegate, not the Product Owner, approved this." `AI_COLLABORATION_RULES.md`'s Owner role already says "Launch/deployment decisions **unless delegated**" but that delegation is never defined anywhere. Section 3 isn't implementable as written until one of the two proposals adds something like `Approved (Domain)` to the enum.

## What To Keep

Keep these because they actually reduce mistakes:

- One durable source of truth in GitHub.
- Explicit approval boundaries for risk, privacy, security, money, and production.
- Separate implementation and QA roles.
- Handoff packets for Standard and Hard-Gate tier work (section 4) — Micro tier skips them entirely.
- Decision and approval logs.
- A clear owner model, with delegated domain lanes (section 3) for non-cross-cutting decisions.

## What To Simplify

### 1. Collapse duplicate guidance

Right now, several documents restate the same collaboration rules in slightly different words. That creates drift and reading overhead. This applies to all seven `docs/team_charter/` documents, not just the four most-read ones — `SKILLS_GUIDE.md`, `DEFINITION_OF_DONE.md`, and `HANDOFF_PACKET_TEMPLATE.md` need the same pass.

Simplify by making each doc do one job:
- `AI_COLLABORATION_RULES.md` = collaboration rules and source-of-truth policy.
- `AGENT_OPERATING_MODEL.md` = who does what.
- `STANDING_APPROVAL_LANES.md` = what can proceed without explicit approval.
- `TASK_WORKFLOW.md` = how work moves from idea to done.
- `SKILLS_GUIDE.md` = project-specific tool/integration skills only — not a second copy of role rules.
- `DEFINITION_OF_DONE.md` = the completion bar — not a second copy of approval-state language.
- `HANDOFF_PACKET_TEMPLATE.md` = the packet shape — not three boilerplate prompt slots filled by default.

If a rule is already canonical in one of those places, do not repeat it elsewhere unless a shorter pointer is enough.

**Two of the highest-value duplicates already have a fully specified fix sitting unapproved** in the 06-14 charter proposal (see "Relationship to the 2026-06-14 Proposal" above) — adopt those instead of re-deriving:
- The sync handshake is currently duplicated near-verbatim across five files (`README.md`, `AGENT_OPERATING_MODEL.md`, `AI_COLLABORATION_RULES.md`, and both new-session prompts). Its Proposal 1 replaces the single-character `C`/`c` trigger with `SYNC` and gives the exact edit to each file.
- `SKILLS_GUIDE.md` duplicating role rules already covered in `AGENT_OPERATING_MODEL.md` is its Proposal 3.

The remaining duplicate this memo adds net-new: the overlapping status/approval-class language between `TASK_WORKFLOW.md` and `STANDING_APPROVAL_LANES.md`. Collapse `TASK_WORKFLOW.md`'s "Approval Classes" section to a one-line pointer at `STANDING_APPROVAL_LANES.md`.

### 2. Stop defaulting ambiguity to a hard gate

This is probably the biggest source of unnecessary approvals.

Replace the current “if unclear, treat it as a hard gate” rule with this:

- ambiguous + reversible + low blast radius: ask one clarifying question and proceed under standing approval;
- ambiguous + irreversible or high blast radius: hard gate.

That keeps people from turning uncertainty into bureaucracy.

### 3. Add delegated domain-approval lanes

The current model still routes too much through one Owner by default. That contradicts the stated goal of avoiding the owner as the memory and coordination bottleneck.

Add real delegated approval lanes for named domains, such as:
- learning or curriculum,
- marketing and go-to-market,
- content operations,
- implementation or release operations.

The Product Owner should stay final authority for:
- cross-cutting decisions,
- money,
- legal and privacy,
- production,
- irreversible risk.

**This needs a concrete escalation trigger, or it recreates the ambiguity problem in section 2 one level down.** Without a boundary test, caution will default everything to "better ask David anyway" and the bottleneck reappears with an extra hop in front of it. Default: a decision stays in its domain lane unless it visibly (a) touches a second named domain, (b) touches money, legal, privacy, or production, or (c) the domain approver explicitly punts it. Only those three conditions escalate.

Record domain-approver decisions the same way Proposal 2 (06-14 charter proposal) already records batch approvals — same `APPROVALS_LOG.md` venue, same per-entry format — rather than inventing a second tracking mechanism. **This isn't fully implementable yet:** Proposal 2's `Decision` enum has no value for "a named domain delegate, not the Product Owner, approved this." Add `Approved (Domain)` to the enum (or equivalent) as part of adopting this section — don't record domain approvals under plain `Approved`, which would erase who actually made the call.

This is not role theater. It is the mechanism that keeps one person from becoming the bottleneck for every hard call.

### 4. Add a risk/size tier

Not all work deserves the same ceremony.

Add a simple tier to every task:
- `Micro`
- `Standard`
- `Hard-Gate`

Use that tier to decide the amount of process:
- `Micro`: standing-approved, no handoff packet, minimal status states, log it and finish;
- `Standard`: current workflow;
- `Hard-Gate`: current workflow plus explicit sign-off.

This is how the kit stops making a one-line copy fix look like a production migration.

### 5. Narrow the approval lanes

Approval lanes should be reserved for work with real downside. **This list is a floor, not a replacement** for Cramapple's existing hard-gate list — narrowing must not silently drop protections that already exist for documented reasons:
- privacy,
- security,
- data model changes,
- production launches,
- spending,
- legal exposure (including content licensing/copyrighted material — added after a real incident: see the human-abstraction-firewall decision in `DECISIONS_LOG.md` rejecting an official-derived FRQ),
- user-visible irreversible changes,
- public performance claims,
- expert-quality-gate acceptance,
- Done decisions and closing tasks/issues,
- material changes to `docs/team_charter/` documents (per the 06-14 proposal's Proposal 4, if adopted).

If a change is reversible, local, and low-risk, the kit should make it easy to move, not stop and ask for theater. "Narrow" means cutting ambiguous or rarely-triggered categories, not cutting categories that exist because of a specific past incident.

### 6. Replace self-reported sync with an actual check

Do not rely on narrated “done” or “synced” claims.

Add a portable script such as `scripts/verify-sync.sh` that checks:
- clean git status,
- local `HEAD` equals **the current branch's remote tracking ref — not necessarily `main`**,
- the relevant document changes are present in the pushed commit.

The "not necessarily `main`" qualifier is load-bearing, not a stylistic choice: Proposal 9e of the 06-14 charter proposal deliberately makes in-progress work on a feature branch fully sync-compliant without ever touching `main` (9a–9e). A script that checks `HEAD == origin/main` would fail every legitimate in-progress branch and directly contradict that model. Build the script against Proposal 9e's precise definition of "synchronization complete" — branch name, commit-present-on-remote verification, and governed-document `Status:` value — rather than a looser one invented here.

Close rituals should require a real sync check before a work block is called complete when durable project state changed.

### 7. Rotate and index the logs

The logs are already too big to read casually.

Add:
- a small index block at the top of each log with recent entries and task IDs;
- a rotation rule that archives a log once it crosses a practical size threshold.

The goal is to keep “read the relevant log” cheap enough that agents actually do it.

### 8. Prefer one default model path

Use a simple model policy:
- fast/default model for drafting, routine edits, summaries, and straightforward implementation support;
- stronger model for ambiguous reasoning, sensitive policy calls, review, and hard synthesis;
- deterministic scripts and tools whenever the task can be made mechanical.

Do not keep extra model variants around unless they earn their place with measurable quality or cost wins.

### 9. Make QA genuinely independent

The QA Agent should not just be a renamed continuation of the implementation thread.

QA needs a fresh context and an independent pass.

Reserve the strongest reasoning depth for:
- final QA verdicts,
- hard-gate classification,
- conductor decisions.

Use cheaper, faster treatment for:
- handoff packets,
- task drafting,
- routine cleanup.

State this as a portable principle, not a model-specific rule.

### 10. Make status words fewer and sharper

Status vocabulary should be small and meaningful. If a status is only there to distinguish one internal flavor of the same thing, collapse it. Good status words are the ones that change what a human should do next.

**Concrete proposal, not just the principle:** collapse the current 12-state list to six for `Micro` and `Standard` tier work:

- `Not Started`
- `In Progress` (absorbs `Spec Drafted`, `Approved for Execution`)
- `Blocked` (absorbs `QA Blocked` — both mean "waiting on something before work can continue")
- `Ready for Review` (absorbs `Ready for QA`, `QA Passed`, `Ready for Owner Review` — all mean "someone needs to look at this next"; who that someone is comes from the task's tier, not a separate status word)
- `Done`
- `Do Not Do`

`Hard-Gate` tier tasks keep one additional state — `Awaiting Owner Approval` — inserted before `Done`.

**This directly conflicts with three items already in flight in the 06-14 charter proposal** and needs reconciliation before either is adopted: its Proposal 5 narrows who may set `QA Passed` (assumes it stays a distinct status); its Proposal 8 formally defines `Do Not Do` and adds a "Status Definitions" subsection distinguishing `Blocked` / `QA Blocked` / `Do Not Do` / `Done` (assumes `QA Blocked` stays distinct from `Blocked`); and its Proposal 9f (push cadence) names `Ready for QA` and `Ready for Owner Review` as explicit push triggers — both names disappear under this collapse. Pick one direction — reduce the count, or keep the count and sharpen each definition — not both at once, and update all three locations together if reduction wins.

### 11. Reconsider the log count

Three logs (`ACTIVITY_LOG.md`, `APPROVALS_LOG.md`, `DECISIONS_LOG.md`) get independent indexing and rotation machinery added in section 7, while the closing section of this memo lists "fewer documents" as a goal. An approval is a kind of decision — collapsing `APPROVALS_LOG.md` into a tagged section of `DECISIONS_LOG.md` would halve the machinery just designed for it.

**Flagging the tension rather than resolving it here:** the 06-14 proposal's Proposal 2 builds substantial structure specifically on `APPROVALS_LOG.md` staying a distinct file — its own `Decision` enum, a dedicated batch-approval entry format, and the expiration/conflict-resolution rules the move-faster SLA idea below depends on. Merging the logs would require redoing that design, not just moving text. Don't act on this section until Proposal 2's fate is decided.

## Rollout Sequencing

This touches two live projects (PassTo, Cramapple — the latter with 21 active tasks and a 1,183-line decision log already) plus the upstream generic kit repository. Adopting all of this at once, retroactively, is its own risk.

- Resolve the 06-14 proposal and this memo together first (see above) so the charter docs only move once, not twice.
- Pilot the result on **new tasks only** in one project before propagating to the other and upstreaming proven changes to the generic kit — consistent with treating real-project drift as signal, not the other way around.
- Do not retroactively rewrite existing tasks, logs, or decisions onto the new status vocabulary or tiering scheme. Add a cutover marker (a `DECISION-NNNN` entry is sufficient) stating which task ID the new scheme starts at; everything before it reads under the old rules.

## Success Metrics

This whole memo is a bet that less ceremony won't cost reliability. Track two cheap leading indicators for a few weeks before and after adoption, or "it feels lighter" is the only signal available:

- Hard-gate escalations per week (should drop if sections 2 and 3 are working).
- QA round-trips per task (should hold steady or improve — a drop here from reduced ceremony alone, without the independence principle in section 9, would suggest QA got rubber-stamped, not faster).

## Other Ways To Move Development Faster

These sit outside the ceremony-reduction scope above — they're throughput levers, not friction removal.

1. **Silence-is-consent SLA for Standard-tier approvals.** Default-approve after a stated window (e.g. 24h) if the Product Owner hasn't objected, instead of every Standard-tier item blocking on an explicit yes. Build this on Proposal 2's existing batch-approval `Expires` / `Status: Active/Expired` machinery in `APPROVALS_LOG.md` rather than inventing new mechanics — the expiration semantics, timezone handling, and conflict rules it already defines are exactly what an SLA needs.
2. **Replace the 8-doc startup read with one generated state snapshot.** Every new session currently reads eight separate files per the session-start prompts. A single `CURRENT_STATE.md`, regenerated at each close ritual (active task, status, blockers, next action), replaces most of that re-orientation cost. The close ritual already produces this content — it just isn't being persisted as one cheap read.
3. **Give the kit a concept of parallel work.** Everything in it currently assumes one task moving through one pipeline. With subagent/parallel-execution tooling available, the kit should say when independent task streams should run concurrently rather than queue — a throughput lever distinct from reducing ceremony per task.
4. **Auto-classify `Micro` tier instead of judgment-calling it every time.** A diff touching only docs, tests, or a pre-approved low-risk path could be tagged `Micro` by a simple file-pattern check rather than requiring a manual decision in the start ritual every time.

## What To Drop Or Merge

These are the first candidates for reduction:

- Multiple docs that explain the same source-of-truth rule.
- Overlapping role descriptions that do not change who can actually act.
- Extra approval layers on reversible draft work.
- Template fields that are always blank or almost always copied forward unchanged — `HANDOFF_PACKET_TEMPLATE.md`'s three "Recommended Prompt" slots are the concrete instance of this, and the 06-14 proposal's Proposal 7 already has the fix (a checkbox marking which slot(s) apply, omit the rest entirely). Use Proposal 7 as written rather than re-auditing the fields from scratch.
- Long “proposed” sections that are really just notes and not decision-ready work.

If a field is never used in practice, delete it. If a doc is read only at startup, shorten it until the startup read is cheap.

## Simple Start Ritual

Use this at the beginning of every work block:

1. Read only the source-of-truth docs that matter for the task.
2. State the objective in one sentence.
3. Classify the task as `Micro`, `Standard`, or `Hard-Gate`.
4. If the task is ambiguous, decide whether it needs a clarifying question or a gate.
5. Identify the right approver lane if one is needed.
6. Decide the default model:
   - fast model for routine work,
   - strong model if the task is ambiguous, risky, or likely to need judgment,
   - tool/script first if the work is mechanical.
7. Choose the smallest useful next action.
8. Say what you are about to change before editing anything.

## Simple Close Ritual

Use this at the end of every work block:

1. Check whether the work is complete, blocked, or intentionally paused.
2. Summarize what changed in plain language.
3. List any files touched.
4. Note any unresolved risk, ambiguity, or follow-up.
5. Run the sync check if the work changed durable project state.
6. If the work should continue later, state the next exact action.
7. Rotate or archive logs if they crossed the practical size threshold.

## Recommended Operating Model

If we want the kit to stay useful, the default should be:

- fewer documents,
- fewer roles,
- fewer approvals,
- fewer model choices,
- more direct ownership,
- more explicit closeout.

That gives us the quality guardrails we need without turning the kit into overhead.
