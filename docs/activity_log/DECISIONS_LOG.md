# Decisions Log

This log records product, architecture, operating, security, design, and workflow decisions.

## Index

Most recent entries (full chronological list follows below):

- DECISION-0087 — Home's "Start Practice" Always Starts With Open Hand (Teaching-First Entry); Answer Keys Must Reveal on an Explicit Action, Never on Mount
- DECISION-0086 — Open Hand Resolves to One Gated Path: Entitlement-Scoped Access With a Mandatory Exclusion Write (Staff/QA Exempt), Unified on `get_open_hand_item`; the Work Is TASK-0051
- DECISION-0085 — Skill-Dimension Labels Are Validated by Model Consensus (≥2 of 3), Not Human Review; Frontier Proposer Pair Plus Blind Adjudicator; Extends DECISION-0066 to `skill_code`
- DECISION-0084 — TASK-0039 BYOQ Ships to Production (Phases 1–2): Launch Defaults for the Eight "New Gaps" (No Entitlement Gate, Quotas, 30-Day Anonymous Retention, Consent Copy, Private-Only, Stuck-Routing and Hints Deferred); Phase 3 Remains Blocked
- DECISION-0083 — Begin TASK-0041 Payment Flow Now; Set Pricing to $39.99 / $69.99 / $89.99; October 2 Free Launch Unchanged
- DECISION-0082 — No Fixed Quantity Targets Outside AP Biology; Maximize Safe Student Usability of Current Published Inventory
- DECISION-0081 — Lean Source-of-Truth Startup Mode: Tier-First Session-Start Reading for Codex and Claude, `AGENTS.md` Search Discipline, and Log `INDEX_END` Markers
- DECISION-0080 — `DECISION-0074` Addendum: the Four Gated Aids (Rubric, Points, Deep Dive, Reference) All Count as Pre-Submission Hint Use for Mastery; Approves Rebuilding `SessionFrame`'s Live Hint Gating to Match (Workstream B1 of the "Gate the Four Aids" Plan)
- DECISION-0079 — Promote All 293 `provisional_model` Topic Labels (112 AP Biology + 181 AP Statistics) to `validated`; Both Now Visible Through `content_item_topic_resolution`
- DECISION-0078 — Ratify Three Session-Start Bootstrap Edits: Live Lovable Front-Ends in the Repository Map, Required First-Read of the Architecture/Design One-Pager + INDEX, and an Anti-Stale Rule
- DECISION-0077 — BYOQ Is Identity-Agnostic: `byoq_items.user_id` Not Required (Anonymous on Marketing, Recognized-but-Not-Gated In-App); Resolves the DECISION-0070 ⟷ DECISION-0068 Conflict
- DECISION-0076 — TASK-0039 BYOQ Phase Priority Corrected: Camera/Phone Capture Is Launch-Required, Not Typed Intake; Ownership Confirmed as Claude, Not Codex
- DECISION-0075 — Ratify `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` as the Canonical Architecture/Design Source of Truth; Adopt the `STATUS:` Header Convention + `docs/INDEX.md`; Legacy Docs Handled by Annotate-in-Place (Option A, No Move)
- DECISION-0074 — Mastery Rule Tightened: 2 Correct MCQ + 1 Full-Point FRQ, No Hint Use Prior to Submission; Adds a New Content-Coverage Dependency (GAP-9)
- DECISION-0073 — Launch Frontend Target Is the Lovable App Published at ap-prep-canvas.lovable.app, Tentatively Identified as the "New Cramapple App" Project
- DECISION-0072 — Extend DECISION-0063 to AP Statistics: Launches on the Flat/Practice Path, Unit-Gating Deferred
- DECISION-0071 — Launch Friday, Free — Ship Without Stripe/Payment Gating; Add Payment Flow as a Post-Launch Follow-Up
- DECISION-0070 — Launch-Planning Follow-Ups: BYOQ Ships Ungated/Anonymous on the New Home Page; Unlimited-Tier Pricing Deferred Until All 10 Subjects Are Live; Target Launch Window Is Next Week; Wordmark-Only Branding Is Sufficient (No Logo Mark Required)
- DECISION-0069 — Day-1 Launch Subjects Are AP Biology and AP Statistics, Fast-Follow the Rest as Site-Performance Confidence Improves; Set Single/2-Bundle/3-Bundle Pricing at $39.99 / $79.99 / $99.99
- DECISION-0068 — BYOQ Data Model Uses Parallel Tables (Option A), Not the Live Graded Pipeline; TASK-0039 Phase 1 Scope Approved
- DECISION-0067 — Coverage Labels Stay Deferred at `provisional_model`; No Promotion Work Until Coverage Reporting Is Prioritized (FF-9)
- DECISION-0066 — Approve AI Two-Model Agreement as Sufficient to Promote Serving Labels to `validated`, Product Owner as Approver (FF-3)
- DECISION-0065 — Four Rules to Unblock J.0's Continuous `attainment_ratio` (FF-6): AI Cross-Model Verb Verification, Same-Tier Borrowing, Mean Aggregation, Non-Overlapping Cut Points
- DECISION-0064 — Split `APBIO-FRQ-S-101` Criterion `a-iv` Into Two Stem-Aligned Criteria; Authorize Rewriting `S-021`/`S-023`/`S-058`'s Canonical Answers to Match Their Rubrics
- Older entries: [`DECISIONS_LOG-0001_to_0065.md`](archive/DECISIONS_LOG-0001_to_0065.md)

**Rotation rule:** once this log exceeds ~600 lines, archive the older entries to `docs/activity_log/archive/DECISIONS_LOG-<range>.md` and update this index to point at the archive. Keep the index itself to the last ~10 entries. (This log is already well over that threshold — the first archive pass is overdue, not optional.)

