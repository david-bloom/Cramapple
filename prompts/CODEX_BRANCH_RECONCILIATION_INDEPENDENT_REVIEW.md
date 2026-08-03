# Codex: independent review of the remaining branch-reconciliation plan

## Context

We audited every branch on this repo against `origin/main` (not local `main`,
which was found stale by 11 commits including PR #37 — verify this yourself,
don't take it on faith). Branches sorted into:

- **Category A** (merged into `origin/main`) — deleted, 33 branches local+remote.
- **Category B** (fully superseded by another branch, verified via
  `git merge-base --is-ancestor`) — deleted, same pass.
- **Category D** (single-commit orphans, never landed anywhere) — 2 of 5
  landed cleanly in PR #46 (still open, unreviewed). 1 verified genuinely
  redundant (byte-identical content already on `origin/main`), branch safe to
  delete without landing. 2 hit real conflicts (`claude/ux-007-progress-review`
  vs `codex/ux-001-student-portal`, both editing the same
  `prototypes/ux-001/index.html` in 6+ places) — flagged in the PR, not
  resolved, needs a product call on which UX iteration wins.
- **Category E** — discarded, deleted.
- **Category C** — real, currently-unmerged work needing reconciliation, not
  deletion. **This is what needs your independent review.** Nobody has
  attempted to merge any of these yet.

## Category C: the 8 branches

Verified against `origin/main` at the time of this writing (re-verify — don't
trust these numbers, confirm them yourself, since branches may have moved):

| Branch | Commits ahead of origin/main | Last commit | What it is |
|---|---|---|---|
| `codex/five-subject-harness-and-content` | 91 | 2026-07-21 | Content-preflight gate, Chemistry/Physics content pipeline, TASK-0017 harness. Checked out in a worktree at `/private/tmp/cramapple-content-qa`. **This is your own branch** — review it with the same skepticism you'd apply to anyone else's, not less. |
| `backup/task-0012-pre-rebase-20260630` | 24 | 2026-06-30 | Despite the "backup" name, this is the deepest tip of a real lineage (TASK-0012 production plumbing → QA fixes → confident-rubin → this). Contains SEO/Biology docs, review-portal proposals, TASK-0010/0011 research. |
| `origin/claude/ap-biology-stimulus-images-y9x86f` | 19 | **2026-07-21 (today)** | Assigning subjects for tutor review; stimulus-image work. Most recent commit of any branch in the repo — may be actively in-flight. Check before touching. |
| `origin/claude/cramapple-content-creation-igjvfb` | 14 | 2026-07-17 | Content-tab read fix, reviewer stage-label clarification. |
| `origin/claude/cramapple-grading-mlr0o1` | 12 | 2026-07-19 | "Allow reviewer roles to read content-assets; add stimulus_image_path column." **Flag:** our own active branch (`claude/cramapple-grading-experiments-9lkjqc`) independently landed its own stimulus-image fix (commits `25d9227`, `8ca2864`) — check whether these two are genuinely compatible or actually competing fixes for the same problem before recommending a merge order. |
| `claude/pull-gold-set-candidates` | 1 | 2026-07-20 | "Recover stranded gold-set-candidate artifacts onto main." |
| `claude/seed-chemistry-physics-content` | 1 | 2026-07-20 | "Recover AP Chemistry/Physics source packages + add loader script." Check for overlap with `five-subject-harness-and-content`'s own Chemistry/Physics content — these may now be redundant with each other. |
| `origin/claude/backend-migration-ob26x7` | 1 | 2026-07-09 | "Reconcile TASK-0012 migration drift and log admin-content defects." Check whether this migration-drift finding is already stale given the migration reconciliation work already done on `claude/cramapple-grading-experiments-9lkjqc` today (2026-07-21). |

## What "independent review" means here

Don't just confirm my categorization — actively try to break it:

1. **Re-verify containment/staleness yourself.** Re-fetch, recompute
   `git merge-base --is-ancestor` for anything you're not certain about. If
   `origin/main` or any of these branches moved since the table above, say so
   and redo the analysis against current state.
2. **For each branch, determine: is a clean merge actually possible, or will
   it conflict?** Don't just check `ahead`/`behind` counts — that tells you
   nothing about conflict risk. Do a trial merge or cherry-pick against
   `origin/main` in a disposable worktree (not your active
   `/private/tmp/cramapple-content-qa` checkout) and see what actually
   happens, the way we did for Category D. If it conflicts, characterize the
   conflict: is it a redundant-content conflict (safe to resolve toward
   whichever side is more current, verify nothing unique is lost) or a real
   competing-change conflict (needs a human call, don't resolve it yourself)?
3. **Specifically resolve the `cramapple-grading-mlr0o1` vs. our branch's
   stimulus-image question.** Read both sets of changes. Are they the same
   fix arrived at twice, complementary, or conflicting? Say which.
4. **Specifically resolve the Chemistry/Physics content question** between
   `claude/seed-chemistry-physics-content` and your own
   `five-subject-harness-and-content`. Is the former now fully subsumed by
   the latter (in which case: say so, recommend deleting it without merging),
   or does it have something the latter doesn't?
5. **Do not touch `origin/claude/ap-biology-stimulus-images-y9x86f`'s content
   or assume it's abandoned** just because it's old-ish in this list — it has
   today's date. Check whether it's still being actively worked (recent
   pushes, an open PR, anyone's session pointed at it) before including it in
   any merge recommendation.
6. **Propose a reconciliation order** — which branch first, which depend on
   which landing first, and why. Your own branch
   (`five-subject-harness-and-content`) is the biggest and most likely to be
   a prerequisite for others (it's the one causing the most friction
   elsewhere already — see `supabase/functions/_shared/content-preflight.ts`
   vs. `_shared/mcq-quality.ts` on `claude/cramapple-grading-experiments-9lkjqc`,
   two independent implementations of the same idea because the branches
   never reconciled). Don't assume that ordering — verify it.
7. **Where you find a real conflict requiring a product/ownership call
   (not a mechanical one), name it explicitly and stop there** — same
   discipline as PR #46: flag it, don't resolve it unilaterally. A merge
   that quietly picks a winner between two people's competing work is worse
   than an unmerged branch.

## Report back

- Confirmed/corrected version of the table above.
- Per-branch: merge cleanly / conflicts (redundant, safe to resolve) /
  conflicts (real, needs a human call) / already superseded, delete without
  merging.
- Answers to the two specific overlap questions (stimulus-image,
  Chemistry/Physics content).
- A proposed merge order with reasoning, explicitly flagged as a
  recommendation pending approval — not something you've executed.
- Anything you assumed or couldn't verify.
