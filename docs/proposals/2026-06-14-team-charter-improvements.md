# Proposal: Team Charter Improvements

**Status:** Proposed — Pending Owner Review
**Version:** v2.3 (adds Proposal 11 — session boundaries)
**Author:** Claude (drafted under Standing Approval — draft plans/recommendations)
**Reviewers:** David Bloom (Product Owner), Codex
**Date:** 2026-06-14
**Affects:** `docs/team_charter/AI_COLLABORATION_RULES.md`, `docs/team_charter/AGENT_OPERATING_MODEL.md`, `docs/team_charter/TASK_WORKFLOW.md`, `docs/team_charter/STANDING_APPROVAL_LANES.md`, `docs/team_charter/DEFINITION_OF_DONE.md`, `docs/team_charter/HANDOFF_PACKET_TEMPLATE.md`, `docs/team_charter/SKILLS_GUIDE.md`, `docs/activity_log/APPROVALS_LOG.md`, `docs/activity_log/DECISIONS_LOG.md`, `docs/agent_notes/` (new), `prompts/CLAUDE_NEW_SESSION_PROMPT.md`, `prompts/CODEX_NEW_SESSION_PROMPT.md`, `prompts/CLOSE_SESSION_PROMPT.md`

## Revision History

**v2.3 — 2026-06-21, added Proposal 11 (session boundaries).** Codifies the existing start-of-session prompts as the formal session-open ritual, adds a matching session-close ritual referencing `prompts/CLOSE_SESSION_PROMPT.md`, and defines the owner trigger phrases ("start a new \<project\> session" and "end \<project\> session"). Additive — does not change Proposals 1–10. The session-close prompt currently lives only on the `claude/task-0011-drawn-response-eval-tooling` branch; adoption of Proposal 11 includes promoting it to `main` independently of that task. Cross-cutting recording covers Proposal 11 in the same bundle when adopted together.

**v2.2 — 2026-06-15, after Codex PR review.** Tightens Proposal 10's note lifecycle and naming model: recipient inboxes replace sender-specific filenames, `SYNC` and startup report every non-Resolved note, owner-authored notes use the same inboxes, the files are described as chronological logs rather than append-only, and the standing-approval text no longer refers to an undefined owner inbox. Also removes a Proposal 9 example that applied lifecycle status to a non-governed artifact and updates the document metadata to reflect all ten proposals.

**v2.1 — 2026-06-14, added Proposal 10 per owner direction.** Introduces a durable cross-agent notes channel (`docs/agent_notes/`) so that when the owner invokes `SYNC` (Proposal 1), each agent has a known location with a known format to read inbound notes from the other agent. Additive — does not change Proposals 1–9. Affected: `AI_COLLABORATION_RULES.md` gains a "Cross-Agent Notes" subsection; kit new-session prompts gain a one-line inbound-file read instruction; three new files seeded under `docs/agent_notes/`. Cross-cutting recording (one `APPROVAL-NNNN`, one `DECISION-NNNN`, one `CHANGELOG.md` entry) covers Proposal 10 in the same bundle when adopted together.

**v2 — 2026-06-14, after Codex review (consolidated for commit).** Incorporates Codex's first review (P1 / P2 / P3 findings) plus three additional fixes from Codex's second pass, plus integration of resolved open questions.

First-pass Codex changes:

- **Proposal 1 (sync trigger):** changed recommendation from `/sync` to `SYNC` for portability across clients that intercept slash commands.
- **Proposal 2 (batch approvals):** dropped the separate "Active Batch Approvals" index from the top of `APPROVALS_LOG.md` (eliminated the two-mutable-source drift risk). Single source of truth is the per-entry record. Added inclusive-date semantics and stated that an elapsed date wins over recorded `Status`.
- **Proposal 4 (charter change management):** dropped per-doc `Version` and `Last Updated` headers and the `ACTIVITY_LOG.md` duplicate. Kept the lightweight `CHANGELOG.md` plus the existing `APPROVAL-NNNN` / `DECISION-NNNN` records.
- **Proposal 5 (who flips `QA Passed`):** narrowed the QA Agent restriction. QA Agent may set non-final QA states (`QA Blocked`), populate `QA Result` and `Test Results`, and recommend a verdict. Only `QA Passed` and other final/terminal dispositions are reserved for the Main Conductor.
- **Proposal 9 (in-progress drafts):** rewritten. Decoupled branch location from document status. Dropped the broad "merge to `main` is a Hard Gate." Merge inherits the approval status of the work it carries — gating attaches to the underlying action class, not the mechanical merge. Limited the `Status:` header to governed documents only (proposals, specifications, policies, charter docs, individual decision/approval records). Branch naming now documents the existing `codex/...` convention rather than mandating new prefixes.

Second-pass Codex fixes:

- **Revision history line:** removed the false "available in git history" claim for v1 (v1 was never committed). v1 is preserved only in the summary bullets above.
- **Proposal 9b (governed-document scope):** corrected the claim that `APPROVALS_LOG.md` entries carry per-entry `Status:`. They use a `Decision:` enum. Lifecycle `Status:` (`Draft / Proposed / Approved / Superseded`) applies to proposals, specifications, policies, charter docs, and `DECISIONS_LOG.md` entries only. Batch approvals retain their separate operational `Status: Active / Expired / Superseded` per Proposal 2 — distinct vocabulary.
- **Cross-cutting recording requirements:** clarified that adoption is **one** Hard Gate (bundle or subset), recorded with **one** `APPROVAL-NNNN`, **one** `DECISION-NNNN`, and **one** `CHANGELOG.md` entry — not per-item.

Integrated resolutions from owner review:

- Proposal 3 rename to `TOOL_AND_INTEGRATION_GUIDE.md` confirmed (no longer optional).
- Proposal 9a actor-prefix policy confirmed (`codex/...`, `claude/...`, other descriptive prefixes allowed).
- Proposal 9g (new) added PR policy: direct pushes to feature branches acceptable; review/PR only for promotion to `main` when the underlying work itself requires review.
- Proposal 2 expiration timezone pinned to **America/New_York** (recorded explicitly).
- Open-questions section replaced by a concise resolutions summary at the end of the document.

**v1 — 2026-06-14, original draft.** Superseded by v2 before any commit. v1 has no separate git history; only v2 is committed. The substantive differences are summarized in the bullets above.

## Purpose

Address ten specific gaps in the team charter: operating-model gaps, small clarifications, a cross-cutting source-of-truth question about in-progress drafts, and a durable cross-agent notes channel. Each section states the problem, the proposed change, and the exact text/structure edits required.

Nothing in this proposal is approved. It is a recommendation under Standing Approval (drafting recommendations and plans). Adoption is a Hard Gate.

---

## 1. Replace the `C` / `c` manual sync trigger

**Problem.** A single character is too easy to fire accidentally. `C` and `c` can appear in normal chat, code snippets, typos, or as the start of a word the user is composing. A false trigger costs little, but a missed deliberate trigger is worse: the user thinks they re-synced when no sync occurred.

**Proposal.** Replace the trigger with `SYNC` (uppercase, standalone). Reasons: distinctive (nearly impossible to appear inadvertently in ordinary writing), portable across clients (some interfaces — including Claude Code — intercept slash-prefixed tokens before the text reaches an agent, which would defeat a `/sync` trigger), and easy to type. The behavior on receiving the trigger is unchanged from the existing handshake.

**Concrete edits.**

- `AI_COLLABORATION_RULES.md`, "Optional Manual Sync Handshake" section — replace the `C / c` code block with `SYNC`. Keep all other behavior rules unchanged.
- `AGENT_OPERATING_MODEL.md`, "Manual Sync Handshake" section — change the example from `C` or `c` to `SYNC`. Update prose accordingly.
- Record the change in `DECISIONS_LOG.md` (Area: Operations) and `APPROVALS_LOG.md`.

**Alternatives considered.** `/sync` (rejected per Codex P3 — slash-prefixed tokens may be intercepted by the client and never reach the agent); `RESYNC` (works but louder); `::c` (distinctive but unfamiliar).

---

## 2. Define a venue and tracking model for Batch Approvals

**Problem.** `STANDING_APPROVAL_LANES.md` Lane 2 specifies a template but doesn't say where a batch approval is recorded or how its expiration is tracked. Without that, batch approvals risk becoming chat-only, which violates the source-of-truth rule. The `Expires / Review Trigger` field has no mechanism that surfaces it when it lapses.

**Proposal.** Extend the existing `docs/activity_log/APPROVALS_LOG.md` rather than create a new directory. The log already supports a `Decision` enum (`Approved / Rejected / Approved with Notes / Done / Not Done / Do Not Do`) and a per-entry format that maps cleanly to a batch approval.

**Concrete edits to `APPROVALS_LOG.md`:**

1. Add `Approved (Batch)` to the `Decision` enum.
2. Add a new entry format for batch approvals:

   ```markdown
   ## APPROVAL-NNNN — Batch Title

   **Date:** YYYY-MM-DD
   **Approved By:** David Bloom
   **Related Task:** TASK-XXXX / N/A
   **Decision:** Approved (Batch)
   **Applies To:** [agents/roles/tasks that may invoke this approval]
   **Expires / Review Trigger:** YYYY-MM-DD or named condition
   **Status:** Active / Expired / Superseded

   ### Approved Scope
   - …

   ### Not Approved
   - …

   ### Notes
   - …
   ```

**Single source of truth.** Per-entry records in `APPROVALS_LOG.md` are the only authoritative list. There is no separate "Active Batch Approvals" index — that would create two mutable sources that can drift (Codex P2). Agents who need to know which batch approvals are currently in force grep the log for entries with `Decision: Approved (Batch)` and evaluate the per-entry `Expires` and `Status` fields.

**Expiration semantics.**