(Note: the TASK-0012 branch independently logged its own DECISION-0027/0028 — CORS/ALLOWED_ORIGINS and budget-burn semantics — under different numbers on its own branch. Those land separately when that work merges to `main`; this charter-adoption decision claimed 0027/0028 here because `main` had not yet recorded entries past DECISION-0026 at merge time. If both branches' numbering collides on merge, renumber on whichever side merges second and update this index.)

(Note: the same collision recurred 2026-09-26. The `claude/launch-planning-cram-4oyh2g` branch independently claimed DECISION-0068 through 0072 for five launch-planning decisions, not knowing `main` had already recorded its own DECISION-0068 (BYOQ parallel tables, TASK-0039 Phase 1) by the time this branch merged. Per the rule above, this branch — the later-merging side — renumbered its five decisions to DECISION-0069 through 0073 at merge time; main's DECISION-0068 is untouched. If you are reading an older copy of any of the five renumbered decisions (in a plan doc, a chat log, or a stale local checkout) under its original 0068-0072 number, this is why the number no longer matches — the content is unchanged, only the ID moved.)

<!-- INDEX_END -->

## DECISION-0087 — Home's "Start Practice" Always Starts With Open Hand; Keys Reveal on an Explicit Action, Never on Mount

**Date:** 2026-09-29
**Decision Owner:** David Bloom
**Status:** Approved (direction given in session, 2026-09-29)
**Related Task:** `docs/tasks/TASK-0052-OPEN-HAND-FRONTEND-WIRING.md`
**Related Docs:** `DECISION-0086` (the Open Hand serving contract), `DECISION-0074` (mastery bar), `DECISION-0080` (gated aids), `docs/product/SKILL_DIMENSION_FEASIBILITY_2026_09_29.md` (the MCQ ceiling arithmetic)
**Area:** Product / student entry flow / content economics

### Decided

**Teaching-first is the default entry.** Home's "start practice" always routes to Open Hand, not to
`/session`. This is no longer a flagged experiment: `practice_entry.ts` stops branching on the
plate-loop flag for this decision, and the `?loop=` URL override is removed (`DECISION-0086`
follow-on).

### Consequence recorded at decision time, and the requirement it forces

Every disclosed answer key permanently removes that item from the student's scorable pool
(`DECISION-0086`). With Open Hand as the mandatory entry, that collides with `DECISION-0074`'s bar of
2 correct MCQ + 1 full-point FRQ per topic×skill cell. Measured against Production 2026-09-29:
AP Biology has 43 published MCQs, so a ceiling of 21 masterable cells, falling to **16 after ten
disclosures and 11 after twenty**; AP Statistics goes 50 → 45 → 40. **Roughly one masterable cell
lost per two MCQ keys disclosed**, permanently and per student.

**Therefore, a hard requirement on `TASK-0052`:** the key must be revealed by an **explicit student
action**, never on mount. `OpenHandMcqScreen` currently renders every choice's verdict as soon as it
renders; combined with a mandatory Open Hand entry that would burn an item on **every session start**,
with no student choice and no opportunity for the consent notice TASK-0052 already requires. The
screen opens keys-hidden, showing the question; disclosure sits behind a deliberate action carrying
the consequence in plain words. A student who passes through without opening a key burns nothing.

So teaching-first costs inventory only when a student actually asks to be taught — which is what this
decision intends, and is not what the current screen would do.

### Left open

Whether Open Hand should draw from a **reserved teaching pool** rather than the same published pool
practice scores from. That decouples teaching cost from the mastery ceiling entirely, at the price of
authoring or designating dedicated items. Not required now; recorded so it is not lost once real usage
shows how fast students actually disclose.

## DECISION-0086 — Open Hand Resolves to One Gated Path: Entitlement-Scoped Access With a Mandatory Exclusion Write, Unified on `get_open_hand_item`

**Date:** 2026-09-29
**Decision Owner:** David Bloom
**Status:** Approved (direction given in session, 2026-09-29)
**Approval:** `APPROVAL-0061`
**Related Task:** `docs/tasks/TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md`
**Related Docs:** `docs/product/OPEN_HAND_BRANCH_RESOLUTION_PLAN_2026_09_29.md`; `docs/product/PLATE_LOOP_BUILD_PLAN_2026_09_27.md` (on PR #256); `DECISION-0080` (the four gated aids count as pre-submission hint use)
**Area:** Open Hand / answer-key exposure / scoring integrity

_Numbering note: this entry took 0086 because `DECISION-0085` was, at the time of writing, claimed by the skill-dimension rollout on the then-unmerged PR #259. **#259 merged 2026-09-29 (`25c18e7c`)**, so 0085 is now on `main` and the sequence is correct with no renumbering needed._

### Context

Open Hand was built twice, independently, by agents that could not see each other's work — one
branch (`codex/task-0049-open-hand-answer-key`) was local-only until 2026-09-29. The two designs
disagreed on what the risk is. PR #256's `open-hand-item` serves the answer key and writes nothing,
reasoning that "practice/exam grading never calls this function." That is true of code paths but
does not address the **student**: nothing stopped a student reading item X's key and then being
scored on item X. The codex branch treated the student as the risk and added an exclusion table plus
a `409` refusal in `evaluate-attempt`. `DECISION-0080` — under which rubric, how-points, deep dive
and reference all count as pre-submission hint use — supports the codex framing, since Open Hand
exposes strictly more than those four aids.

### Decided

1. **D1 (c) — Access is entitlement-scoped, with a mandatory exclusion write.** Any authenticated
   user with an active entitlement for the item's subject may view, on a servable pack. Staff/QA
   roles may view and are **exempt from the exclusion write**. Chosen over the codex branch's
   session-scoped rule (which removes reviewer/QA access entirely) and over #256's entitlement rule
   (which leaves the gap open).
2. **D2 (a) — Unify on the RPC.** `open-hand-item` calls `public.get_open_hand_item` instead of
   reading `mcq_choices` / `frq_criteria` / `canonical_answer_spans` directly. The exclusion insert
   and the key read then happen in one statement, leaving no window in which a student has seen the
   key but no exclusion row exists. Rejected: bolting a separate write onto the edge function, which
   reintroduces that window and leaves two code paths to the same answer data to keep in sync.
3. **D3 — The work is TASK-0051.** TASK-0050 now belongs to the skill-dimension rollout.

### Consequences recorded at decision time

- The existing RPC implements D1 (a), not D1 (c); its access predicate must be rewritten and a
  view-only staff/QA bypass added.
- **`app.open_hand_scoring_exclusions.learning_session_id` is `NOT NULL`** (verified in Dev,
  2026-09-29). Entitlement-scoped callers may have no learning session, so this column must become
  nullable — otherwise D1 (c) collapses back into D1 (a) in practice.
- ~~`evaluate-attempt` cannot currently be deployed to either environment~~ — **withdrawn
  2026-09-29** after independent review (Fable) falsified it. The 200,000-byte limit belongs to the
  Supabase MCP `deploy_edge_function` tool, not the platform; `evaluate-attempt` was deployed to Dev
  and Production via the CLI on 2026-09-27 (Production v61; v66 today). There is no bundle blocker
  and nothing needs splitting. Deploy with the CLI and an explicit `--workdir`.
- The RPC, not the edge function, is the real security boundary: it is granted `execute` to
  `authenticated`, so students can call it directly through PostgREST. The entitlement predicate and
  the staff/QA exemption must therefore live in SQL, reading the role from `app.profiles`, and the
  exemption must never be a caller-supplied flag.
- `open-hand-item` is a **list** endpoint (up to 50 items) while the RPC is single-item. Looping the
  RPC across a listed page would permanently exclude ~20 items per screen load — enough to burn AP
  Biology's entire 43-item MCQ pool in two loads. The disclosure contract must be settled before
  implementation; TASK-0051 records the recommendation (list without keys, one RPC per item actually
  opened) and flags it as needing Product Owner confirmation because it changes a frontend contract.

### Severity, as established by the plan's Step 0

No student-facing exposure exists today. `open-hand-item` is deployed in Dev with **no caller**; the
Open Hand screens are demo-only components fed local sample content that make no network call; Dev's
exclusions table holds 0 rows; Production has no `open-hand-item`. The gap becomes real when the
plate loop is wired to live data, so **the exclusion mechanism must land in the same change as that
wiring**, not afterwards. This decision is a sequencing commitment, not an incident response.

## DECISION-0085 — Skill-Dimension Labels Are Validated by Model Consensus (≥2 of 3), Not Human Review; Frontier Proposer Pair Plus Blind Adjudicator

**Date:** 2026-09-29
**Decision Owner:** David Bloom
**Status:** Approved (direction given in session, 2026-09-29). One implementation route remains open — see "Not decided" below.
**Approval:** `APPROVAL-0060`
**Related Task:** `docs/tasks/TASK-0050-SKILL-DIMENSION-ROLLOUT.md`
**Related Docs:** `docs/product/SKILL_DIMENSION_ROLLOUT_PLAN_2026_09_29.md`; `docs/product/SKILL_DIMENSION_FEASIBILITY_2026_09_29.md`; `DECISION-0066` (two-model agreement sufficient for serving labels — this extends it), `DECISION-0074` (mastery rule), `DECISION-0079` (human promotion of topic labels)
**Area:** Content taxonomy / Labeling quality / Data schema

### Decided

1. **Model roster for Phase B labeling.** Proposers `openai/gpt-5.5` and `gemini-2.5-pro`; blind
   adjudicator `claude-opus-5`. The adjudicator must not be a proposer. `gemini-2.5-flash` is
   dropped: it is the small/fast tier, and the cost argument for it does not survive the measured
   volume — roughly 260k input tokens per model pass per subject, so a frontier two-model pass is
   under $10 per subject and under ~$100 for all ten.
2. **Proposer disagreements are broken by the blind adjudicator**, asked the same question with both
   candidate labels withheld. Its answer is the label. No human adjudication queue.
3. **`validated` is earned by model consensus: at least 2 of the 3 models agree.** No human review
   pass and no spot-check sample. This **extends `DECISION-0066`** — which already approved AI
   two-model agreement as sufficient to promote serving labels to `validated` — from serving labels
   to `skill_code` on `app.content_item_cells`, and adds a third model as tie-breaker. It does not
   disturb `DECISION-0079`, which was a one-time human promotion of 293 existing topic labels.
4. **No-majority items park as `held`** (proposers split and the adjudicator names a third label),
   excluded from serving and listed for a later pass. Not hypothetical: 88 of AP Statistics' 181
   items sit on topics with 3 or 4 registered skills.
5. **All three models run on every item**, not only on disagreements (~$5 extra per subject), and the
   agreement tier — unanimous vs majority-earned — is recorded on every row.

### Not decided (open, Hard Gate)

`app.content_item_cells_validation_check` requires `validated_by`, a uuid FK to `app.profiles`, and
Production has no system/service profile (17 tutor, 14 student, 2 admin, 1 reader — checked
2026-09-29). A model-consensus `validated` is therefore **rejected by the database today**. Two
routes, neither authorized by this decision and both requiring their own approval:

- **Relax the CHECK (recommended):** permit `validated` when `validated_by is null and model_run_id
  is not null and validation_decision_id is not null`. Preserves the audit trail; pretends nothing.
- **Mint a synthetic "system" profile (not recommended):** records a human-shaped actor for a
  decision no human made; every later audit joining `validated_by` to a person silently misleads.

Phase B is explicitly **not blocked** on this: labels sit at `provisional_model` with the consensus
outcome recorded in `model_run_id`, and promotion becomes a single later UPDATE.

### Evidence considered, and why it did not change the decision

This project's own paid measurement — the 2026-08-20 `gpt-5.2` full-corpus self-consistency run
(322 calls, $6.64; archived activity log) — found **majority-earned 2-of-3 cut false-accept rate
19.0 → 14.7, while unanimous 3-of-3 cut it to 9.5**. A 2-of-3 majority was meaningfully weaker than
unanimity, and on that task still failed its quality gate. That was hand-drawn graph grading, a task
with a far larger answer space than a 2–4 way skill choice, so it does not transfer directly. It was
raised before the decision and did not override it. It is the reason item 5 requires the agreement
tier to be recorded: if skill labels later prove unreliable, the remedy is a query demoting the
2-of-3 tier, not a re-run of all ten subjects.

## DECISION-0084 — TASK-0039 BYOQ Ships to Production (Phases 1–2) with Launch Defaults for the Eight "New Gaps"; Phase 3 Remains Blocked

**Date:** 2026-09-28
**Decision Owner:** David Bloom (direction); defaults chosen by Claude as implementation owner, flagged for confirmation
**Status:** Approved (production direction). **2026-09-28: David confirmed items 1–3, 7 and 8** (free/open access; 30 new questions per owner per day and 120 new anonymous users per IP per hour; 30-day anonymous retention; stuck-routing deferred; hints revised as below). Items 4–6 stand as shipped.
**Approval:** `APPROVAL-0058` — Product Owner direction, 2026-09-28: "Work through all phases unless blocked. The goal is to get task 0039 into production."
**Related Docs:** `docs/tasks/TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`; `DECISION-0057`, `DECISION-0068`, `DECISION-0070`, `DECISION-0071`, `DECISION-0076`, `DECISION-0077`; `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md`
**Area:** Product / BYOQ / Security / Data Lifecycle

_Numbering note: first recorded as DECISION-0083 on the TASK-0039 branch. `main` had already recorded its own DECISION-0083 (TASK-0041 payment flow), so this entry was renumbered to 0084 at merge time. The content is unchanged._

### Decision

TASK-0039's "New gaps" list required a Product Owner call before BYOQ reached real students. David's
direction to ship TASK-0039 to Production is treated as authority to ship with the following
conservative launch defaults. Each one is a starting position that can be changed without schema
rework, and none of them weakens `DECISION-0057`:

1. **Entitlement/trial gating — none.** BYOQ is free and ungated, consistent with `DECISION-0071`
   (launch free, no payment gating) and `DECISION-0070`/`DECISION-0077` (ungated/anonymous on the
   marketing site, recognized-but-not-gated in-app).
2. **Rate limits/quotas.** Anonymous owners: 120 per client IP per rolling hour (sized for a school
   NAT) plus a global circuit breaker of 5,000 per hour, failing closed when no client IP is
   available. Per owner: 30 new items per 24h and 200 live items in total, 200 saved response
   versions per item, 12 capture links per 10 minutes, and 6 open capture links at a time. Per capture
   link: 12 upload URLs, and 10 current pages per question/answer part. Stem ≤ 6,000 chars, choice
   ≤ 1,000, answer text ≤ 20,000, 2–6 MCQ choices, photos ≤ 20 MB (enforced at the storage bucket
   too). Page views create nothing; an owner is created only by the first saved question.
3. **Retention/deletion.** An anonymous owner inactive for 30 days is purged together with its
   items, responses, and photos by a scheduled job (every 15 minutes via pg_cron → `byoq` purge). Raw
   (unstripped) phone uploads that were never submitted are swept 5 minutes after their capture link
   closes. All child rows cascade from their item, and students can delete an item or a photo at any
   time. Full account deletion remains a pre-existing, product-wide gap, not a BYOQ one.
4. **Consent copy.** The phone capture screen carries the privacy notice: no names, schools, or other
   people's work, and location data is removed. The homepage section states the 30-day anonymous
   retention. Only metadata-stripped images are stored, and the upload fails closed when stripping is
   incomplete.
5. **Private-until-promoted boundary.** BYOQ items are private to their owner. No public, SEO, or AEO
   path may read `app.byoq_items` without a moderation/content-review step first; this is recorded in
   the table comment.
6. **Subject/taxonomy scoping.** Subjects and topics come from the live `app.taxonomy_*` tables for
   all ten subjects (hyphen/underscore normalized). Enrollment is not used to filter, because BYOQ is
   ungated. When a topic has no published guide, the response says so explicitly
   (`reference.missing = true`) instead of rendering nothing.
7. **Stuck-BYOQ routing — deferred.** The practice screen links to the student's chosen topic reference
   only. The "recommend a related Open Hand item, then return" flow named in `DECISION-0057` is
   explicitly deferred to a follow-up.
8. **Hints/deep-dive floor — reference only.** BYOQ shows CramApple-authored topic guides (point briefs
   and explainers) and no rubric-derived hints, as a deliberate v1 scope choice. The "distinct,
   smaller" hint contract remains future work.
   **Revised 2026-09-28 (David):** the reference now appears as up to four topic-level hints, revealed one per click from the topic's published point brief: what this is testing, how points are earned, the answer move, and where students lose points. The full guide stays available. The hints are never specific to the student's question, reveal state stays in the browser, and hint use is not recorded or counted toward mastery.

**Build locus.** BYOQ is built in the App Lovable project (`app.cramapple.com/byoq`). The marketing
site (`cramapple.com`) carries only a homepage section that links into the app, so there is one
implementation and no duplicate flow.

**Phase 3 (worksheet upload)** is not shipped. It remains blocked on
`BYOQ_WORKSHEET_PARSING_DESIGN.md`'s open decisions: parsing vendor, candidate cap, and retention
window.

## DECISION-0083 — Begin TASK-0041 Payment Flow Implementation Now, in Advance of the October 2 Free Launch; Launch Shape Itself Unchanged

**Date:** 2026-09-28
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, in-session, 2026-09-28
**Related Docs:** `docs/tasks/TASK-0041-LAUNCH-PAYMENT-FLOW.md`;
`docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`; `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`;
`LAUNCH_RUNBOOK_2026_10_02.md`; `DECISION-0071`
**Area:** Launch Readiness / Payments

### Decision

TASK-0041 (the purchase funnel / payment flow) starts implementation now, ahead of the October 2 free
launch, instead of waiting until after launch. This moves the build timeline earlier; it does not
reverse `DECISION-0071`. The October 2 launch itself remains free with no Stripe/payment gating —
nothing about the free-launch shape, the flat-path Day-1 subjects, or the no-payment-gating rule
changes. What changes is that engineering work on TASK-0041 (Stripe checkout, parent-pay, promo
codes, post-purchase add-on, per `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` §5) is active now rather
than deferred to a post-launch follow-up, so it can be closer to ready when payment gating is later
turned on. Every Hard-Gate boundary in that plan and in TASK-0041 itself still applies unchanged:
live Stripe catalog/config writes, live-mode secret changes, Production migrations/deployment, and
enabling paid sales all still require separate, explicit Product Owner approval. Nothing here
authorizes turning on payment gating for October 2 or moves that date.

Approved paid pricing is **$39.99** for one subject, **$69.99** for two subjects, and **$89.99** for three subjects. These values supersede `DECISION-0069`; unlimited remains deferred unless separately decided.

## DECISION-0082 — No Fixed Quantity Targets Outside AP Biology; Maximize Safe Student Usability of Current Published Inventory

**Date:** 2026-09-27
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-27 (TASK-0042 closeout)
**Related Docs:** `CONTENT_QUANTITY_AND_DISTRIBUTION.md`;
`LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md`; `TASK-0042-LAUNCH-CONTENT-PIPELINE.md`
**Area:** Content / Quantity / Launch Readiness

### Decision

The nine non-Biology subjects do not receive fixed inventory-count targets. AP Biology's approved
600 MCQ / 300 short-FRQ / 64 long-FRQ planning targets remain Biology-only. For every other subject,
the operating objective is to make as many currently published questions safely usable by students
as the evidence supports. This does not weaken content, freshness, rubric, or DECISION-0066 gates:
items that fail or disagree in independent review remain unpromoted rather than being counted toward
an invented quota.

### TASK-0042 application

David separately approved sending 141 current multi-unit question packets, including stems, answers,
and rubrics, through Vercel AI Gateway to `anthropic/claude-haiku-4-5` for blind third review.
Twenty-seven exact full-label matches were promoted; 66 unit/primary disagreements and 48 rubric or
scope holds remained unpromoted. The absence of a quota is not permission to lower that bar.

## DECISION-0081 — Lean Source-of-Truth Startup Mode: Tier-First Session-Start Reading, `AGENTS.md`, Log `INDEX_END` Markers

**Date:** 2026-09-27
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-27 (this session); see `APPROVAL-0055`
**Related Docs:** `prompts/CODEX_NEW_SESSION_PROMPT.md`, `prompts/CLAUDE_NEW_SESSION_PROMPT.md`,
`docs/team_charter/CRAMAPPLE_SESSION_START.md`, `AGENTS.md` (new), `docs/activity_log/ACTIVITY_LOG.md`,
`APPROVALS_LOG.md`, `DECISIONS_LOG.md` (this file)
**Area:** Operating Policy / Session Startup

### Context

Codex session-start cost had grown large enough to consume most of a session's usage budget before
any task work began. Diagnosis (independently corroborated by Codex and Claude): the entry-point
prompt `CODEX_NEW_SESSION_PROMPT.md` hardcoded an unconditional read of 11 governance/log/product
docs (~3,200 lines) for every task regardless of size, and its "(Index section)" instruction for the
three activity/approval/decision logs had no enforceable stopping point, so a normal read pulled each
full log (400-900+ lines) instead of its ~30-130 line index. This directly contradicted
`CRAMAPPLE_SESSION_START.md`'s own existing guidance ("Read only the documents needed for a clearly
bounded task. The broad orientation list is a fallback, not mandatory ceremony for every Micro
task.") — the entry-point prompt was stricter than the protocol it was supposed to invoke.

### Decision

Adopt a tier-first startup protocol ("Lean Source-of-Truth Mode") for both Codex and Claude new
sessions:

- Classify the task's Tier (Micro / Standard / Hard-Gate) before choosing a reading set, using the
  existing Task Tiers definition in `AGENT_OPERATING_MODEL.md` as the sole test — the startup
  prompts do not redefine tier criteria themselves, to avoid two definitions drifting apart.
- Micro tasks read only `CRAMAPPLE_SESSION_START.md` and the named task record by default; the full
  11-doc stack is reserved for Standard/Hard-Gate or genuinely unclear-scope work.
- The three activity/approval/decision logs now carry an explicit `<!-- INDEX_END -->` marker after
  their Index section (added to `ACTIVITY_LOG.md`, `APPROVALS_LOG.md`, `DECISIONS_LOG.md` in this
  change). Startup reading stops at that marker and searches by exact ID/date/keyword before ever
  reading a full log; an empty targeted search must be reported as such, not treated as proof the
  record doesn't exist.
- A new root `AGENTS.md` sets repo-wide search discipline (no broad scans of `docs/research`,
  `docs/teaching`, `prompts`, `tmp`, `output`, worktree/dependency directories, generated output, raw
  logs, or image/PDF corpora; targeted search and capped output everywhere else).
- `prompts/CODEX_NEW_SESSION_PROMPT.md` and `prompts/CLAUDE_NEW_SESSION_PROMPT.md` were rewritten in
  parallel to this rule set (each keeping its own tool-specific tail — Claude's operating-model/
  model-effort section, Codex's explicit do-not-implement-past-approval language).
- An escalation from a lower tier to a higher one changes required approvals and status path (per
  `TASK_WORKFLOW.md`), not just the reading list — both must be applied together.
- This is an operating-policy change to how every future session bootstraps; it does not change
  authority order, approval lanes, or any hard gate.

### Not resolved by this decision

- Repo-size hygiene (large tracked PDFs, raw `.jsonl` model-call logs, generated SQL under
  `scripts/*/out`) is a real, separate finding and is explicitly deferred to its own task — it was not
  bundled with this change.
- The pre-existing debt of both `APPROVALS_LOG.md`'s and `DECISIONS_LOG.md`'s Index sections already
  exceeding their own "~10 entries" rotation target is unchanged by this decision.

## DECISION-0080 — `DECISION-0074` Addendum: Hint-Definition Boundary for Mastery

**Date:** 2026-09-27
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-27 (this session)
**Related Docs:** `docs/product/STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md` (Open Decision #1, the
hard gate this resolves); `DECISION-0074` (the mastery rule this addends); `.lovable/plan/gate-the-four-aids-in-practice-findings-and-plan-2026-09-27.md`
(same-day Lovable investigation this decision is grounded in — real code, not the schema plan's
candidate-event list)
**Area:** Product / Mastery / Schema

### Context

`DECISION-0074` requires "no hint use prior to submission" for mastery, but left "which in-attempt
events count as hint use" undefined — the schema plan's Phase 1 items 1-2 (hint-tracking table +
mastery counters) were hard-gated on this answer, because the plan's own reasoning holds: logging an
event now that's later ruled non-disqualifying is a cheap recompute; *not* logging one now that's later
ruled disqualifying is unrecoverable history.

David's answer: **"there are four hints in the architecture. clicking on any of them is recorded in the
schema. if that action happens before scoring, it counts against mastery."** Verified against the live
codebase (`56cae479`) before recording, rather than taken as an abstract answer: the four gated aids
that actually exist, per `HintGate.jsx`'s call sites, are **Rubric/criteria preview, "How points are
earned/lost," Deep Dive, and Reference Materials** (there is also a fifth, MCQ-only bonus gate,
Elimination — not one of "the four," left as a bonus/aside per the same architecture). All four are
built and gated in the **plate Practice templates** (`/practice-mcq`, `/practice-frq`) via `HintGate`/
`DeepDiveGate`; none of the four exist yet on the route a real student actually reaches by default
(bare `/session` → `SessionFrame.tsx`, which has exactly one pre-submit aid, "I need help," ungated by
`HintGate` at all).

**This gap was surfaced and put to David directly rather than silently building the schema against an
architecture real students can't reach:** asked whether to (a) build the schema for all four and treat
`SessionFrame` rebuild as a prerequisite, or (b) build for what's live today (one aid) and extend later.
**Answer: (a), all four — rebuild `SessionFrame` to match.**

### Decision

1. **Hint-definition boundary (unblocks schema plan Phase 1 items 1-2):** an in-attempt event counts
   as disqualifying "hint use before submission" under `DECISION-0074` if and only if the student opens
   one of the four gated aids — **Rubric/criteria preview, Points-earned/lost, Deep Dive, or Reference
   Materials** — before the attempt is scored. (Elimination, the MCQ-only bonus gate, is out of scope
   of "the four" as David named them; whether it also disqualifies is not decided here and should not
   be assumed either way until asked.) Opening any one of the four sets `pre_submit_hint_count > 0` for
   that attempt regardless of how many total opens occur, per the schema plan's Phase 1 item 1 design
   (`app.attempt_assistance_events`, one row per open event, rolled up via
   `app.assistance_event_policy.disqualifies_mastery`).
2. **Live-path scope (new, not in the schema plan):** the four-hint model only exists in the unlinked
   plate templates today. David approved **Workstream B1** of the "gate the four aids" plan — split
   `SessionFrame`'s single "I need help" link into four separate `HintGate`s (Rubric preview, Points,
   Reference, Deep Dive) on the live default path — as the way to make this decision enforceable for
   real students, not just plate-template demo traffic. **Workstream B2** (replace `SessionFrame`'s
   question UI wholesale with the plate templates) is explicitly **not** approved — the investigating
   plan itself recommends against it as a follow-on edit, given the scope (react-router-dom hooks,
   `SessionProvider` state, confirm-transfer/repair/recheck/skill-rail carry-over).

### Not resolved by this decision — real blockers to B1, not yet executed

- **Data source gap, flagged by the same investigation, not newly found here:** a rubric-preview gate
  needs a student-safe rubric source for served items, which doesn't exist today (`PracticeFrqScreen`
  already notes this for its own unlinked route). Reference Materials and Deep Dive content likewise
  have no data source on served items yet — only the plate templates' local sample content has it.
  **B1 cannot show real content in three of its four gates until this content/data gap is closed
  separately** — gating an empty pane is not the same as gating real content, and shipping empty gates
  to real students needs its own explicit go-ahead, not an assumption bundled into this decision.
