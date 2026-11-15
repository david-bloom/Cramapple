# Cheat Sheet digestibility: proposals and progress (handoff, 2026-11-13)

Purpose: single handoff for a fresh context thread. Case study: https://app.cramapple.com/learn/ap-chemistry/2/2.1.
Full analysis (uncommitted at time of writing): `docs/product/CHEAT_SHEET_DEEP_DIVE_DIGESTIBILITY_AP_CHEM_2_1_2026_10_30.md`.
App repo: david-bloom/ap-prep-blueprint (Lovable app 56cae479). Content repo: this one.

## The five proposals and where each stands

| # | Proposal | Status | Where |
|---|---|---|---|
| 1 | Render each fact once (suppress brief twins when an explainer exists; fold practice bridge into answer-move card; drop a bridge that repeats another card) | Done, merged | App PR 40, PR 58 |
| 2 | "In 30 seconds" block (one sentence each from answer move, point loss, first hook; needs >=2 items, max 60 words/sentence) | Frontend v1 done, merged. Authored `quick_take` field NOT started | App PR 59 |
| 3 | Structured pieces (bullets, numbered steps, tables) instead of paragraphs | Renderer merged and published. Content rolled out to Production for Stats, Bio, Chem units 1-5 | App PR 60; Cramapple PR 645, PR 646 |
| 4 | Length caps and near-duplicate check in the QA gate | Done by another session | Cramapple PR #578 (C13 overlap, advisory budgets) |
| 5 | Cheat Sheet open, Deep Dive as toggles | Done, merged | App PR 40 |

## Proposal 3 details (structured pieces)

- No schema change. Markers live inside existing text columns of `app.topic_explainers`:
  `- ` bullets, `1. ` steps, `| a | b |` table rows (first row = header, no separator needed).
  A paragraph renders structured only if every line follows the marker and there are at least 2 lines.
- Frontend path: topic-content.ts -> selectedTopicNotes (HomeStudyActions.tsx) -> mapOpenHandGuides (src/lib/open-hand/presentation.ts) -> NotesSheetContent (src/components/overlay/DeepDiveOverlay.jsx). Helpers in src/lib/deep-dive-export.ts (`notesBlock`, `quickTake`, `firstSentence`); CSS in src/styles/deep-dive.css.
- Field caps (chars): core_idea 360, what_students_need_to_understand 360, how_this_becomes_points 320, point_attaining_answer 520. C13 overlap warning at 0.80.
- Production rollout (each apply guarded by per-row md5, independently read back 100%, 603 published explainers left unchanged; `db query` leaves no ledger row per DECISION-0128):

| Subject | Topics | Four-field words before -> after | Approval |
|---|---|---|---|
| Chemistry 1.5 (test) | 1 | n/a | PR 645 |
| Statistics units 1-5 | 55 | 10,756 -> 9,569 | APPROVAL-0262 |
| Biology units 1-5 | 33 | 6,643 -> 5,802 | APPROVAL-0263 |
| Chemistry units 1-5 (excl. 1.5) | 47 | 8,374 -> 7,331 | APPROVAL-0264 |

- Rollout files: `scripts/content-seed/structured-explainers-2026-11-13/` (tools.py with validate / migration / check; per-subject current.json pre-apply snapshot, proposed_all.json, migration.sql, README, RULINGS, checker output). Test topic files: `scripts/content-seed/ap-chemistry-explainer-u1-1-5-structured-test-2026-11-12/`.
- Process used: authored in session (no gateway authoring), checked by two non-Claude families (openai/gpt-6.1-sol, moonshotai/kimi-k3.1-pro) with planted-defect controls; Claude arbitrated flags. deepseek-v4-pro returned empty output and was dropped.

## Verification state

- #1 confirmed across all 355 topics in units 1-5 (one Precalculus Unit 4 repeat fixed in PR 58).
- Live bundle check (2026-11-13): the published app's DeepDiveOverlay chunk and stylesheet contain the PR 40, 59 and 60 markers (table wrapper, steps, "In 30 seconds", toggles). So PR 60 is published. PR 58 could not be confirmed from minified code.
- Not verified: no signed-in visual render of any structured topic. Suggested spot checks: Chemistry 1.5, Chemistry 3.8, Statistics 3.2, Biology 2.3.

## Open items

