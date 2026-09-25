-- Fixes the 2 P0 findings Codex's remediation-verification pass (PR #190,
-- docs/content/CODEX_QA_REPORT_P0_REMEDIATION_VERIFICATION_2026_09_25.md) found still open after the
-- 34-item remediation (migrations 20260925070000-20260925130000). Codex explicitly flagged these as
-- requiring a separate authorized Production write, since its own task was read-only/report-only.
--
-- 1. apphy1-frq-026: the earlier remediation fixed the b-time criterion's `learner_facing_text` (and the
--    canonical) to say arrival order depends on track geometry, but never touched the same row's
--    `evidence_requirements`, which still literally required the response to "conclude Track A finishes
--    first" -- the original false grading requirement survived in Production despite the learner-facing
--    text being corrected. Fixed `evidence_requirements` to match.
--
-- 2. apstats-frq-u12-020: the earlier remediation raised South's stimulus SD from 3.1 to 5.8 (resolving
--    the original mathematical-impossibility defect) but only ASSERTED, without computing, that the
--    corrected post-error-fix South SD "could be close to, or even below" North's 3.1. Codex
--    independently recomputed this exactly from the given summary statistics (replacing the erroneous
--    40-lb entry with the true 8.0-lb value, holding the other 39 South values fixed, as the item's own
--    single-data-entry-error narrative implies): Σx²=(n-1)s²+n·mean²=39(5.8)²+40(12.4)²=7462.36 before
--    correction; substituting 8 for 40 gives Σx'²=7462.36-40²+8²=5926.36 and mean'=11.6; corrected
--    variance s'²=[5926.36-40(11.6)²]/39≈13.95, so s'≈3.735. This is still ABOVE North's 3.1, not below
--    it -- the previous fix's hedge ("plausibly... even below") was wrong. The canonical's final
--    paragraph had also drifted into a claim that directly contradicted this (spread "differs more than
--    originally reported," when the corrected 3.735-vs-3.1 gap is actually much SMALLER than the
--    original, impossible 5.8-vs-3.1 comparison). Independently re-verified Codex's arithmetic before
--    applying; rewrote both the canonical's SD-comparison paragraph (showing the full recomputation, not
--    just the answer) and its closing paragraph, plus the underlying frq_criteria row's
--    `learner_facing_text` and `evidence_requirements`, which still described the earlier, superseded
--    "smaller than North" / "identical originally reported SDs" framing.
--
-- Verified post-apply: span concatenation still equals canonical_answer_1 for apstats-frq-u12-020;
-- neither the stale "even below" hedge nor the contradictory "differs more than originally reported"
-- claim remain in the canonical text; neither rubric row still contains its superseded claim.

begin;

update app.frq_criteria
set evidence_requirements = 'Explicitly states that speed-at-a-given-height is the same on both tracks, correctly identifies path length/height-profile (not speed) as the source of any time difference, and concludes that which track finishes first depends on the specific track geometry rather than being determined by the qualitative descriptions given here alone.'
where content_item_version_id = '3860d78d-4c4c-4505-bfc1-8db4ba0bbf45' and criterion_key = 'b-time';

update app.canonical_answer_spans
set span_text = 'South''s reported standard deviation (5.8) was already larger than North''s (3.1) before the correction, partly driven by the erroneous 40-pound entry. Recomputing exactly from the given summary statistics with 40 replaced by 8 (holding the other 39 South values fixed, as the single-entry-error scenario implies): Σx²=(n-1)s²+n·mean²=39(5.8)²+40(12.4)²=7462.36, so after the substitution Σx''²=7462.36-40²+8²=5926.36 and the corrected mean is x̄''=(496-40+8)/40=11.6. The corrected sample variance is s''²=[Σx''²-n(x̄'')²]/(n-1)=[5926.36-40(11.6)²]/39≈13.95, giving s''≈3.735. This corrected South SD (≈3.735) is still somewhat larger than North''s 3.1, but the gap shrinks substantially -- from 5.8-3.1=2.7 before correction to about 3.735-3.1=0.6 after -- so the two facilities'' spreads become noticeably more similar once the data-entry error is corrected, even though South''s spread remains slightly larger.'
where content_item_version_id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670' and answer_field='canonical_answer_1' and criterion_keys = array['part-c-criterion-03'];

update app.canonical_answer_spans
set span_text = 'The centers (mean and median) of the North and South distributions remain fairly similar even after the correction (South''s mean shifts down only slightly, and its median may shift somewhat but stays in a comparable range to North''s). Combined with the corrected SD comparison above, the two facilities turn out to be broadly comparable in both typical package weight and spread once the data-entry error is corrected -- much more similar than the original (impossible) summary statistics suggested, though South''s spread remains modestly larger than North''s.'
where content_item_version_id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670' and answer_field='canonical_answer_1' and criterion_keys = array['part-c-criterion-04'];

update app.content_item_versions
set canonical_answer_1 = (
  select string_agg(span_text, '' order by span_ordinal)
  from app.canonical_answer_spans
  where content_item_version_id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670' and answer_field='canonical_answer_1'
)
where id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670';

update app.frq_criteria
set learner_facing_text = 'Recomputes the corrected South SD exactly from the given summary statistics (replacing 40 with 8, holding the other 39 values fixed) to get approximately 3.735, and concludes this remains somewhat larger than North''s 3.1 -- the gap in spread shrinks substantially after correction but does not close or reverse.',
    evidence_requirements = 'Response performs the exact recomputation (or an equivalent correct approach) rather than asserting an unverified direction, and correctly concludes that the corrected South SD (~3.735) is still larger than North''s SD (3.1), though the gap is much smaller than the pre-correction 5.8-vs-3.1 comparison.'
where content_item_version_id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670' and criterion_key = 'part-c-criterion-03';

commit;