- **Server-side "coached" propagation** for the plate templates' live routes (`LivePracticeMcq`/
  `LivePracticeFrq`) is itself unconfirmed — today they only pass `hintsUsed` into the client-side
  result receipt, not to the grading server. Workstream A of the same plan (unrelated to B1, smaller/
  lower-risk) already flags this as a "stop and report" item if the grade endpoint has no such field.
- **This decision does not itself build anything.** It resolves the open policy question the schema
  plan needed and approves B1's scope; implementing `attempt_assistance_events`, the four `HintGate`
  splits in `SessionFrame`, and the content/data-source work above are separate, still-unexecuted
  engineering tasks.

## DECISION-0079 — Promote All 293 `provisional_model` Topic Labels to `validated`

**Date:** 2026-09-27
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-27 (this session)
**Related Docs:** `docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` (carried-forward item #1, taxonomy
rationalization close-out); `docs/product/CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md`;
`DECISION-0067` (the prior, unrelated coverage-label deferral — not reversed by this decision, see below)
**Area:** Content / Taxonomy

### Context

`CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md` Phase 1/3 landed 112 AP Biology topic-only cells
and 181 new AP Statistics topic labels as `assignment_status = 'provisional_model'` — deliberately not
`validated`, per that plan's own decision to keep AI-derived serving labels out of student-facing
surfaces until promoted. `app.content_item_topic_resolution`'s `SAFETY-CRITICAL FILTER` (migration
`20260927004700`) only exposes `assignment_status IN ('validated', 'authored')`, so all 293 rows were
invisible to `student-session-items` and everything downstream of it (breadcrumb, habits pair,
reference pane, deep dive, progress, study map) despite existing in `content_item_cells`.