1. Commit the digestibility analysis doc (and this one) in a docs PR; docs-only PRs may be merged by Claude when CI is green.
2. Signed-in visual check of structured topics (tables on phone width, list markers, no raw `-` or `|` showing).
3. #2 phase 2: authored `quick_take` field (needs schema migration, DECISION-0099 regeneration, approvals). Current block is derived from existing fields.
4. No human review yet of the Statistics, Biology and Chemistry structured text.
5. Subjects beyond Stats, Bio, Chem, and units beyond 1-5, are not structured. Each Production write needs explicit per-subject approval.
6. Image policy (section 3 of the analysis doc): need-based, no fixed figure count, no placeholder, figures next to the content they explain, alt text required, 0119/0120 size floor kept.

## Constraints to keep

- Code PRs go to David to merge; no Lovable publish or Supabase/content writes without approval.
- No hand-patching generated content; author in session, gateway only checks.
- Never print the AI Gateway key. Do not commit dev-harness files.
- Production CLI: `supabase db query --linked --workdir /Users/davidbloom -f file.sql -o json` (ref pcntajvbdfqhbeewmdry; confirm with --debug). Dev ref wmgjsdkphcyhngaffbqf.
- Check open PRs before numbering approvals (next number after 0264, verify).
- Worktrees: .worktrees/app-cheatsheet-dedupe (app repo), .worktrees/chem15-structured, .worktrees/approval-0262 (content repo). The main checkout was on another session's branch; leave it alone.

## Status update: open item 3 (#2 phase 2, authored `quick_take`), design draft, 2026-11-13

Status: DESIGN ONLY. Nothing written to Dev or Production; no migration file created. Awaiting David's go-ahead on the design below.

Findings
- `docs/INDEX.md` has no entry for the cheat sheet or `quick_take`; the nearest canonical doc is `docs/product/TOPIC_BRIEFS_AND_LEARN_MORE_PRODUCTION_PROTOCOL.md` (covers `app.topic_explainers` and its public view).
- Today's block (app `quickTake` in `src/lib/deep-dive-export.ts`) takes `firstSentence` of answer move, common point loss and the first "Remember it" hook, needs >=2 items, max 60 words per sentence. It can pick a weak opening sentence (e.g. a scene-setter) because nothing is rewritten.
- Approvals on main already run to APPROVAL-0268, and open PR 649 touches TASK-0050. The next free number must be re-checked at write time (0269 or later).

Proposed design
1. Schema: add one nullable column `quick_take text` to `app.topic_explainers` (default null, no backfill required), plus a check that it is null or non-empty. Recreate `public.topic_explainers` view and `get_topic_point_guides` output in the same migration (per the public-view column drift rule). Nullable means the frontend keeps today's derived block as the fallback, so rollout can be per subject with no breakage.
2. Format: three lines, one per existing label, stored as `The answer move: ...` / `How points are lost: ...` / `Remember it: ...`, each one sentence, <=25 words (stricter than the 60 now). Newline-separated, so the renderer splits on lines and reuses the label styles. Memory-hook line only if a published hook exists; otherwise two lines (still meets the >=2 rule).
3. Authoring (DECISION-0099 / author-in-session): Claude writes the text per topic from the topic's published explainer fields; two non-Claude checkers (same pair as the structured rollout) verify each line is supported by the topic's own fields (no new facts), <=25 words, not a near-duplicate of the card it summarises (C13 overlap rule at 0.80 applies), with planted-defect controls. Claude arbitrates flags; no hand patches.
4. Rollout order: Chemistry 2.1 as a test topic in Dev, visual check, then Statistics / Biology / Chemistry units 1-5 each under its own approval. Production writes only with explicit per-subject approval, same per-row md5 guard and independent read-back used for APPROVAL-0262 to 0264.
5. Frontend: small app PR (goes to David): prefer `quick_take` when present, else the derived block. Copy/export path already handles the block.

Illustrative sample (not authored, not checked; Chemistry 2.1, shape only)
- The answer move: Name the bond type, then back it with an electronegativity comparison.
- How points are lost: Calling a bond ionic or covalent by metal/nonmetal alone, with no electronegativity difference.
- Remember it: (published hook for 2.1, if any)
Real text must be written from the topic's actual `answer_move` / `common_point_loss`, which were not re-read in this session.

Questions for David
- Approve the nullable-column-plus-fallback design and the 25-word cap?
- OK to apply the migration to Dev only (confirm ref wmgjsdkphcyhngaffbqf, `--workdir` pinned to the repo) and author Chemistry 2.1 as the test topic?