- `Expires` is **end-of-day inclusive** in **America/New_York** (matching project-owner operations; confirmed in v2 owner review). `Expires: 2026-07-01` means the approval remains valid through 23:59 of 2026-07-01 America/New_York. The timezone is recorded explicitly rather than as "local" to remove ambiguity for remote actors and CI.
- **The date wins when in conflict with `Status`.** If today is after `Expires` but the entry still reads `Status: Active`, the approval is treated as expired regardless of the recorded status. The conflict is a stale record, not an active approval. Agents who detect the conflict propose flipping the entry to `Status: Expired` in their next commit and note the discrepancy in their session report.
- `Status: Superseded` overrides date-based validity (a superseded approval is not valid even before its expiration date).
- An approval may also use a **named condition** instead of a date (e.g., `Expires: when CONTENT-001A closes`). In that case the named condition is the sole trigger; agents check it explicitly.

**Per-task citation.** When a task file invokes a batch approval, its `Approval State` block must cite the `APPROVAL-NNNN` ID. This makes the linkage auditable and lets a global search reveal everything depending on a given batch when it expires.

**Concrete edits to `STANDING_APPROVAL_LANES.md`:**

- Lane 2 section: add a "Where Recorded" subsection stating that batch approvals live in `docs/activity_log/APPROVALS_LOG.md`, must include the fields above, and must be cited by `APPROVAL-NNNN` in any task file that invokes them.
- Add an "Expiration and Conflict Resolution" subsection codifying the rules above (inclusive date, date-wins-over-Status, named-condition support).

---

## 3. Scope `SKILLS_GUIDE.md` to project-specific skills only

**Problem.** `SKILLS_GUIDE.md` re-states rules that already live in `AGENT_OPERATING_MODEL.md` (Source / Live-State, QA, Strategy). Two copies of the same rule will drift. Worse, an agent that reads only `SKILLS_GUIDE.md` (because the task is technical) may miss updates to `AGENT_OPERATING_MODEL.md`.

**Proposal.** Scope `SKILLS_GUIDE.md` strictly to **project-specific tool and integration skills** — Lovable, Supabase, Vercel, Stripe (when introduced), model providers, email/SMS providers, frontend wiring. Remove role-based rules. Where role context matters, link back to the canonical section in `AGENT_OPERATING_MODEL.md`.

**Concrete edits to `SKILLS_GUIDE.md`:**

- **Remove:** "Skill Equivalent: Source of Truth", "Skill Equivalent: Implementation / Live State", "Skill Equivalent: QA", "Skill Equivalent: Strategy". These are role rules covered by `AGENT_OPERATING_MODEL.md` and `AI_COLLABORATION_RULES.md`.
- **Keep and expand:** "Skill Equivalent: Payments / Integrations", "Skill Equivalent: Deployment / Serverless Routes", "Skill Equivalent: Frontend / UX". These are genuinely project-specific.
- **Add a header note:** "This guide covers project-specific tool and integration skills only. Role definitions, agent boundaries, source-of-truth rules, QA process, and approval lanes live in `AI_COLLABORATION_RULES.md`, `AGENT_OPERATING_MODEL.md`, and `STANDING_APPROVAL_LANES.md`."
- **Rename the file** to `docs/team_charter/TOOL_AND_INTEGRATION_GUIDE.md` (confirmed in v2 owner review). Update any inbound links in other charter docs. The clearer ownership signal outweighs the minor link churn.

**Alternative considered.** Keep both and add cross-references. Rejected: it doesn't eliminate the drift risk; it just makes the drift faster to detect.

---

## 4. Add change-management to the charter itself

**Problem.** Each charter doc shows `Status: Approved` but offers no at-a-glance signal that the rules have changed. If a Hard Gate moves to Standing Approval (or vice versa), agents who rely on remembered rules keep applying the old version. The charter is meta — it governs the process — so changes to it should themselves be governed.

**Proposal (v2, narrowed per Codex P2).** Three lightweight mechanisms — no per-doc headers, no duplicate activity-log entries:

1. **Treat material charter changes as Hard Gates.** They affect the operating model.
2. **Record each change in the existing logs:** one `APPROVAL-NNNN` in `APPROVALS_LOG.md` and one `DECISION-NNNN` in `DECISIONS_LOG.md` (Area: Operations). These already capture rationale, owner, and date — no new fields needed.
3. **Maintain a single lightweight `docs/team_charter/CHANGELOG.md`** as the at-a-glance signal that agents check on sync.

Git history covers per-document detail; we do not add per-doc `Version` or `Last Updated` headers, which would drift independently of git.

**Concrete edits.**

- **New file `docs/team_charter/CHANGELOG.md`** — append-only chronological log, one entry per material charter change:

  ```markdown
  # Team Charter Changelog

  ## 2026-06-14 — [Doc Name(s)]
  **Approval:** APPROVAL-NNNN
  **Decision:** DECISION-NNNN
  **Change (one or two lines):**
  - …
  ```

  No per-doc version numbers; the `APPROVAL-NNNN` and `DECISION-NNNN` references plus git blame are sufficient.

- **`STANDING_APPROVAL_LANES.md`, Lane 3 (Hard Gates)** — add: "Material changes to `docs/team_charter/` documents (the operating model itself)."

- **`AI_COLLABORATION_RULES.md`, Source-of-Truth Rule** — add a sentence: "Material changes to charter documents are Hard Gates, recorded in `docs/team_charter/CHANGELOG.md` with cross-references to the governing `APPROVAL-NNNN` and `DECISION-NNNN`."

