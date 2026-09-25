# AP Statistics Pilot Pack — Unpublish, Additivity Check, and Double-Blind Content Review (2026-09-25)

## What was done

1. **Unpublished the pilot exam pack.** Set `retired_at = now()` on `app.exam_pack_versions.id =
   7c5a2975-8f0e-45b9-8fcc-7ec9b8d81ada` (the "pilot" pack: 203 MCQ, 0 FRQ, released 2026-08-26). This
   resolves the platform's only criterion-6 dual-published-version hazard
   (`docs/product/SUBJECT_SERVABILITY_CRITERIA.md`). Verified post-apply: this exam_pack_id now has
   exactly 1 live version (`548f06be-ccf4-426d-b82b-b424137a4438`, the reviewed general pack), and a
   platform-wide scan confirms no other exam_pack has more than 1 live version.
   - One caveat found during verification: `dbloom01@gmail.com`'s own profile had
     `active_exam_pack_version_id` pointing at the pilot pack. Not a real student (consistent with prior
     findings that Production has zero real students), but flagging it since that account will now see a
     retired pack if used for testing.

2. **Confirmed the pilot pack's content is additive, not copied.** Compared all 203 pilot items against
   the reviewed pack's 118 MCQ:
   - **Zero content_key overlap** (203 pilot keys, 0 also present in the old pack; the two packs use
     entirely different naming conventions — `apstat-<category>-<id>` for the pilot vs `APSTATS-MCQ-NNN`
     for the old pack).
   - **Zero exact stem-text overlap** with the old pack's 118 MCQ.
   - This is genuinely new content, not a re-import of existing questions.

3. **Found and characterized internal duplication within the pilot pack itself** (not part of the
   original ask, but surfaced while checking additivity): 203 rows contain only **151 distinct question
   stems** — 52 rows are exact byte-for-byte re-saves of a question already present under a different
   `content_key` (up to 5 copies of some questions). Checked whether duplicate-stem items ever disagree on
   their correct answer — **they don't**: every group of duplicate stems shares the same marked-correct
   choice. This is redundant storage (likely a content-generation run saved without deduplication), not
   conflicting content. It does not need review (reviewing byte-identical text twice adds no signal); it
   needs cleanup — deleting the 52 redundant rows — as a separate, simple follow-up, not addressed here.

## Double-blind review of the 151 distinct questions

Since the content proved additive, ran a genuine double-blind review: two independent Claude agents,
launched in isolated environments with identical instructions and no visibility into each other's
progress or output, each independently re-derived the correct answer for all 151 unique MCQ items
(stem + 4 choices + distractor rationales) *before* looking at which choice was marked `is_correct`, then
compared.

**Result: both passes returned 151/151 PASS, 0 findings (0 P0, 0 P1, 0 P2) — and the two passes agree with
each other on every single item's derived answer.** Diffed both reports programmatically (not just
compared summary counts): identical set of 151 `content_key`s reviewed by both, zero answer mismatches
between the two passes.

Method both passes used:
- **Arithmetic-heavy categories** (mean/median/IQR comparisons, LSRL predictions, histogram bin counts,
  five-number-summary shape/outlier logic, 1.5×IQR boxplot fence construction — roughly 113 of the 151
  items) were independently recomputed from the raw numbers in each stem, not just visually checked.
- **Conceptual categories** (sampling-method identification, bias-type identification, experimental-design
  vocabulary, variable classification — the remaining ~38 items) were re-derived against standard AP
  Statistics definitions before checking the marked answer.
- Distractor rationales were spot-checked in both passes and found to accurately describe the specific
  error each represents (e.g., range-vs-IQR confusion, n vs n−1, reporting one group's statistic instead
  of the difference, mean-vs-median confusion).
- No stem was found ambiguous, unanswerable, or containing a meaning-changing typo, in either pass.

One non-defect note from Pass B: the "reported a standard deviation" distractors in the `summary_stats`
category use the population (÷n) SD formula rather than the sample (÷(n−1)) formula, but since the
rationale text doesn't specify which formula, this isn't flagged as an error — just noted for awareness.

## Bottom line

The pilot pack's 151 unique MCQ items pass independent double-blind content review cleanly. This is
necessary but not sufficient for launch readiness — this review covered content *correctness* only (MCQ
answer/rationale quality), not the pack's other gaps: it has 0 FRQ (so it cannot support the same practice
modes as the general pack without substantial additional authoring), 0 serving labels, 0 difficulty rows,
and the 52 duplicate rows described above still need cleanup. The pack remains retired
(`retired_at` set) pending a decision on whether/how to build it out further or fold its 151 clean
questions into the live pack.
