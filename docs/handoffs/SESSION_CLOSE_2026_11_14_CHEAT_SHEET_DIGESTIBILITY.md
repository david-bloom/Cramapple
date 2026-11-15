# Session close — Cheat Sheet digestibility rollout (2026-11-13 to 2026-11-14)

**Task:** the five Cheat Sheet digestibility proposals (`docs/product/CHEAT_SHEET_DIGESTIBILITY_PROPOSALS_AND_PROGRESS_2026_11_13.md`), started from a parent session. **Next owner:** David (review and render check), then a content session for the open items below.

## 1. Current task
Finish all five proposals in Production for every subject except Physics 2 and Physics C (excluded by David as low priority). This session did #2 phase 2 (authored `quick_take`) and #3 (structured text) for all remaining subjects, a Calculus AB source repair, and confirmed #1, #4, #5.

## 2. What changed
- **#2 `quick_take`:** schema (`20261113150000_topic_explainers_quick_take.sql`, view and `get_topic_point_guides`), then authored text on 136 Chem/Bio/Stats units 1-5 rows (`APPROVAL-0272`) and 363 more rows: Biology 6-8, Chemistry 6-9, Calculus AB and BC, Physics 1, Precalculus (`APPROVAL-0279`).
- **#3 structured text:** 317 rows (Biology 6-8, Chemistry 6-9, Calculus AB 35, BC 111, Physics 1, Precalculus) (`APPROVAL-0273`); Calculus AB units 1 and 6-8, 41 topics (`APPROVAL-0279`); 5 AB topics (1.5, 1.6, 1.7, 1.9, 1.11) are single-idea and stay prose.
- **Calculus AB lost primes:** second-derivative primes (f'') restored in AB 5.6-5.9, 5.11 explainer text (`APPROVAL-0274`) and in AB 5.6-5.9 `answer_move` / `common_point_loss` (`APPROVAL-0279`).
- **App PRs (ap-prep-blueprint, all merged and published by David):** 61 (`quick_take` rendering), 62 (worked example removed from the Cheat Sheet), 63 (practice bridge hidden when it near-duplicates another card, #1).
- **Cramapple PRs merged:** 653 (records for 0272-0274) and 655 (record `APPROVAL-0279`, evidence). The earlier 0262-0264 rollout (Stats, Bio, Chem units 1-5) was done before this session.

## 3. Verified
Each Production write was guarded on the row's previous text and read back from Production independently: 136/136, 317/317, 5/5 and 3/3 (primes), 363/363, 41/41, 4/4. Production ref confirmed with `--debug` before every write. Every set was checked by `openai/gpt-6.1-sol` and `moonshotai/kimi-k3.1-pro` with a planted control (except the AB structured set, which has no control); real defects were fixed and re-checked clean. PR 63's rule was measured on all 603 published explainers (it hides exactly four bridges). Live app check by David and me confirmed `quick_take` lines and the Calculus AB fallback.

## 4. Open
- **No human has read any of the new text, and none has been seen rendered** (tables and phone width were not checked live).
- **Source-field mismatches carry into some `quick_take` lines** because checkers compare against the same source: for example Calculus BC 1.16, 5.2, 8.2, 8.3, 10.5; Chemistry 7.3, 7.8, 8.1; Physics 1 8.4 (misconception phrasing). Chemistry 3.1-3.11 and Statistics 3.1-3.15 answer moves are boilerplate; Statistics 2.4, 2.8, 2.9 point-loss fields look aligned to other topics.
- **Primes scanned only on AB topics mentioning concavity or second derivatives**; other AB or BC fields (briefs, hooks) were not scanned.
- About 55 `quick_take` lines have a label line over 25 words (each sentence is within the limit).
- The C13 overlap check was not re-run on rewritten rows.
- Physics 2 and Physics C (E&M, Mechanics) untouched by design.
- The Calculus AB structured set had no planted-error control.

## 5. Blockers and risks
No blocker. Risk: text changes are live to students with only model checks behind them. Rollback for each change is in its approval record (`quick_take = null` for the 363 and 136 rows; restore four fields from the `current_*.json` / `fetch_ab.json` snapshots).

## 6. Files
Created: `scripts/content-seed/quick-take-2026-11-13/`, `structured-explainers-rest-2026-11-13/`, `quick-take-rest-2026-11-14/`; `supabase/migrations/20261113150000_topic_explainers_quick_take.sql`; `APPROVAL-0272`, `0273`, `0274`, `0279`; the handoff doc above (status updates appended). Earlier rollout files are under `structured-explainers-2026-11-13/` (separate PRs 645, 646).

## 7. Commands and results
`supabase db query --linked --workdir /Users/davidbloom -f …` for Production and `--workdir <repo>` for Development (ref confirmed with `--debug`), all succeeded; read-backs matched. Gateway checks about $3 (first `quick_take` batch) plus about $2 (second batch) plus about $1.5 (structured rest). PR 652 (Codex, Calculus Unit 5 releases): reviewed, merged `origin/main` into its branch to trigger CI (`157d8271`); CI was running at session end.

## 8. Approval state
All writes above were approved by David in chat and recorded. No further approval is pending. PR 652 is Codex's: do not merge without David.

## 9. Next step
David spot-checks the live Cheat Sheets (suggested: Chemistry 2.1, Statistics 3.2, Biology 6.1, Calculus AB 5.6, Physics 1 1.4, Precalculus 3.7) on desktop and phone width, then decides whether a human content review or a source-field repair pass (the mismatches in §4) comes first.

## 10. Do not touch
Codex's branch `codex/unit5-calculus-finish` and its worktree `/private/tmp/cramapple-unit5-calculus` (an active Codex session may push; it will need to pull). The shared checkout's uncommitted edits to `ACTIVITY_LOG.md` and `APPROVALS_LOG.md` duplicate what is on main and will conflict if committed; other sessions' untracked files there (`Marketing Images/`, coaching plans and folders, Statistics harder seeds) belong to those sessions. Do not apply any Production write for Physics 2 or Physics C without a new instruction.