- **Manual sync (`SYNC`) behavior** — extend the existing list: when running `SYNC`, agents check `docs/team_charter/CHANGELOG.md` for entries newer than the last read and re-read the affected charter docs before reporting state.

**Removed from v1.** Per-doc `Version` and `Last Updated` headers — git history is the authoritative record of who changed what and when. Per-change `ACTIVITY_LOG.md` entry — redundant with `APPROVAL-NNNN`, `DECISION-NNNN`, and the new `CHANGELOG.md`.

---

## 5. Clarify who flips a task to `QA Passed`

**Problem.** `TASK_WORKFLOW.md` lists `QA Passed` as a status. `AI_COLLABORATION_RULES.md` says the QA Agent "must not… mark tasks passed as final." That leaves the actor for that transition implicit.

**Proposal (v2, narrowed per Codex P2).** The original v1 wording — "QA Agent never sets task status" — was too broad; it would block useful QA-side transitions like flagging `QA Blocked` when QA cannot proceed. Reserve only **final/terminal QA dispositions** for the Main Conductor; allow QA to record non-final QA state and evidence.

The QA Agent **may**:

- Set status to `QA Blocked` when QA cannot proceed (missing evidence, blocked dependency, environment issue).
- Populate the task's `QA Result` and `Test Results` fields with proposed findings and executed-evidence captures.
- Recommend a verdict (`QA Passed` / `QA Failed`) in those fields without setting the task's overall status.

The QA Agent **must not**:

- Set status to `QA Passed`, `Done`, `Ready for Owner Review`, or `Do Not Do`. These are terminal or owner-facing dispositions and require Main Conductor (or Product Owner) action.
- Otherwise approve, close, publish final decisions, deploy, migrate, or alter live state (unchanged from existing rules).

The Main Conductor integrates the QA Agent's recommended verdict, validates evidence, and sets `QA Passed` (or returns the task for remediation).

**Concrete edits.**

- `AI_COLLABORATION_RULES.md`, "Main Conductor" role bullet list — add: "Setting task status to `QA Passed` after integrating the QA Agent's recommended verdict and verifying evidence."
- `AI_COLLABORATION_RULES.md`, "QA Agent" role — update the prohibition list to: "The QA Agent must not set task status to `QA Passed`, `Done`, `Ready for Owner Review`, or `Do Not Do`; must not approve, close, publish final decisions, deploy, migrate, or alter live state. The QA Agent may set `QA Blocked` and populate `QA Result` and `Test Results` with proposed findings and recommended verdict."
- `TASK_WORKFLOW.md`, Status Values — annotate `QA Passed` with `(set by Main Conductor)`; annotate `QA Blocked` with `(may be set by QA Agent)`.

---

## 6. Clarify "Tests/QA checks are documented" in Definition of Done

**Problem.** `DEFINITION_OF_DONE.md` requires "Tests/QA checks are documented." That phrase is ambiguous between "a test plan is written" and "tests were executed and the results are captured." The task metadata field `Test Results:` implies the latter, but the DoD doesn't say so.

**Proposal.** Specify that "documented" means evidence of execution.

**Concrete edits to `DEFINITION_OF_DONE.md`:**

- Change "Tests/QA checks are documented." to:

  > "QA evidence is captured in the task's `Test Results` field — the artifacts demonstrating each acceptance criterion was exercised (test output, screenshots, query results, manual-test transcripts, or equivalent). A test plan without executed evidence does not satisfy this criterion."

- Add to "Not Done" list: "A test plan exists but no execution evidence is captured."

---

## 7. Simplify the handoff packet's three prompt slots

**Problem.** `HANDOFF_PACKET_TEMPLATE.md` always contains three "Recommended Prompt" slots (Implementation, QA, UX/Prompt). Most handoffs need only one. Today the template invites placeholder filler or copy-paste from prior templates, eroding signal.

**Proposal.** Keep one template, mark prompts as fill-only-as-needed, and add a single line at the top of the packet listing which slots apply.

**Concrete edits to `HANDOFF_PACKET_TEMPLATE.md`:**

- Add a line near the top, just under `Next Expected Output`:

  ```text
  Prompts Included:
  - [ ] Implementation Agent
  - [ ] QA Agent
  - [ ] UX / Prompt Agent
  ```

- Above the three `Recommended Prompt for …` blocks, add:

  > "Include only the prompt(s) for the agent(s) listed in `Prompts Included` above. Omit the others entirely — do not leave empty triple-quoted blocks or placeholder text."

**Alternative considered.** Split into three lighter templates. Rejected: it multiplies maintenance and most handoffs benefit from the surrounding shared context.

---

## 8. Define the `Do Not Do` status

**Problem.** `TASK_WORKFLOW.md` lists `Do Not Do` as a status with no definition. `APPROVALS_LOG.md` includes `Do Not Do` in its Decision enum, but neither doc explains when a task lands there or how it differs from `Blocked`.

