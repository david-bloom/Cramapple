-- 8 original Cramapple-authored Calculus MCQs (4 AP Calculus AB Unit 1, 4 AP
-- Calculus BC Units 1-2), sourced via
-- docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md:
-- topic scope and skill categories mined from three Solebury School summer
-- assignments (Michelle Gavin's AB packet, Hannah Pritchett's BC DeltaMath
-- set), with every stem, number, and distractor independently authored --
-- no wording or values copied from those documents. See
-- docs/research/orly_source_log/SOURCE_LOG.md for provenance.
--
-- Product-Owner-approved direct publish (2026-08-24): David approved
-- publishing these as "simple versions of questions assigned to Orly"
-- without a separate second-reviewer pass. Each item still walks the real
-- draft -> reviewed_approved -> published state machine so the pipeline's
-- own guards (content_pipeline_guard_publish, enforce_publish_gate) apply
-- normally; review_status is set to answer_approved to record that this was
-- a Product Owner approval, not a standard content-review-assignment pass.
--
-- No content_taxonomy_labels rows are created here -- that is a separate
-- pipeline step (model-labeled, then validated) this migration does not
-- attempt to fabricate. Until it runs, these items will not appear in
-- taxonomy-gated serving paths (select_unit_gated_practice_items).
--
-- A local helper function does the repetitive item+version+choices+publish
-- work for all 8 calls, then drops itself so it leaves no residue.

create or replace function app._orly_20260824_publish_mcq(
  p_pack uuid,
  p_content_key text,
  p_stem text,
  p_explanation text,
  p_correct_key text,
  p_choices jsonb, -- array of {choice_key, choice_text, is_correct, rationale}
  p_taxonomy_refs jsonb, -- array of {node_key, scheme_key, scheme_version}
  p_exam_code text,
  p_archetype_key text,
  p_originality_note text
) returns uuid
language plpgsql
as $fn$
declare
  v_owner uuid := 'f5a26c6b-3566-4d58-9e97-979fbb947564'; -- David, admin
  v_item uuid;
  v_version uuid;
  v_prompt jsonb;
begin
  v_prompt := jsonb_build_object(
    'item_type', 'mcq', 'difficulty', 'Medium', 'calculator_mode', 'no_calculator',
    'package_id', p_content_key, 'content_key', p_content_key,
    'provenance', jsonb_build_object(
      'source_refs', jsonb_build_array('orly-protocol-2026-08-24'),
      'generated_at', '2026-08-24T00:00:00Z', 'generated_by', 'claude'
    ),
    'parts', jsonb_build_array(jsonb_build_object(
      'part_key', 'question', 'ordinal', 1, 'points', 1,
      'response_modalities', jsonb_build_array('choice'),
      'prompt', p_stem || E'\n\n' || (
        select string_agg(c->>'choice_key' || '. ' || (c->>'choice_text'), E'\n' order by c->>'choice_key')
        from jsonb_array_elements(p_choices) c
      ),
      'criteria', jsonb_build_array(jsonb_build_object(
        'criterion_key', 'correct-answer', 'points', 1,
        'description', 'Select the unique correct response.',
        'required_evidence', jsonb_build_array(p_correct_key, p_explanation),
        'deterministic_checks', jsonb_build_array(jsonb_build_object(
          'check_type', 'choice-key', 'parameters', jsonb_build_object('correct_key', p_correct_key)
        ))
      ))
    )),
    'stimuli', jsonb_build_array(),
    'mcq_choices', p_choices,
    'review_notes', jsonb_build_object(
      'expected_reasoning', p_explanation,
      'originality_statement', p_originality_note
    ),
    'archetype_ref', jsonb_build_object('archetype_key', p_archetype_key, 'version', '1.0.0'),
    'exam_pack_ref', jsonb_build_object('exam_code', p_exam_code, 'school_year', '2026-27', 'exam_pack_version', '1.0.0'),
    'taxonomy_refs', p_taxonomy_refs,
    'schema_version', '1.0.0', 'content_version', 1,
    'canonical_answers', jsonb_build_array(p_correct_key)
  );

  insert into app.content_items (
    exam_pack_version_id, content_key, item_type, title, status, created_by
  ) values (
    p_pack, p_content_key, 'mcq', p_content_key, 'draft', v_owner
  ) returning id into v_item;

  insert into app.content_item_versions (
    content_item_id, version_num, stem, prompt_json, explanation,
    content_hash, status, rubric_type, evaluator_strategy,
    canonical_answer_1, created_by
  ) values (
    v_item, 1, p_stem, v_prompt, p_explanation,
    encode(extensions.digest(p_content_key || p_stem, 'sha256'), 'hex'),
    'draft', 'mcq', 'rule_based_mcq', p_correct_key, v_owner
  ) returning id into v_version;

  insert into app.mcq_choices (
    content_item_version_id, choice_key, choice_text, is_correct, rationale
  )
  select v_version, c->>'choice_key', c->>'choice_text',
         (c->>'is_correct')::boolean, c->>'rationale'
  from jsonb_array_elements(p_choices) as c;

  update app.content_item_versions
    set status = 'reviewed_approved', review_status = 'answer_approved',
        approved_by = v_owner, approved_at = now()
    where id = v_version;
  update app.content_items set status = 'reviewed_approved' where id = v_item;

  update app.content_item_versions
    set status = 'published', published_at = now()
    where id = v_version;
  update app.content_items set status = 'published' where id = v_item;

  return v_item;