### Decision

**Promote all 293 rows from `provisional_model` to `validated`.** Applied directly to Production
(`pcntajvbdfqhbeewmdry`): `validated_by` = David Bloom's `auth.users.id`, `validated_at` = time of
write, `validation_decision_id` = a single generated UUID (`5cbbd490-3c47-4715-badc-fc417e763077`)
shared across all 293 rows, this decision being their validation record. Verified post-write:
`content_item_cells` now shows 0 `provisional_model` rows (203 `authored` + 293 `validated`);
`content_item_topic_resolution` row count went from 203 to 496, exactly matching. `get_advisors`
(security) run immediately after showed no new findings attributable to this change — all findings
present were pre-existing (RLS-enabled-no-policy on unrelated tables, etc.).

### Not resolved by this decision

- **This does not itself close GAP-9.** No FRQ in either subject carries a topic/skill cell label at
  all (a separate, unstarted labeling gap), and AP Biology's `app.taxonomy_cells` "legal topic × skill
  grid" is still empty (0 rows; every subject except AP Statistics is empty) — that grid needs to be
  authored from curriculum judgment, not derived from this promotion. GAP-9 remains 0 masterable cells
  in both subjects until both of those are addressed.
- **Does not touch or reverse `DECISION-0067`** (coverage labels / `assessed_topics`, a different
  label type measured at only 44% two-model agreement) — that deferral stands untouched. This decision
  is about **serving/topic labels** specifically, which `DECISION-0066` already approved promoting on
  a materially stronger 89% agreement basis.
- Whether the underlying AI-derived labels are individually correct was not re-audited here — this
  decision executes the promotion David approved, it does not re-run the labeling QA.

## DECISION-0078 — Ratify Three Session-Start Bootstrap Edits (Live Front-Ends, Required First-Read, Anti-Stale Rule)

**Date:** 2026-09-27
**Decision Owner:** David Bloom
**Status:** Approved (see `APPROVAL-0054`)
**Related Docs:** `docs/team_charter/CRAMAPPLE_SESSION_START.md` (the governed bootstrap, APPROVAL-0047 /
DECISION-0054); `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`; `docs/INDEX.md`; PR #232
**Area:** Governance / Operating Policy

### Context