**Proposal.** Define `Do Not Do` as: "Task was evaluated and explicitly declined or descoped. The work will not be done. Different from `Blocked`, which is deferred pending input or a dependency. Different from `Done`, which means the work was completed. The Product Owner makes a `Do Not Do` decision; the Main Conductor records it in `APPROVALS_LOG.md` and updates the task status."

**Concrete edits.**

- `TASK_WORKFLOW.md`, Status Values — annotate `Do Not Do` with: "(Product Owner decision; rejected or descoped; not the same as Blocked)."
- Add a short "Status Definitions" subsection under Status Values, defining the three states most easily confused: `Blocked` (deferred pending input), `QA Blocked` (deferred pending QA-side dependency), `Do Not Do` (rejected/descoped — terminal), and `Done` (completed — terminal).
- `APPROVALS_LOG.md` Decision enum already includes `Do Not Do`. Add one sentence to its header: "`Do Not Do` records an explicit Product Owner decision not to do the related task or scope."

---

## 9. Source-of-Truth: handle in-progress drafts (rewritten in v2)

**Problem.** The Source-of-Truth Rule (`AI_COLLABORATION_RULES.md`, formalized in `DECISION-0012` / `APPROVAL-0012`) requires every retained local doc to be committed and pushed to `david-bloom/Cramapple`. It does not address how in-progress drafts coexist with that rule: a doc actively being written, or a multi-session draft not yet ready to land on `main`. Without convention, agents either push half-formed work to `main` or keep work local in violation of the rule.

**Codex's v1 critique (applied here).** The v1 version conflated two independent concerns:

- **Durability** — has the work reached GitHub so it isn't trapped on one machine?
- **Approval lifecycle** — is the underlying work approved?

V1 coupled them ("Approved status requires merge to `main`" and "merging to `main` is a Hard Gate"). That overshoots: a `Proposed` decision can legitimately live on `main` for durable recording without being Approved, and an approved implementation should not require a *second* approval at merge time. V2 keeps the two axes orthogonal.

### 9a. Branch convention — actor-prefixed, descriptively named

- In-flight work happens on a feature branch off `main`, pushed to GitHub.
- **Actor prefixes** (confirmed in v2 owner review):
  - `codex/...` when Codex is the actor (matches existing practice).
  - `claude/...` when Claude is the actor.
  - Other descriptive prefixes are allowed when an actor or context warrants it. The prefix is convention, not law; what matters is that the branch is **descriptively named** (actor and work both legible) and **pushed to the remote**.
- A doc on a pushed feature branch satisfies the Source-of-Truth Rule. It does **not** need to be on `main` to be durably synced.

### 9b. Document status — only for governed documents

Apply a lifecycle `Status:` header to **governed documents**: proposals, specifications, policies, charter docs, and individual entries in `DECISIONS_LOG.md` (which already use `Status: Proposed / Approved / Superseded` per entry).

Do **not** apply this lifecycle `Status:` to:

- Append-only logs themselves (`APPROVALS_LOG.md`, `DECISIONS_LOG.md`, `ACTIVITY_LOG.md`) — they don't have a single lifecycle state.
- `APPROVALS_LOG.md` **entries** — those use a `Decision:` enum (`Approved / Rejected / Approved with Notes / Done / Not Done / Do Not Do / Approved (Batch)`), not the lifecycle `Status:`. Decision and lifecycle Status are distinct vocabularies and should not be conflated.
- Templates, indexes, README files, generated artifacts, or non-Markdown files.

Recognized lifecycle `Status:` values for governed documents:

- `Draft` — actively being written; not yet stable enough to circulate.
- `Proposed` — stable enough to review; awaiting an approval decision. (Already in use in `DECISIONS_LOG.md`.)
- `Approved` — approval recorded (Standing, Batch, or Hard Gate as applicable).
- `Superseded` — replaced by a newer artifact; preserved for history.

**Separate vocabulary — batch approvals.** Batch approval entries in `APPROVALS_LOG.md` carry their own operational `Status: Active / Expired / Superseded` per Proposal 2. That is a distinct vocabulary tracking whether the approval is currently in force, not a lifecycle state of a document. The two never mix on the same entry.

### 9c. Branch and status are independent

