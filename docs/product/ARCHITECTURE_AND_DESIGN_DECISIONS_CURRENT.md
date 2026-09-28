# Architecture & Design Decisions — Current

STATUS: CURRENT
DATE: 2026-09-27
OWNER: David Bloom
DECISION: DECISION-0075 (ratified 2026-09-27)
CANONICAL REPOSITORY: `david-bloom/Cramapple`

---

## What this document is

The single "decided vs. open" entry point for **what the app's architecture and design
are, right now.** If you read only this file, you should get the correct current picture and
know where to go for detail.

It does **not** make product decisions. Every DECIDED row cites the record that decided it.
Every OPEN row names why it is open and who owns it. Where two older docs disagree, this file
reconciles **by pointer** to the decision already on record — it does not pick a winner on
anything still undecided.

**Why this exists.** The most load-bearing plan (`APP_REBUILD_MIGRATION_PLAN.md`, 2026-09-22)
carries no Task ID, owner, or DECISION number (its own §16), and its §11 "open decisions" table
was largely resolved on 2026-09-26 without being updated in place. Several canonical design docs
still assert rules that have since been reversed. This one-pager is the ratifiable summary that
those docs now point *to*.

**Ratification.** Ratified 2026-09-27 as **DECISION-0075** (owner: David Bloom). This file is the
canonical entry point for current app architecture/design; where an older design/architecture doc
conflicts with it, this file wins. See `docs/activity_log/DECISIONS_LOG.md` → DECISION-0075.

