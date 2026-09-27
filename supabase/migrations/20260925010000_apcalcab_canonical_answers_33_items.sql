-- AP Calculus AB servability work (docs/product/SUBJECT_SERVABILITY_CRITERIA.md), criterion 4.
-- Authors canonical_answer_1 + canonical_answer_spans for the 33 published Calc AB FRQ items that
-- had a blank canonical_answer_1 (apcalcab-frq-024/025/026, apcalcab-frq-np2-001..010,
-- apcalcab-frq-u13-001..020), following the same pattern as
-- supabase/migrations/20260924220000_apbio_s101_canonical_write.sql: each answer's text is composed
-- of criterion-exclusive spans (one span per frq_criteria.criterion_key, plus assembly_literal
-- separators), verified to concatenate exactly to canonical_answer_1.
--
-- Content investigation (Part 1 of the original Calc AB work order,
-- prompts/CODEX_WORK_ORDER_AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_24.md): read every item's stem,
-- stimulus, and frq_criteria directly. All 33 are genuine, complete, production-quality FRQ content
-- (u13-* covers Unit 1 limits/continuity plus derivative rules; np2-* and 024/025/026 are a mixed
-- practice bank spanning limits, continuity, derivatives, related rates, optimization, and
-- integration) -- none are placeholder/draft-quality, so all 33 get canonical answers, not an
-- unpublish recommendation.
--
-- Every value in every canonical answer was independently re-derived (not copied from the rubric's
-- learner_facing_text) -- spot-checked cases included u13-011's four one-sided infinite-limit signs,
-- u13-017's arcsin/arctan derivative simplification, and u13-019's implicit second derivative --
-- all matched the rubric's stated correct values, confirming the rubric text was itself correct.
--
-- Verification before writing this migration (see scratchpad build script, not committed):
-- (1) every one of the 33 items' full criterion_key set was re-fetched fresh from Production
--     immediately before authoring (not from memory/an earlier session state) and matched exactly
--     against the authored spans -- no criterion missing, none extra, none duplicated;
-- (2) span concatenation per item was verified programmatically to equal canonical_answer_1 byte for
--     byte before generating this SQL;
-- (3) all 33 target rows were confirmed to have canonical_answer_1 IS NULL beforehand -- this is a
--     pure addition, nothing is overwritten.
-- A second, live verification (concatenation of the actually-inserted spans vs. the actually-written
-- canonical_answer_1) runs inside this transaction below, and a third, independent check runs via a
-- separate execute_sql call after apply, per this session's standing verification discipline.
--
-- Rollback: set canonical_answer_1 back to null and delete the inserted canonical_answer_spans rows
-- for these 33 content_item_version_ids (listed in the do-block below) if ever needed.
begin;

-- apcalcab-frq-024 (c975c3ce-6e5b-4618-8ecc-776f750fbafc)
update app.content_item_versions set canonical_answer_1 = 'For x is not equal to 1, f(x) = (x^2-1)/(x-1) = (x-1)(x+1)/(x-1) = x+1, so f simplifies to x+1 away from x=1.

The limit as x approaches 1 of x+1 is 2, so lim x->1 f(x) = 2.

For f to be continuous at x=1, k must equal this limit, so k = 2.

With k=2, f(x) = x+1 for all x near 1 (including at x=1, since f(1)=k=2=1+1), so the difference quotient for f at x=1 is the same as for the linear function x+1.

Since f(x)=x+1 near x=1, f''(x)=1 everywhere near x=1, so f''(1) = 1.

Because this derivative exists, f is differentiable at x=1.

f is continuous on [1,2]: for the continuous choice k=2, f equals the linear function x+1 on this interval, and part (b) already established the stronger fact that f is differentiable at x=1.

f(1) = 2 and f(2) = 3, and 5/2 lies between 2 and 3, so the Intermediate Value Theorem applies.