- A governed document with `Status: Draft` may live on a feature branch (typical) **or** on `main`.
- A `Proposed` document may live on a feature branch **or** on `main`. Recording a `Proposed` decision on `main` durably captures the proposal; it does not imply approval.
- An `Approved` document may live on `main` (typical, once merged) **or** on a feature branch (if it was approved while still on the branch and merge hasn't happened yet).
- No combination of branch and status is implicitly forbidden. Status reflects the approval lifecycle; branch reflects the workflow location.

### 9d. Merging is mechanical — gating attaches to the underlying action

A merge to `main` does **not** itself require a fresh approval. The merge inherits the approval state of the work it carries, applying the existing Lane rules in `STANDING_APPROVAL_LANES.md`:

- **Implementation within an approved task** — already approved (Lane 3 covered the task). Merge proceeds.
- **Documentation-only updates that accurately record an already-approved decision** — Standing Approval (Lane 1). Merge proceeds.
- **Recording a new `Proposed` decision or recommendation** — Standing Approval (drafting plans/recommendations). The doc lands on `main` with `Status: Proposed`. Merge proceeds. Approval of the proposal itself is a separate, later event.
- **Implementation not covered by an approved task** — the implementation requires a Hard Gate before any merge that lands it. The gate is on the *work*, not the merge.
- **Material changes to charter documents** — Hard Gate per Proposal 4. The gate is on the *change*, not the merge.

The v1 wording "merging to `main` is a Hard Gate" is dropped. The existing Lane 3 list, plus Proposal 4's addition for charter changes, is sufficient.

### 9e. What "synchronization complete" means

"Synchronization complete" applies to the **branch the agent is working on**, not necessarily `main`. The agent's sync report must state:

- The branch name.
- That the latest commit is verified present on the remote.
- For governed documents in the change: the document's `Status:` value (`Draft` / `Proposed` / `Approved` / `Superseded`).

This preserves the rule's intent (no local-only durable state) without forcing immature drafts onto `main`.

### 9f. Push cadence (unchanged)

- Push at the end of each work session.
- Push before any handoff (`HANDOFF_PACKET_TEMPLATE.md`).
- Push before reporting `Ready for QA`, `Ready for Owner Review`, or invoking the `SYNC` trigger on this work.
- Always verify the remote contains the commit before reporting sync complete (already required by `DECISION-0012`; reaffirming).

### 9g. PR policy (confirmed in v2 owner review)

- **Direct pushes to a feature branch are acceptable.** No PR is required for ongoing work on `codex/...`, `claude/...`, or other actor-prefixed branches.
- **Promotion to `main` uses a PR only when the underlying work requires review.** If the work is Standing Approval (e.g., documentation-only updates recording an already-approved decision), a direct merge is acceptable. If the work requires Hard Gate review or batch-approval verification, the merge goes through a PR that cites the relevant `APPROVAL-NNNN`.
- The PR requirement attaches to the **underlying work's review need**, not to the merge as a mechanical step. This is consistent with 9d (merging inherits the approval status of the work it carries).

### 9h. Concrete edits

- `AI_COLLABORATION_RULES.md`, Source-of-Truth Rule — append a new subsection "In-Progress Drafts and Branches" covering 9a, 9c, 9e, 9f, 9g. State explicitly that durability and approval status are independent.
- `AI_COLLABORATION_RULES.md`, Universal Document Format Rule — add a short "Document Status" subsection codifying 9b (recognized lifecycle `Status:` values and the **governed-documents-only** scope; explicit note that `APPROVALS_LOG.md` entries use `Decision:`, and batch approvals use a separate operational `Status:` per Proposal 2).
- `STANDING_APPROVAL_LANES.md` — **no change** to Lane 3 from this proposal (v1's "merge to `main` is a Hard Gate" is dropped). Charter-change additions remain governed by Proposal 4.

---

## 10. Cross-Agent Notes — a durable agent-to-agent channel

**Problem.** Today, agent-to-agent communication has no durable venue. Handoff packets (`HANDOFF_PACKET_TEMPLATE.md`) are task-bound and one-shot. The activity log captures completed events, not forward-looking requests. Chat does not survive sessions. If Codex needs Claude to handle something next session — or vice versa — there is no source-of-truth location to leave that note. When the owner invokes `SYNC` (Proposal 1), each agent has nowhere to look for outstanding cross-agent requests, so cross-agent context is repeatedly lost.

**Proposal.** Add a small notes folder containing two chronological recipient inboxes. Sender-authored content is immutable; recipients update only operational status and resolution fields.

### 10a. Folder and files

```
docs/agent_notes/
  CLAUDE_INBOX.md   — durable notes addressed to Claude
  CODEX_INBOX.md    — durable notes addressed to Codex
  README.md         — one-page convention reference
```

Naming pattern: `[RECIPIENT]_INBOX.md`. The sender is recorded in each entry's `From:` field, so agent-authored and owner-authored notes use the same recipient inbox. A third recurring agent requires only one additional inbox.

### 10b. Entry format

Chronological, newest at bottom (matches `ACTIVITY_LOG.md`, `APPROVALS_LOG.md`, `DECISIONS_LOG.md`):

```markdown
## NOTE-YYYY-MM-DD-NN — Short subject

**From:** Codex
**To:** Claude
**Status:** Open / Acknowledged / Resolved
**Related:** TASK-XXXX, APPROVAL-NNNN, branch, PR, file path (any/none)
**Date:** YYYY-MM-DD

### Context

### Note / Request / Question

### Required Action (if any)

### Resolution
*(filled by recipient when status → Resolved)*
```

`Status:` vocabulary (operational, not the lifecycle `Status:` from Proposal 9b):

- `Open` — sender awaits acknowledgement or action.
- `Acknowledged` — recipient has seen and accepted; not yet resolved.
- `Resolved` — action taken or note no longer load-bearing; preserved for history.

### 10c. Edit rules

- The **sender** appends new notes to the bottom of the inbound file for the recipient. The Context / Note / Required Action blocks are immutable once written (like a sent message).
- The **recipient** may update the `Status:` field and fill the `### Resolution` block. The recipient does **not** edit the sender's text.
- Either agent may add a follow-up note to the *other* file in response (e.g., a clarifying question). Cross-reference by `NOTE-…` ID.

### 10d. SYNC behavior addition

Add to the `SYNC` handshake section in `AI_COLLABORATION_RULES.md`:

> On `SYNC`, the agent re-reads `docs/agent_notes/[RECIPIENT]_INBOX.md` and reports every entry whose `Status` is not `Resolved` — by `NOTE-…` ID, subject, status, sender, date, and required action — before reporting other state. For Claude, the file is `CLAUDE_INBOX.md`; for Codex, it is `CODEX_INBOX.md`.

### 10e. Startup prompt addition

Add one line to the new-session prompt (the unified `NEW_SESSION_PROMPT.md` per Kit-review B1; until that lands, add to both `CLAUDE_NEW_SESSION_PROMPT.md` and `CODEX_NEW_SESSION_PROMPT.md`):

> Read `docs/agent_notes/[RECIPIENT]_INBOX.md` and report all notes not marked `Resolved`.

### 10f. Owner as occasional sender

The owner may leave standing notes by writing an entry with `From: David` and `To: Claude`, `To: Codex`, or `To: Both`. Entries addressed `To: Both` are mirrored in both recipient inboxes so each agent sees the note on `SYNC`. Use a shared `NOTE-…` ID with `-A` / `-B` suffix to make the mirror visible (e.g., `NOTE-2026-06-15-01-A` in `CLAUDE_INBOX.md`, `NOTE-2026-06-15-01-B` in `CODEX_INBOX.md`).

This is not a replacement for direct chat — it's a durable place for instructions that must survive session boundaries.

### 10g. Concrete edits

- **Create** `docs/agent_notes/CLAUDE_INBOX.md`, `docs/agent_notes/CODEX_INBOX.md`, and `docs/agent_notes/README.md`. Each inbox ships with the format block at the top and zero entries. `README.md` summarizes 10a–10f.
- **`AI_COLLABORATION_RULES.md`** — add a "Cross-Agent Notes" subsection covering 10a, 10b, 10c, and 10d.
- **New-session prompts** — add the one-line read instruction (10e). When the kit's merged-prompt change (Kit-review B1) lands, this lives in the single file with an actor-aware placeholder.
- **`STANDING_APPROVAL_LANES.md`** — Lane 1 (Standing Approvals) explicitly covers "Writing a note in another agent's recipient inbox (`docs/agent_notes/*_INBOX.md`)." Writing notes is communication, not implementation; it inherits the Lane 1 doc-only standing approval.

### 10h. Alternatives considered

- **Single shared `AGENT_NOTES.md` file.** Rejected: loses the "addressed to me" cue; both agents would have to filter on every `SYNC`. Recipient inboxes mean each agent reads exactly one file.
- **Reuse `HANDOFF_PACKET_TEMPLATE.md`.** Rejected: handoff packets are task-bound and one-shot. Cross-agent notes are standing, additive, and may span tasks — different shape, different lifecycle.
- **GitHub issues or PR comments.** Rejected: heavier surface, fragments across two interfaces (files vs the GitHub UI), and breaks the existing "durable project state is Markdown in `docs/`" pattern.
- **Per-agent inbox folders (`docs/agent_notes/claude/inbox.md`).** Rejected for now: same effect as flat recipient inbox files but with extra path depth. Worth reconsidering if agent-specific notes expand beyond one file each.

---

## 11. Session boundaries — formalize open and close rituals

**Problem.** Two prompts already exist that bracket a working session — `prompts/CLAUDE_NEW_SESSION_PROMPT.md` and `prompts/CODEX_NEW_SESSION_PROMPT.md` (start) and `prompts/CLOSE_SESSION_PROMPT.md` (end). The start prompts are tracked on `main`. The close prompt currently lives only on the `claude/task-0011-drawn-response-eval-tooling` feature branch. Nothing in the team charter references either ritual, so:

- The trigger phrasing the owner uses ("start a new cramapple session", "end cramapple session") works only because agents have internalized it from prior sessions, not because the charter documents it.
- An agent that hasn't seen the convention has no canonical reference to follow.
- The close ritual depends on a file that will only reach `main` if TASK-0011 merges first — a logically unrelated dependency.

**Proposal.** Codify both rituals in the charter and promote the close prompt to `main` independently of TASK-0011.

### 11a. Triggers

- **Open:** the owner says any variant of "start a new \<project\> session" (e.g. "start a new cramapple session"). Agents respond by running the steps in `prompts/CLAUDE_NEW_SESSION_PROMPT.md` (Claude) or `prompts/CODEX_NEW_SESSION_PROMPT.md` (Codex): read current source-of-truth docs, report current task, approval state, blockers, and next action. This trigger is sync/orientation only — it does not authorize execution or imply owner approval.
- **Close:** the owner says any variant of "end \<project\> session" or "close \<project\> session" (e.g. "end cramapple session"). Agents respond by running the 10-point closeout in `prompts/CLOSE_SESSION_PROMPT.md`: current task, what changed, what was verified, what remains open, blockers/risks, files changed, commands run with results, approval state, exact next step, do-not-touch scope. If the work is not ready to resume cleanly, the agent also refreshes a handoff packet per `HANDOFF_PACKET_TEMPLATE.md`.

The close ritual is **not** owner approval. Like `SYNC` (Proposal 1) and the start-of-session ritual, it is sync/handoff only. Done decisions, QA pass decisions, deployment authorization, and other hard gates still follow the normal approval path.

### 11b. Charter additions

- `AI_COLLABORATION_RULES.md`, after the "Startup Rule" section, add a "Closeout Rule" section: "At the end of a working session, agents run the closeout reported in `prompts/CLOSE_SESSION_PROMPT.md`. The closeout records current state in GitHub before the session ends. It does not by itself authorize execution, approval, deployment, or task closure — those follow the normal approval path."
- `AI_COLLABORATION_RULES.md`, "Startup Rule" section, append: "The owner's start-of-session trigger ('start a new \<project\> session') invokes this rule explicitly."
- `TASK_WORKFLOW.md`, Status Values section, add a note that `Ready for Owner Review` and `Ready for QA` transitions trigger a closeout if they would end the session.

### 11c. Prompt promotion

`prompts/CLOSE_SESSION_PROMPT.md` is currently only on the `claude/task-0011-drawn-response-eval-tooling` branch. Adoption of Proposal 11 includes:

1. Cherry-picking that file onto `main` directly (or onto whichever branch lands Proposal 11), so the close prompt is not dependent on TASK-0011 merging.
2. Confirming `prompts/CLAUDE_NEW_SESSION_PROMPT.md` and `prompts/CODEX_NEW_SESSION_PROMPT.md` remain on `main` unchanged.

### 11d. Why both rituals belong in the charter, not just the prompts directory

Prompts are agent-facing operating instructions. The charter documents the rules they enforce. Without the charter reference:

- Future agents may not know the prompts exist or that the trigger phrases are real commands.
- The owner cannot reasonably hold an agent accountable for skipping the closeout if the rule never appears in the charter.
- The `SYNC` handshake (Proposal 1) is already documented in `AI_COLLABORATION_RULES.md`; session-open and session-close are the same shape of operational handshake and deserve the same treatment.

### 11e. Concrete edits

- **Charter:** add the Closeout Rule subsection to `AI_COLLABORATION_RULES.md` and the trigger-phrase note to the existing Startup Rule.
- **Prompts:** promote `prompts/CLOSE_SESSION_PROMPT.md` to `main` as a kit-level file.
- **Recording:** the adoption is one `APPROVAL-NNNN` and one `DECISION-NNNN` in the cross-cutting bundle below; no separate per-rule records.

### 11f. Alternatives considered

- **Leave it implicit; let agents learn the convention.** Rejected: the team is adding agents and the convention is undocumented. The cost of one charter section is much less than the cost of every new agent discovering the closeout ritual by trial and error.
- **Document closeout only in `CLAUDE.md` files at the project root.** Rejected: the charter docs are the source of truth for operating rules; `CLAUDE.md` is downstream context.
- **Replace both prompts with inline charter text.** Rejected: prompts can be loaded into a session's context window directly; charter sections cannot. Both formats are needed for different consumers.

---

## Cross-cutting recording requirements

The owner may adopt this proposal as a single bundle, or as any explicitly listed subset of the eleven items. The adoption — bundle or subset — is **one Hard Gate**, recorded with:

- **One** `APPROVAL-NNNN` entry in `APPROVALS_LOG.md` that names the adopted items by number (e.g., "Adopts Proposals 1, 2, 3, 5, 6, 7, 8, 9, 10, 11 from `docs/proposals/2026-06-14-team-charter-improvements.md`").
- **One** `DECISION-NNNN` entry in `DECISIONS_LOG.md` (Area: Operations) capturing rationale and consequences.
- **One** `CHANGELOG.md` entry in `docs/team_charter/` (per Proposal 4) listing which proposal numbers landed and pointing back to the `APPROVAL-NNNN` and `DECISION-NNNN`.

Git history is the authoritative record of per-document edits. No per-doc version headers; no separate `ACTIVITY_LOG.md` entry for a change already captured in the three records above.

## Resolutions from v2 owner review

The v1 "Open questions" list has been resolved. The answers are integrated into the affected proposals above and summarized here for the record:

1. **Sync trigger.** `SYNC` confirmed.
2. **`SKILLS_GUIDE.md` rename.** Rename to `TOOL_AND_INTEGRATION_GUIDE.md` (Proposal 3).
3. **Branch prefixes.** `codex/...` (existing), `claude/...` (new), other descriptive prefixes allowed (Proposal 9a).
4. **Batch approval lifecycle automation.** Human-in-the-loop now. Automation may be added later once batch approvals are used enough to justify it (Proposal 2).
5. **PR policy on feature branches.** Direct pushes to feature branches are fine. Review/PR required only for promotion to `main` when the underlying work itself requires review (Proposal 9g).
6. **Timezone for inclusive expiration dates.** America/New_York, recorded explicitly (Proposal 2).