### Update: Dev applied (David approved "Dev only" 2026-11-13)
- Dev only (ref wmgjsdkphcyhngaffbqf, confirmed by --debug and `--workdir` pinned to repo). Production untouched; no approval number used yet.
- Applied `scripts/content-seed/quick-take-2026-11-13/migration_dev.sql`: nullable `app.topic_explainers.quick_take` (+ non-empty, <=400 chars check), `public.topic_explainers` view recreated with the column appended (security_invoker/barrier kept, grants verified), `get_topic_point_guides` explainers now carry `quickTake`. The function body is Dev's live definition plus one key; Prod's function may differ (see the skew note in memory), so diff md5 against Prod before any Prod migration. Via `db query`, so no ledger row (DECISION-0128).
- Authored Chemistry 2.1 (Dev only): two lines (no published hook exists for 2.1), 14 and 12 words, both drawn from the topic's own answer_move and common_point_loss. Apply script and proposal in the same folder.
- NOT done: the two non-Claude checker pass (gateway) was not run for this single test row; only the word cap and source-faithfulness by my own reading. No frontend change yet (app must prefer `quickTake`; app PR goes to David). No visual check.
- Next: app PR for preference + fallback; checker pass before authoring other topics; per-subject Production approval and a Prod migration file in supabase/migrations.

### Update: app PR opened
- App PR 61 (david-bloom/ap-prep-blueprint, branch claude/quick-take-field, worktree .worktrees/app-quicktake): frontend prefers `quickTake`, falls back to the derived block. Not merged, not Lovable-published, no visual check. Safe before the Prod migration (absent field = unchanged behaviour). Goes to David to merge.

### Update: quick_take authored for Chem, Bio, Stats units 1-5; ready for Production, NOT applied
- Folder: `scripts/content-seed/quick-take-2026-11-13/` (README has the full checks, weak spots and Prod steps). 136 topics authored in session (Chem 48, Bio 33, Stats 55), two checker families plus planted controls, 24 topics revised after flags and rechecked.
- Verified: Dev rehearsal 136/136 byte-equal; Production's function and view definitions were identical to Dev's pre-change; Dev source-field md5s equal Production's for all 136 rows. Production only read, never written.
- Schema file added: `supabase/migrations/20261113150000_topic_explainers_quick_take.sql` (idempotent, same as the Dev-applied one). Uncommitted.
- Waiting on David's explicit go for the Production write (approval number to be assigned then; main shows 0268 and other branches hold 0269-0271, so likely 0272, re-check). Students see nothing until app PR 61 is merged and published.

### Update: quick_take LIVE in Production (APPROVAL-0272, David approved 2026-11-13)
- Applied to Production (ref pcntajvbdfqhbeewmdry, confirmed with --debug): schema, RPC key `quickTake`, and `quick_take` on 136 topics (Chem 48, Bio 33, Stats 55, units 1-5). Read back 136/136 byte-equal, source fields unchanged, 603 published explainers total unchanged.
- With the earlier items, proposals #1-#5 are done for Chem, Bio and Stats units 1-5 in content, but #2 only becomes visible once app PR 61 is merged and published to Lovable (David's call; code PR). Until then students see the derived block.
- Record: `docs/activity_log/APPROVAL-0272_...md` plus index lines in APPROVALS_LOG and ACTIVITY_LOG, all uncommitted on branch claude/chem-unit2-explainer-rewrite-2026-10-31 (unrelated to this work; commit on a fresh branch from main). The log lines will need union-merging with other open approvals (0269-0271 exist on other branches).
- Still open: signed-in visual check, human review of the text, other subjects/units, the weak spots in the README, a 'Remember it' line only exists for Chem 1.5 and Stats 1.9.

### Update: app PR 61 merged (David, 2026-11-13)
- Merged to app main. Lovable publish not confirmed by this session; students see the authored quick_take only after publish. Not visually checked.

### Update: Lovable publish reported by David (2026-11-13); not independently verified
- David said PR 61 was published on Lovable. This session could not confirm it: the app redirects signed-out visitors to cramapple.com/login, and the lazy app chunks that would contain `quickTake` load only after sign-in. Still needed: a signed-in look at Chemistry 2.1 (expect the two authored lines) and Statistics 1.9 or Chemistry 1.5 (three lines).

### Update: live app check (signed in via David's Chrome, 2026-11-13)
- app.cramapple.com Chemistry 2.1: "In 30 seconds" shows the two authored lines; the structured Core idea, What to understand and How points are earned render as bullets and numbered steps with no raw `-` or `|`. Chemistry 1.5: three authored lines incl. "Remember it" diagonal rule. Calculus AB 1.1 (not authored): derived block still shows. So PR 61 is published and the fallback works.
- Not checked: tables (Chem 2.1 point-attaining answer sits in the worked example, collapsed), phone width, Statistics and Biology topics.