Solving x+1 = 5/2 gives x = 3/2, so there exists a value in (1,2), namely x=3/2, with f(x) = 5/2.' where id = 'c975c3ce-6e5b-4618-8ecc-776f750fbafc';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 1, 'For x is not equal to 1, f(x) = (x^2-1)/(x-1) = (x-1)(x+1)/(x-1) = x+1, so f simplifies to x+1 away from x=1.', ARRAY['part-a-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 3, 'The limit as x approaches 1 of x+1 is 2, so lim x->1 f(x) = 2.', ARRAY['part-a-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 5, 'For f to be continuous at x=1, k must equal this limit, so k = 2.', ARRAY['part-a-criterion-3'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 7, 'With k=2, f(x) = x+1 for all x near 1 (including at x=1, since f(1)=k=2=1+1), so the difference quotient for f at x=1 is the same as for the linear function x+1.', ARRAY['part-b-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 9, 'Since f(x)=x+1 near x=1, f''(x)=1 everywhere near x=1, so f''(1) = 1.', ARRAY['part-b-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 11, 'Because this derivative exists, f is differentiable at x=1.', ARRAY['part-b-criterion-3'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 13, 'f is continuous on [1,2]: for the continuous choice k=2, f equals the linear function x+1 on this interval, and part (b) already established the stronger fact that f is differentiable at x=1.', ARRAY['part-c-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 15, 'f(1) = 2 and f(2) = 3, and 5/2 lies between 2 and 3, so the Intermediate Value Theorem applies.', ARRAY['part-c-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc', 'canonical_answer_1', 17, 'Solving x+1 = 5/2 gives x = 3/2, so there exists a value in (1,2), namely x=3/2, with f(x) = 5/2.', ARRAY['part-c-criterion-3'], 'drafted');

-- apcalcab-frq-025 (b21ebb17-3823-41ad-bf55-4c68e9e3d8f3)
update app.content_item_versions set canonical_answer_1 = '(a) Rewrite sin(5x)/x as 5 times sin(5x)/(5x).

As x approaches 0, 5x approaches 0, so sin(5x)/(5x) approaches 1, giving a limit of 5*1 = 5.

(b) Divide numerator and denominator of (3x^2-x)/sqrt(9x^4+1) by x^2, giving (3 - 1/x)/sqrt(9 + 1/x^4).

As x approaches infinity, x^2 > 0 and the terms 1/x and 1/x^4 approach 0, so the expression approaches 3/sqrt(9) = 1.

(c) For all x not equal to 0, -1 <= cos(1/x) <= 1, so multiplying by x^2 (nonnegative) gives -x^2 <= x^2cos(1/x) <= x^2.

Since both bounds -x^2 and x^2 approach 0 as x approaches 0, the Squeeze Theorem gives lim x->0 x^2cos(1/x) = 0.

(d) p(x) = x^3+x-1 is a polynomial, so it is continuous everywhere, in particular on [0,1].

p(0) = -1 and p(1) = 1.

Since p is continuous on [0,1] and p(0) = -1 < 0 < 1 = p(1), the Intermediate Value Theorem guarantees a zero of p in (0,1).' where id = 'b21ebb17-3823-41ad-bf55-4c68e9e3d8f3';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 1, '(a) Rewrite sin(5x)/x as 5 times sin(5x)/(5x).', ARRAY['part-a-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 3, 'As x approaches 0, 5x approaches 0, so sin(5x)/(5x) approaches 1, giving a limit of 5*1 = 5.', ARRAY['part-a-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 5, '(b) Divide numerator and denominator of (3x^2-x)/sqrt(9x^4+1) by x^2, giving (3 - 1/x)/sqrt(9 + 1/x^4).', ARRAY['part-b-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 7, 'As x approaches infinity, x^2 > 0 and the terms 1/x and 1/x^4 approach 0, so the expression approaches 3/sqrt(9) = 1.', ARRAY['part-b-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 9, '(c) For all x not equal to 0, -1 <= cos(1/x) <= 1, so multiplying by x^2 (nonnegative) gives -x^2 <= x^2cos(1/x) <= x^2.', ARRAY['part-c-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 11, 'Since both bounds -x^2 and x^2 approach 0 as x approaches 0, the Squeeze Theorem gives lim x->0 x^2cos(1/x) = 0.', ARRAY['part-c-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 13, '(d) p(x) = x^3+x-1 is a polynomial, so it is continuous everywhere, in particular on [0,1].', ARRAY['part-d-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 15, 'p(0) = -1 and p(1) = 1.', ARRAY['part-d-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3', 'canonical_answer_1', 17, 'Since p is continuous on [0,1] and p(0) = -1 < 0 < 1 = p(1), the Intermediate Value Theorem guarantees a zero of p in (0,1).', ARRAY['part-d-criterion-3'], 'drafted');

-- apcalcab-frq-026 (400885fa-5480-4b13-b26e-deb87d9fdfa0)
update app.content_item_versions set canonical_answer_1 = '(a) By the product rule, d/dx[f(x)g(x)] = f''(x)g(x) + f(x)g''(x).

At x=2: (-1)(4) + (3)(2) = -4+6 = 2.

(b) Since f(2)=3, the inverse-function derivative formula gives (f^-1)''(3) = 1/f''(2).

So (f^-1)''(3) = 1/(-1) = -1.

(c) By the chain rule, d/dx[f(g(x))] at x=2 is f''(g(2))*g''(2) = f''(4)*g''(2).

This equals 5*2 = 10.

(d) h(2) = f(2)/g(2) = 3/4.

By the quotient rule, h''(x) = [f''(x)g(x) - f(x)g''(x)]/[g(x)]^2, so h''(2) = [(-1)(4)-(3)(2)]/16 = -10/16 = -5/8.

Substituting f(2), g(2), f''(2), g''(2) into the quotient rule gives h''(2) = -5/8.

The tangent line to h at x=2 is y - 3/4 = -5/8(x-2).' where id = '400885fa-5480-4b13-b26e-deb87d9fdfa0';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 1, '(a) By the product rule, d/dx[f(x)g(x)] = f''(x)g(x) + f(x)g''(x).', ARRAY['part-a-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 3, 'At x=2: (-1)(4) + (3)(2) = -4+6 = 2.', ARRAY['part-a-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 5, '(b) Since f(2)=3, the inverse-function derivative formula gives (f^-1)''(3) = 1/f''(2).', ARRAY['part-b-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 7, 'So (f^-1)''(3) = 1/(-1) = -1.', ARRAY['part-b-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 9, '(c) By the chain rule, d/dx[f(g(x))] at x=2 is f''(g(2))*g''(2) = f''(4)*g''(2).', ARRAY['part-c-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 11, 'This equals 5*2 = 10.', ARRAY['part-c-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 13, '(d) h(2) = f(2)/g(2) = 3/4.', ARRAY['part-d-criterion-1'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 15, 'By the quotient rule, h''(x) = [f''(x)g(x) - f(x)g''(x)]/[g(x)]^2, so h''(2) = [(-1)(4)-(3)(2)]/16 = -10/16 = -5/8.', ARRAY['part-d-criterion-2'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 17, 'Substituting f(2), g(2), f''(2), g''(2) into the quotient rule gives h''(2) = -5/8.', ARRAY['part-d-criterion-4'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 18, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('400885fa-5480-4b13-b26e-deb87d9fdfa0', 'canonical_answer_1', 19, 'The tangent line to h at x=2 is y - 3/4 = -5/8(x-2).', ARRAY['part-d-criterion-3'], 'drafted');

-- apcalcab-frq-np2-001 (8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4)
update app.content_item_versions set canonical_answer_1 = 'Differentiate xy^2 - 3y = x^2 + 5 with respect to t. The term xy^2 needs the product rule: d/dt[xy^2] = (dx/dt)y^2 + 2xy(dy/dt). So the equation becomes (dx/dt)y^2 + 2xy(dy/dt) - 3(dy/dt) = 2x(dx/dt).

Collecting the dy/dt terms: dy/dt*(2xy-3) = 2x(dx/dt) - y^2(dx/dt) = (2x-y^2)(dx/dt), so dy/dt = (2x-y^2)(dx/dt)/(2xy-3).

Substituting x=2, y=3, dx/dt=4: dy/dt = (4-9)(4)/(12-3) = (-5)(4)/9 = -20/9.' where id = '8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4', 'canonical_answer_1', 1, 'Differentiate xy^2 - 3y = x^2 + 5 with respect to t. The term xy^2 needs the product rule: d/dt[xy^2] = (dx/dt)y^2 + 2xy(dy/dt). So the equation becomes (dx/dt)y^2 + 2xy(dy/dt) - 3(dy/dt) = 2x(dx/dt).', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4', 'canonical_answer_1', 3, 'Collecting the dy/dt terms: dy/dt*(2xy-3) = 2x(dx/dt) - y^2(dx/dt) = (2x-y^2)(dx/dt), so dy/dt = (2x-y^2)(dx/dt)/(2xy-3).', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4', 'canonical_answer_1', 5, 'Substituting x=2, y=3, dx/dt=4: dy/dt = (4-9)(4)/(12-3) = (-5)(4)/9 = -20/9.', ARRAY['part-a-criterion-03'], 'drafted');

-- apcalcab-frq-np2-002 (2be7e655-9c90-42d4-ac84-59146fd84599)
update app.content_item_versions set canonical_answer_1 = '(a) For f(x) = x^(1/3), f''(x) = (1/3)x^(-2/3).

f''(8) = (1/3)(8)^(-2/3) = (1/3)(1/4) = 1/12.

(b) The linearization at x=8 is L(x) = f(8) + f''(8)(x-8) = 2 + (1/12)(x-8).

(c) L(8.6) = 2 + (1/12)(0.6) = 2.05.

This is an overestimate: f is concave down (f''''(x)<0) for x>0, so its tangent line lies above the actual curve, meaning L(8.6) overestimates the cube root of 8.6.' where id = '2be7e655-9c90-42d4-ac84-59146fd84599';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2be7e655-9c90-42d4-ac84-59146fd84599', 'canonical_answer_1', 1, '(a) For f(x) = x^(1/3), f''(x) = (1/3)x^(-2/3).', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2be7e655-9c90-42d4-ac84-59146fd84599', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2be7e655-9c90-42d4-ac84-59146fd84599', 'canonical_answer_1', 3, 'f''(8) = (1/3)(8)^(-2/3) = (1/3)(1/4) = 1/12.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2be7e655-9c90-42d4-ac84-59146fd84599', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2be7e655-9c90-42d4-ac84-59146fd84599', 'canonical_answer_1', 5, '(b) The linearization at x=8 is L(x) = f(8) + f''(8)(x-8) = 2 + (1/12)(x-8).', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2be7e655-9c90-42d4-ac84-59146fd84599', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2be7e655-9c90-42d4-ac84-59146fd84599', 'canonical_answer_1', 7, '(c) L(8.6) = 2 + (1/12)(0.6) = 2.05.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2be7e655-9c90-42d4-ac84-59146fd84599', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2be7e655-9c90-42d4-ac84-59146fd84599', 'canonical_answer_1', 9, 'This is an overestimate: f is concave down (f''''(x)<0) for x>0, so its tangent line lies above the actual curve, meaning L(8.6) overestimates the cube root of 8.6.', ARRAY['part-c-criterion-02'], 'drafted');

-- apcalcab-frq-np2-003 (095a5088-1d13-463a-a8d5-73726adc81e2)
update app.content_item_versions set canonical_answer_1 = '(a) For f(x) = x^4-8x^2+3, f''(x) = 4x^3-16x = 4x(x-2)(x+2).

Setting f''(x)=0 gives x=0, 2, -2; only x=0 and x=2 lie in [-1,3] (x=-2 is outside).

(b) Evaluating f at the critical points and endpoints: f(-1) = -4, f(0) = 3, f(2) = -13, f(3) = 12.

The largest value is 12, so the absolute maximum on [-1,3] is 12, at x=3.

The smallest value is -13, so the absolute minimum on [-1,3] is -13, at x=2.' where id = '095a5088-1d13-463a-a8d5-73726adc81e2';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('095a5088-1d13-463a-a8d5-73726adc81e2', 'canonical_answer_1', 1, '(a) For f(x) = x^4-8x^2+3, f''(x) = 4x^3-16x = 4x(x-2)(x+2).', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('095a5088-1d13-463a-a8d5-73726adc81e2', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('095a5088-1d13-463a-a8d5-73726adc81e2', 'canonical_answer_1', 3, 'Setting f''(x)=0 gives x=0, 2, -2; only x=0 and x=2 lie in [-1,3] (x=-2 is outside).', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('095a5088-1d13-463a-a8d5-73726adc81e2', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('095a5088-1d13-463a-a8d5-73726adc81e2', 'canonical_answer_1', 5, '(b) Evaluating f at the critical points and endpoints: f(-1) = -4, f(0) = 3, f(2) = -13, f(3) = 12.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('095a5088-1d13-463a-a8d5-73726adc81e2', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('095a5088-1d13-463a-a8d5-73726adc81e2', 'canonical_answer_1', 7, 'The largest value is 12, so the absolute maximum on [-1,3] is 12, at x=3.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('095a5088-1d13-463a-a8d5-73726adc81e2', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('095a5088-1d13-463a-a8d5-73726adc81e2', 'canonical_answer_1', 9, 'The smallest value is -13, so the absolute minimum on [-1,3] is -13, at x=2.', ARRAY['part-b-criterion-03'], 'drafted');

-- apcalcab-frq-np2-004 (2aa9f09d-7d8f-446a-a687-1ed543858db7)
update app.content_item_versions set canonical_answer_1 = '(a) g''(x) = (x-1)(x-4)^2 = 0 when x=1 or x=4, so the critical points are x=1 and x=4.

(b) Since (x-4)^2 is never negative, the sign of g''(x) matches the sign of (x-1): negative for x<1, positive for x>1 (x != 4).

Therefore g is decreasing on (negative infinity, 1) and increasing on (1, infinity).

(c) g does not have a local extremum at x=4: because (x-4)^2 >= 0, g'' has the same sign on both sides of x=4 (positive on both sides, since x>1 nearby), so g'' does not change sign there and g keeps increasing through x=4.' where id = '2aa9f09d-7d8f-446a-a687-1ed543858db7';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2aa9f09d-7d8f-446a-a687-1ed543858db7', 'canonical_answer_1', 1, '(a) g''(x) = (x-1)(x-4)^2 = 0 when x=1 or x=4, so the critical points are x=1 and x=4.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2aa9f09d-7d8f-446a-a687-1ed543858db7', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2aa9f09d-7d8f-446a-a687-1ed543858db7', 'canonical_answer_1', 3, '(b) Since (x-4)^2 is never negative, the sign of g''(x) matches the sign of (x-1): negative for x<1, positive for x>1 (x != 4).', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2aa9f09d-7d8f-446a-a687-1ed543858db7', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2aa9f09d-7d8f-446a-a687-1ed543858db7', 'canonical_answer_1', 5, 'Therefore g is decreasing on (negative infinity, 1) and increasing on (1, infinity).', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2aa9f09d-7d8f-446a-a687-1ed543858db7', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2aa9f09d-7d8f-446a-a687-1ed543858db7', 'canonical_answer_1', 7, '(c) g does not have a local extremum at x=4: because (x-4)^2 >= 0, g'' has the same sign on both sides of x=4 (positive on both sides, since x>1 nearby), so g'' does not change sign there and g keeps increasing through x=4.', ARRAY['part-c-criterion-01'], 'drafted');

-- apcalcab-frq-np2-005 (c9bbae66-e509-49d4-8ca1-e029c41d2668)
update app.content_item_versions set canonical_answer_1 = '(a) By the Fundamental Theorem of Calculus, g(x) = the integral from 1 to x of (3-t^2)dt has derivative g''(x) = f(x) = 3-x^2.

So g''(x) = 3 - x^2.

(b) Setting g''(x) = 3-x^2 = 0 gives x = plus or minus the square root of 3.

g'' changes from positive to negative at x = the square root of 3 (3-x^2 is positive just below and negative just above), so by the First Derivative Test g has a local maximum there.

(c) g(2) = the integral from 1 to 2 of (3-t^2)dt, with antiderivative 3t - t^3/3 evaluated from 1 to 2.

g(2) = [6 - 8/3] - [3 - 1/3] = 10/3 - 8/3 = 2/3.' where id = 'c9bbae66-e509-49d4-8ca1-e029c41d2668';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 1, '(a) By the Fundamental Theorem of Calculus, g(x) = the integral from 1 to x of (3-t^2)dt has derivative g''(x) = f(x) = 3-x^2.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 3, 'So g''(x) = 3 - x^2.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 5, '(b) Setting g''(x) = 3-x^2 = 0 gives x = plus or minus the square root of 3.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 7, 'g'' changes from positive to negative at x = the square root of 3 (3-x^2 is positive just below and negative just above), so by the First Derivative Test g has a local maximum there.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 9, '(c) g(2) = the integral from 1 to 2 of (3-t^2)dt, with antiderivative 3t - t^3/3 evaluated from 1 to 2.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c9bbae66-e509-49d4-8ca1-e029c41d2668', 'canonical_answer_1', 11, 'g(2) = [6 - 8/3] - [3 - 1/3] = 10/3 - 8/3 = 2/3.', ARRAY['part-c-criterion-02'], 'drafted');

-- apcalcab-frq-np2-006 (dc1f2f7d-12ce-4735-be3d-c3fa85c802cd)
update app.content_item_versions set canonical_answer_1 = 'The trapezoidal sum over [0,2], [2,5], [5,9] is (2/2)(v(0)+v(2)) + (3/2)(v(2)+v(5)) + (4/2)(v(5)+v(9)) = (2/2)(3+7) + (3/2)(7+12) + (4/2)(12+20).

Evaluating: (1)(10) + (1.5)(19) + (2)(32) = 10 + 28.5 + 64 = 102.5.

Since v(t) is speed in miles per hour, this trapezoidal sum estimates the total distance traveled as approximately 102.5 miles over the 9-hour period.' where id = 'dc1f2f7d-12ce-4735-be3d-c3fa85c802cd';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('dc1f2f7d-12ce-4735-be3d-c3fa85c802cd', 'canonical_answer_1', 1, 'The trapezoidal sum over [0,2], [2,5], [5,9] is (2/2)(v(0)+v(2)) + (3/2)(v(2)+v(5)) + (4/2)(v(5)+v(9)) = (2/2)(3+7) + (3/2)(7+12) + (4/2)(12+20).', ARRAY['criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('dc1f2f7d-12ce-4735-be3d-c3fa85c802cd', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('dc1f2f7d-12ce-4735-be3d-c3fa85c802cd', 'canonical_answer_1', 3, 'Evaluating: (1)(10) + (1.5)(19) + (2)(32) = 10 + 28.5 + 64 = 102.5.', ARRAY['criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('dc1f2f7d-12ce-4735-be3d-c3fa85c802cd', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('dc1f2f7d-12ce-4735-be3d-c3fa85c802cd', 'canonical_answer_1', 5, 'Since v(t) is speed in miles per hour, this trapezoidal sum estimates the total distance traveled as approximately 102.5 miles over the 9-hour period.', ARRAY['criterion-03'], 'drafted');

-- apcalcab-frq-np2-007 (e2434089-78b6-4091-8553-4664beef7549)
update app.content_item_versions set canonical_answer_1 = 'Separating variables in dy/dx = xy/3 gives (1/y)dy = (x/3)dx; integrating both sides gives ln|y| = x^2/6 + C.

Using y(0)=5: ln(5) = 0 + C, so C = ln(5).

So ln|y| = x^2/6 + ln(5); exponentiating and using y(0)=5>0 gives y = 5e^(x^2/6).' where id = 'e2434089-78b6-4091-8553-4664beef7549';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('e2434089-78b6-4091-8553-4664beef7549', 'canonical_answer_1', 1, 'Separating variables in dy/dx = xy/3 gives (1/y)dy = (x/3)dx; integrating both sides gives ln|y| = x^2/6 + C.', ARRAY['criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('e2434089-78b6-4091-8553-4664beef7549', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('e2434089-78b6-4091-8553-4664beef7549', 'canonical_answer_1', 3, 'Using y(0)=5: ln(5) = 0 + C, so C = ln(5).', ARRAY['criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('e2434089-78b6-4091-8553-4664beef7549', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('e2434089-78b6-4091-8553-4664beef7549', 'canonical_answer_1', 5, 'So ln|y| = x^2/6 + ln(5); exponentiating and using y(0)=5>0 gives y = 5e^(x^2/6).', ARRAY['criterion-03'], 'drafted');

-- apcalcab-frq-np2-008 (72973fb2-f772-4729-b9cb-e21d6ba8650d)
update app.content_item_versions set canonical_answer_1 = '(a) dP/dt = 0.04P is the standard exponential-growth equation dP/dt = kP with k=0.04, whose solution is P(t) = P(0)e^(kt); with P(0)=2000, P(t) = 2000e^(0.04t).

(b) P(10) = 2000e^(0.4), which is approximately 2983.649.

(c) Setting 2000e^(0.04t) = 5000 and dividing by 2000 gives e^(0.04t) = 2.5.

Taking the natural log: 0.04t = ln(2.5), so t = ln(2.5)/0.04, approximately 22.907.' where id = '72973fb2-f772-4729-b9cb-e21d6ba8650d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('72973fb2-f772-4729-b9cb-e21d6ba8650d', 'canonical_answer_1', 1, '(a) dP/dt = 0.04P is the standard exponential-growth equation dP/dt = kP with k=0.04, whose solution is P(t) = P(0)e^(kt); with P(0)=2000, P(t) = 2000e^(0.04t).', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('72973fb2-f772-4729-b9cb-e21d6ba8650d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('72973fb2-f772-4729-b9cb-e21d6ba8650d', 'canonical_answer_1', 3, '(b) P(10) = 2000e^(0.4), which is approximately 2983.649.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('72973fb2-f772-4729-b9cb-e21d6ba8650d', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('72973fb2-f772-4729-b9cb-e21d6ba8650d', 'canonical_answer_1', 5, '(c) Setting 2000e^(0.04t) = 5000 and dividing by 2000 gives e^(0.04t) = 2.5.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('72973fb2-f772-4729-b9cb-e21d6ba8650d', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('72973fb2-f772-4729-b9cb-e21d6ba8650d', 'canonical_answer_1', 7, 'Taking the natural log: 0.04t = ln(2.5), so t = ln(2.5)/0.04, approximately 22.907.', ARRAY['part-c-criterion-02'], 'drafted');

-- apcalcab-frq-np2-009 (9803edbb-ed8a-439e-b71f-c29204dcf34c)
update app.content_item_versions set canonical_answer_1 = '(a) The average value of r on [0, 2*pi] is (1/(2*pi)) times the integral from 0 to 2*pi of (4+3sin(t))dt.

That integral is [4t-3cos(t)] from 0 to 2*pi = 8*pi, so dividing by 2*pi gives an average value of 4.

(b) The average rate of change is (r(2*pi)-r(0))/(2*pi); since r(0)=r(2*pi)=4, this is 0.

(c) These measure different things: the average value (4) is the mean height of r over the interval, found by integrating and dividing by the interval length, while the average rate of change (0) is just the net change in r divided by elapsed time -- a function can have a large average value while starting and ending at the same height, giving these two different numbers.' where id = '9803edbb-ed8a-439e-b71f-c29204dcf34c';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('9803edbb-ed8a-439e-b71f-c29204dcf34c', 'canonical_answer_1', 1, '(a) The average value of r on [0, 2*pi] is (1/(2*pi)) times the integral from 0 to 2*pi of (4+3sin(t))dt.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('9803edbb-ed8a-439e-b71f-c29204dcf34c', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('9803edbb-ed8a-439e-b71f-c29204dcf34c', 'canonical_answer_1', 3, 'That integral is [4t-3cos(t)] from 0 to 2*pi = 8*pi, so dividing by 2*pi gives an average value of 4.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('9803edbb-ed8a-439e-b71f-c29204dcf34c', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('9803edbb-ed8a-439e-b71f-c29204dcf34c', 'canonical_answer_1', 5, '(b) The average rate of change is (r(2*pi)-r(0))/(2*pi); since r(0)=r(2*pi)=4, this is 0.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('9803edbb-ed8a-439e-b71f-c29204dcf34c', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('9803edbb-ed8a-439e-b71f-c29204dcf34c', 'canonical_answer_1', 7, '(c) These measure different things: the average value (4) is the mean height of r over the interval, found by integrating and dividing by the interval length, while the average rate of change (0) is just the net change in r divided by elapsed time -- a function can have a large average value while starting and ending at the same height, giving these two different numbers.', ARRAY['part-c-criterion-01'], 'drafted');

-- apcalcab-frq-np2-010 (ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74)
update app.content_item_versions set canonical_answer_1 = '(a) On [0,4], the square root of x is greater than or equal to x/2, so the area of R is the definite integral from 0 to 4 of (the square root of x - x/2)dx.

Evaluating: (2/3)x^(3/2) - x^2/4 from 0 to 4 gives 16/3 - 4 = 4/3, so the area of R is 4/3.

(b) Revolving R about y=-1 with the washer method, the outer radius is the square root of x + 1 and the inner radius is x/2 + 1, giving volume = pi times the integral from 0 to 4 of [(the square root of x + 1)^2 - (x/2+1)^2] dx.

(c) Expanding gives 2*sqrt(x) - x^2/4 as the integrand; integrating from 0 to 4 gives pi*[(4/3)(8) - 64/12] = pi*(32/3-16/3) = 16*pi/3.' where id = 'ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74', 'canonical_answer_1', 1, '(a) On [0,4], the square root of x is greater than or equal to x/2, so the area of R is the definite integral from 0 to 4 of (the square root of x - x/2)dx.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74', 'canonical_answer_1', 3, 'Evaluating: (2/3)x^(3/2) - x^2/4 from 0 to 4 gives 16/3 - 4 = 4/3, so the area of R is 4/3.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74', 'canonical_answer_1', 5, '(b) Revolving R about y=-1 with the washer method, the outer radius is the square root of x + 1 and the inner radius is x/2 + 1, giving volume = pi times the integral from 0 to 4 of [(the square root of x + 1)^2 - (x/2+1)^2] dx.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74', 'canonical_answer_1', 7, '(c) Expanding gives 2*sqrt(x) - x^2/4 as the integrand; integrating from 0 to 4 gives pi*[(4/3)(8) - 64/12] = pi*(32/3-16/3) = 16*pi/3.', ARRAY['part-c-criterion-01'], 'drafted');

-- apcalcab-frq-u13-001 (829f41f5-2804-4231-a111-9edb31cda154)
update app.content_item_versions set canonical_answer_1 = '(a) As x approaches 2 from the left, f(x)=x^2-1, giving a left-hand limit of 2^2-1 = 3.

As x approaches 2 from the right, f(x)=2x-1, giving a right-hand limit of 2(2)-1 = 3.

Since x=2 falls in the x<=2 piece, f(2) = 2^2-1 = 3.

(b) Since the left-hand and right-hand limits from part (a) are both 3, the two-sided limit exists.

The one-sided limits agree because both equal 3.

Therefore lim x->2 f(x) = 3.

(c) A function f is continuous at x=c when f(c) is defined, lim x->c f(x) exists, and lim x->c f(x) = f(c).

From parts (a) and (b): f(2)=3 is defined, the limit exists and equals 3, and these two values agree (3=3), so all three conditions hold.

Therefore f is continuous at x=2.' where id = '829f41f5-2804-4231-a111-9edb31cda154';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 1, '(a) As x approaches 2 from the left, f(x)=x^2-1, giving a left-hand limit of 2^2-1 = 3.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 3, 'As x approaches 2 from the right, f(x)=2x-1, giving a right-hand limit of 2(2)-1 = 3.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 5, 'Since x=2 falls in the x<=2 piece, f(2) = 2^2-1 = 3.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 7, '(b) Since the left-hand and right-hand limits from part (a) are both 3, the two-sided limit exists.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 9, 'The one-sided limits agree because both equal 3.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 11, 'Therefore lim x->2 f(x) = 3.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 13, '(c) A function f is continuous at x=c when f(c) is defined, lim x->c f(x) exists, and lim x->c f(x) = f(c).', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 15, 'From parts (a) and (b): f(2)=3 is defined, the limit exists and equals 3, and these two values agree (3=3), so all three conditions hold.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('829f41f5-2804-4231-a111-9edb31cda154', 'canonical_answer_1', 17, 'Therefore f is continuous at x=2.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-002 (d0f2974c-bac9-498d-8173-8a1c88b3d8eb)
update app.content_item_versions set canonical_answer_1 = '(a) At x=-1, the graph shows a closed dot at (-1,1), so g(-1) = 1.

For 2<=x<=4, the graph starts at the closed point (2,3), so g(2) = 3.

(b) As x approaches -1 from the left, the graph approaches the open circle at (-1,4), so the left-hand limit is 4.

As x approaches -1 from the right, the graph follows the horizontal segment at height y=1, so the right-hand limit is 1.

Since the left-hand limit (4) and right-hand limit (1) are unequal, lim x->-1 g(x) does not exist.

(c) As x approaches 2 from the left, the graph follows the horizontal segment at y=1 with an open circle at (2,1), so the left-hand limit is 1.

As x approaches 2 from the right, the graph starts at the closed point (2,3), so the right-hand limit is 3.

Since these one-sided limits (1 and 3) are unequal, lim x->2 g(x) does not exist.

Because the one-sided limits at x=2 are both finite but unequal, this is a jump discontinuity.' where id = 'd0f2974c-bac9-498d-8173-8a1c88b3d8eb';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 1, '(a) At x=-1, the graph shows a closed dot at (-1,1), so g(-1) = 1.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 3, 'For 2<=x<=4, the graph starts at the closed point (2,3), so g(2) = 3.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 5, '(b) As x approaches -1 from the left, the graph approaches the open circle at (-1,4), so the left-hand limit is 4.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 7, 'As x approaches -1 from the right, the graph follows the horizontal segment at height y=1, so the right-hand limit is 1.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 9, 'Since the left-hand limit (4) and right-hand limit (1) are unequal, lim x->-1 g(x) does not exist.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 11, '(c) As x approaches 2 from the left, the graph follows the horizontal segment at y=1 with an open circle at (2,1), so the left-hand limit is 1.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 13, 'As x approaches 2 from the right, the graph starts at the closed point (2,3), so the right-hand limit is 3.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 15, 'Since these one-sided limits (1 and 3) are unequal, lim x->2 g(x) does not exist.', ARRAY['part-c-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('d0f2974c-bac9-498d-8173-8a1c88b3d8eb', 'canonical_answer_1', 17, 'Because the one-sided limits at x=2 are both finite but unequal, this is a jump discontinuity.', ARRAY['part-c-criterion-04'], 'drafted');

-- apcalcab-frq-u13-003 (594f8bc1-35a0-4a04-ac7f-f3835f40f96d)
update app.content_item_versions set canonical_answer_1 = '(a) The average rate of change of h from t=0 to t=6 is (h(6)-h(0))/(6-0).

Using the table, (9.0-2.0)/6 = 7/6, approximately 1.167 cm/day.

This means the plant''s height increased at an average rate of about 1.167 centimeters per day over the first 6 days.

(b) A central difference quotient at t=9 uses the surrounding table values at t=6 and t=12: (h(12)-h(6))/(12-6).

Using the table, (22.0-9.0)/6 = 13/6, approximately 2.167 cm/day.

This estimate carries units of centimeters per day.

(c) The instantaneous rate of growth at t=9 is written h''(9).

h''(9) represents the instantaneous rate of change of the plant''s height, in cm/day, at exactly t=9 -- estimated in part (b) as approximately 2.167 cm/day.

A difference quotient gives only an average rate over an interval, while the derivative h''(9) is the limit of such quotients as the interval width shrinks to 0, giving the instantaneous rate at that single instant.' where id = '594f8bc1-35a0-4a04-ac7f-f3835f40f96d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 1, '(a) The average rate of change of h from t=0 to t=6 is (h(6)-h(0))/(6-0).', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 3, 'Using the table, (9.0-2.0)/6 = 7/6, approximately 1.167 cm/day.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 5, 'This means the plant''s height increased at an average rate of about 1.167 centimeters per day over the first 6 days.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 7, '(b) A central difference quotient at t=9 uses the surrounding table values at t=6 and t=12: (h(12)-h(6))/(12-6).', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 9, 'Using the table, (22.0-9.0)/6 = 13/6, approximately 2.167 cm/day.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 11, 'This estimate carries units of centimeters per day.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 13, '(c) The instantaneous rate of growth at t=9 is written h''(9).', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 15, 'h''(9) represents the instantaneous rate of change of the plant''s height, in cm/day, at exactly t=9 -- estimated in part (b) as approximately 2.167 cm/day.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('594f8bc1-35a0-4a04-ac7f-f3835f40f96d', 'canonical_answer_1', 17, 'A difference quotient gives only an average rate over an interval, while the derivative h''(9) is the limit of such quotients as the interval width shrinks to 0, giving the instantaneous rate at that single instant.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-004 (f786dc8a-a3c4-497f-a271-24a2da334fcd)
update app.content_item_versions set canonical_answer_1 = 'Limit 1: (x^2-9)/(x^2-x-6) factors as (x-3)(x+3)/[(x-3)(x+2)].

The common factor (x-3) cancels (valid since x approaches, but never equals, 3), leaving (x+3)/(x+2).

Substituting x=3: (3+3)/(3+2) = 6/5.

Limit 2: multiply (sqrt(x+4)-2)/x by the conjugate (sqrt(x+4)+2)/(sqrt(x+4)+2).

The numerator becomes (x+4)-4 = x, so the expression simplifies to 1/(sqrt(x+4)+2).

Substituting x=0: 1/(2+2) = 1/4.

Direct substitution gives the indeterminate form 0/0 in both cases.

Limit 1''s 0/0 comes from a shared polynomial factor, so factor-and-cancel is the right technique; Limit 2''s 0/0 comes from a square root, so rationalizing via the conjugate is the right technique.

Each technique removes the shared factor that makes both numerator and denominator vanish at the limit point, leaving an expression that can be evaluated directly by substitution.' where id = 'f786dc8a-a3c4-497f-a271-24a2da334fcd';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 1, 'Limit 1: (x^2-9)/(x^2-x-6) factors as (x-3)(x+3)/[(x-3)(x+2)].', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 3, 'The common factor (x-3) cancels (valid since x approaches, but never equals, 3), leaving (x+3)/(x+2).', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 5, 'Substituting x=3: (3+3)/(3+2) = 6/5.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 7, 'Limit 2: multiply (sqrt(x+4)-2)/x by the conjugate (sqrt(x+4)+2)/(sqrt(x+4)+2).', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 9, 'The numerator becomes (x+4)-4 = x, so the expression simplifies to 1/(sqrt(x+4)+2).', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 11, 'Substituting x=0: 1/(2+2) = 1/4.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 13, 'Direct substitution gives the indeterminate form 0/0 in both cases.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 15, 'Limit 1''s 0/0 comes from a shared polynomial factor, so factor-and-cancel is the right technique; Limit 2''s 0/0 comes from a square root, so rationalizing via the conjugate is the right technique.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('f786dc8a-a3c4-497f-a271-24a2da334fcd', 'canonical_answer_1', 17, 'Each technique removes the shared factor that makes both numerator and denominator vanish at the limit point, leaving an expression that can be evaluated directly by substitution.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-005 (66c7e7de-16e7-4d06-a7ac-25e80a6d8f22)
update app.content_item_versions set canonical_answer_1 = '(a) As x approaches 1 from the left, f(x)=x+5 gives a left-hand limit of 6; as x approaches 1 from the right, f(x)=-x^2+4x+3 gives a right-hand limit of -1+4+3=6, so lim x->1 f(x) = 6.

By the piecewise definition, f(1) = 3.

(b) Since the limit (6) exists but does not equal f(1) (3), this is a removable discontinuity.

In the three-part definition of continuity, the first two conditions hold, but the third -- that the limit equals f(1) -- fails.

Redefining f(1) to equal 6 would remove the discontinuity.

(c) As x approaches 3 from the left, f(x)=-x^2+4x+3 gives a left-hand limit of -9+12+3=6.

As x approaches 3 from the right, f(x)=1/(x-3), and as x-3 approaches 0 from the positive side, this grows without bound, so the right-hand limit is positive infinity.

Since the right-hand limit is unbounded, lim x->3 f(x) does not exist.

Because one side is infinite, this is an infinite discontinuity, with a vertical asymptote at x=3.' where id = '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 1, '(a) As x approaches 1 from the left, f(x)=x+5 gives a left-hand limit of 6; as x approaches 1 from the right, f(x)=-x^2+4x+3 gives a right-hand limit of -1+4+3=6, so lim x->1 f(x) = 6.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 3, 'By the piecewise definition, f(1) = 3.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 5, '(b) Since the limit (6) exists but does not equal f(1) (3), this is a removable discontinuity.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 7, 'In the three-part definition of continuity, the first two conditions hold, but the third -- that the limit equals f(1) -- fails.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 9, 'Redefining f(1) to equal 6 would remove the discontinuity.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 11, '(c) As x approaches 3 from the left, f(x)=-x^2+4x+3 gives a left-hand limit of -9+12+3=6.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 13, 'As x approaches 3 from the right, f(x)=1/(x-3), and as x-3 approaches 0 from the positive side, this grows without bound, so the right-hand limit is positive infinity.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 15, 'Since the right-hand limit is unbounded, lim x->3 f(x) does not exist.', ARRAY['part-c-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22', 'canonical_answer_1', 17, 'Because one side is infinite, this is an infinite discontinuity, with a vertical asymptote at x=3.', ARRAY['part-c-criterion-04'], 'drafted');

-- apcalcab-frq-u13-006 (2f5e9638-893a-42bc-8b31-8b316a216968)
update app.content_item_versions set canonical_answer_1 = '(a) The average rate of change from t=2 to t=6 is (T(6)-T(2))/(6-2).

Using the table, this evaluates to -4.5 degrees C per minute.

(b) At t=0, only a forward difference is available since t=0 is the left endpoint of the table.

This forward difference quotient evaluates to -6 degrees C per minute.

This result is only an approximation to T''(0), not its exact value, since it uses average rather than instantaneous behavior.

(c) The instantaneous rate of change at t=6 is written T''(6).

Using a central difference around t=6, T''(6) is estimated as approximately -3.5 degrees C per minute.

A central difference incorporates the function''s behavior on both sides of the point, rather than only one side.

This makes it a better model of the true derivative than a one-sided quotient, since the derivative itself is defined as a two-sided limit.' where id = '2f5e9638-893a-42bc-8b31-8b316a216968';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 1, '(a) The average rate of change from t=2 to t=6 is (T(6)-T(2))/(6-2).', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 3, 'Using the table, this evaluates to -4.5 degrees C per minute.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 5, '(b) At t=0, only a forward difference is available since t=0 is the left endpoint of the table.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 7, 'This forward difference quotient evaluates to -6 degrees C per minute.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 9, 'This result is only an approximation to T''(0), not its exact value, since it uses average rather than instantaneous behavior.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 11, '(c) The instantaneous rate of change at t=6 is written T''(6).', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 13, 'Using a central difference around t=6, T''(6) is estimated as approximately -3.5 degrees C per minute.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 15, 'A central difference incorporates the function''s behavior on both sides of the point, rather than only one side.', ARRAY['part-c-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('2f5e9638-893a-42bc-8b31-8b316a216968', 'canonical_answer_1', 17, 'This makes it a better model of the true derivative than a one-sided quotient, since the derivative itself is defined as a two-sided limit.', ARRAY['part-c-criterion-04'], 'drafted');

-- apcalcab-frq-u13-007 (7a8363c6-f70b-43a7-ae03-3f9943157edc)
update app.content_item_versions set canonical_answer_1 = '(a) By the power rule, the derivative of 3x^4 is 12x^3 and the derivative of -8x^3 is -24x^2.

The derivative of 5x is 5, and the derivative of the constant -6 is 0.

Assembling these gives f''(x) = 12x^3 - 24x^2 + 5.

(b) f''(1) = 12-24+5 = -7.

f''(-1) = -12-24+5 = -31.

A horizontal tangent occurs where f''(x)=0, so the equation to solve is 12x^3-24x^2+5 = 0.

(c) By the constant multiple and sum rules, g''(x) = 5f''(x) - 6x^2.

Substituting f''(x) = 12x^3-24x^2+5 from part (a): g''(x) = 5(12x^3-24x^2+5) - 6x^2.

Simplifying: g''(x) = 60x^3 - 120x^2 + 25 - 6x^2 = 60x^3 - 126x^2 + 25.' where id = '7a8363c6-f70b-43a7-ae03-3f9943157edc';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 1, '(a) By the power rule, the derivative of 3x^4 is 12x^3 and the derivative of -8x^3 is -24x^2.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 3, 'The derivative of 5x is 5, and the derivative of the constant -6 is 0.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 5, 'Assembling these gives f''(x) = 12x^3 - 24x^2 + 5.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 7, '(b) f''(1) = 12-24+5 = -7.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 9, 'f''(-1) = -12-24+5 = -31.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 11, 'A horizontal tangent occurs where f''(x)=0, so the equation to solve is 12x^3-24x^2+5 = 0.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 13, '(c) By the constant multiple and sum rules, g''(x) = 5f''(x) - 6x^2.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 15, 'Substituting f''(x) = 12x^3-24x^2+5 from part (a): g''(x) = 5(12x^3-24x^2+5) - 6x^2.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('7a8363c6-f70b-43a7-ae03-3f9943157edc', 'canonical_answer_1', 17, 'Simplifying: g''(x) = 60x^3 - 120x^2 + 25 - 6x^2 = 60x^3 - 126x^2 + 25.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-008 (fd460169-7f26-45b2-a7d7-e96a174f5d5d)
update app.content_item_versions set canonical_answer_1 = '(a) The product rule states (uv)'' = u''v + uv''.

Let u = x^2, so u'' = 2x.

Let v = e^x, so v'' = e^x.

(b) Substituting into the product rule: h''(x) = 2x*e^x + x^2*e^x.

Factoring out e^x gives e^x(x^2+2x).

So the final derivative is h''(x) = e^x*x*(x+2).

(c) h''(0) = e^0*0*(0+2) = 0.

h''(1) = e^1*1*(1+2) = 3e, approximately 8.15.

Since h''(0)=0, the tangent line to h at x=0 is horizontal.' where id = 'fd460169-7f26-45b2-a7d7-e96a174f5d5d';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 1, '(a) The product rule states (uv)'' = u''v + uv''.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 3, 'Let u = x^2, so u'' = 2x.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 5, 'Let v = e^x, so v'' = e^x.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 7, '(b) Substituting into the product rule: h''(x) = 2x*e^x + x^2*e^x.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 9, 'Factoring out e^x gives e^x(x^2+2x).', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 11, 'So the final derivative is h''(x) = e^x*x*(x+2).', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 13, '(c) h''(0) = e^0*0*(0+2) = 0.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 15, 'h''(1) = e^1*1*(1+2) = 3e, approximately 8.15.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('fd460169-7f26-45b2-a7d7-e96a174f5d5d', 'canonical_answer_1', 17, 'Since h''(0)=0, the tangent line to h at x=0 is horizontal.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-009 (92b7fc1f-e3df-4f44-a251-540fee43da11)
update app.content_item_versions set canonical_answer_1 = '(a) f(x) = sin(3x^2-5x) has outer function sin(u) and inner function u = 3x^2-5x.

The chain rule states d/dx[f(g(x))] = f''(g(x))*g''(x).

The inner derivative is g''(x) = 6x-5.

(b) The outer derivative evaluated at the inner function is cos(3x^2-5x).

Multiplying by the inner derivative (6x-5) per the chain rule gives the product cos(3x^2-5x)*(6x-5).

So f''(x) = (6x-5)cos(3x^2-5x).

(c) f''(0) = (0-5)cos(0) = -5*1 = -5.

f''(5/6) = (6*(5/6)-5)cos(...) = (5-5)cos(...) = 0, since the factor (6x-5) vanishes at x=5/6.

Because f''(5/6)=0, the graph of f has a horizontal tangent at x=5/6.' where id = '92b7fc1f-e3df-4f44-a251-540fee43da11';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 1, '(a) f(x) = sin(3x^2-5x) has outer function sin(u) and inner function u = 3x^2-5x.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 3, 'The chain rule states d/dx[f(g(x))] = f''(g(x))*g''(x).', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 5, 'The inner derivative is g''(x) = 6x-5.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 7, '(b) The outer derivative evaluated at the inner function is cos(3x^2-5x).', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 9, 'Multiplying by the inner derivative (6x-5) per the chain rule gives the product cos(3x^2-5x)*(6x-5).', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 11, 'So f''(x) = (6x-5)cos(3x^2-5x).', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 13, '(c) f''(0) = (0-5)cos(0) = -5*1 = -5.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 15, 'f''(5/6) = (6*(5/6)-5)cos(...) = (5-5)cos(...) = 0, since the factor (6x-5) vanishes at x=5/6.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('92b7fc1f-e3df-4f44-a251-540fee43da11', 'canonical_answer_1', 17, 'Because f''(5/6)=0, the graph of f has a horizontal tangent at x=5/6.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-010 (daf9d061-631a-4f52-a59d-92d39431e448)
update app.content_item_versions set canonical_answer_1 = '(a) k is continuous on [0,1], satisfying the hypothesis of the Intermediate Value Theorem there.

k(0) = -3 and k(1) = 2, so 0 lies between k(0) and k(1) (-3 < 0 < 2).

By the IVT, there exists a value c in (0,1) with k(c) = 0.

(b) k is continuous on [1,3], satisfying the IVT''s hypothesis.

k(1)=2 and k(3)=-4, so -1 lies between them (-4 < -1 < 2).

Yes, the IVT guarantees at least one c in (1,3) with k(c) = -1.

(c) The claim of exactly one such c is unjustified: the IVT only guarantees the existence of at least one c, not uniqueness.

Since k(2)=1 and k(3)=-4, k could cross the value 0 more than once in (2,3) without contradicting the IVT or continuity.

The correct, fully supportable conclusion is that the IVT guarantees at least one, not necessarily exactly one, c in (2,3) with k(c)=0.' where id = 'daf9d061-631a-4f52-a59d-92d39431e448';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 1, '(a) k is continuous on [0,1], satisfying the hypothesis of the Intermediate Value Theorem there.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 3, 'k(0) = -3 and k(1) = 2, so 0 lies between k(0) and k(1) (-3 < 0 < 2).', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 5, 'By the IVT, there exists a value c in (0,1) with k(c) = 0.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 7, '(b) k is continuous on [1,3], satisfying the IVT''s hypothesis.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 9, 'k(1)=2 and k(3)=-4, so -1 lies between them (-4 < -1 < 2).', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 11, 'Yes, the IVT guarantees at least one c in (1,3) with k(c) = -1.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 13, '(c) The claim of exactly one such c is unjustified: the IVT only guarantees the existence of at least one c, not uniqueness.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 15, 'Since k(2)=1 and k(3)=-4, k could cross the value 0 more than once in (2,3) without contradicting the IVT or continuity.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('daf9d061-631a-4f52-a59d-92d39431e448', 'canonical_answer_1', 17, 'The correct, fully supportable conclusion is that the IVT guarantees at least one, not necessarily exactly one, c in (2,3) with k(c)=0.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-011 (a10d5a79-0d50-4945-adb0-b4942902ac34)
update app.content_item_versions set canonical_answer_1 = '(a) r(x) = (2x^2-3x-5)/(x^2-4) factors as (2x-5)(x+1)/[(x-2)(x+2)].

There are no common factors between numerator and denominator, so both x=2 and x=-2 are candidates for vertical asymptotes.

The vertical asymptotes occur at x=2 and x=-2.

(b) Near x=2, the numerator (2x-5)(x+1) evaluates to (4-5)(3) = -3, which is negative.

As x approaches 2 from the right, (x-2)(x+2) approaches 0 from the positive side; as x approaches 2 from the left, it approaches 0 from the negative side.

So lim x->2+ r(x) = -3/0+ = negative infinity, and lim x->2- r(x) = -3/0- = positive infinity.

(c) Near x=-2, the numerator evaluates to (2(-2)-5)(-2+1) = (-9)(-1) = 9, which is positive.

As x approaches -2 from the right, (x-2)(x+2) approaches 0 from the negative side, giving lim x->-2+ r(x) = 9/0- = negative infinity; as x approaches -2 from the left, it approaches 0 from the positive side, giving lim x->-2- r(x) = 9/0+ = positive infinity.

The vertical asymptote at this location is x = -2.' where id = 'a10d5a79-0d50-4945-adb0-b4942902ac34';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 1, '(a) r(x) = (2x^2-3x-5)/(x^2-4) factors as (2x-5)(x+1)/[(x-2)(x+2)].', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 3, 'There are no common factors between numerator and denominator, so both x=2 and x=-2 are candidates for vertical asymptotes.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 5, 'The vertical asymptotes occur at x=2 and x=-2.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 7, '(b) Near x=2, the numerator (2x-5)(x+1) evaluates to (4-5)(3) = -3, which is negative.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 9, 'As x approaches 2 from the right, (x-2)(x+2) approaches 0 from the positive side; as x approaches 2 from the left, it approaches 0 from the negative side.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 11, 'So lim x->2+ r(x) = -3/0+ = negative infinity, and lim x->2- r(x) = -3/0- = positive infinity.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 13, '(c) Near x=-2, the numerator evaluates to (2(-2)-5)(-2+1) = (-9)(-1) = 9, which is positive.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 15, 'As x approaches -2 from the right, (x-2)(x+2) approaches 0 from the negative side, giving lim x->-2+ r(x) = 9/0- = negative infinity; as x approaches -2 from the left, it approaches 0 from the positive side, giving lim x->-2- r(x) = 9/0+ = positive infinity.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('a10d5a79-0d50-4945-adb0-b4942902ac34', 'canonical_answer_1', 17, 'The vertical asymptote at this location is x = -2.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-012 (87949000-95db-4cf3-a1eb-c14767be7728)
update app.content_item_versions set canonical_answer_1 = '(a) From the trend 5.72, 5.97 as x approaches 2 from the left, lim x->2- m(x) is approximately 6.

From the trend 6.03, 6.28 as x approaches 2 from the right, lim x->2+ m(x) is also approximately 6.

Since both one-sided estimates approach the same value, the two-sided limit exists and equals 6.

This conclusion is justified because both one-sided trends converge to the same number.

(b) Comparing lim x->2 m(x) = 6 (from part a) to the given value m(2) = 5, per the continuity definition.

Since the limit (6) does not equal m(2) (5), m is not continuous at x=2.

This is a removable discontinuity, since the limit exists but disagrees with the function value.

(c) Define n(x) = m(x) for all x not equal to 2.

Set n(2) = 6 (the value of the limit) to make n continuous at x=2.' where id = '87949000-95db-4cf3-a1eb-c14767be7728';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 1, '(a) From the trend 5.72, 5.97 as x approaches 2 from the left, lim x->2- m(x) is approximately 6.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 3, 'From the trend 6.03, 6.28 as x approaches 2 from the right, lim x->2+ m(x) is also approximately 6.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 5, 'Since both one-sided estimates approach the same value, the two-sided limit exists and equals 6.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 7, 'This conclusion is justified because both one-sided trends converge to the same number.', ARRAY['part-a-criterion-04'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 9, '(b) Comparing lim x->2 m(x) = 6 (from part a) to the given value m(2) = 5, per the continuity definition.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 11, 'Since the limit (6) does not equal m(2) (5), m is not continuous at x=2.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 13, 'This is a removable discontinuity, since the limit exists but disagrees with the function value.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 15, '(c) Define n(x) = m(x) for all x not equal to 2.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('87949000-95db-4cf3-a1eb-c14767be7728', 'canonical_answer_1', 17, 'Set n(2) = 6 (the value of the limit) to make n continuous at x=2.', ARRAY['part-c-criterion-02'], 'drafted');

-- apcalcab-frq-u13-013 (3befbb63-72fe-45f2-a2d9-8fa58c57300f)
update app.content_item_versions set canonical_answer_1 = '(a) The quotient rule states (u/v)'' = (u''v - uv'')/v^2.

Let u = 3x^2+1, so u'' = 6x.

Let v = x-4, so v'' = 1.

(b) Substituting into the quotient rule: p''(x) = [6x(x-4) - (3x^2+1)(1)]/(x-4)^2.

Expanding the numerator: 6x^2-24x-3x^2-1 = 3x^2-24x-1.

So p''(x) = (3x^2-24x-1)/(x-4)^2.

(c) p(0) = (3*0+1)/(0-4) = 1/(-4) = -1/4.

p''(0) = (0-0-1)/(-4)^2 = -1/16.

The tangent line at x=0 is y = -1/16 x - 1/4.' where id = '3befbb63-72fe-45f2-a2d9-8fa58c57300f';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 1, '(a) The quotient rule states (u/v)'' = (u''v - uv'')/v^2.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 3, 'Let u = 3x^2+1, so u'' = 6x.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 5, 'Let v = x-4, so v'' = 1.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 7, '(b) Substituting into the quotient rule: p''(x) = [6x(x-4) - (3x^2+1)(1)]/(x-4)^2.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 9, 'Expanding the numerator: 6x^2-24x-3x^2-1 = 3x^2-24x-1.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 11, 'So p''(x) = (3x^2-24x-1)/(x-4)^2.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 13, '(c) p(0) = (3*0+1)/(0-4) = 1/(-4) = -1/4.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 15, 'p''(0) = (0-0-1)/(-4)^2 = -1/16.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3befbb63-72fe-45f2-a2d9-8fa58c57300f', 'canonical_answer_1', 17, 'The tangent line at x=0 is y = -1/16 x - 1/4.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-014 (3b86e94b-3723-498c-a653-2952a034223c)
update app.content_item_versions set canonical_answer_1 = '(a) The derivative of tan(x) is sec^2(x).

The derivative of 3sec(x) is 3sec(x)tan(x).

The derivative of -2x is -2, so q''(x) = sec^2(x) + 3sec(x)tan(x) - 2.

(b) At x=pi/4, sec(pi/4) = the square root of 2 and tan(pi/4) = 1.

So sec^2(pi/4) = 2.

q''(pi/4) = 2 + 3*(the square root of 2)*1 - 2 = 3*the square root of 2.

(c) At x=0, sec(0)=1 and tan(0)=0.

q''(0) = 1 + 3*1*0 - 2 = -1.

Since q''(0) = -1 is not 0, there is no horizontal tangent to the graph of q at x=0.' where id = '3b86e94b-3723-498c-a653-2952a034223c';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 1, '(a) The derivative of tan(x) is sec^2(x).', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 3, 'The derivative of 3sec(x) is 3sec(x)tan(x).', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 5, 'The derivative of -2x is -2, so q''(x) = sec^2(x) + 3sec(x)tan(x) - 2.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 7, '(b) At x=pi/4, sec(pi/4) = the square root of 2 and tan(pi/4) = 1.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 9, 'So sec^2(pi/4) = 2.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 11, 'q''(pi/4) = 2 + 3*(the square root of 2)*1 - 2 = 3*the square root of 2.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 13, '(c) At x=0, sec(0)=1 and tan(0)=0.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 15, 'q''(0) = 1 + 3*1*0 - 2 = -1.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('3b86e94b-3723-498c-a653-2952a034223c', 'canonical_answer_1', 17, 'Since q''(0) = -1 is not 0, there is no horizontal tangent to the graph of q at x=0.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-015 (b00b9a52-ad49-4f07-a7a6-4911a180f91a)
update app.content_item_versions set canonical_answer_1 = '(a) The derivative of x^2 with respect to x is 2x.

By the product rule, the derivative of xy with respect to x is y + x*y''.

By the chain rule, the derivative of y^2 with respect to x is 2y*y''.

(b) So 2x + y + x*y'' + 2y*y'' = 0; collecting the y'' terms gives x*y'' + 2y*y'' = -2x-y.

Factoring: y''(x+2y) = -(2x+y).

So dy/dx = -(2x+y)/(x+2y).

(c) Substituting x=2, y=1 into dy/dx = -(2x+y)/(x+2y).

dy/dx = -(4+1)/(2+2) = -5/4 at (2,1).

The tangent line at (2,1) is y - 1 = -5/4(x-2).' where id = 'b00b9a52-ad49-4f07-a7a6-4911a180f91a';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 1, '(a) The derivative of x^2 with respect to x is 2x.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 3, 'By the product rule, the derivative of xy with respect to x is y + x*y''.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 5, 'By the chain rule, the derivative of y^2 with respect to x is 2y*y''.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 7, '(b) So 2x + y + x*y'' + 2y*y'' = 0; collecting the y'' terms gives x*y'' + 2y*y'' = -2x-y.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 9, 'Factoring: y''(x+2y) = -(2x+y).', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 11, 'So dy/dx = -(2x+y)/(x+2y).', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 13, '(c) Substituting x=2, y=1 into dy/dx = -(2x+y)/(x+2y).', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 15, 'dy/dx = -(4+1)/(2+2) = -5/4 at (2,1).', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('b00b9a52-ad49-4f07-a7a6-4911a180f91a', 'canonical_answer_1', 17, 'The tangent line at (2,1) is y - 1 = -5/4(x-2).', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-016 (798d58ab-6661-4293-a380-7ca6a7245909)
update app.content_item_versions set canonical_answer_1 = '(a) The inverse-function derivative formula is (f^-1)''(x) = 1/f''(f^-1(x)).

From the table, f(3)=8, so a=3 satisfies f(a)=8.

Since g = f^-1, g(8) = 3.

(b) Applying the formula, g''(8) = 1/f''(3).

From the table, f''(3) = 4.

So g''(8) = 1/4.

(c) Since f(2)=5, g(5) = 2.

g''(5) = 1/f''(2) = 1/3.

The tangent line to g at x=5 is y - 2 = (1/3)(x-5).' where id = '798d58ab-6661-4293-a380-7ca6a7245909';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 1, '(a) The inverse-function derivative formula is (f^-1)''(x) = 1/f''(f^-1(x)).', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 3, 'From the table, f(3)=8, so a=3 satisfies f(a)=8.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 5, 'Since g = f^-1, g(8) = 3.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 7, '(b) Applying the formula, g''(8) = 1/f''(3).', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 9, 'From the table, f''(3) = 4.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 11, 'So g''(8) = 1/4.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 13, '(c) Since f(2)=5, g(5) = 2.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 15, 'g''(5) = 1/f''(2) = 1/3.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('798d58ab-6661-4293-a380-7ca6a7245909', 'canonical_answer_1', 17, 'The tangent line to g at x=5 is y - 2 = (1/3)(x-5).', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-017 (bb06d698-561d-40bc-a57f-f4181365b134)
update app.content_item_versions set canonical_answer_1 = '(a) For the arctan term, d/dx[arctan(u)] = u''/(1+u^2) with u=2x, u''=2.

For the arcsin term, d/dx[arcsin(u)] = u''/sqrt(1-u^2) with u=x/3, u''=1/3.

This formula requires -3 < x < 3 for the arcsin term to be differentiable there.

(b) The arctan term contributes 2/(1+4x^2).

The arcsin term, before simplifying, is (1/3)/sqrt(1-x^2/9).

Simplifying the arcsin term to 1/sqrt(9-x^2) gives w''(x) = 2/(1+4x^2) + 1/sqrt(9-x^2).

(c) w''(0) = 2/(1+0) + 1/sqrt(9-0) = 2 + 1/3 = 7/3.

The domain restriction on w''(x) is -3 < x < 3.

This is strict (not <=) because arcsin(x/3) requires -3<=x<=3 but the derivative''s denominator sqrt(9-x^2) cannot equal 0, which rules out the endpoints.' where id = 'bb06d698-561d-40bc-a57f-f4181365b134';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 1, '(a) For the arctan term, d/dx[arctan(u)] = u''/(1+u^2) with u=2x, u''=2.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 3, 'For the arcsin term, d/dx[arcsin(u)] = u''/sqrt(1-u^2) with u=x/3, u''=1/3.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 5, 'This formula requires -3 < x < 3 for the arcsin term to be differentiable there.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 7, '(b) The arctan term contributes 2/(1+4x^2).', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 9, 'The arcsin term, before simplifying, is (1/3)/sqrt(1-x^2/9).', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 11, 'Simplifying the arcsin term to 1/sqrt(9-x^2) gives w''(x) = 2/(1+4x^2) + 1/sqrt(9-x^2).', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 13, '(c) w''(0) = 2/(1+0) + 1/sqrt(9-0) = 2 + 1/3 = 7/3.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 15, 'The domain restriction on w''(x) is -3 < x < 3.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bb06d698-561d-40bc-a57f-f4181365b134', 'canonical_answer_1', 17, 'This is strict (not <=) because arcsin(x/3) requires -3<=x<=3 but the derivative''s denominator sqrt(9-x^2) cannot equal 0, which rules out the endpoints.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-018 (c794879c-9f93-41bb-883c-d0688834fb30)
update app.content_item_versions set canonical_answer_1 = '(a) lim x->0 sin(5/x) does not exist, because it oscillates between -1 and 1 infinitely often as x approaches 0.

The product rule for limits cannot be applied here because it requires both individual limits (of x^4 and of sin(5/x)) to exist, and the second does not.

An alternative method, the Squeeze Theorem, is needed instead.

(b) For all x not equal to 0, -1 <= sin(5/x) <= 1.

Multiplying through by x^4 (nonnegative) gives -x^4 <= x^4sin(5/x) <= x^4.

This inequality holds for all x not equal to 0.

(c) lim x->0 (-x^4) = 0 and lim x->0 x^4 = 0.

By the Squeeze Theorem, since both bounding functions converge to the same value, the function trapped between them converges to that value too.

Therefore lim x->0 x^4sin(5/x) = 0.' where id = 'c794879c-9f93-41bb-883c-d0688834fb30';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 1, '(a) lim x->0 sin(5/x) does not exist, because it oscillates between -1 and 1 infinitely often as x approaches 0.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 3, 'The product rule for limits cannot be applied here because it requires both individual limits (of x^4 and of sin(5/x)) to exist, and the second does not.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 5, 'An alternative method, the Squeeze Theorem, is needed instead.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 7, '(b) For all x not equal to 0, -1 <= sin(5/x) <= 1.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 9, 'Multiplying through by x^4 (nonnegative) gives -x^4 <= x^4sin(5/x) <= x^4.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 11, 'This inequality holds for all x not equal to 0.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 13, '(c) lim x->0 (-x^4) = 0 and lim x->0 x^4 = 0.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 15, 'By the Squeeze Theorem, since both bounding functions converge to the same value, the function trapped between them converges to that value too.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('c794879c-9f93-41bb-883c-d0688834fb30', 'canonical_answer_1', 17, 'Therefore lim x->0 x^4sin(5/x) = 0.', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-019 (529f709a-1910-4ffd-a628-d864a9a53d43)
update app.content_item_versions set canonical_answer_1 = '(a) Differentiating x^2+y^2=25 implicitly gives 2x + 2y*y'' = 0.

Solving gives y'' = -x/y.

At (3,4), which lies on the curve since 3^2+4^2=25, y'' = -3/4.

(b) Differentiating y'' = -x/y again via the quotient rule: y'''' = [(-1)(y) - (-x)(y'')]/y^2.

The numerator simplifies to -y + x*y''.

So y'''' = (x*y'' - y)/y^2.

(c) Substituting y'' = -x/y from part (a) into this expression for y''''.

At (3,4) with y''=-3/4: the numerator is 3*(-3/4) - 4 = -9/4-4 = -25/4, and y^2=16.

So y'''' = (-25/4)/16 = -25/64 at (3,4).' where id = '529f709a-1910-4ffd-a628-d864a9a53d43';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 1, '(a) Differentiating x^2+y^2=25 implicitly gives 2x + 2y*y'' = 0.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 3, 'Solving gives y'' = -x/y.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 5, 'At (3,4), which lies on the curve since 3^2+4^2=25, y'' = -3/4.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 7, '(b) Differentiating y'' = -x/y again via the quotient rule: y'''' = [(-1)(y) - (-x)(y'')]/y^2.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 9, 'The numerator simplifies to -y + x*y''.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 11, 'So y'''' = (x*y'' - y)/y^2.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 13, '(c) Substituting y'' = -x/y from part (a) into this expression for y''''.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 15, 'At (3,4) with y''=-3/4: the numerator is 3*(-3/4) - 4 = -9/4-4 = -25/4, and y^2=16.', ARRAY['part-c-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('529f709a-1910-4ffd-a628-d864a9a53d43', 'canonical_answer_1', 17, 'So y'''' = (-25/4)/16 = -25/64 at (3,4).', ARRAY['part-c-criterion-03'], 'drafted');

-- apcalcab-frq-u13-020 (bc2104db-65a3-4a64-a42d-1e7997a70d61)
update app.content_item_versions set canonical_answer_1 = '(a) As x approaches 0 from the left, e^(2x) approaches e^0 = 1.

As x approaches 0 from the right, 1+3x approaches 1, consistent with f(0)=1.

Since both one-sided limits equal 1 = f(0), f is continuous at x=0.

(b) The left-hand derivative, via the chain rule on e^(2x), is 2e^(2x); at x=0 this is 2e^0 = 2.

The right-hand derivative of 1+3x is 3.

These one-sided derivatives, 2 and 3, are unequal.

Because the definition of differentiability requires equal one-sided derivatives, f is not differentiable at x=0, even though f is continuous there -- continuity does not imply differentiability.

(c) Yes: differentiability at a point always implies continuity at that point.

This is a general theorem, and f itself illustrates that the converse is false, since f is continuous but not differentiable at x=0.' where id = 'bc2104db-65a3-4a64-a42d-1e7997a70d61';
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 1, '(a) As x approaches 0 from the left, e^(2x) approaches e^0 = 1.', ARRAY['part-a-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 2, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 3, 'As x approaches 0 from the right, 1+3x approaches 1, consistent with f(0)=1.', ARRAY['part-a-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 4, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 5, 'Since both one-sided limits equal 1 = f(0), f is continuous at x=0.', ARRAY['part-a-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 6, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 7, '(b) The left-hand derivative, via the chain rule on e^(2x), is 2e^(2x); at x=0 this is 2e^0 = 2.', ARRAY['part-b-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 8, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 9, 'The right-hand derivative of 1+3x is 3.', ARRAY['part-b-criterion-02'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 10, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 11, 'These one-sided derivatives, 2 and 3, are unequal.', ARRAY['part-b-criterion-03'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 12, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 13, 'Because the definition of differentiability requires equal one-sided derivatives, f is not differentiable at x=0, even though f is continuous there -- continuity does not imply differentiability.', ARRAY['part-b-criterion-04'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 14, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 15, '(c) Yes: differentiability at a point always implies continuity at that point.', ARRAY['part-c-criterion-01'], 'drafted');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 16, '

', ARRAY[]::text[], 'assembly_literal');
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance) values ('bc2104db-65a3-4a64-a42d-1e7997a70d61', 'canonical_answer_1', 17, 'This is a general theorem, and f itself illustrates that the converse is false, since f is continuous but not differentiable at x=0.', ARRAY['part-c-criterion-02'], 'drafted');

do $$
declare
  v_bad text;
begin
  -- verify concatenation of spans equals canonical_answer_1 for each of the 33 items
  select string_agg(civ.id::text, ', ') into v_bad
  from (values ('c975c3ce-6e5b-4618-8ecc-776f750fbafc'::uuid),('b21ebb17-3823-41ad-bf55-4c68e9e3d8f3'::uuid),('400885fa-5480-4b13-b26e-deb87d9fdfa0'::uuid),('8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4'::uuid),('2be7e655-9c90-42d4-ac84-59146fd84599'::uuid),('095a5088-1d13-463a-a8d5-73726adc81e2'::uuid),('2aa9f09d-7d8f-446a-a687-1ed543858db7'::uuid),('c9bbae66-e509-49d4-8ca1-e029c41d2668'::uuid),('dc1f2f7d-12ce-4735-be3d-c3fa85c802cd'::uuid),('e2434089-78b6-4091-8553-4664beef7549'::uuid),('72973fb2-f772-4729-b9cb-e21d6ba8650d'::uuid),('9803edbb-ed8a-439e-b71f-c29204dcf34c'::uuid),('ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74'::uuid),('829f41f5-2804-4231-a111-9edb31cda154'::uuid),('d0f2974c-bac9-498d-8173-8a1c88b3d8eb'::uuid),('594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid),('f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid),('66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid),('2f5e9638-893a-42bc-8b31-8b316a216968'::uuid),('7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid),('fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid),('92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid),('daf9d061-631a-4f52-a59d-92d39431e448'::uuid),('a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid),('87949000-95db-4cf3-a1eb-c14767be7728'::uuid),('3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid),('3b86e94b-3723-498c-a653-2952a034223c'::uuid),('b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid),('798d58ab-6661-4293-a380-7ca6a7245909'::uuid),('bb06d698-561d-40bc-a57f-f4181365b134'::uuid),('c794879c-9f93-41bb-883c-d0688834fb30'::uuid),('529f709a-1910-4ffd-a628-d864a9a53d43'::uuid),('bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid)) as t(vid)
  join app.content_item_versions civ on civ.id = t.vid
  cross join lateral (
    select string_agg(cas.span_text, '' order by cas.span_ordinal) as concat
    from app.canonical_answer_spans cas
    where cas.content_item_version_id = civ.id and cas.answer_field = 'canonical_answer_1'
  ) agg
  where agg.concat is distinct from civ.canonical_answer_1;

  if v_bad is not null then
    raise exception 'span concatenation mismatch for version ids: %', v_bad;
  end if;
end $$;

commit;