end;
$fn$;

do $$
declare
  v_ab_pack uuid := '826c8cf1-bc1b-4f2a-bd33-61a758e1487d';
  v_bc_pack uuid := '3778d753-273a-403d-8f02-55dc64ec6a27';
  v_ab_note text := 'Independently authored Cramapple practice item; topic scope only (not wording or numbers) informed by a Solebury School AP Calculus AB summer assignment (Michelle Gavin) per docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md. No released, secure, or third-party question language used. Published on Product Owner approval 2026-08-24 without a separate second-reviewer pass.';
  v_bc_note text := 'Independently authored Cramapple practice item; topic scope only (not wording or numbers) informed by a Solebury School AP Calculus BC DeltaMath summer assignment (Hannah Pritchett) per docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md. No released, secure, or third-party question language used, and no DeltaMath problem instances were used as templates. Published on Product Owner approval 2026-08-24 without a separate second-reviewer pass.';
begin

  -- apcalcab-mcq-060 -- Topic 1.3, Estimating Limit Values from Graphs
  perform app._orly_20260824_publish_mcq(
    v_ab_pack, 'apcalcab-mcq-060',
    'The graph of g consists of the line y = x + 1 for x < 3, an isolated point at (3, 6), and the curve y = -(x - 3)^2 + 4 for x > 3. What is lim(x->3) g(x)?',
    'As x->3-, g(x)=x+1->4. As x->3+, g(x)=-(x-3)^2+4->4. Both one-sided limits equal 4, so lim(x->3) g(x) = 4, regardless of the isolated value g(3)=6.',
    'A',
    jsonb_build_array(
      jsonb_build_object('choice_key','A','choice_text','4','is_correct',true,'rationale','Left limit = 3+1 = 4; right limit = -(3-3)^2+4 = 4; both agree.'),
      jsonb_build_object('choice_key','B','choice_text','6','is_correct',false,'rationale','Confuses the limit with the isolated function value g(3).'),
      jsonb_build_object('choice_key','C','choice_text','Does not exist, because g(3) is not equal to 4','is_correct',false,'rationale','A mismatch between g(3) and the limit does not make the limit fail to exist.'),
      jsonb_build_object('choice_key','D','choice_text','Does not exist, because the two branches use different formulas','is_correct',false,'rationale','Different formulas can still share a common limit at the boundary.')
    ),
    jsonb_build_array(
      jsonb_build_object('node_key','unit-1-limits-and-continuity','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','topic-1.3','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','practice-2','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0')
    ),
    'ap_calculus_ab', 'ap-calculus-ab-mcq', v_ab_note
  );

  -- apcalcab-mcq-070 -- Topic 1.4, Estimating Limit Values from Tables
  perform app._orly_20260824_publish_mcq(
    v_ab_pack, 'apcalcab-mcq-070',
    'The table shows values of f(x) for x near 2: f(1.9)=5.9, f(1.99)=5.99, f(1.999)=5.999, f(2.001)=6.001, f(2.01)=6.01, f(2.1)=6.1. Based on the table, what is lim(x->2) f(x)?',
    'As x->2 from both sides, f(x) gets arbitrarily close to 6, so lim(x->2) f(x) = 6. The table never needs to show f(2) itself.',
    'A',
    jsonb_build_array(
      jsonb_build_object('choice_key','A','choice_text','6','is_correct',true,'rationale','Values approach 6 from both sides.'),
      jsonb_build_object('choice_key','B','choice_text','5.999','is_correct',false,'rationale','Reads a single table entry instead of the trend.'),
      jsonb_build_object('choice_key','C','choice_text','Cannot be determined without knowing f(2)','is_correct',false,'rationale','A limit does not require the function value at the point.'),
      jsonb_build_object('choice_key','D','choice_text','Does not exist, since the left- and right-side values are never exactly equal','is_correct',false,'rationale','Approaching, not equaling, is what matters for a limit.')
    ),
    jsonb_build_array(
      jsonb_build_object('node_key','unit-1-limits-and-continuity','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','topic-1.4','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','practice-2','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0')
    ),
    'ap_calculus_ab', 'ap-calculus-ab-mcq', v_ab_note
  );

  -- apcalcab-mcq-080 -- Topic 1.6, Algebraic Manipulation
  perform app._orly_20260824_publish_mcq(
    v_ab_pack, 'apcalcab-mcq-080',
    'What is lim(x->-2) (x^2 + 5x + 6) / (x + 2)?',
    'Factor the numerator: x^2+5x+6 = (x+2)(x+3). Cancel the common (x+2) factor (valid for x not equal to -2), leaving x+3. lim(x->-2)(x+3) = 1.',
    'A',
    jsonb_build_array(
      jsonb_build_object('choice_key','A','choice_text','1','is_correct',true,'rationale','Cancel the common factor, then evaluate x+3 at x=-2.'),
      jsonb_build_object('choice_key','B','choice_text','0','is_correct',false,'rationale','Plugs x=-2 into the numerator alone and stops before simplifying.'),
      jsonb_build_object('choice_key','C','choice_text','Does not exist, because the denominator equals 0 at x = -2','is_correct',false,'rationale','Misses that it is a removable discontinuity, not a true division by zero.'),
      jsonb_build_object('choice_key','D','choice_text','5','is_correct',false,'rationale','Arithmetic slip: evaluates x+3 at x=2 instead of x=-2.')
    ),
    jsonb_build_array(
      jsonb_build_object('node_key','unit-1-limits-and-continuity','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','topic-1.6','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','practice-1','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0')
    ),
    'ap_calculus_ab', 'ap-calculus-ab-mcq', v_ab_note
  );

  -- apcalcab-mcq-090 -- Topic 1.8, Squeeze Theorem
  perform app._orly_20260824_publish_mcq(
    v_ab_pack, 'apcalcab-mcq-090',
    'Let f be a function such that 2 - 3(x - 1)^2 <= f(x) <= 2 + 3(x - 1)^2 for all x. What is lim(x->1) f(x)?',
    'Both bounding functions, 2-3(x-1)^2 and 2+3(x-1)^2, approach 2 as x->1. Since f is squeezed between two functions with the same limit, the Squeeze Theorem gives lim(x->1) f(x) = 2.',
    'A',
    jsonb_build_array(
      jsonb_build_object('choice_key','A','choice_text','2','is_correct',true,'rationale','Both bounding functions approach 2 as x->1.'),
      jsonb_build_object('choice_key','B','choice_text','0','is_correct',false,'rationale','Evaluates only the 3(x-1)^2 term and drops the +2 shift.'),
      jsonb_build_object('choice_key','C','choice_text','It cannot be determined, since f is not explicitly defined','is_correct',false,'rationale','Misses that the Squeeze Theorem pins the limit without needing f explicitly.'),
      jsonb_build_object('choice_key','D','choice_text','Does not exist, because the inequality is not an equality','is_correct',false,'rationale','Bounding is enough for the Squeeze Theorem; equality is not required.')
    ),
    jsonb_build_array(
      jsonb_build_object('node_key','unit-1-limits-and-continuity','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','topic-1.8','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','practice-3','scheme_key','ap-calculus-ab-2025-26','scheme_version','1.0.0')
    ),
    'ap_calculus_ab', 'ap-calculus-ab-mcq', v_ab_note
  );

  -- apcalcbc-mcq-060 -- Topic 1.10, Exploring Types of Discontinuities
  perform app._orly_20260824_publish_mcq(
    v_bc_pack, 'apcalcbc-mcq-060',
    'Let f(x) = (x^2 - 9)/(x - 3) for x not equal to 3, and f(3) = 2. What type of discontinuity does f have at x = 3?',
    'For x not equal to 3, f(x) = (x-3)(x+3)/(x-3) = x+3, so lim(x->3) f(x) = 6. Since f(3)=2 does not equal 6, the limit exists but disagrees with the function value -- a removable discontinuity.',
    'A',
    jsonb_build_array(
      jsonb_build_object('choice_key','A','choice_text','Removable, because lim(x->3) f(x) = 6 but f(3) = 2','is_correct',true,'rationale','Factors to x+3; the limit exists and disagrees with the point value.'),
      jsonb_build_object('choice_key','B','choice_text','Jump, because the left- and right-hand limits differ','is_correct',false,'rationale','Both one-sided limits equal 6.'),
      jsonb_build_object('choice_key','C','choice_text','Infinite, because the denominator is 0 at x = 3','is_correct',false,'rationale','The factor cancels, so there is no vertical asymptote.'),
      jsonb_build_object('choice_key','D','choice_text','There is no discontinuity, since f(3) is defined','is_correct',false,'rationale','Being defined does not imply continuity.')
    ),
    jsonb_build_array(
      jsonb_build_object('node_key','unit-1-limits-and-continuity','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','topic-1.10','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','practice-2','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0')
    ),
    'ap_calculus_bc', 'ap-calculus-bc-mcq', v_bc_note
  );

  -- apcalcbc-mcq-070 -- Topic 1.15, Limits at Infinity and Horizontal Asymptotes
  perform app._orly_20260824_publish_mcq(
    v_bc_pack, 'apcalcbc-mcq-070',
    'What is lim(x->infinity) (6x^3 - 2x + 1) / (2x^3 + 5x^2 - 4)?',
    'Numerator and denominator both have degree 3, so the limit at infinity is the ratio of leading coefficients: 6/2 = 3.',
    'A',
    jsonb_build_array(
      jsonb_build_object('choice_key','A','choice_text','3','is_correct',true,'rationale','Ratio of leading coefficients, 6/2.'),
      jsonb_build_object('choice_key','B','choice_text','0','is_correct',false,'rationale','Treats the numerator as lower degree than the denominator.'),
      jsonb_build_object('choice_key','C','choice_text','Infinity','is_correct',false,'rationale','Treats the numerator as dominating without bound.'),
      jsonb_build_object('choice_key','D','choice_text','6/5','is_correct',false,'rationale','Mixes the numerator leading coefficient with the denominator x^2 coefficient.')
    ),
    jsonb_build_array(
      jsonb_build_object('node_key','unit-1-limits-and-continuity','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','topic-1.15','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','practice-1','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0')
    ),
    'ap_calculus_bc', 'ap-calculus-bc-mcq', v_bc_note
  );

  -- apcalcbc-mcq-080 -- Topic 2.2, Defining the Derivative via Limit Notation
  perform app._orly_20260824_publish_mcq(
    v_bc_pack, 'apcalcbc-mcq-080',
    'lim(h->0) [3(2+h)^2 - 3(2)^2] / h is the derivative of which function f, evaluated at which value of x?',
    'This is the difference-quotient form [f(a+h)-f(a)]/h with f(x)=3x^2 and a=2, so the limit defines f prime of 2 for f(x)=3x^2.',
    'A',
    jsonb_build_array(
      jsonb_build_object('choice_key','A','choice_text','f(x) = 3x^2 at x = 2','is_correct',true,'rationale','Matches the difference-quotient definition of f prime of 2.'),
      jsonb_build_object('choice_key','B','choice_text','f(x) = 3x^2 at x = 2 + h','is_correct',false,'rationale','h is the variable that vanishes, not part of the evaluation point.'),
      jsonb_build_object('choice_key','C','choice_text','f(x) = 6x at x = 2','is_correct',false,'rationale','Confuses the answer (the derivative formula) with the original function.'),
      jsonb_build_object('choice_key','D','choice_text','f(x) = 3x^2 at x = 0','is_correct',false,'rationale','Misreads "h approaches 0" as "x approaches 0".')
    ),
    jsonb_build_array(
      jsonb_build_object('node_key','unit-2-differentiation-definition-and-fundamental-properties','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','topic-2.2','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','practice-2','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0')
    ),
    'ap_calculus_bc', 'ap-calculus-bc-mcq', v_bc_note
  );

  -- apcalcbc-mcq-090 -- Topic 2.9, The Quotient Rule
  perform app._orly_20260824_publish_mcq(
    v_bc_pack, 'apcalcbc-mcq-090',
    'If f(x) = (3x^2 - 1) / (x + 4), what is f prime of x?',
    'Quotient rule: f prime of x = [(6x)(x+4) - (3x^2-1)(1)] / (x+4)^2 = [6x^2+24x - 3x^2+1] / (x+4)^2 = (3x^2+24x+1)/(x+4)^2.',
    'A',
    jsonb_build_array(
      jsonb_build_object('choice_key','A','choice_text','(3x^2 + 24x + 1) / (x + 4)^2','is_correct',true,'rationale','Correct quotient-rule numerator and squared denominator.'),
      jsonb_build_object('choice_key','B','choice_text','6x / (x + 4)','is_correct',false,'rationale','Differentiates numerator and denominator separately, skipping the quotient rule.'),
      jsonb_build_object('choice_key','C','choice_text','(3x^2 - 24x - 1) / (x + 4)^2','is_correct',false,'rationale','Sign error distributing the quotient-rule numerator.'),
      jsonb_build_object('choice_key','D','choice_text','(3x^2 + 24x + 1) / (x + 4)','is_correct',false,'rationale','Forgets to square the denominator.')
    ),
    jsonb_build_array(
      jsonb_build_object('node_key','unit-2-differentiation-definition-and-fundamental-properties','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','topic-2.9','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0'),
      jsonb_build_object('node_key','practice-1','scheme_key','ap-calculus-bc-2025-26','scheme_version','1.0.0')
    ),
    'ap_calculus_bc', 'ap-calculus-bc-mcq', v_bc_note
  );

end $$;

drop function app._orly_20260824_publish_mcq(uuid, text, text, text, text, jsonb, jsonb, text, text, text);