### Update: table check, a layout defect found (2026-11-13)
- Chemistry 2.1 Worked example expanded at about 1456px wide: the Point-attaining answer table renders in the narrow right column beside the Weak answer and breaks words mid-word in its headers ("Bo/nd", "Electr/onega/tivitie/s", "Diff/ere/nce"), so it is hard to read. Cause looks like the side-by-side compare layout plus table cells that wrap at any character. Not fixed (app code; goes to David). Options: stack weak and strong answers when the strong one contains a table; stop mid-word breaks and let the table scroll horizontally inside its wrapper. Phone width not checked and is likely worse.

### Update: worked example removed from the Cheat Sheet (David's decision, 2026-11-13)
- David: the worked example adds nothing to the cheat sheet; remove it. App PR opened (branch claude/cheatsheet-drop-worked-example, worktree .worktrees/app-no-worked-example): no longer maps Mini example / Weak answer / Point-attaining answer into the notes, so the disclosure, the two jump links and the copy export lose them. This also removes the narrow-column table defect noted above. Data untouched; `point_attaining_answer` is still the field restructured under APPROVAL-0262 to 0264 and stays in the database; whether anything else reads it was not checked. Not merged, not published, not visually checked. Dead compare code left for a follow-up.

### Update: audit of proposals 1-5 for Chem, Bio, Stats units 1-5 (2026-11-13)
- Production data (read-only, 136 published topics: Chem 48, Bio 33, Stats 55): all 136 have structured text in the four fields and the structured source_note; 0 over the field caps; all 136 have a well-formed quick_take.
- Live app sampled (Stats 3.2, Bio 2.3, Chem 3.8, earlier Chem 2.1 and 1.5): In 30 seconds shows authored text, bullets and steps render, Full notes are toggles. After app PR 62 merged (17:07 UTC) and David said it was published, the live app STILL showed the Worked example disclosure and the two jump links on Chem 3.8 after a hard reload. So PR 62 is not live yet (publish not propagated, or not actually published).
- #4 is tooling (PR 578, merged 2026-10-31); the C13 overlap check was not re-run on the 136 rewritten rows.

### Update: #1 re-executed on Chem, Bio, Stats units 1-5 (2026-11-13)
- Audit of Production (read-only) for the 136 topics after the rewrites: no exact repeats between the six cards; sentence-level overlap (word overlap >= 0.8 between any two cards) found one case, Statistics 5.1 (answer move vs practice bridge, which share a card); at 0.6-0.8 two more, Statistics 4.6 and 5.5, same pair. Brief/explainer twins are already suppressed by the app. All three are the bridge restating the answer move.
- Fix is in the app, not the data: app PR (branch claude/cheatsheet-bridge-near-twin) hides a bridge with word overlap >= 0.7 against the answer move, point loss or how-points-are-earned. On all 603 published explainers it affects exactly four: Stats 4.6, 5.1, 5.5 and Precalculus 3.9. Not merged, not published, not visually checked. No Production write, no approval number needed.
- Not covered: the live app was still showing the worked example after PR 62 (see the audit update above); the quick_take lines repeat card content by design.

### Update: #1 and #3 for the remaining subjects, Dev applied, Production NOT applied (2026-11-13)
- #1 needs no content work: the rule (PR 63) is in the app and was measured on all 603 published explainers.
- #3: 317 topics reshaped (Biology 6-8: 27; Chemistry 6-9: 43; Calculus AB: 35 of 81, units 1, 6, 7, 8 skipped as one-idea templated text; Calculus BC: 111; Physics 1: 43; Precalculus: 58). Physics 2 and Physics C excluded by David. Files: `scripts/content-seed/structured-explainers-rest-2026-11-13/` (current_*.json from Production, proposed_*.json, migration_*.sql, RULINGS.md, check_out/).
- Checked by gpt-6.1-sol and kimi-k3.1-pro with a planted control (caught by both). 4 real defects fixed (Bio 7.2, 7.10; BC 5.11, 5.12), 11 separator-row findings ruled non-defects. Re-check clean.
- Applied to Development only (317 rows confirmed by source_note count; Production count 0). Production needs per-subject approval and an APPROVAL record.
- Source defect found, not changed: Calculus AB 5.6 (likely 5.7-5.9, 5.11) lost second-derivative primes (f'' reads f').
- Not done: no human review, no rendered check of the new text.

### Update: #3 LIVE in Production for the six remaining subjects (APPROVAL-0273, David approved 2026-11-13)
- 317 of 317 rows read back equal to the proposed text. Production now holds structured text for every subject except Physics 2 and Physics C (excluded). No app publish needed.

### Update: Calculus AB lost primes repaired in Production (APPROVAL-0274, 2026-11-13)
- AB 5.6, 5.7, 5.8, 5.9, 5.11 restored and read back 5/5 (weak_answer 3/3). Only concavity/second-derivative topics were scanned.
