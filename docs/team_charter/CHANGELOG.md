# Team Charter Changelog

Append-only chronological log, one entry per material change to `docs/team_charter/`. Checked on every `SYNC`. Per-doc `Version`/`Last Updated` headers are not used — git history plus the `APPROVAL-NNNN` / `DECISION-NNNN` references below are sufficient.

## 2026-06-23 — Charter simplification and tiering adoption

**Approval:** APPROVAL-0022
**Decision:** DECISION-0027
**Change (summary):**
- Replaced the `C`/`c` sync trigger with `SYNC` across all charter docs and both new-session prompts.
- Renamed `SKILLS_GUIDE.md` to `TOOL_AND_INTEGRATION_GUIDE.md`; removed its duplicated role-rule sections.
- Collapsed the task status taxonomy from 12 values to 6 (plus `Awaiting Owner Approval` for Hard-Gate tier).
- Added `Tier` (`Micro` / `Standard` / `Hard-Gate`) to task metadata; Micro tier skips handoff packets and most status states.
- Added Delegated Domain Approval lanes for Orly (curriculum) and Micah (marketing/GTM), with an explicit escalation-trigger test.
- Replaced "ambiguous → default to hard gate" with a clarify-vs-gate split based on reversibility and blast radius.
- Added a silence-is-consent SLA for Standard-tier batch approvals, built on the existing `Expires`/`Status` machinery in `APPROVALS_LOG.md`.
- Added `Approved (Domain)` to the `APPROVALS_LOG.md` Decision enum.
- Documented the in-progress-drafts/branch model (durability vs. approval lifecycle are independent axes) and the precise definition of "synchronization complete."
- Added Model/Effort Policy and reaffirmed QA-must-run-in-a-fresh-context as a named anti-pattern otherwise.
- Added Index sections and a rotation rule to all three activity logs; none have been archived yet.
- Added `scripts/verify-sync.sh`.

## 2026-06-23 — Agent routing and automatic QA (Codex proposal, folded in)

**Approval:** APPROVAL-0023
**Decision:** DECISION-0028
**Change (summary):**
- Main Conductor now auto-triggers QA for `Standard`/`Hard-Gate` tier work at `Ready for Review` instead of waiting for a request; `Micro` tier QA stays optional.
- Main Conductor now auto-applies the Model and Effort Policy per call instead of asking the Product Owner to choose a model each time; model/tier is recorded only when it deviates from the default (escalation to the strongest tier).
- Added explicit good-use/bad-use guidance for spawning additional agents, and three new Anti-Patterns (QA not auto-triggered, model choice asked per call, agent sprawl recreating the bottleneck it's meant to remove).

## 2026-07-26 — Branch hygiene rules (R1–R7): anti branch-sprawl

**Approval:** APPROVAL-0027
**Decision:** DECISION-0039
**Change (summary):**
- Added canonical Branch Hygiene rules R1–R7 to `AI_COLLABORATION_RULES.md` (§In-Progress Drafts and Branches); they govern where they conflict with the older branch/PR/push bullets.
- Added `Branch` / `PR` fields to `TASK_WORKFLOW.md` task metadata (R2 continuation via the task record).
- Added `Branch / PR` and an uncommitted/unpushed dirty-state-handoff field to `HANDOFF_PACKET_TEMPLATE.md` (R4).
- Updated the Claude and Codex new-session prompts and `CLOSE_SESSION_PROMPT.md` to reference/operationalize R1–R7 (canonical text stays in `AI_COLLABORATION_RULES.md`; no competing definitions).
- Source proposal: `docs/proposals/BRANCH_HYGIENE_AND_ANTI_SPRAWL_2026_07_09.md` (approved + merged as PR #54).
- Operational enforcement (main branch protection, required CI checks, native auto-merge, one-time branch/worktree cleanup) is tracked separately, NOT in this PR.
