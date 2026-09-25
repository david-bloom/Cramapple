-- Remediation of the first 4 of 34 P0 findings from the canonical-answer QA report
-- (docs/content/CODEX_QA_REPORT_CANONICAL_ANSWERS_CALC_AB_THROUGH_PHYSICS_1_2026_09_25.md, PR #188).
-- Prioritized per user instruction: the two AP Statistics numerical/source-data defects, then the two
-- P0s found within this week's own new canonical-answer writes (apphy1-frq-054, apphycem-frq-038).
--
-- 1. APSTAT-MOD4-H001-INV: the stem states "a significant result (p is approximately 0.014)" for a
--    one-sided test (Ha: mu_treatment < mu_control), but 0.014 is the two-sided p-value for the
--    computed t ≈ -2.56 with Welch df ≈ 46.5. The correct one-sided p-value is ≈ 0.007. Fixed both the
--    stem's stated value and the canonical's part (c)/(d) text, which had parroted the incorrect 0.014
--    instead of independently deriving it. Reject/not-reject conclusion at α=.05 is unchanged.
--
-- 2. apstats-frq-u12-020: the stimulus table reported South facility n=40, mean=12.4, SD=3.1, max=40.0.
--    These are mathematically incompatible: (n-1)*SD^2 = 374.79, but the single max observation alone
--    contributes (40-12.4)^2 = 761.76 to that sum -- already double the reported total. Raised South's
--    stimulus SD to 5.8 (comfortably above the ~4.42 minimum required for internal consistency with the
--    given mean/n/max) and rewrote the canonical's SD-comparison paragraph (part-c-criterion-03), which
--    had depended on North and South's reported SDs appearing identical (both 3.1) -- with the corrected
--    5.8 they are not, so the paragraph's comparison logic was rewritten accordingly, not just the number.
--
-- 3. apphy1-frq-054: the stem's part (a) explicitly asks students to "Determine the horizontal and
--    vertical components of the initial velocity, v0x and v0y," but the canonical only ever computed
--    v0y numerically (16.07 m/s) and never stated v0x. Added v0x = 25.0*cos(40.0°) ≈ 19.15 m/s to the
--    same paragraph. Note: frq_criteria has no dedicated criterion for the component pair itself (only
--    a-symbolic-range/a-time/a-height/a-range), so this is a completeness fix to the canonical answer
--    matching what the stem asks, not a rubric change.
--
-- 4. apphycem-frq-038: part (a)'s canonical asserted "this corresponds to a definite current direction
--    around the loop (describable unambiguously...)" without ever stating what that direction is.
--    Derived it directly from F=qv×B on the rod's positive charge carriers (v rightward, B downward):
--    current flows counterclockwise around the loop when viewed from above (looking down, along B).
--    Replaced the vague assertion with the actual stated direction and its derivation.
--
-- All four fixes verified post-apply: span concatenation still equals canonical_answer_1 byte-for-byte,
-- and each version's covered criterion_keys still exactly match its frq_criteria set (4/4, 10/10, 6/6,
-- 8/8 respectively -- no criterion added, removed, or reassigned by these edits).

begin;

update app.content_item_versions
set stem = replace(stem, 'p is approximately 0.014', 'p is approximately 0.007')
where id = 'b045075d-724f-4248-8a3b-e0f0c68e82a0';

update app.canonical_answer_spans
set span_text = '(c) Testing H0: mu_treatment = mu_control against Ha: mu_treatment < mu_control (since the claim is that exercise reduces heart rate), with treatment mean=68 (SD=6, n=25) and control mean=72 (SD=5, n=25): the two-sample t-statistic is t = (68-72)/sqrt(6^2/25 + 5^2/25) = -4/sqrt(36/25+25/25) = -4/sqrt(2.44) = -4/1.562 ≈ -2.56. Using the Welch-Satterthwaite approximation, the degrees of freedom are df ≈ 46.5. For this one-sided (lower-tail) test, t ≈ -2.56 with df ≈ 46.5 gives a p-value of approximately 0.007. Since p ≈ 0.007 < alpha = 0.05, we reject H0 and conclude there is significant evidence that the exercise program reduces resting heart rate.'
where content_item_version_id = 'b045075d-724f-4248-8a3b-e0f0c68e82a0' and answer_field='canonical_answer_1' and criterion_keys = array['hypothesis_test_execution'];

update app.canonical_answer_spans
set span_text = '(d) A statistically significant result (p ≈ 0.007 < 0.05, from the one-sided test conducted in part (c)) means the observed difference is unlikely to be due to chance alone -- but this is a separate question from whether the difference is practically/clinically meaningful. A 4 bpm difference in resting heart rate (68 vs 72) is a real but fairly modest physiological change; whether it matters clinically depends on context (e.g., for most healthy young adults, this might be a nice-to-have improvement, but for patients with cardiovascular risk factors, even a small consistent reduction could be clinically relevant). Statistical significance tells us the effect is probably real; practical significance asks whether the size of that real effect is large enough to matter for decisions.'
where content_item_version_id = 'b045075d-724f-4248-8a3b-e0f0c68e82a0' and answer_field='canonical_answer_1' and criterion_keys = array['significance_interpretation'];

update app.content_item_versions
set canonical_answer_1 = (
  select string_agg(span_text, '' order by span_ordinal)
  from app.canonical_answer_spans
  where content_item_version_id = 'b045075d-724f-4248-8a3b-e0f0c68e82a0' and answer_field='canonical_answer_1'
)
where id = 'b045075d-724f-4248-8a3b-e0f0c68e82a0';

