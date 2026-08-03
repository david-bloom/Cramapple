# AP Statistics blocked-branch reconciliation — review before executing

**Revision 4** (2026-08-02, post-execution) — the plan below was EXECUTED by Fable on 2026-08-02 after David's authorization. The branch is archived (`archive/codex-five-subject-20260727` → `30bc07d`; remote + local branch refs deleted), all three verification checks came back safe (provenance 288/288 in Production; migration diff found only Dev-only + two archive-preserved files; §3 verified 55/55 clean against the Fall-2026 CED PDF), and the fact pack was upgraded to source-verified. Full results: `docs/activity_log/ACTIVITY_LOG.md` entry 2026-08-02. **Still open: Step 0 (landing the working branch on `main`), the deferred Jill confirmation (David's call, 2026-08-02 — send the Sheet whenever convenient), and the follow-up sweep of same-era branches/worktrees/PRs.** Historical revision notes below are retained as-written for the record; where a section says NOT DONE, check the activity log entry — most of them were completed in execution.

## Step 0 — STILL PENDING, still the actual blocker

**None of this session's work has landed on `main` yet.** `main` (`eb6cbb9`) does not have the schema-baseline squash (`b6559a2`) — that squash, the approved fact pack (including the §3 port done since Revision 2), the curvature/topic-count edits, the `apprecalc-mcq-044` fix, the Chemistry CED-alignment fixes, the Precalculus FRQ restructuring, and the `review-queue`/`review-decision` bug fix all exist only on `claude/cramapple-grading-experiments-9lkjqc`. Everything "done" in this plan is done *on that branch only* — nothing here has reached `main`.

**ASK DAVID: what's blocking `claude/cramapple-grading-experiments-9lkjqc` from a PR to `main` today?** This has not been asked/answered yet as of this revision. Don't let the progress below create false confidence — none of it is landed anywhere durable.

## Background

`codex/five-subject-harness-and-content` (local + `origin`) forked from `main` on **2026-07-01**, last commit **2026-07-27**, 1176 files changed, ~206K insertions, 93 commits ahead of / 57 behind the current working branch. It contains five-subject content-authoring harnesses, tutor review banks, and a version of `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`.

On 2026-08-02, the actual AP Statistics subject tutor (Jill) reviewed the current fact pack via a shared Google Doc and gave two concrete edits, applied on the current working branch and cross-checked against Production content with no items needing changes:

1. §8 "retained" sentence clarified: curvature is a *pattern observed in residual plots used to assess linear-model appropriateness*, not a standalone concept.
2. §9 item 2 miscount fixed: "5 removed topics" → "4 removed topics" (§8's list of 5 confirmed removals is still correct — item 5 is a whole-unit removal, a different category than the 4 in-unit topic removals item 9.2 is actually asking about).

## The two-approvals question — narrowed, not resolved by memory-litigation

The blocked branch's fact pack carries its own status line: *"G0A-APPROVED by the qualified AP Statistics subject tutor (Jill) on 2026-07-14, without changes (relayed by David...)."* Read `git show b8d76d3` yourself.

**Do not try to resolve this by asking "did you really review it on 07-14?"** — that's an awkward, unreliable memory question three weeks out, and per the branch's own §9, even that draft never claimed anchoring confirmation was done (*"Tutor: confirm the skill anchoring is acceptable"* is listed as an **open item**, not a completed one). So the suspect branch doesn't actually contradict itself here — it never claimed §3 was validated. It's the *combination* of "no changes" plus a full skill/LO table that reads as inconsistent, not the anchoring's existence.

The 07-14 question still matters for one narrower thing: **whether the Statistics tutor-review content authored against the pre-08-02 draft (the "G3V vertical slice" — see commits `dabe379`, `7dd50a7`) needs re-checking against today's actual edits.** This is still an open, separate ask — **not addressed by anything done so far in this plan.** Don't fold it into the anchoring review below; it needs its own question to David/Jill.

## §3 salvage — DONE (on the working branch only; see Step 0)

The branch's fact pack had a per-topic skill/LO map (§3) covering 60 topics that our version lacked. **This has been ported into `docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md`.** Two corrections made during the port, not a verbatim copy:

- **The actual topic count is 55, not 60.** 13 (Unit 1) + 12 (Unit 2) + 15 (Unit 3) + 10 (Unit 4) + 5 (Unit 5) = 55. The branch's "all 60 topics" claim was likely counting the pre-removal CED (55 + 5 removed = 60) — re-verify this arithmetic yourself before trusting it further, it was reasoned, not sourced.
- The "Removed-topic note" originally said *"the five removed topics"* — corrected during the port to match Jill's "4 removed topics" fix, so it doesn't reintroduce the exact confusion she just resolved.

The fact pack's confidence-flags line and §9 item 2 both now explicitly say this table is a **candidate pending Jill's confirmation**, not verified fact — don't let anyone (including yourself) read it as already validated. The rebuild cascade keys MC practice weighting directly off these tags (P1 5–10% … P4 25–35%); a wrong skill map silently misweights the whole item bank, which is exactly why the next step matters.

**Verification-of-source note, still true:** the Stats CED PDF exists locally (`docs/teaching/ap-statistics-course-and-exam-description.pdf`) but has no extracted-text version, only rendered PNGs (`tmp/pdfs/apstats-ced/`) — independently checking all 55 topics against source means reading a 150+ page PDF by hand. That's why Jill's confirmation is the practical verification path, not a shortcut around a "real" one.

## Jill's review artifact — BUILT, not yet sent, and explicitly NOT urgent

A Google Sheet exists for her targeted confirmation: **"AP Statistics — Topic Skill-Tag Review (Jill) v2"** (`https://docs.google.com/spreadsheets/d/1T1jsGRfmq-HGHzp9j6ItV5xvWIv9VIhEa7IZdMCSh40/edit`). Structure, per David's direction:

- Column A: the 55 topics.
- Column B: current candidate skill tags — **written as plain-language descriptions, not alphanumeric codes** (e.g., "Justify a claim from calculations/results," not "4.B"). David was explicit that codes are too difficult for a human reviewer; don't reintroduce them anywhere in this artifact.
- Column C: Correct Y/N — plain text cell, not a real dropdown (no Sheets-formatting API was available to set data validation programmatically; David can add one via *Data → Data validation* in ~15 seconds if he wants it, but it works fine as free text).
- Column D: Remove (free text).
- Column E: Add (free text).
- A reference row at the bottom spells out all the skill descriptions so Jill doesn't need the fact pack open side-by-side.

**A stale earlier version of this sheet exists** (`1maqS7tOh5c7lD1VBHn8jZeOa8IhQevSmD4wNjMTIaI4`, "...v1") that still uses alphanumeric codes — David was asked to trash it manually (no delete capability was available). **Confirm it's actually gone before sending anything to Jill** — don't let the wrong version circulate.

**Explicitly discussed with David and confirmed: this is not urgent.** Blast radius is zero right now — no active students, zero of the 158 Stats FRQs are currently servable to anyone (separate `practice_format` bug), and publish is gated on G4B calibration regardless. The value of getting this checked is prospective (avoiding rework once bulk Statistics authoring actually starts against these tags), not something with a live cost today. **Send this to Jill whenever convenient — do not treat it as a blocking, time-sensitive ask.** The only real deadline is "before bulk authoring starts," which has not been scheduled.

## Drop or reframe step 5 from v1 — still moot, unchanged

**The schema has no topic/unit/skill tagging anywhere — `topic_selections` is empty across the board, confirmed 2026-07-24, unchanged since.** A "search Production for anything keyed to the new skills" check would trivially find nothing and prove nothing. Don't run it, don't imply it as a safety check.

## Make "don't merge" structural — NOT DONE

Still nothing stops a future `gh pr create --fill` from merging the codex branch. None of the following has happened yet:

1. Tag the branch: `git tag archive/codex-five-subject-20260727 origin/codex/five-subject-harness-and-content` (push the tag).
2. Record the salvage decision (what was ported — §3 — what wasn't, and why) in `docs/activity_log/ACTIVITY_LOG.md` or a DECISION doc.
3. Delete the remote branch only *after* the tag is pushed and confirmed.
4. **`codex/task0018-recognized-home` and `codex/task0019-session-targets`** (forked 2026-07-12, both with their own `.worktrees/`), plus `recovery/production-plumbing-storage-20260721` and `recovery/ap-statistics-benchmark-content-20260721` — same pre-squash-migration hazard class, still un-triaged, still not this plan's scope, still worth flagging to David as a follow-up sweep so they don't sit as silent landmines.

## Replace the migration risk assertion with a computed check — NOT DONE

Still an assertion, not a measurement. Before deciding anything about the branch's ~30 migrations:

1. Apply the codex branch's full migration chain to a scratch Postgres (local or a throwaway Supabase branch — never Dev, never Production).
2. `pg_dump --schema-only` that result.
3. `pg_dump --schema-only` Production or Dev (already reflects the squashed baseline) for comparison.
4. Diff. Three outcomes: baseline ⊇ branch (drop with confidence) / branch has extra objects (investigate before archiving) / conflict (confirms the danger concretely, tells you what would have broken).

## Before archiving anything: what already leaked into Production? — PARTIALLY CHECKED

Checked: commit `dabe379` (Jill's Stats tutor-review-set commit) — its own message says *"Built read-only from Production; no assignment created."* Its content keys (`APSTAT-MOD6-H001`, `APSTATS-HDG-2026-GRAPH-005`, etc.) are references *into* already-live Production content, not new content pushed *from* the branch. **For this specific commit, archiving the branch does not destroy provenance.**

**Still not checked**, and still required before any archive step: the per-subject seed commits (`0469643` Chemistry, `2b0648b`/`27a563a`/`1933944`/`5816181` Physics, `96dd28a` Calculus, etc.) — whether that authored content also exists in Production via a separate channel, or is genuinely only on this branch. **ASK DAVID or check directly.** Don't archive until every subject the branch touches has an answer, not just Statistics.

## Revised plan, current status

1. **Land `claude/cramapple-grading-experiments-9lkjqc` to `main`.** ⬜ STILL OPEN — the only remaining blocker. Note added in execution: the deployed `review-queue` edge-function source exists only on this branch, so until it lands, Production runs code with no merged source of truth.
2. **Confirm scope with David.** ✅ DONE — David authorized execution 2026-08-02 ("review, ask final questions, then execute").
3. **Port §3's skill/LO table forward**, harmonized wording. ✅ DONE — and subsequently source-verified (see 4).
4. **Jill's targeted confirmation.** 🟡 DEFERRED by David 2026-08-02 (she's needed elsewhere). Substantially de-risked in execution: all 55 rows verified against the Fall-2026 CED Unit-at-a-Glance tables (PDF is the new edition, contrary to earlier belief) — zero mismatches. Her eventual pass is exceptions-only. G3V vertical-slice re-check: ✅ CLOSED on content grounds (the full 07-14→08-02 delta was cross-checked against Production on 08-02; zero items needed edits); only the governance question about relayed sign-offs survives, addressed by the discipline rule below.
5. **Computed migration-diff check.** ✅ DONE (declared-DDL analysis; Docker unavailable). Verdict: baseline NOT a strict superset — 8 migrations of TASK-0017 harness schema are Dev-only 🟡; two files (`20260718014159_add_atomic_draft_package_adoption.sql`, `202607200001_subject_package_preflight.sql`) declare objects existing nowhere 🔴, deliberately not ported (they depend on Dev-only columns), preserved in the archive tag for when TASK-0017 resumes.
6. **Production-leakage question, every subject.** ✅ DONE — 288/288 branch content keys exist in Production via the documented 07-17/07-20 SQL-loader ingestion; Production has evolved past the branch. Archiving loses no content.
7. **Tag, document, then delete.** ✅ DONE — annotated tag `archive/codex-five-subject-20260727` → `30bc07d` pushed and verified; remote branch deleted; stale tmp worktree pruned; local branch deleted; rationale in the tag message + activity log.
8. **Sibling stale branches/worktrees/PRs sweep.** ⬜ FLAGGED, not executed (out of scope): `codex/task0018-recognized-home`, `codex/task0019-session-targets` (+`.worktrees/`), `recovery/production-plumbing-storage-20260721`, `recovery/ap-statistics-benchmark-content-20260721` (live `~/.codex/worktrees/`), `origin/recovery/ap-statistics-set04-integration`, `claude/grading-conflict-resolution-ledger`, two detached-HEAD worktrees, and stale draft PRs #43/#39/#38.

## Discipline rule to end on

The root cause of this whole mess is document forking: the fact pack circulated in two lineages (repo file vs. Google Doc) and each collected its own, disconnected approval. Going forward: **the repo file is canonical. Google Docs, Sheets, or any other external review surface are a review surface only — edits get ported back to the repo the same day, never left to accumulate as a second source of truth.** (This applies to the new Google Sheet too, once Jill's answers come back — port her corrections into the fact pack promptly, don't let the Sheet become the record of truth by default.)

## What not to touch

- Don't touch `supabase/functions/review-queue` or `review-decision` — fixed and confirmed live by the reporting reviewer. Unrelated to this task.
- Don't run any migration from the codex branch directly against Production or Dev, including during the scratch-DB diff in step 5 — use a genuinely disposable database, never a real environment.
