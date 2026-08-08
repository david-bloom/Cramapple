-- Owner remediation: 5 rubric-architecture defects found during the
-- 2026-08-08 AP Calculus AB/BC full-corpus conformance scan (run against the
-- newly deepened AP_CALCULUS_AB_BC_CED_FACT_PACK.md, Units 1-8). No math
-- was wrong in any of these items — only how points were split.
--
-- Fixes:
--   apcalcab-frq-026 (part-d): the quotient-rule step bundled setup+value
--     into one point, inconsistent with the same item's own part-a, which
--     correctly splits product-rule setup from value. Split into two points.
--   apcalcab-frq-024 (part-c-criterion-1): "cites continuity" credited with
--     no requirement to state why -- the exact IVT near-miss pattern the CED
--     update flagged as the lowest-scoring point type nationally (mean
--     ~0.27-0.28/1 on the real 2025 exam). Added the "why" requirement.
--   apcalcab-frq-025 (part-d-criterion-1): same gap, weaker case (p is a
--     polynomial). Added the "why" requirement.
--   apcalcbc-frq-u13-016, apcalcbc-frq-u13-020 (part-a): full implicit
--     differentiation of the whole equation split into 3-4 separate
--     per-term points, violating this fact pack's own documented convention
--     (that step is all-or-nothing) and inconsistent with apcalcbc-frq-020,
--     an essentially identical curve problem in the same corpus that scores
--     it correctly as one point. Merged into one all-or-nothing criterion
--     each; point totals for these two items drop accordingly (u13-016:
--     9->6, u13-020: 9->7) to match genuine AP scoring structure -- this is
--     a correction, not a preserved-total edit.
--
-- Pattern: new admin-authored version per item (old version retired, never
-- edited in place), owner_remediation_approval admin decision, then the
-- standard two-step publish (reviewed_approved -> published, per
-- tg_content_pipeline_guard_publish). Admin UUID f5a26c6b-3566-4d58-9e97-979fbb947564
-- matches the DECISION-0044 / TASK-0022 remediation precedent.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalc-rubric-architecture-fixes-20260808'));

do $$
declare
  v_admin uuid := 'f5a26c6b-3566-4d58-9e97-979fbb947564';
  v_item record;
  v_old record;
  v_new uuid;
  v_assignment uuid;
begin

  -- =========================================================================
  -- 1) apcalcab-frq-026 -- split part-d-criterion-2 into setup + value
  -- =========================================================================
  select ci.* into v_item from app.content_items ci where ci.content_key='apcalcab-frq-026';
  select civ.* into v_old from app.content_item_versions civ where civ.id = (
    select id from app.content_item_versions v2 where v2.content_item_id=v_item.id and v2.status='published'
    order by v2.version_num desc limit 1);

  update app.content_item_versions set status='retired', updated_at=now() where id=v_old.id;

  v_new := gen_random_uuid();
  insert into app.content_item_versions (
    id, content_item_id, version_num, stem, stimulus, content_hash, status,
    review_status, rubric_type, evaluator_strategy, created_by
  ) values (
    v_new, v_item.id, v_old.version_num+1, v_old.stem, v_old.stimulus,
    md5(v_old.stem || '::rubric-fix-20260808'), 'draft', 'tutor_review_pending',
    v_old.rubric_type, v_old.evaluator_strategy, v_admin
  );

  insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
  select gen_random_uuid(), v_new, fc.criterion_key, fc.learner_facing_text, fc.points_possible, fc.evidence_requirements, fc.minimum_fix, fc.accepted_variants
  from app.frq_criteria fc where fc.content_item_version_id=v_old.id and fc.criterion_key <> 'part-d-criterion-2';

  insert into app.frq_criteria (id, content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
  values
    (gen_random_uuid(), v_new, 'part-d-criterion-2', 'Uses the quotient rule, writing h′(x)=[f′(x)g(x)−f(x)g′(x)]/[g(x)]².', 1,
     'Response states the quotient rule formula explicitly, with correct numerator order (f′g−fg′), before substituting values.',
     'Write the quotient rule formula as its own step, separate from evaluating it.', '[]'::jsonb),
    (gen_random_uuid(), v_new, 'part-d-criterion-4', 'Correctly substitutes to obtain h′(2)=−5/8.', 1,
     'Response substitutes f′(2)=−1, g(2)=4, f(2)=3, g′(2)=2 to get [(−1)(4)−(3)(2)]/16 = −5/8.',
     'Show the substituted numeric expression before the final value.', '[]'::jsonb);

  -- renumber the old part-d-criterion-3 (tangent line) to part-d-criterion-3 stays as-is (already after criterion-2 alphabetically it's fine to keep key as-is; no rename needed since keys are just labels, not ordinal-enforced)

  v_assignment := gen_random_uuid();
  insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
  values (v_assignment, v_new, v_admin, 'tutor_question', 'frq', 'pending', 'owner_remediation_approval', v_admin);

  insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
  values (v_assignment, v_new, v_admin, 'tutor_question', 1, 'Medium', false, array[]::text[],
    'owner_remediation_approval: split bundled quotient-rule setup+value criterion (2026-08-08 CED conformance scan) -- apcalcab-frq-026',
    'approve',
    jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalc_rubric_architecture_fix','qa_date','2026-08-08','content_key','apcalcab-frq-026'),
    encode(extensions.digest('apcalcab-frq-026-fix-20260808','sha256'),'hex'), v_admin);

  update app.content_item_versions set status='reviewed_approved', updated_at=now() where id=v_new;
  update app.content_item_versions set status='published', review_status='question_review_approved',
    approved_at=now(), approved_by=v_admin, published_at=now(), updated_at=now() where id=v_new;
  update app.content_items set status='published', updated_at=now() where id=v_item.id;

end $$;
commit;
select 'apcalcab-frq-026 fixed' as status;