**Verification note (the project's own rule: verify against live systems, not docs).** The
live-system claims below were re-verified on 2026-09-27: the responsive-frame change was read
directly from Lovable project `56cae479` commit `44a0f59e`; the in-repo commits were confirmed
in git; both domains were confirmed live on Cloudflare/Lovable. Frontend commit hashes cited
here live in the Lovable project history, **not** in this git repository — see the "Two-repo
reality" note at the end.

---

## DECIDED

| # | Decision | Current answer (one line) | Source of record | Task / commit / DECISION |
| --- | --- | --- | --- | --- |
| D1 | **Session modes** | **One session mode, working name "Learn."** No selectable Course / Homework / Cram *mode*. The mechanics survive as components, not as a mode. | `COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` §1 (DECIDED); `APP_REBUILD_MIGRATION_PLAN.md` §4.1; David verbal 2026-09-27 ("course mode is no longer a thing. there is only one mode.") | `APP_REBUILD` §11 #12 Resolved |
| D2 | **Two plate templates** | Every question type exists in two templates: **Open Hand** (rubric/answer face-up, manipulable, **nothing scored** — a teaching method) and **Practice** (support hidden or gated, one submission, **scored**). | `APP_REBUILD_MIGRATION_PLAN.md` §4.2; `docs/new_design/VISUAL_IDENTITY.md`; David 2026-09-22 | — |
| D3 | **Frame: responsive, not fixed** | **Go responsive.** The old fixed 1440×900 `overflow:hidden` never-scroll plate is **superseded**: the plate is now fluid up to 1440px, grows with content, and stacks its pane grid below 900px (vertical scroll allowed). | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` "DECIDED, 2026-09-26" #1; verified live in Lovable `56cae479` | TASK-0047 Workstream A, commit `44a0f59e` (Lovable) |
| D4 | **Design system** | **Light-only, brand orange** (`#f54900`; `#ca3500` for ink), **square corners** (radius 0), **zero motion** (ConfettiBurst is the one named exception), fonts **Bungee / Passion One / Source Sans 3 / STIX Two Math**. `docs/new_design/` is canonical. | `docs/new_design/README.md` + `VISUAL_IDENTITY.md` (canonical); dark mode retired 2026-09-21 (David) | `APP_REBUILD` §11 #2, #6 Resolved |
| D5 | **Superseded design systems** | The emerald/dark/Plus-Jakarta **v2 brief** and the red `#F5442E` "**Project-Crux**"/clay/amber palette in `DESIGN_SYSTEM_CUTOVER_PLAN.md` are **both superseded** by D4. | `docs/new_design/README.md` "What changed from v2"; this file §"Design drift" | — |
| D6 | **Marketing / app split & live projects** | Two deployed Lovable projects: **App** = "New Cramapple App" `56cae479` → `app.cramapple.com`; **Marketing** = "New Cramapple Marketing" `61dd6602` → `cramapple.com`. In-repo rebuild target is `web/`. | `APP_REBUILD_MIGRATION_PLAN.md` §3; `DECISION-0073` (self-correction); verified live 2026-09-27 | — |
| D7 | **Mastery rule** | **2 correct MCQ + 1 full-point FRQ, with no hint use prior to submission** on any of the three (hints after submission never affect mastery). Foundational and **still unbuilt**. | `docs/activity_log/DECISIONS_LOG.md` `DECISION-0074` | `DECISION-0074` (supersedes the earlier "2 full-point, hint allowed" first pass) |
| D8 | **Multi-part FRQ** | **Cheap render-time parser stopgap** for `(a)/(b)/(c)` prose parts; full re-authoring migration explicitly **not** committed. | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` "DECIDED" #11 | TASK-0047 Workstream B, commit `c52c3fd6` (Lovable) |
| D9 | **BYOQ shape & owner** | **Phone/camera capture is the launch-required intake**; typed/paste is a **fallback alongside** it; worksheet/document upload **deferred post-launch (Phase 3)**. BYOQ is the alternative path, not the default (Practice defaults to a Cramapple question). **Owner: Claude** (Codex moved to the content pipeline). | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` "DECIDED" #18/#19; `DECISION-0076` / `APPROVAL-0052` (phase priority + ownership, 2026-09-27) | `TASK-0039` (`DECISION-0076`) |
| D10 | **ConfettiBurst motion** | **Keep**, as a named, documented exception to the "zero motion" rule. | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` "DECIDED" #3 | `APP_REBUILD` §11 #3 |
| D11 | **Course-Mode component survival** | Generalize `ConfirmTransferBeat`'s trigger; fold `LessonOpener` into `WorkedExample`; keep `StreakBadge`. These are **components**, not a "mode." | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` "DECIDED" #17 | TASK-0047 Workstream D, commits `8337b270` / `6b696008` (Lovable); follow-on backend `9fc0f75b` (this repo) |
| D12 | **Item-package format** | **Dual-read adapter**, not a mass backfill. (Gap was found dormant — adapter is forward insurance.) | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` "DECIDED" #23 | TASK-0047 Workstream E, commit `1a6e8404` (this repo) |
| D13 | **`validated` status gate** | Does **not** gate the Oct 2 launch. Post-launch content-hygiene project. | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` "DECIDED" #24 | — |
| D14 | **Canonical session flow** | Standardize on **bare `/session`** (`SessionFrame.tsx`); retire `/session/mcq` + `/session/frq`. Shape decided; **route retirement not yet executed** (scope wider than first described — see OPEN O10). | `LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` "DECIDED" "NEW canonical session flow" | — |
| D15 | **Day-1 launch subjects** | **AP Biology + AP Statistics** live day 1; other 8 subjects fast-follow. Pricing $39.99 / $79.99 / $99.99 (single / 2-bundle / 3-bundle). | `docs/activity_log/DECISIONS_LOG.md` `DECISION-0069` | `DECISION-0069` |
| D16 | **Backend does not move** | The 16 edge functions, data model (`attempts`, `attempt_responses`, `grading_results`, `learning_sessions`, `subject_entitlements`), grading engines and migrations are **unchanged** by the rebuild. Rebuild re-implements callers, not contracts. | `APP_REBUILD_MIGRATION_PLAN.md` §2.4, §10 | — |
| D17 | **Open Hand answer-key: method** | Open Hand is a **sanctioned full-disclosure teaching method** — a unit:topic-relevant item shown with its answer, rubric, points earned/lost, reference pane and deep dive, none of it scored. (*Whether* to show the key is settled; *how* to serve it is now also settled — see O5, RESOLVED by TASK-0049.) | `APP_REBUILD_MIGRATION_PLAN.md` §5.2, §11 #21; David 2026-09-22 | — |
| D18 | **BYOQ is identity-agnostic** | BYOQ requires **no authentication**: `app.byoq_items.user_id` is **nullable** (recognition metadata for a signed-in in-app user, not a gate). It runs **anonymously on the marketing page** (`61dd6602`) and **recognized in the app** (`56cae479`) with identical behavior. Amends `DECISION-0068`'s authenticated-only schema; upholds `DECISION-0070`. Anonymous scoping (e.g. session/device token) is build work under TASK-0039. | `DECISION-0077` / `APPROVAL-0053` (David, 2026-09-27) | `TASK-0039` |

---

## OPEN

| # | Question | Why it's open / what it blocks | Owner |
| --- | --- | --- | --- |
| O1 | **Logo** | No mark exists; the type-set wordmark ships as the mark unless resolved. An agent must not invent one. | David |
| O2 | **Cross-subdomain auth handoff** (`.cramapple.com` cookie scope) | Foundational to the app/marketing split (D6); a student signing in on one subdomain must carry to the other. | David / eng |
| O3 | **Route-by-route auth-requirement audit** | `APP_REBUILD` §2.3 buckets routes by name only — a first pass, not an audit. | eng |
| O4 | **"Open Hand" naming collision** | The term means both a *pedagogical sequence* (consolidation plan) and a *plate template* (design system + `web/`). They map cleanly but **one vocabulary must be chosen** before both ship. | David |
| ~~O5~~ | **Open Hand answer-key serving contract** | **RESOLVED, TASK-0049:** `public.get_open_hand_item(learning_session_id, content_item_version_id)` requires an owned active session and a published item in that session's exact exam pack, then atomically records a permanent per-user/version scoring exclusion before returning the full key. `evaluate-attempt` hard-rejects excluded pairs with `409 open_hand_item_not_scorable`. Existing views and revoked grants remain unchanged. | David / eng |
| O6 | **BYOQ intake design** | The capture/paste/confirm intake is not visually designed. Shape + owner are set (D9, `DECISION-0076`); the screen is not, and no production backend exists yet (`TASK-0039`). | David / Claude |
| O7 | **Student-signal evidence basis** | The consolidation pivot rests on an undocumented feedback sample (size, method, stated-vs-observed). Upstream of D1/D9 and the mastery design. | David |
| O8 | **Topic-labelling specifics** | Direction is AI-led with a second source (`APP_REBUILD` §6.2); **open**: whether to re-score stored runs for *primary-topic* agreement first, and the human-escalation threshold. Blocks breadcrumb, habits pair, reference pane, deep dive, progress, study map. | David / content |
| ~~O9~~ | **Per-choice "fix" line in the Open Hand key** | **RESOLVED, TASK-0049:** the RPC derives MCQ `minimum_fix` from the existing authored `rationale`; no new column or content-authoring pass. FRQ continues to return its authored `minimum_fix`. | David / eng |
| O10 | **Session-route retirement scope** | D14's retirement is unexecuted; the dead cluster is wider than first named (`/setup`, `/session/uncertain` also point at the legacy routes). Widen-in-one-pass vs. re-point-first is undecided. Also owes a stale-doc pass on `docs/teaching/COURSE_MODE_*` "core loop" language. | David / eng |
| O11 | **Mastery build + hint-timing definition** | D7 is decided but unbuilt; `app.student_cell_state` has no discrete hint-timing / item-type-mix tracking. **Hard-gated** on David's definition of "what counts as hint use before submission" (`STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md`). | David |
| O12 | **GAP-9 — masterable-cell coverage** | Unmeasured: how many topic×skill cells lack a servable MCQ *or* FRQ, which under D7 blocks mastery on that cell permanently. Needs a count before mastery ships. | content |
| O13 | **Gold-for-full-marks** | v2's gold moment is currently absorbed into blue; keep-or-drop is an open design call. | David |
| O14 | **Type-stack final confirmation** | Canonical/shipping answer is the Bungee family (D4); `docs/new_design/README.md` still flags a formal "confirm which is real" against v2's Plus Jakarta Sans. Minor. | David |
| O15 | **Owner / Task ID for the rebuild** | TASK-0047 created (2026-09-26) but **owner still unassigned**; §7–§11 work has no named owner or exit gate. (This one-pager itself is now ratified — DECISION-0075, owner David Bloom.) | David |
| ~~O16~~ | **BYOQ: anonymous vs. authenticated (0070 ⟷ 0068 conflict)** | **RESOLVED 2026-09-27 → see D18** (`DECISION-0077`): BYOQ is identity-agnostic; `user_id` nullable; runs on both surfaces. | — |
| O17 | **`/home` never structurally redesigned to the canonical Plate/pane system** | Found 2026-09-27 (new session), previously untracked: `TopicHome.tsx`/`HomeV2.tsx` (the real `/home`) use a separate, older `home2-`/`home3-` prefixed CSS/component layer, not `docs/new_design/`'s Plate/pane system D3/D4 define and Session now uses. Two prior passes are both real but neither did a structural redesign: the 2026-09-24 Lovable plan "Apply the imported CramApple style guide" explicitly scoped itself as a **token bridge** ("preserving each screen's structure and behavior") — it wired Home's colors/fonts onto the new brand tokens without touching layout; TASK-0047 Workstream A (`44a0f59e`, the D3 responsive-frame commit) touches only `Breadcrumb.jsx`/`Plate.jsx`/`app.css`/spacing tokens — confirmed via `get_diff` — never `TopicHome.tsx`/`HomeV2.tsx`. Net effect: Home's *colors* are correct brand orange (verified directly in the live CSS), but its *layout and component language* (madlib unit/topic picker, Learn/Points mode toggle, `home2-`/`home3-` classes) predate and were never rebuilt against the canonical system — this is very likely what reads as "still using legacy design" on a live look at `/home`. **Answered 2026-09-27 (same session):** David shared a Design-canvas artifact
(`https://claude.ai/artifact/HoaRcFFv8GoiV9VeyDcgYh`) with the intended redesign. Reviewed for
viability against the real schema; Stage A (new student) and Stage B (building evidence) are buildable
now or after small backend work — planned as `TASK-0048`. The Personalized/Main state depends on
`GAP-10`, an unbuilt partial-FRQ-resume capability, and a nonexistent streak/trend layer — deliberately
deferred, not yet a task. | David |

---

## Design drift — the three systems, reconciled

For the record, since this is the single most misleading area of the docs:

- **Canonical (D4):** orange `#f54900` / `#ca3500` ink, light-only, square corners, Bungee family, zero motion. Lives in `docs/new_design/`. Verified live in Lovable `56cae479`.
- **Superseded v2:** emerald/forest green, dark-first, Plus Jakarta Sans + JetBrains Mono, gold-for-full-marks. Retained as historical input only (`docs/product/CRAMAPPLE_VISUAL_IDENTITY_BRIEF_v2.md`).
- **Superseded "Project-Crux" snapshot:** brand red `#F5442E`, clay-for-incorrect, amber-for-revisit — described in `DESIGN_SYSTEM_CUTOVER_PLAN.md` §1/§8 as the "new" system. That doc froze an earlier snapshot; the system that actually landed went orange. Banner added to that doc.

---

## Two-repo reality — "is it done?"

The rebuild's frontend lives in Lovable, not in this git repo. **A frontend commit hash cited in a doc is not verifiable from `david-bloom/Cramapple`.** Verified 2026-09-27:

- **In this repo:** `1a6e8404` (Workstream E), `9fc0f75b` (cell-serving follow-on), and the taxonomy-rationalization commits (`1d9dcfff`, `912699b2`, `6888116e`, `ac883a9e`) — all present.
- **In Lovable `56cae479` only:** `44a0f59e`, `c52c3fd6`, `f2475531`, `8337b270`, `6b696008`, `9be19bbc` — confirmed absent from this repo, present in the Lovable project history.
- **Live DNS (2026-09-27):** both domains resolve to Cloudflare/Lovable (`185.158.133.1`); `app.cramapple.com` currently **301-redirects to `cramapple.com`** (a live-state observation — re-confirm the intended launch behavior, do not assume from this doc).
- **Deploy status caveat:** TASK-0047's workstreams were "code-complete, not deployed" as of 2026-09-26. Per `DECISION-0073`'s own self-correction rule, re-confirm any project-ID or deploy claim against live DNS / Lovable before trusting it.

---

## Sources of record

| Topic | Canonical doc |
| --- | --- |
| Architecture & rebuild plan | `docs/product/APP_REBUILD_MIGRATION_PLAN.md` (note: its §11 is annotated in place; this one-pager is the current summary) |
| Decisions closed 2026-09-26 | `docs/product/LAUNCH_PLAN_STUDENT_HUB_2026_09_26.md` "DECIDED, 2026-09-26" |
| Execution of §7–§11 | `docs/tasks/TASK-0047-APP-REBUILD-SECTIONS-7-11.md` |
| Design system | `docs/new_design/` (`README.md`, `VISUAL_IDENTITY.md`, `TOKENS.md`) |
| Mode consolidation | `docs/product/COURSE_HOMEWORK_CONSOLIDATION_PLAN.md` |
| Numbered decisions | `docs/activity_log/DECISIONS_LOG.md` |
| Launch execution | `docs/product/LAUNCH_RUNBOOK_2026_10_02.md`, `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` |
| Doc map / discoverability | `docs/INDEX.md` |