The 2026-09-27 documentation cleanup found that the session-start bootstrap could still route sessions
to outdated material: its Repository Map named `exam-buddy-wireframe` as the "current front-end," the
new canonical one-pager + INDEX were only in the optional fallback list, and there was no explicit rule
to distrust superseded docs or stale memory. Three edits were made and merged (PR #232), flagged pending
ratification because the bootstrap is a governed operating-policy document.

### Decision

The three edits are **ratified and kept** (they change routing/guidance, not authority order or gates):

1. **Repository Map corrected** — names the live Lovable front-ends **`56cae479`** (app, `app.cramapple.com`)
   and **`61dd6602`** (marketing, `cramapple.com`), notes front-end commits live in Lovable (not this
   repo) and must be re-confirmed against live DNS, and demotes `exam-buddy-wireframe` to a
   reviewer-portal holdover (rebuild §10).
2. **Required first-read** — for architecture / design / front-end / session-mode / launch work,
   `ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` + `docs/INDEX.md` must be read first, not left to the
   optional fallback list.
3. **Anti-stale rule** — treat `STATUS: SUPERSEDED`/`HISTORICAL` docs as non-current; assume memory and
   prior-chat context may be stale on design/mode/frame/frontend; verify against the one-pager, which
   governs on conflict.

Builds on `DECISION-0075` (which ratified the earlier one-pager/INDEX pointers in the same bootstrap).

## DECISION-0077 — BYOQ Is Identity-Agnostic; `byoq_items.user_id` Not Required; Resolves DECISION-0070 ⟷ DECISION-0068

**Date:** 2026-09-27
**Decision Owner:** David Bloom
**Status:** Approved (see `APPROVAL-0053`)
**Related Docs:** `docs/tasks/TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md`;
`docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` (O16 → resolved); `DECISION-0070`;
`DECISION-0068`; `DECISION-0057`
**Area:** Backend / Schema / Product

### Context

The BYOQ session (acting on the 2026-09-27 doc-cleanup broadcast) surfaced a real conflict between two
approved decisions: `DECISION-0070` (2026-09-26) says BYOQ ships "ungated, as an anonymous session" on
the new home page — no sign-in — while `DECISION-0068`'s approved Option A schema makes
`app.byoq_items.user_id` a `NOT NULL` FK to `app.profiles` with RLS keyed to `auth.uid()`, which an
anonymous visitor cannot satisfy. It also raised whether BYOQ ships on the marketing site or the
authenticated app. Surfaced to David rather than self-resolved (per standing rule); this task already
carried the same flag (TASK-0039 lines ~199–216).

### Decision

**BYOQ is identity-agnostic.** David, 2026-09-27: "There is never a need for a specific BYOQ. If a
student uses it on the marketing page they do so without registering. If they are registered and use it
inside the app they are recognized, but that doesn't affect their use of BYOQ either way." Concretely:

- **`app.byoq_items.user_id` is NOT required** — nullable; when present (signed-in in-app user) it is
  recognition metadata, not a gate. This **amends** the Option A schema approved under `DECISION-0068`;
  the parallel-tables architecture is otherwise unchanged.
- **BYOQ runs on both surfaces with identical behavior** — anonymous on the marketing home page
  (`cramapple.com` / `61dd6602`), recognized in the app (`app.cramapple.com` / `56cae479`).
- Implementation defines how anonymous items are scoped/secured without `auth.uid()` (e.g. a durable
  session/device token) and preserves BYOQ's invariants (Practice-only, never Open Hand, no canonical
  answer/rubric — `DECISION-0057`). That scoping is build work under TASK-0039, not a further PO decision.

`DECISION-0070` stands; `DECISION-0068`'s user-authentication assumption is the part that gives.

## DECISION-0076 — TASK-0039 BYOQ Phase Priority Corrected: Camera/Phone Capture Is Launch-Required, Not Typed Intake; Ownership Confirmed as Claude, Not Codex

**Date:** 2026-09-27
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-27 (this session)
**Related Docs:** `docs/tasks/TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md` ("Correction" section); `DECISION-0075`;
`docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` (D9); `docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`
("BYOQ is phone capture to start. Document upload post launch"); `DECISION-0068`/`APPROVAL-0050`
**Area:** Product / Governance / BYOQ

### Context

`TASK-0039` was drafted 2026-09-25 and its Phase 1 (typed/pasted intake, camera capture deferred to
Phase 2) approved 2026-09-26 (`DECISION-0068`/`APPROVAL-0050`), without knowledge of a same-day decision
recorded elsewhere in a concurrent session's launch-planning work: "BYOQ is phone capture to start.
Document upload post launch," which also named BYOQ's build as Codex's workstream. A separate
concurrent session's documentation cleanup ratified `DECISION-0075` on 2026-09-27, surfacing this
conflict directly to the session executing `TASK-0039`. That session verified the conflict against the
primary source (not just the one-pager summary) and stopped rather than self-resolve it, per this
project's standing rule to notify the Product Owner on exactly this kind of cross-session contradiction.

### Decision

**Camera/phone capture is BYOQ's primary, launch-required intake method — not typed/pasted text.**
David's direction: "phase 1 is phone, not text BYOQ." What `TASK-0039` originally labeled "Phase 2" (QR
photo capture) is launch-required and ships no later than the data model and Practice screen; what it
labeled "Phase 1" (typed/pasted intake) is a fallback input, not the primary or first-shipped path.

**Ownership confirmed: Claude, not Codex.** David's direction: "Claude is taking over BYOQ while Codex
works on content pipeline." This supersedes the earlier direction recorded in
`LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` that BYOQ's build was Codex's workstream.

**Unaffected by this decision:** the data-model architecture (Option A, parallel `byoq_*` tables) and
Phase 1's schema/screen scope approved under `DECISION-0068`/`APPROVAL-0050` — this decision reorders
priority and confirms ownership, it does not reopen that approval. `TASK-0039`'s Phase 3 (worksheet
upload, post-launch) was already correctly scoped and is unaffected.

### Not decided by this entry

Whether BYOQ ships **ungated, as an anonymous session** (`DECISION-0070`, 2026-09-26: "BYOQ ships on the
new home page, ungated, as an anonymous session... A visitor does not need to sign in or purchase")
is a separate, more severe conflict this same review pass found, structurally at odds with the
approved Option A schema (owner-scoped RLS keyed to an authenticated `auth.uid()`/`app.profiles.user_id`
— an anonymous visitor has neither). **Not resolved here** — see the same-day Activity Log entry for
this finding, reported to David rather than self-resolved.

## DECISION-0075 — Ratify the Current Architecture/Design One-Pager as Canonical; Adopt STATUS Headers + INDEX; Legacy = Annotate-in-Place

**Date:** 2026-09-27
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, this session (2026-09-27 doc-cleanup)
**Related Docs:** `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` (the ratified one-pager);
`docs/INDEX.md`; `docs/proposals/LEGACY_DOCS_ARCHIVE_PROPOSAL_2026_09_27.md`;
`docs/activity_log/ACTIVITY_LOG.md` (2026-09-27 doc-cleanup entry)
**Area:** Documentation / Information Architecture

### Context

The most load-bearing architecture/design plan (`APP_REBUILD_MIGRATION_PLAN.md`) carried no Task ID,
owner, or DECISION number; its §11 "open decisions" were largely resolved 2026-09-26 without in-place
updates; and design/vocabulary/palette drift (fixed-plate rule, Course Mode, "Project-Crux" red) was
actively misleading readers. A docs-only cleanup produced a single decided-vs-open one-pager and a
discoverability layer, verified against live systems.

### Decision

1. **`docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` is ratified** as the canonical entry
   point for the app's current architecture and design. Where an older design/architecture doc conflicts
   with it, the one-pager wins (it cites a source of record for every DECIDED row). **Owner: David Bloom.**
2. **Adopt the `STATUS:` header convention** (`CURRENT | SUPERSEDED by <doc> (<date>) | HISTORICAL`) and
   `docs/INDEX.md` as the canonical source-of-truth-per-topic map.
3. **The discoverability pointers added to the governed `docs/team_charter/CRAMAPPLE_SESSION_START.md`
   are ratified and kept** (they added references only, no policy change).
4. **Legacy docs: Option A — annotate-in-place, no physical move.** Superseded docs stay where they are,
   carry supersession banners, and are listed in `docs/INDEX.md`. No `docs/legacy/` tree is created at
   this time (see the proposal for Options B/C if revisited later).

### Notes

Docs-only; no product/design decision was created or reversed by this ratification — it records and
organizes decisions already made. Next free decision number after this is DECISION-0076.

## DECISION-0074 — Mastery Rule Tightened: 2 Correct MCQ + 1 Full-Point FRQ, No Hint Use Prior to Submission

**Date:** 2026-09-27
**Decision Owner:** David Bloom
**Status:** Approved; unbuilt
**Approval:** Product Owner direction, this session
**Related Docs:** `docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` (#20, originally recorded
2026-09-26); `docs/product/CONTENT_GAPS_RUNNING_LIST.md` (GAP-9, new); memory
`project_launch_plan_six_section_audit_2026_09_26.md` (Finding 3, mastery schema gap)
**Area:** Learning Design / Grading

### Context

The 2026-09-26 launch-plan audit flagged mastery derivation as specified but unbuilt, and found
that `app.student_cell_state`'s actual columns (`weighted_evidence`, `tier`, `fragile`, `last_event`,
`last_weight`) don't support the original rule ("2 full-point answers, with hint; hints before
submission don't disqualify") as a discrete, auditable count. When asked to reconsider the rule with
that gap in mind, David proposed tightening it instead of just re-scoping the same rule against the
existing schema.

### Decision

**Supersedes the mastery-derivation rule recorded under `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` #20.**
A skill/cell reaches mastery once the student has produced:

- **2 correct MCQ answers**, and
- **1 full-point (fully correct) FRQ answer**,

on that cell, where **none of those three answers used a hint before submission**. A hint viewed
*after* submission/scoring (post-hoc explanation or reveal) never affects mastery, on any answer,
including the three that count toward it — this half of the original rule is unchanged.

This is a stricter bar than the 2026-09-26 version in two ways: it requires a specific item-type mix
(2 MCQ + 1 FRQ, not "any 2 full-point answers"), and it removes the prior allowance for a
before-submission hint on a qualifying answer.

### New dependency this creates: GAP-9

Under this rule, a cell with no servable FRQ (or no servable MCQ) can never reach mastery — not "reach
it slower," genuinely blocked. Tracked as `GAP-9` in `CONTENT_GAPS_RUNNING_LIST.md`. David accepted
this as a temporary gap, explicitly to be closed by content authoring, not by relaxing the rule — see
that gap entry for scope and status.

### Still unbuilt — same schema gap, now sharper

`app.student_cell_state` still has no discrete counter for "correct-without-pre-submission-hint,
by item type." Building this rule requires, at minimum: recording hint-use timing (before vs. after
submission) per answer, and item-type (MCQ vs. FRQ) per counted answer — neither exists today. Needs
its own scoping pass before implementation, per the same caution the original #20 entry recorded.

