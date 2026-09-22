# Cramapple Session Start

**Status:** Approved  
**Owner / Product Owner:** David Bloom  
**Approval:** APPROVAL-0047  
**Decision:** DECISION-0054  
**Canonical repository:** `david-bloom/Cramapple`

## Purpose

This is the device-neutral bootstrap for every substantive Cramapple session, whether it starts in ChatGPT on desktop, ChatGPT on iPhone, ChatGPT Work, Codex, Claude, or another approved tool.

The invariant is:

> Device and chat history may change. Cramapple's current GitHub records govern.

Project memory helps with continuity, but it is not the source of truth for operating policy, approval state, repository state, deployments, or live service state.

## Authority Order

Use this order when sources differ:

1. Current canonical records in `david-bloom/Cramapple`, read from the relevant branch or `main` as directed by the active task record.
2. Explicit instructions for the current task that do not conflict with an approved hard gate or canonical policy. A new owner decision must be recorded durably before future sessions rely on it.
3. Cramapple ChatGPT Project instructions and Project sources.
4. Relevant prior conversations inside the Cramapple Project.
5. General account memory or model memory.

Do not silently resolve a conflict. Name it, identify the governing source, and stop at any unresolved approval boundary.

## Session-Start Procedure

Before substantive work:

1. Confirm that this is Cramapple work and identify the requested outcome.
2. Read this file from the current canonical repository; do not rely on an uploaded or remembered copy.
3. Read the current task record, issue, PR, handoff, or named work order when one exists.
4. Read the task-relevant canonical documents. For broad or unclear work, start with:
   - `docs/team_charter/AI_COLLABORATION_RULES.md`
   - `docs/team_charter/TASK_WORKFLOW.md`
   - `docs/team_charter/AGENT_OPERATING_MODEL.md`
   - `docs/team_charter/STANDING_APPROVAL_LANES.md`
   - `docs/team_charter/TOOL_AND_INTEGRATION_GUIDE.md`
   - `docs/team_charter/CHANGELOG.md`
   - the Index sections of `docs/activity_log/ACTIVITY_LOG.md`, `APPROVALS_LOG.md`, and `DECISIONS_LOG.md`
   - `docs/product/CRAMAPPLE_VISION.md`
5. Verify current GitHub state for every repository involved. Continue the branch named by the task record; otherwise follow branch-hygiene R1-R7.
6. Determine the task Tier, approval state, required QA, and any Product Owner or Delegated Domain Approver gate.
7. Verify access to each required external system. Tool availability in an earlier chat, on another device, or on a Mac does not prove availability in the current session.
8. Report the current task, governing sources, branch/PR, approval state, blockers, and next action before crossing a hard gate.

Read only the documents needed for a clearly bounded task. The broad orientation list is a fallback, not mandatory ceremony for every Micro task.

## Repository Map

- `david-bloom/Cramapple` — authoritative Cramapple governance, product records, architecture, backend, content, migrations, tasks, decisions, approvals, and activity history.
- `david-bloom/exam-buddy-wireframe` — current Lovable/front-end code when the active Cramapple task or handoff names it. Its code state does not override governance in `david-bloom/Cramapple`.
- `david-bloom/cramapple-beta` — available repository, but not authoritative by default. Use it only when a current canonical Cramapple task or handoff explicitly names it.
- `david-bloom/ai-project-operating-kit` — upstream reusable template. Cramapple's installed, approved documents govern until a migration from the kit is approved and landed.

If a later decision changes this topology, update this map in the same approved change.

## External-System Map

Use live state only when relevant and accessible:

- GitHub — durable documentation, code, issues, branches, PRs, and workflow evidence.
- Supabase — database, Auth, Storage, Edge Functions, and migrations.
- Lovable — current front-end editing and publication path where the active task says so.
- Vercel — use only when the active task or canonical deployment record identifies a Vercel-owned surface.
- Stripe — payments and billing.
- PostHog — product analytics.

Never infer live state from chat memory. Verify the relevant environment and distinguish Development, Preview, and Production. Production deployments, migrations, secrets, payments, privacy, and irreversible changes retain their existing hard gates.

## Portable Context Versus Local State

A new desktop or iPhone Project chat may rely on the same Project instructions, Project memory, GitHub records, and connected cloud apps.

It must not assume access to:

- a Mac-local checkout or worktree;
- uncommitted or unpushed changes;
- local environment variables;
- an IDE buffer;
- a local development server; or
- a running desktop Codex process.

When work depends on that state, continue the existing remote/local session or first create a durable GitHub handoff. Do not reconstruct local state from memory.

## ChatGPT Project Contract

Use the single existing ChatGPT Project named **Cramapple** on desktop and iPhone. Do not create a mobile-specific duplicate.

- Keep Cramapple's current **Default memory** setting so Project conversations can use project context and ChatGPT Work remains available.
- Start Cramapple tasks inside the Cramapple Project.
- Use loose chats only for intentionally context-free thinking; they are not durable Cramapple state.
- Use the GitHub connection to read current canonical files instead of uploading fast-changing copies as Project sources.
- Connected-app access is verified per session; it is not assumed from another device.

The exact Project-instructions text is maintained in `docs/team_charter/CHATGPT_PROJECT_INSTRUCTIONS.md`.

## Session Close

Before ending a session that changed durable state:

1. Follow `prompts/CLOSE_SESSION_PROMPT.md`.
2. Update the relevant task, decision, approval, activity, or handoff record.
3. Commit and push the checkpoint to the task branch.
4. Verify the remote contains it.
5. State the exact next owner and next action.
6. Do not report synchronization complete for local-only or chat-only work.

## Protocol Maintenance

- Normal project or architecture change: update the governing canonical file.
- Operating-policy change: update the canonical policy and its approval/decision records.
- Repository or service topology change: update this bootstrap.
- Fundamental ChatGPT discovery or authority change: update both this bootstrap and `CHATGPT_PROJECT_INSTRUCTIONS.md`.
- Do not edit old conversations or maintain separate desktop and mobile protocol copies.
