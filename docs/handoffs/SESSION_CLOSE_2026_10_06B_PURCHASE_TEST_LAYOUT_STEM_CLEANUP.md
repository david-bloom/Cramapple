# Session Close (part 2) — 2026-10-06/07: live purchase test, Deep Dive + pane layout, stem cleanup

**Follows:** `SESSION_CLOSE_2026_10_06_OPEN_HAND_LIVE.md`. Same session and branch.
**Next owner:** David Bloom.
**Single best next action:** **publish the Lovable build.** The latest edit is `9ecbee88` and it bundles three
reviewed changes; see section 2. Then repeat the Practice check in section 5.

## 1. Live test results (David, anonymous Safari)
- **Purchase:** completed with Apple Pay and a coupon. Pass.
- **Diagnostic removal:** `/session/setup` redirects to Home. Home "Start" opened Open Hand (Chemistry 1.1). Pass.
- **Open Hand:** the answer key and rationales are visible on load. Each rationale appears once, with no "Fix:"
  duplicate, and the screen reads "Not scored". Pass.
- **Spotted on that screen, not yet fixed:**
  - An empty "Vocabulary" heading.
  - The title appears twice.
  - Formatting in the explainer text ("--", "6.022x10^23").
  - The item is an older spare, not one of the 91 new ones, and its rationales lack the "why it tempts + Fix:" pattern.
- **Practice:** a wrong answer is graded and the correct answer is revealed. David's feedback from that screen
  drove sections 2 and 3.

## 2. Lovable — built and reviewed, NOT yet published
Lovable bundles three edits, in order:

1. **`303953a7` — Deep Dive content restored.**
   - Commit 450e107d had switched the Deep Dive to explainer-first fields. Since then the brief's "What it is",
     "Why it matters" and "How points are earned" were dropped whenever an explainer existed, and the explainer's
     mini example, weak answer, point-attaining answer and practice bridge never appeared.
   - The Deep Dive now has two bands: "From the worked example" (the 5 sections plus the title) first, then
     "Full deep dive" (every authored field, with duplicates and empty fields skipped).
   - The overlay scrolls. The data shape was verified against `fetchTopicGuides`.
2. **`f1106dff` — pane layout, answer key, tints.**
   - **Left pane:** separate "Rubric" and "How points are earned and lost" buttons.
   - **Right pane:** Reference Materials, then a "Show me the deep dive" button. This applies on Practice MCQ, Practice
     FRQ and Open Hand; Open Hand is ungated.
   - **Answer key:** Practice now restores the post-grading answer key (regressed in aec926a) beneath the buttons.
     Each row shows Correct or Distractor with the choice text; the rationales stay in the question pane only.
   - **Tints:** distractor rows are light red and the correct row is light blue. The student's pick shows "Your answer".
3. **`9ecbee88` — fixes after review.**
   - The Rubric hint receipt was counted twice; it is now counted once.
   - The FRQ Rubric gate is hidden when the item has no criteria.
   - The item's own `scoringNote` is restored; the generic one-point line is only a fallback.
   - The selected-row border shows on top of the tint.
   - The stray "Open the deep dive" link on the Open Hand placeholder is removed.

Lovable reports 614 tests passing, and typecheck and build are clean.

## 3. Product feedback recorded (David) — roadmap, not built
- **Formula support:** give students the formula (formula card, or a reference entry by topic). The trigger was a
  missed n = m/M item.
- **Feedback quality:** "What is the question actually asking you to find…" is generic and unhelpful.
  - Proposed model: for each wrong answer, author three things: the likely slip, a five-second check that would catch
    it (an estimate or a units check), and one reusable habit. Drop the "Incorrect. This…" echo.
  - Example, glucose item, pick 0.250: "You divided by about twice glucose's molar mass. Quick check: 90 g is half of
    180 g, so expect about half a mole. Habit: estimate before you calculate."
  - This needs a content pipeline pass (the TASK-0065 generate-and-select pipeline fits).
- **Older spare teaching items (95):** they predate the named-trap rationale standard. Consider replacing them via
  the pipeline.

## 4. Production change — stem cleanup (APPROVAL-0128)
- **Defect:** 198 published MCQs repeated their choices as a trailing `A. … D. …` list in the stem (Chemistry 68,
  Calculus BC 42, Calculus AB 26, Physics C Mechanics 22, Physics C E&M 20, Physics 2 20). All 198 are cleaned. The 7
  items with an assumption line after the list keep that line.
- **Label carry-forward:** serving labels were carried forward in the same statement as each edit. A bare edit would
  have pulled 148 items from Practice.
- **Verified:** labels are unchanged, servable stays at 148, and 0 inline lists remain.
- **Records:**
  - Production records this change as `APPROVAL-0127`. It was renumbered to 0128 in the log because another session
    claimed 0127 first.
  - Files: `scripts/content-seed/stem_choice_cleanup_2026_10_06/` (`REPORT.md`, `APPLY_LOG.md`, snapshot, rollback).
  - PR #357 (merged).

## 5. Next actions, in order
1. **David:** publish Lovable. Then answer one Practice question wrong on purpose and check:
   - Left pane: Rubric and How-points buttons, with the answer key beneath them.
   - Red and blue tints, and "Your answer" on the pick.
   - Deep Dive under Reference on the right, with two bands.
2. **Lovable polish (small):**
   - Hide empty sections such as the Vocabulary heading.
   - Remove the duplicate title line.
   - Fix "--" and caret exponents in explainer text. That is a content cleanup in `topic_explainers`, and may need
     a pass of its own.
3. **Content:**
   - Biology Unit 1 practice MCQs: the plate loop's biggest gap.
   - The "slip / check / habit" feedback pass.
   - Replace the older spare teaching items.
4. **Guard the import path:** `enforce_mcq_stem_choice_sync` misses identical inline copies of the choice list.
5. **Housekeeping:**
   - Drop Development table `public.scc_rehearsal_chunks_20261006` from the SQL editor; the DROP timed out
     through the MCP.
   - Two stems end in "--" (apphy2-mcq-010, apphycem-mcq-016).
   - Deploy `attempt-response` (the 409 mapping) via the CLI. This is still pending from part 1.

## 6. Repo hygiene this part
- **PRs merged:** #351 (generate-and-select pipeline) and #352 (Orly clean-room MCQs). I merged main into both and
  resolved the activity-log conflicts.
- **#351:** I added a "Reconciliation" section to TASK-0065. Units 1–3 are live via the hand-patch track; the
  pipeline's 18 Biology pilot items must not be loaded; the pipeline is for Units 4+.
- **#357:** merged.