### Revisit condition

Revisit if GAP-9's cell-level MCQ+FRQ coverage turns out to be worse than expected once measured
(the six-section audit did not measure it — only flagged the risk), or if the schema-scoping pass
finds the hint-timing/item-type tracking meaningfully more expensive to build than anticipated.

## DECISION-0073 — Launch Frontend Target: ap-prep-canvas.lovable.app

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved, with an unresolved verification gap (see below)
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` (decision D-2);
`docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`
**Area:** Product / Frontend / Launch Scope

### Decision

David identified the launch frontend as the Lovable app published at
**`https://ap-prep-canvas.lovable.app/`**, resolving decision D-2 (which frontend is the actual launch
target — the `web/` Vite rebuild in this repo, or a Lovable app). It is neither of the two candidates
this session had previously framed as the choice — it's a third option, a Lovable project.

### CORRECTED, 2026-09-26 (same session): verification gap closed, wrong project originally guessed

This session's first guess ("New Cramapple App," `56cae479-...`) was **wrong**. David provided the live
HTML from `ap-prep-canvas.lovable.app` directly. It embeds `<meta property="og:image" content="https://pub-bb2e103a32db4e198524a2e9ed8f35b4.r2.dev/.../id-preview-be1cdb15--d334fed9-5a97-4e76-906e-7c0ad7082212.lovable.app-....png">`
— Lovable auto-generates a page's social-preview meta from its own project screenshot, so this embedded
project ID is strong evidence of which project actually serves that page.

**The launch frontend is the "Remix of Cramapple App" Lovable project**
(id `d334fed9-5a97-4e76-906e-7c0ad7082212`, created 2026-07-09, tech stack TanStack Start — confirmed
independently by the live HTML's own `$_TSR`/TanStack Router hydration markers, matching this project's
stored description exactly).