update app.content_item_versions
set stimulus = replace(
  stimulus,
  'South | 40 | 12.4 | 3.1 | 2.0 | 10.5 | 12.5 | 14.0 | 40.0',
  'South | 40 | 12.4 | 5.8 | 2.0 | 10.5 | 12.5 | 14.0 | 40.0'
)
where id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670';

update app.canonical_answer_spans
set span_text = 'South''s reported standard deviation (5.8) was already noticeably larger than North''s (3.1) before the correction, in part driven by the erroneous 40-pound entry. After removing that extreme value, the corrected South SD would drop -- plausibly landing close to, or even below, North''s 3.1 -- so the two facilities'' true spread is likely far more similar than the pre-correction summary statistics suggested.'
where content_item_version_id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670' and answer_field='canonical_answer_1' and criterion_keys = array['part-c-criterion-03'];

update app.content_item_versions
set canonical_answer_1 = (
  select string_agg(span_text, '' order by span_ordinal)
  from app.canonical_answer_spans
  where content_item_version_id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670' and answer_field='canonical_answer_1'
)
where id = '3449fff0-009e-4ffc-ac1f-ef1c77c0b670';

update app.canonical_answer_spans
set span_text = 'Numerically: v0x = 25.0*cos(40.0°) = 25.0*0.7660 ≈ 19.15 m/s, and v0y = 25.0*sin(40.0°) = 25.0*0.6428 ≈ 16.07 m/s. Time of flight t = 2*v0y/g = 2*(16.07)/9.80 ≈ 3.28 s.'
where content_item_version_id = '4c283652-3ddd-4d93-99f7-186acbed682d' and answer_field='canonical_answer_1' and criterion_keys = array['a-time'];

update app.content_item_versions
set canonical_answer_1 = (
  select string_agg(span_text, '' order by span_ordinal)
  from app.canonical_answer_spans
  where content_item_version_id = '4c283652-3ddd-4d93-99f7-186acbed682d' and answer_field='canonical_answer_1'
)
where id = '4c283652-3ddd-4d93-99f7-186acbed682d';

update app.canonical_answer_spans
set span_text = 'Given the specified rail geometry, this current flows counterclockwise around the loop when the setup is viewed from above (looking straight down, in the same direction B points): using F=qv×B on the positive charge carriers in the rod (v to the right, B downward), the force drives conventional current across the rod toward the far rail in this bird''s-eye view, then along that rail toward the resistor, through the resistor, and back along the near rail to the rod -- consistent with the upward-pointing induced field identified via the right-hand rule.'
where content_item_version_id = 'b71c78c4-a9e7-442c-a174-8a591ef6bd66' and answer_field='canonical_answer_1' and criterion_keys = array['part-a-criterion-02'];

update app.content_item_versions
set canonical_answer_1 = (
  select string_agg(span_text, '' order by span_ordinal)
  from app.canonical_answer_spans
  where content_item_version_id = 'b71c78c4-a9e7-442c-a174-8a591ef6bd66' and answer_field='canonical_answer_1'
)
where id = 'b71c78c4-a9e7-442c-a174-8a591ef6bd66';

do $$
declare
  concat1 text; stored1 text; stem1 text;
  concat2 text; stored2 text; stim2 text;
  concat3 text; stored3 text;
  concat4 text; stored4 text;
begin
  select string_agg(span_text,'' order by span_ordinal) into concat1 from app.canonical_answer_spans where content_item_version_id='b045075d-724f-4248-8a3b-e0f0c68e82a0' and answer_field='canonical_answer_1';
  select canonical_answer_1, stem into stored1, stem1 from app.content_item_versions where id='b045075d-724f-4248-8a3b-e0f0c68e82a0';
  if concat1 is distinct from stored1 then raise exception 'concat mismatch for APSTAT-MOD4-H001-INV'; end if;
  if stem1 not like '%p is approximately 0.007%' or stem1 like '%0.014%' then raise exception 'stem not corrected for APSTAT-MOD4-H001-INV'; end if;

  select string_agg(span_text,'' order by span_ordinal) into concat2 from app.canonical_answer_spans where content_item_version_id='3449fff0-009e-4ffc-ac1f-ef1c77c0b670' and answer_field='canonical_answer_1';
  select canonical_answer_1, stimulus into stored2, stim2 from app.content_item_versions where id='3449fff0-009e-4ffc-ac1f-ef1c77c0b670';
  if concat2 is distinct from stored2 then raise exception 'concat mismatch for apstats-frq-u12-020'; end if;
  if stim2 not like '%South | 40 | 12.4 | 5.8%' then raise exception 'stimulus not corrected for apstats-frq-u12-020'; end if;

  select string_agg(span_text,'' order by span_ordinal) into concat3 from app.canonical_answer_spans where content_item_version_id='4c283652-3ddd-4d93-99f7-186acbed682d' and answer_field='canonical_answer_1';
  select canonical_answer_1 into stored3 from app.content_item_versions where id='4c283652-3ddd-4d93-99f7-186acbed682d';
  if concat3 is distinct from stored3 then raise exception 'concat mismatch for apphy1-frq-054'; end if;
  if stored3 not like '%v0x = 25.0*cos(40.0°)%' then raise exception 'v0x not added for apphy1-frq-054'; end if;

  select string_agg(span_text,'' order by span_ordinal) into concat4 from app.canonical_answer_spans where content_item_version_id='b71c78c4-a9e7-442c-a174-8a591ef6bd66' and answer_field='canonical_answer_1';
  select canonical_answer_1 into stored4 from app.content_item_versions where id='b71c78c4-a9e7-442c-a174-8a591ef6bd66';
  if concat4 is distinct from stored4 then raise exception 'concat mismatch for apphycem-frq-038'; end if;
  if stored4 not like '%counterclockwise%' then raise exception 'direction not stated for apphycem-frq-038'; end if;
end $$;

commit;
