-- §9 verification pass on the Calc AB (23) and Statistics (48) draft
-- batches just assigned to Abdul Hanan / Shazia Fazal, 2026-08-09.
--
-- 4 parallel background agents ran independent re-derivation QA:
--   - AP Calculus AB (23 items): 22/23 clean, 1 defect.
--   - AP Statistics batch 1 (17 items): 16/17 clean, 1 defect.
--   - AP Statistics batch 2 (16 items): 16/16 clean.
--   - AP Statistics batch 3 (16 items): 15/16 clean, 1 defect -- but that
--     defect (APSTAT-MOD8-H001) is a stale pre-existing assignment to a
--     different reviewer (created 2026-07-29), not part of today's new
--     Statistics batch to Shazia Fazal -- out of scope, not repaired here.
--
-- Net in-scope result: Calc AB 22/23 clean, Statistics 47/48 clean.
-- Both confirmed in-scope defects fixed below, edit-in-place (these are
-- unreviewed drafts -- no decision on record to preserve, so the "never
-- edit reviewed/published content in place" discipline doesn't apply).

begin;

-- 1. apcalcab-mcq-037: answer key had the local min/max sign-change
-- rationales swapped. f'(x)=x^3-3.2x^2-1.1x+2.4 on [-2,4] changes - to +
-- at x=0.796 (local max) and + to - at x=-0.910 (local min); the stored
-- key marked -0.910 correct. Independently re-derived by QA agent via
-- sign analysis of the cubic's three real roots (-0.910, 0.796, 3.313).
update app.mcq_choices
set is_correct = false,
    rationale = 'Selects the negative-to-positive derivative sign change, which gives a local minimum, not a maximum.'
where id = 'a214a07b-47dc-4c32-a658-fe0f332d268a';

update app.mcq_choices
set is_correct = true,
    rationale = 'Correctly identifies the positive-to-negative derivative sign change, giving the local maximum.'
where id = 'd1e12bf5-97b3-4b03-a258-4490ca6a6aa8';

update app.content_item_versions
set content_hash = md5(stem || E'\n' || coalesce(stimulus,'') || E'\n' ||
  (select string_agg(mc.choice_text || ':' || mc.is_correct::text, E'\n' order by mc.choice_text)
   from app.mcq_choices mc where mc.content_item_version_id = app.content_item_versions.id)),
    updated_at = now()
where id = '809ae281-c05f-4e7e-8582-15dabad909d0';

-- 2. APSTAT-MOD7-H002-INV: stem supplied only 2 of the numbers its own
-- rubric (contingency_table / chi_square_test / probability_analysis /
-- contextual_interpretation) requires to build a 3x2 table -- no group
-- sizes and no medium-anxiety STEM rate. Added internally consistent
-- counts (200/200/100 split, medium rate 55%) so a unique table, chi-
-- square statistic (chi^2 ~= 52.2, df=2, p<0.0001), and conditional
-- probabilities are all derivable.
update app.content_item_versions
set stem = 'A survey of 500 high school students asks about their math anxiety level (low, medium, high) and whether they plan to pursue STEM majors (yes/no). Of the 500 students, 200 report low anxiety, 200 report medium anxiety, and 100 report high anxiety. Among low-anxiety students, 80% plan to pursue STEM; among medium-anxiety students, 55% plan to pursue STEM; among high-anxiety students, 40% plan to pursue STEM. (a) Construct the complete contingency table from the given information, showing all counts and marginal totals. (b) Is there evidence of an association between anxiety level and STEM pursuit? Perform a chi-square test of independence (α = 0.05) and interpret the results. (c) Calculate appropriate conditional probabilities. What do these probabilities suggest about the relationship between anxiety and STEM pursuit? (d) Interpret your conclusions in context. What limitations might this observational data have for drawing conclusions about this relationship?',
    content_hash = md5('A survey of 500 high school students -- updated 2026-08-09 contingency data fix' || E'\n' ||
      (select string_agg(fc.criterion_key||':'||fc.learner_facing_text, E'\n' order by fc.criterion_key)
       from app.frq_criteria fc where fc.content_item_version_id = '9817ead7-52af-493f-b7ef-dc30c3c4d904')),
    updated_at = now()
where id = '9817ead7-52af-493f-b7ef-dc30c3c4d904';

commit;

-- Follow-up (not actioned here): APSTAT-MOD8-H001's stem also claims a
-- concrete 25-student dataset the item was never given (stimulus is
-- empty; rubric already grades method-only/ABSTAIN in acknowledgment of
-- this). It belongs to a different, older assignment (2026-07-29, a
-- different reviewer) and is out of scope for today's Calc AB/Stats
-- verification pass -- flagging for a separate remediation pass.