**The branding-mismatch finding was half right, for the wrong reason.** This session's `get_project`
screenshot read for this exact project is genuinely stale (still shows the old blue/red "cramapple"
wordmark) — but the *live* HTML David sent shows the page is fully current: it imports
`docs/new_design/tokens/*.css` verbatim (the page's inline `<style>` block literally comments "CramApple
design tokens — generated from github.com/david-bloom/Cramapple docs/new_design/tokens/*.css"), uses
the Bungee/Passion One/Source Sans 3/STIX Two Math font stack, and renders the orange masthead
correctly. **The live site already matches the new design system in full — there is no branding gap.**
Lovable's cached screenshot is simply out of date; don't trust `get_project` screenshots as current-state
evidence for this project going forward, only the live HTML/URL.

**New finding from the live HTML, not previously known: the page still shows a $39.99 purchase CTA and
a full Stripe-style pricing section ("Get it · $39.99", "Get AP Statistics" buy button, tutor-cost
comparison).** This is stale against `DECISION-0071` (Friday launches free, no Stripe/payment gating).
Someone needs to swap this for a free-access/sign-up CTA before Friday — tracked in the marketing
home page plan now.

**Also confirmed from the live HTML, consistent with existing decisions:** AP Statistics and AP Biology
show "Live now"; the other 8 subjects show "Coming soon" (matches `DECISION-0069`'s Day-1 subject list).
A full anonymous, ungated BYOQ flow is present ("Upload a photo" / "Paste the text", "One free question.
Your photo isn't kept.") — matches `DECISION-0070`.

### Consequences

- `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` and `LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md` should
  both point at "Remix of Cramapple App" (`d334fed9-5a97-4e76-906e-7c0ad7082212`), not the previously
  guessed project.
- No visual/brand rebuild is needed — remove that item from the student hub plan's scope.
- **New launch-blocking task for Friday:** replace the $39.99/Stripe purchase CTA and pricing section
  with a free-access sign-up flow, per `DECISION-0071`. (Update: David is handling this directly with a
  "Free this week!" banner rather than a full CTA rework — not delegated to an agent.)
- Lesson for future verification: prefer live HTML/fetch over Lovable `get_project` screenshots, which
  can be meaningfully stale.

### VERIFIED, 2026-09-26 (same session): practice/grading is real, not a demo

David asked whether the practice/grading flow visible on the live page is genuinely wired to production
grading or just a scripted demo — this was never actually checked earlier despite being listed as an
open research item. Verified directly by reading this project's source via the Lovable MCP:

- `src/components/marketing/FrqDemo.tsx` (the "Open Hand · FRQ" plate on the home page hero) **is a
  scripted marketing demo** — 4 hardcoded example Q&As with pre-written grading payloads baked into the
  component source, cycled via `setTimeout` state transitions (typing → submitting → graded). No API
  call. This is expected and appropriate for a marketing teaser, not a defect.
- `src/lib/use-grade-practice.ts` (the real practice-session grading hook, used by
  `src/components/session/SessionFrame.tsx` and `GradeResultView.tsx`) **is genuinely wired to
  production**: it calls `supabase.functions.invoke()` against the real, named edge functions
  documented elsewhere in this repo — `session-event`, `attempt-response` (create/save/submit
  operations), `evaluate-attempt`. The file's own header comment: "Uses the four already-deployed edge
  functions... No legacy beta-attempt path is involved." This is the same grading infrastructure
  covered by TASK-0016's rollout, not a separate or mocked path.
- This also independently confirms the earlier-flagged entitlement-gating bug (`DECISION-0069`'s
  follow-up, `ACTIVITY_LOG.md` 2026-09-20) is real and lives in exactly this code path — the generic
  error string "Couldn't score that — try again." in `use-grade-practice.ts`'s `runEvaluate` matches
  the bug report precisely.

**Verdict: the student hub / practice & grading engine is not a separate long-build item for Friday —
it already exists and is production-wired.** The main open risk for Friday is the entitlement-gating bug
above, not the existence of real grading.

## DECISION-0072 — AP Statistics Launches on the Flat Practice Path, Unit-Gating Deferred

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `DECISION-0063` (the original Biology-only version of this decision);
`docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` (decision D-3);
`docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`;
`docs/content/CODEX_QA_REPORT_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`
**Area:** Product / Serving

### Decision

**`DECISION-0063` (AP Biology launches on the practice path, not the unit-gated path) is extended to
AP Statistics.** Statistics launches Friday on its flat/practice serving path; its unit-gated path
(organized by curriculum unit) is deferred, same as Biology.

### Context

Statistics is the one subject with real evidence of multi-unit unit-gated content (64 validated
serving labels on its old/general exam pack, 27 items confirmed live via
`select_unit_gated_practice_items`, spanning units 1 through 5 per the 2026-09-25 audit). Unlike
Biology, Statistics *could* plausibly launch with a working unit-gated experience. David chose the flat
path anyway, for consistency with Biology and to keep both Day-1 subjects on the same, simpler,
lower-risk serving mechanism for Friday.

### Consequences

- `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`'s open question ("does DECISION-0063 extend to
  Statistics?") is resolved — yes.
- Statistics' criteria 3/5 (validated labels, difficulty) are **not launch-blocking for Friday**, same
  as they aren't for Biology — they matter for whenever unit-gated practice is turned on, not for the
  flat-path launch.
- `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md`'s testing criterion (currently "test against AP Biology, FRQ
  path") should be read as covering both Day-1 subjects on their flat paths, not Biology alone.
- Index decision **D-3** is resolved for both Day-1 subjects.

## DECISION-0071 — Launch Friday, Free — No Stripe/Payment Gating at Launch

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`; `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md`;
`DECISION-0069`; `DECISION-0070`
**Area:** Product / Launch Scope / Commercial

### Decision

**Cramapple launches Friday, October 2, 2026, free, with no Stripe/payment gating.** David confirmed
the exact date on 2026-09-26, correcting the earlier invalid `2026-09-27` placeholder. All students
get full access without purchasing. Payment flow (Stripe checkout, entitlement gating) is deferred to
a post-launch follow-up, once there's time to add it properly — not a Day-1 requirement.

This supersedes `DECISION-0070`'s "target launch window is next week" with a firmer date and a
materially different launch shape: **not a paid launch with a payment system, but a free launch with
payment added later.**

### Consequences

- `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` is **removed from the Friday launch-critical path.** None of
  its acceptance criteria block Friday's launch. It becomes a fast-follow plan, run whenever there's
  time to build it properly, per this decision.
- The entitlement-gating bug flagged under `DECISION-0069`'s follow-up (`attempt-response` not gated on
  entitlement) becomes **moot for Friday specifically** — if nothing is paywalled, an ungated attempt
  path isn't a defect at launch. It still needs a real answer for whenever payment flow ships, so don't
  delete it from tracking, just reclassify its urgency.
- BIZ-001's remaining items (access duration, refunds, parent-purchaser handling) are **not needed for
  Friday** — they matter once payment flow actually ships. Do not treat them as launch blockers this
  week.
- The marketing home page's pricing/CTA section changes meaning: it can't send a visitor to checkout
  (nothing to check out into yet) — it needs a "free access" / sign-up CTA instead of a
  purchase CTA for Friday, with pricing/purchase copy added back in whenever payment flow ships.
- Removes urgency from D-6 (2-bundle pricing anomaly), D-9 (promo code), D-10 (dev subject seeding for
  Stripe testing), and D-11 (BIZ-001 remainder) for Friday's launch specifically — they remain open,
  just not this week's problem.

### What actually gates October 2

With payment removed, the October 2 critical path is: the live marketing/free-access entry, the
student hub and brand-new-student entitlement/grading round trip, Biology and Statistics on their
approved flat practice paths, anonymous BYOQ safety/copy verification, fresh independent QA, and
David's final go/no-go decision. D-1/D-2 are resolved by `DECISION-0073`. The labels/difficulty
content pipeline is post-launch for these two flat-path subjects and remains required before
unit-gated practice is enabled.

### Sequencing clarification, 2026-09-26

D-1 is resolved for the October 2 launch. `DECISION-0073` verified that the launch frontend and home
page already exist and already use the current design system, so there is no remaining page-build
sequence to decide. The October 2 work is a verification/fix pass against that live surface. Payment
remains post-launch. This clarification does not authorize a deployment or the final launch decision.

## DECISION-0070 — Launch-Planning Follow-Ups, 2026-09-26

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md` (decision register D-3 through
D-8, D-12); `docs/product/LAUNCH_PLAN_MARKETING_HOME_PAGE_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`;
`docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md` (UX-004);
`docs/content/APSTATS_PILOT_PACK_REVIEW_AND_UNPUBLISH_2026_09_25.md`; `DECISION-0069`
**Area:** Product / Launch Scope / Commercial / Content

### Decisions

1. **BYOQ ships on the new home page, ungated, as an anonymous session.** A visitor does not need to
   sign in or purchase to use the full Student-Provided Question Intake (BYOQ) experience
   (`STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`). This changes UX-004 from a deferred/non-critical item
   to launch-critical for the marketing home page and content-pipeline plans.
2. **Unlimited-subject pricing tier is deferred.** It will be priced and enabled once all 10 subjects
   are live, not at initial launch. Not an open item for now — remove from the payment-flow plan's
   blocking criteria until that condition is reached.
3. **Target launch window is next week.**
4. **Logo/wordmark is not a launch blocker.** A type-only wordmark is sufficient; no illustrated logo
   mark is required for launch.

### Confirmed, not new: AP Statistics' criterion-6 hazard is resolved

David asked to confirm this was already handled — it was. `docs/content/APSTATS_PILOT_PACK_REVIEW_AND_UNPUBLISH_2026_09_25.md`
(2026-09-25, one day before this session's launch-planning docs were drafted) retired the
MCQ-only pilot exam-pack version (`exam_pack_versions.id 7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada`) and
verified platform-wide exam-pack-version singularity was restored. **The launch-planning docs drafted
2026-09-26 cited this as an open Day-1 hazard because they were built from
`SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table, which itself was never updated after the
2026-09-25 fix** — a staleness bug in that table, not a new problem. Corrected in
`LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`; `SUBJECT_SERVABILITY_CRITERIA.md` itself should
also be updated by whoever next touches AP Statistics' row in it.

### Flag: the 1-week launch window creates real tension with the rebuild's own sequencing

`APP_REBUILD_MIGRATION_PLAN.md` sets an explicit sequence (app rebuild → marketing reskin → Stripe
update → new home page last, "once the system it advertises exists") and lists 25 open decisions, some
blocking Phase 0. A 1-week window is very tight against that sequence plus the still-open items in the
decision register (D-1 sequencing override, D-2 which frontend, the unentitled-attempt bug from
`DECISION-0069`'s follow-up). This is surfaced, not resolved, here — see D-1/D-2 in the index's
decision register. Recommend confirming with David whether the 1-week window means the rebuild
sequence is being compressed/overridden, or whether "next week" targets a narrower slice of the full
rebuild scope.

### Not yet resolved

Does DECISION-0063 (Biology launches on the FRQ-only practice path, unit-gated path deferred) extend
to AP Statistics as well, since Statistics is now also a Day-1 subject? Not addressed by this decision.

## DECISION-0069 — Day-1 Launch Subjects and Pricing (BIZ-001, GTM-001)

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session)
**Related Docs:** `docs/MASTER_TODO.md` BIZ-001, GTM-001; `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md`;
`docs/product/SUBJECT_SERVABILITY_CRITERIA.md`; `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`;
`docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`; `docs/product/LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`
**Area:** Commercial / Pricing / Launch Scope

### Decision

Day-1 launch subjects are **AP Biology and AP Statistics**. Remaining subjects (Calculus AB/BC,
Chemistry, Physics 1/2, Physics C Mechanics/E&M, Precalculus) fast-follow as confidence in site
performance improves — no fixed date set for the fast-follow subjects in this decision.

Pricing (partially resolves BIZ-001):
- Single subject: **$39.99** (matches the already-built live/sandbox Stripe catalog — no change).
- Two-subject bundle: **$79.99** (changes the built catalog's current $69.99).
- Three-subject bundle: **$99.99** (changes the built catalog's current $89.99).
- Unlimited-subjects tier: **not specified in this decision.** The built catalog currently prices it
  at $139.99; that price is neither confirmed nor superseded here. Open question for David: does the
  unlimited tier still exist at launch, and if so, at what price?

### Flag, not yet resolved by this decision

The two-subject bundle price ($79.99) is $0.01 **more** than buying two single subjects separately
($39.99 × 2 = $79.98) — effectively no bundle discount, and technically a worse deal than buying
singles. The three-subject bundle ($99.99 vs. $119.97 for three singles) does carry a real ~$20
discount. This asymmetry is called out here rather than silently implemented; confirm with David
whether the 2-bundle price is intentional (e.g., a smaller incentive by design) or a rounding
oversight before the Stripe catalog is updated to match.

### Consequences

- AP Statistics is now on the Day-1 critical path. Its known Hard Gate hazard — two simultaneously
  published exam-pack versions (`SUBJECT_SERVABILITY_CRITERIA.md` criterion 6) — must be resolved
  before launch, not treated as a lower-priority special case.
- The live and sandbox Stripe Product/Price catalogs (`TASK-0023`) need their 2- and 3-subject bundle
  Prices updated to $79.99 / $99.99. This is a live-Stripe-account change and remains a Hard Gate
  requiring David's explicit go per the payment-flow plan.
- BIZ-001's "prevent sales of subject bundles before each pack passes quality gates" rule now
  concretely means: don't enable bundle purchases spanning Biology + Statistics (or any fast-follow
  subject) until Statistics' criterion-6 hazard is resolved and the bundled subjects each pass
  `SUBJECT_SERVABILITY_CRITERIA.md`.
- BIZ-001 remains open on: access duration, refunds/discounts, parent-purchaser handling, and the
  unlimited-tier question above.

### Risks / Follow-ups

- Confirm the 2-bundle pricing anomaly before any Stripe catalog update.
- Decide the unlimited tier's fate (keep at $139.99, reprice, or drop) before payment-flow plan can
  fully close its catalog criterion.
- No fast-follow date/threshold was set for "as confidence in site performance improves" — if a
  concrete trigger (e.g., N days of stable serving, or a specific error-rate threshold) is wanted, that
  needs a follow-up decision.

## DECISION-0066 — Approve AI Two-Model Agreement as Sufficient to Promote Serving Labels to `validated` (FF-3)

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` (FF-3);
`docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` §7a (T9), §10 (T6.b); DECISION-0055;
DECISION-0062; `supabase/migrations/` — `content_taxonomy_labels_validation_check` constraint
**Area:** Content / Taxonomy / Governance

### Context

The unit-gated serving path (`public.select_unit_gated_practice_items`) requires
`label_status='validated'` on a serving label, and the schema enforces this genuinely: the
`content_taxonomy_labels_validation_check` constraint makes `validated` impossible unless
`validated_by`, `validated_at`, `validation_decision_id`, and a fresh content-hash match are all
present. As of 2026-09-24 this made the path dark for 8 of 10 subjects (0 servable), with only
AP Calculus AB and AP Calculus BC carrying any `validated` rows (4 each, from an earlier pass).

The open question was whether T9/T6.b's human-validation requirement survives DECISION-0055's
pause of the human independent-review requirement. T6.b already resolves this **for serving labels
specifically** — it was "accepted for units only — not for topics," on a measured **89% two-model
agreement rate**. Unlike FF-9's coverage labels (44% agreement, "near a coin flip" per
DECISION-0062), the evidence for serving labels already supports automation; this decision approves
operationalizing what the plan already endorses in principle, not a new automation claim.

### Decision

1. **Two-model agreement is accepted as sufficient basis for promoting a serving label to
   `validated`**, across all subjects — this decision is not Biology-scoped, since the unit-gated
   path is dark product-wide and the underlying evidence (T6.b) was never subject-specific.
2. **The Product Owner (David) is the approver of record.** Promotion is recorded via
   `content_taxonomy_validation_decisions` with `decided_by` = David's `profiles.user_id` and
   `decision_source='automated_spot_check'` — a value the schema already supports — applied in
   batch, not per item.
3. **Items where the two models disagree are NOT promoted.** They remain `provisional_model` or
   `held`. No adjudication, no picking one model's answer — same discipline as every other
   AI-agreement gate in this project (DECISION-0065's verb verification, work order N's
   disagreement rows).
4. **This does not touch coverage labels.** `assessed_topics` stays under FF-9 (DECISION-0067),
   unaffected — the evidence and the risk profile are different, and T9's split between serving and
   coverage labels is explicitly preserved.

### Execution (same day)

Claude executed the batch promotion immediately after approval, against **existing** agreed serving
labels already sitting in Production from an earlier labeling pass (`source =
'vercel_ai_gateway_two_model_serving_lane'`, `reason` matching `two_model_*`) — this did not require
waiting on new work orders. Freshness was verified per item, not assumed: a candidate was promoted
only if the item's current published content version predates the label's creation (i.e. content
was not edited after the label was made); `validated_against_taxo_hash` was computed fresh from
current content at promotion time, per the schema's own constraint.

**229 labels promoted across 9 subjects.** Unit-gated servable count: **8 → 143** product-wide.
Verified clean afterward: `app.servable_items_census_selftest()` 93/93 ok, 0 mismatch.

**Two subjects remain dark** because none of their candidate labels were fresh: **AP Physics C:
Mechanics** (0 of 4 candidates) and **AP Calculus BC** (0 of 17 candidates) — both need their
serving labels re-run against current content, not promoted as-is. This is ordinary content work,
tracked per-subject, same as any other relabeling need — not a governance question.

### Correction, same day: the multi-unit gap the plan itself flagged was real

After execution, re-reading `TAXONOMY_LABELING_PLAN_V3`'s own routing table (§T6.b) found that the
229-item promotion did not match the plan's own design: the plan reserves blanket two-model-agreement
promotion for **single-unit** agreement only, and explicitly routes **multi-unit** agreement to full
human validation, "because a correlated error has no third vote to catch it" — and conditions the
entire auto lane on a T6.a gold-set calibration (40 items, 2 blind human reviewers) that no record of
ever running could be found. This decision's original text did not carry that nuance to David before
execution.

**26 of the 229 were multi-unit.** All 26 were immediately reverted to `provisional_model` pending a
genuine third opinion — the plan's own fix for "no tiebreaker."

**Remediation: Claude served as an independent third reviewer** (differently-architected from the
original GPT-5.5 + Gemini-2.5-flash pair), reading each item's full stem/stimulus/rubric criteria
against the subject's unit closed list from scratch, not just re-checking the original models' stated
reasoning. Two rounds:

- First pass: 19 of 26 confirmed (three-way agreement), 7 disputed.
- Second pass, prompted by a direct question distinguishing genuine content dependency from
  incidental distractor vocabulary: 3 of the 7 reclassified from disputed to confirmed on closer
  reading (the "extra" unit's concept turned out to be load-bearing for the correct answer, not
  decorative) — bringing the confirmed total to **22 of 26**. **2 of 26 are genuine over-tags**
  (`APBIO-MCQ-012`, `apchem-mcq-048` — the extra unit appears only in wrong-answer distractors, not
  in what's needed to reach or defend the correct answer). **2 of 26 remain genuinely unresolved**
  even on careful re-reading (`APBIO-MCQ-041`, `apchem-frq-l-004`).

**Risk direction matters here and changes the urgency.** Over-tagging (requiring a unit that isn't
truly needed) only delays an item's availability — it cannot cause the unfair "shown material not yet
covered" harm this whole review was checking for, because it makes the gate *more* conservative, not
less. Re-verified: none of the 7 disputed items were under-tagged relative to my independent read, so
none of the 229 originally promoted labels carried the harmful-direction risk in their final state.

**Executed:** the 22 confirmed labels were promoted (`decision_source='chat_review'`, since this was
a direct content review, not a scripted model-agreement pipeline) — unit-gated servable count
increased further as a result. The 2 confirmed over-tags and 2 unresolved items remain
`provisional_model`; a Codex work order will author new distractors/criteria to resolve the
ambiguity in the content itself (`prompts/CODEX_WORK_ORDER_UNIT_TAG_DISTRACTOR_REPAIR_2026_09_24.md`)
rather than continuing to adjudicate by argument.

**Standing correction to this decision's mechanism, going forward:** any future promotion under
DECISION-0066 must route multi-unit agreement through an explicit third-review step (a differently-
architected model or a human), not blanket-promote on two-model agreement alone. Single-unit
agreement promotion is unaffected by this correction — the plan's own routing table treats that lane
differently.

Work orders N and N.1 (Biology, queued behind J.0) and any equivalent future labeling passes for
other subjects will need the same promotion step repeated once their labels reach agreement — this
decision's mechanism applies to them too, not just to what was promoted today.

### What this does not decide

- Coverage/topic label promotion (FF-9) — explicitly out of scope, see DECISION-0067.
- Whether to re-run serving labeling for subjects that don't have current labels at all — that's
  ordinary content work, tracked per-subject, not a governance question.

## DECISION-0068 — BYOQ Data Model Uses Parallel Tables (Option A), Not the Live Graded Pipeline; TASK-0039 Phase 1 Scope Approved

**Date:** 2026-09-26
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-26 (this session) — see `APPROVAL-0050`
**Related Docs:** `docs/tasks/TASK-0039-BYOQ-PRODUCTION-OPERATIONAL.md` ("Question identity, answer
capture, and image linking" section, Decision needed #1); `DECISION-0057`;
`docs/product/BYOQ_ANSWER_VISIBILITY_AND_DATA_MODEL_DISCUSSION.md`
**Area:** Backend / Schema / Governance

### Context

`TASK-0039` needed a call on how BYOQ (bring-your-own-question) items and their attempts/images are
stored: generalize the live, real-student-data `app.attempts`/`app.response_versions`/
`app.response_attachments`/`app.capture_pairing_tokens` tables in place (Option D), or build BYOQ its
own parallel tables (Option A). Option D was this session's first-draft recommendation, on the theory
that a single, well-tested guard on the shared grading code paths would be a smaller surface than
duplicating working attempt/version/retake machinery.

An adversarial review of that exact schema, checked line-by-line against the live migrations and
function bodies rather than taken on the plan's word, and independently re-verified directly against
Production before this decision was recorded, found Option D's "one guard" premise false:
`app.record_manual_grade` (the RPC the human-grading queue calls) checks only `status = 'submitted'`,
with no content or BYOQ-provenance check of any kind; `app.prevent_client_grading_truth_update` (the
trigger meant to block unauthorized grading writes) explicitly exempts the `service_role` every
grading path runs as, so it offers no protection here; and `app.attempts_status_check` has no
terminal "never graded, by design" status, so a BYOQ attempt reaching `submitted` sits in exactly the
state the human-grading queue scopes on. Together, under Option D a BYOQ hand-drawn response photo
reaching `submitted` status would land in the real human-grading queue, with the student's name
attached, one RPC call away from being graded — a live `DECISION-0057` leak path, not a hypothetical
one. Closing it under Option D would require a new, service-role-inclusive guard trigger, a new
terminal attempt status, and rewrites to `bind_response_attachment` and `capture-pairing`'s
supersede logic for the corrected `part_key`/`page_sequence` uniqueness rule — a materially larger and
riskier migration surface against live tables than "a few additive columns."

### Decision

**Option A: BYOQ gets its own parallel tables** — `app.byoq_items`, `app.byoq_responses` (or a
`byoq_attempts`/`byoq_responses` pair, sized to what BYOQ actually needs, not the full graded state
machine), and, when Phase 2 starts, `app.byoq_capture_pairing_tokens`/`app.byoq_attachments`. No
shared code path exists between BYOQ and the graded pipeline for a guard to fail on, because there is
no shared code path — the human-grading queue, `evaluate-attempt`, and `record_manual_grade`
structurally cannot see a `byoq_*` row. The `part_key`/`page_sequence` fix for "whole vs. part of a
multi-part answer" (a real, pre-existing gap this task found, affecting library content too — AP
Biology's longer FRQs and future long-form subjects like AP Literature) still applies, built correctly
into `byoq_attachments` from the start (a `NOT NULL` triple-keyed uniqueness rule, not the nullable
pair the first draft mistakenly specified).

**`TASK-0039` Phase 1 scope is approved**: the `app.byoq_items`/`app.byoq_responses` schema (Option A
shape, no answer-bearing column of any kind on `byoq_items`), a separate BYOQ Practice
screen/component sharing UI components with but never branching inside the live graded Practice
screens, and the Home entry point, per that task's Phase 1 section as currently written.

### Not decided by this approval

- **Phase 2** (QR photo capture) is not authorized to start — it still needs the Pre-flight
  verification step (which Lovable frontend actually serves `cramapple.com`) done first, and its own
  implementation go-ahead once Phase 1 ships.
- **Phase 3** (worksheet parsing) remains blocked on `docs/product/BYOQ_WORKSHEET_PARSING_DESIGN.md`'s
  own Open Decisions (parsing vendor, candidate cap, retention window).
- **`TASK-0039`'s "New gaps" list is not resolved by this decision** — entitlement/trial gating, rate
  limits/quotas, retention/deletion, consent copy, the private-until-promoted boundary, subject/
  taxonomy scoping, stuck-BYOQ routing, and the hints/deep-dive floor all still need an explicit
  Product Owner call before Phase 1 ships to real students, not just before its schema is built.

## DECISION-0067 — Coverage Labels Stay Deferred; No Promotion Work Until Coverage Reporting Is Prioritized (FF-9)

**Date:** 2026-09-24
**Decision Owner:** David Bloom
**Status:** Approved
**Approval:** Product Owner direction, 2026-09-24 (this session)
**Related Docs:** `docs/product/AP_BIOLOGY_FAST_FOLLOW.md` (FF-9); DECISION-0062; `docs/architecture/
TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` §7a (T9), §10 (T6.b)
**Area:** Content / Taxonomy / Governance

### Context

Coverage labels (`assessed_topics`) measured only **44% two-model agreement** — "near a coin flip"
per DECISION-0062 — a materially weaker basis than serving labels' 89% (DECISION-0066). T9's rule
requiring full human validation for coverage labels was set by measuring AI at exactly this task and
finding it unreliable, not by a general policy preference. Verified during this session: **nothing
in the live product reads `assessed_topics`** — it appears only in DDL (column, constraint, index,
view definition), never in served content or grading. A wrong topic label cannot mis-serve a
student; it can only miscount a coverage report (T8) that has not been built yet.

### Decision

**FF-9 stays deferred.** No promotion work, no automation-basis decision, no human-validation
resourcing — none of it is scheduled. This is a deliberate "do nothing yet" call, not an oversight:
given zero live cost and weak automation evidence, there is nothing to gain from deciding this now.

### Revisit condition

Revisit only when coverage reporting (T8) is actually prioritized on the roadmap. At that point the
real question becomes concrete: fund human validation of coverage labels (matching what T9 already
requires), or make a fresh case for AI automation with better evidence than the measured 44%. Either
is a real option then; neither is worth deciding in the abstract now.
