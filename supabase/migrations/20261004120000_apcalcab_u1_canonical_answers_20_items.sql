-- AP Calculus AB, servability criterion 4: canonical answers for the 20 FRQs published 2026-09-30 without one
-- (apcalcab-frq-u1n-001..005, apcalcab-frq-u1v-001..005-v1..v3). Found by the 2026-10-04 six-criteria re-run
-- (docs/product/SUBJECT_SERVABILITY_CRITERIA.md).
--
-- Same pattern as 20260925010000_apcalcab_canonical_answers_33_items.sql: canonical_answer_1 is one span per
-- frq_criteria.criterion_key, in rubric order, joined by assembly_literal blank lines; the spans are written to
-- app.canonical_answer_spans. In-place write on the current published version (no new version): it adds an
-- answer key, it does not change question content, rubric or grading. Every value was re-derived from each
-- item's own stimulus and stem, checked numerically, and reviewed independently before apply.
--
-- Label carry-forward. app.taxonomy_relevant_hash() covers canonical_answer_1, so the write fires
-- tg_content_versions_taxonomy_stale and all 20 items' human-validated serving labels go 'stale', which drops
-- them from unit-gated serving. In the same transaction this file restores each label to 'validated' with its
-- ORIGINAL validated_by / validated_at / validation_decision_id (captured before the write) and re-points
-- validated_against_taxo_hash at the new hash. Units, topics and confidence are unchanged; nothing is
-- re-labelled. Carrying a human validation across a change is a human validation act (precedent APPROVAL-0066),
-- so the file refuses to run until the approval reference below is set.
--
-- Grading is unaffected: FRQs are graded against frq_criteria; evaluate-attempt reads canonical_answer_1 only on
-- the privileged QA path.
--
-- Trap 1: record this as version 20261004120000 on every environment (file name = ledger version).
--
-- Rollback (same transaction): update app.content_item_versions set canonical_answer_1 = null for the 20 ids
-- below; delete from app.canonical_answer_spans where proposal_run = 'calcab-u1-canonicals-2026-10-04'; then re-point the 20 labels'
-- validated_against_taxo_hash at app.taxonomy_relevant_hash(version) again (the null write also changes it).

begin;
select pg_advisory_xact_lock(hashtext('cramapple-calcab-u1-canonicals-20261004'));

create temporary table approval (ref text) on commit drop;
insert into approval values ('PENDING');
do $$ begin
  if (select ref from approval) = 'PENDING' then
    raise exception 'label carry-forward is not approved: set the Product Owner approval reference';
  end if;
end $$;

create temporary table target (content_key text primary key, civ_id uuid not null unique) on commit drop;
insert into target values
('apcalcab-frq-u1n-001','a92d2284-d97b-4cf0-aa38-a174072ab6a3'),
('apcalcab-frq-u1n-002','2c67f828-c472-4a91-9e60-3b496790f523'),
('apcalcab-frq-u1n-003','5ea968e0-46cf-4e75-af9a-55429cb91b04'),
('apcalcab-frq-u1n-004','b6a27db2-890c-4748-a20e-5d57227a8416'),
('apcalcab-frq-u1n-005','2b570fcd-5bcd-4975-8f79-b3de324ff94c'),
('apcalcab-frq-u1v-001-v1','5097502d-e640-4091-8167-129b117c676f'),
('apcalcab-frq-u1v-001-v2','eaf4260e-c12d-4cfd-9eb9-d9c918bd6f7b'),
('apcalcab-frq-u1v-001-v3','7e4245f8-4ccc-4510-8100-9b94d86992ea'),
('apcalcab-frq-u1v-002-v1','eee4bcfa-d137-4b03-82a3-1c55d857569a'),
('apcalcab-frq-u1v-002-v2','4645223d-2a13-4603-8d18-b756bbd1a088'),
('apcalcab-frq-u1v-002-v3','fc8a3696-9e13-479e-90ea-5619cfe264cb'),
('apcalcab-frq-u1v-003-v1','3a50593d-1c22-4452-bc2b-5770489768cc'),
('apcalcab-frq-u1v-003-v2','fbe47044-e562-4540-bf45-53d2cef998a5'),
('apcalcab-frq-u1v-003-v3','c203cfcd-7977-46a9-aef4-d7bb9084f07d'),
('apcalcab-frq-u1v-004-v1','825fc1de-ed20-4b6c-8bf4-755d47683f6d'),
('apcalcab-frq-u1v-004-v2','7239e911-f066-40b0-afe5-81f57272fc9b'),
('apcalcab-frq-u1v-004-v3','64cb93d4-eaa2-4a50-9fcc-d2b5a1ef2ac1'),
('apcalcab-frq-u1v-005-v1','a69b1047-6636-4aca-88e0-968dc94b7da5'),
('apcalcab-frq-u1v-005-v2','070a60a3-3b03-46be-a9c7-707c621ff7ff'),
('apcalcab-frq-u1v-005-v3','a525f7e8-c50e-479e-ba2e-c6351822a1f6');

-- preconditions: each id is the current published version of its item, with no canonical and no spans yet,
-- and exactly one current serving label that is validated and hash-fresh.
do $$ declare n int; begin
  select count(*) into n from target t join app.content_item_versions civ on civ.id=t.civ_id
    join app.content_items ci on ci.id=civ.content_item_id and ci.content_key=t.content_key
   where civ.status='published' and ci.status='published' and nullif(trim(civ.canonical_answer_1),'') is null
     and not exists (select 1 from app.content_item_versions later where later.content_item_id=ci.id and later.status='published' and later.version_num>civ.version_num);
  if n<>20 then raise exception 'precondition: expected 20 published versions without a canonical, found %', n; end if;
  select count(*) into n from app.canonical_answer_spans s join target t on t.civ_id=s.content_item_version_id;
  if n<>0 then raise exception 'precondition: % spans already exist on target versions', n; end if;
  select count(*) into n from target t join app.content_items ci on ci.content_key=t.content_key
    join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null
   where l.label_status='validated' and l.validated_against_version_id=t.civ_id and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.civ_id);
  if n<>20 then raise exception 'precondition: expected 20 validated fresh serving labels, found %', n; end if;
end $$;

create temporary table prior_label on commit drop as
select l.content_taxonomy_label_id, t.civ_id, l.validated_by, l.validated_at, l.validation_decision_id
from target t join app.content_items ci on ci.content_key=t.content_key
join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null and l.label_status='validated';

-- apcalcab-frq-u1n-001
create temporary table sp (civ uuid, ord int, txt text, ck text) on commit drop;
insert into sp values
('a92d2284-d97b-4cf0-aa38-a174072ab6a3',1,'Factor: 2x^2 - x - 15 = (2x + 5)(x - 3) and x^2 - 9 = (x - 3)(x + 3). For x != 3, g(x) = (2x + 5)/(x + 3), so lim(x->3) g(x) = (2(3) + 5)/(3 + 3) = 11/6.','part-a-criterion-01'),
('a92d2284-d97b-4cf0-aa38-a174072ab6a3',3,'The limit of g at x = 3 exists and equals the finite number 11/6, but g(3) is not defined, so the discontinuity at x = 3 is removable.','part-b-criterion-01'),
('a92d2284-d97b-4cf0-aa38-a174072ab6a3',5,'Assigning g(3) = 11/6, the value of the limit, makes g continuous at x = 3.','part-b-criterion-02'),
('a92d2284-d97b-4cf0-aa38-a174072ab6a3',7,'Near x = -3, g(x) = (2x + 5)/(x + 3) and the numerator approaches 2(-3) + 5 = -1, which is negative. From the left, x + 3 is small and negative, so g(x) is positive and lim(x->-3-) g(x) = infinity. From the right, x + 3 is small and positive, so g(x) is negative and lim(x->-3+) g(x) = -infinity.','part-c-criterion-01'),
('2c67f828-c472-4a91-9e60-3b496790f523',1,'x^2 - 4x - 5 = (x - 5)(x + 1), so the denominator is 0 at x = 5 and x = -1. The numerator 3x is 15 at x = 5 and -3 at x = -1, nonzero at both, so the vertical asymptotes are x = 5 and x = -1.','part-a-criterion-01'),
('2c67f828-c472-4a91-9e60-3b496790f523',3,'lim(x->5+) f(x) = infinity: near x = 5 the numerator is positive (about 15), x - 5 is small and positive, and x + 1 is positive (about 6), so f(x) is large and positive.','part-b-criterion-01'),
('2c67f828-c472-4a91-9e60-3b496790f523',5,'lim(x->-1-) f(x) = -infinity: near x = -1 the numerator is negative (about -3), x + 1 is small and negative, and x - 5 is negative (about -6), so the denominator is small and positive and f(x) is large and negative.','part-c-criterion-01'),
('2c67f828-c472-4a91-9e60-3b496790f523',7,'The horizontal asymptote is y = 0, because the degree of the denominator (2) exceeds the degree of the numerator (1), so lim(x->infinity) f(x) = lim(x->-infinity) f(x) = 0.','part-d-criterion-01'),
('5ea968e0-46cf-4e75-af9a-55429cb91b04',1,'Dividing numerator and denominator by t, A(t) = (80 + 100/t)/(2 + 5/t), so lim(t->infinity) A(t) = 80/2 = 40.','part-a-criterion-01'),
('5ea968e0-46cf-4e75-af9a-55429cb91b04',3,'As time increases without bound, the amount of salt dissolved in the tank approaches (levels off near) 40 grams.','part-a-criterion-02'),
('5ea968e0-46cf-4e75-af9a-55429cb91b04',5,'sqrt(9x^2 + 2) behaves like 3|x| for large |x|. As x -> infinity, |x| = x, so q(x) -> 4x/(3x) = 4/3; as x -> -infinity, |x| = -x, so q(x) -> 4x/(-3x) = -4/3. The horizontal asymptotes are y = 4/3 and y = -4/3.','part-b-criterion-01'),
('5ea968e0-46cf-4e75-af9a-55429cb91b04',7,'The limit is infinity. Dividing by 5^x gives (2x^4/5^x + 1)/((3/5)^x + x^7/5^x). Because 5^x grows faster than 3^x and faster than any power of x, the numerator approaches 1 and the denominator approaches 0 from above, so the quotient increases without bound.','part-c-criterion-01'),
('b6a27db2-890c-4748-a20e-5d57227a8416',1,'For x > 1, f(x) = (x + 3)(x - 1)/(x - 1) = x + 3, so lim(x->1+) f(x) = 1 + 3 = 4.','part-a-criterion-01'),
('b6a27db2-890c-4748-a20e-5d57227a8416',3,'The left-hand limit is lim(x->1-) (kx + 2) = k + 2. For the limit at x = 1 to exist it must equal the right-hand limit 4, so k + 2 = 4 and k = 2.','part-b-criterion-01'),
('b6a27db2-890c-4748-a20e-5d57227a8416',5,'Continuity at x = 1 requires f(1) to be defined, lim(x->1) f(x) to exist, and the two to be equal. With k = 2 the limit is 4, so m = f(1) = 4.','part-b-criterion-02'),
('b6a27db2-890c-4748-a20e-5d57227a8416',7,'No. With k = 3, lim(x->1-) f(x) = 3(1) + 2 = 5, while lim(x->1+) f(x) = 4. The one-sided limits differ, so lim(x->1) f(x) does not exist and f is not continuous at x = 1. This is a jump discontinuity.','part-c-criterion-01'),
('2b570fcd-5bcd-4975-8f79-b3de324ff94c',1,'lim(x->5) h(x) is about 0.1667 (that is, 1/6): the values from the left (0.16713, 0.16671, 0.16667) and from the right (0.16666, 0.16662, 0.16621) both approach 0.1667 as x approaches 5.','part-a-criterion-01'),
('2b570fcd-5bcd-4975-8f79-b3de324ff94c',3,'Multiply numerator and denominator by sqrt(x + 4) + 3: h(x) = ((x + 4) - 9)/((x - 5)(sqrt(x + 4) + 3)) = (x - 5)/((x - 5)(sqrt(x + 4) + 3)) = 1/(sqrt(x + 4) + 3) for x != 5.','part-b-criterion-01'),
('2b570fcd-5bcd-4975-8f79-b3de324ff94c',5,'So lim(x->5) h(x) = 1/(sqrt(9) + 3) = 1/(3 + 3) = 1/6.','part-b-criterion-02'),
('2b570fcd-5bcd-4975-8f79-b3de324ff94c',7,'No. The limit 1/6 exists but does not equal h(5) = 0.2 = 1/5, so the extended function is not continuous at x = 5. The discontinuity is removable.','part-c-criterion-01'),
('5097502d-e640-4091-8167-129b117c676f',1,'Factor: 3x^2 - x - 14 = (x + 2)(3x - 7) and x^2 - x - 6 = (x + 2)(x - 3). For x != -2, g(x) = (3x - 7)/(x - 3), so lim(x->-2) g(x) = (3(-2) - 7)/(-2 - 3) = (-13)/(-5) = 13/5.','part-a-criterion-01'),
('5097502d-e640-4091-8167-129b117c676f',3,'The limit of g at x = -2 exists and equals the finite number 13/5, but g(-2) is not defined, so the discontinuity at x = -2 is removable.','part-b-criterion-01'),
('5097502d-e640-4091-8167-129b117c676f',5,'Assigning g(-2) = 13/5, the value of the limit, makes g continuous at x = -2.','part-b-criterion-02'),
('5097502d-e640-4091-8167-129b117c676f',7,'Near x = 3, g(x) = (3x - 7)/(x - 3) and the numerator approaches 3(3) - 7 = 2, which is positive. From the left, x - 3 is small and negative, so lim(x->3-) g(x) = -infinity. From the right, x - 3 is small and positive, so lim(x->3+) g(x) = infinity.','part-c-criterion-01'),
('eaf4260e-c12d-4cfd-9eb9-d9c918bd6f7b',1,'Factor: 2 + x - x^2 = (x + 1)(2 - x) and x^2 - 3x - 4 = (x + 1)(x - 4). For x != -1, r(x) = (2 - x)/(x - 4), so lim(x->-1) r(x) = (2 - (-1))/(-1 - 4) = 3/(-5) = -3/5.','part-a-criterion-01'),
('eaf4260e-c12d-4cfd-9eb9-d9c918bd6f7b',3,'The limit of r at x = -1 exists and equals the finite number -3/5, but r(-1) is not defined, so the discontinuity at x = -1 is removable.','part-b-criterion-01'),
('eaf4260e-c12d-4cfd-9eb9-d9c918bd6f7b',5,'Assigning r(-1) = -3/5, the value of the limit, makes r continuous at x = -1.','part-b-criterion-02'),
('eaf4260e-c12d-4cfd-9eb9-d9c918bd6f7b',7,'Near x = 4, r(x) = (2 - x)/(x - 4) and the numerator approaches 2 - 4 = -2, which is negative. From the left, x - 4 is small and negative, so r(x) is positive and lim(x->4-) r(x) = infinity. From the right, x - 4 is small and positive, so r(x) is negative and lim(x->4+) r(x) = -infinity.','part-c-criterion-01'),
('7e4245f8-4ccc-4510-8100-9b94d86992ea',1,'Factor: 2x^2 + 9x + 9 = (x + 3)(2x + 3) and 3 - 2x - x^2 = (x + 3)(1 - x). For x != -3, w(x) = (2x + 3)/(1 - x), so lim(x->-3) w(x) = (2(-3) + 3)/(1 - (-3)) = (-3)/4 = -3/4.','part-a-criterion-01'),
('7e4245f8-4ccc-4510-8100-9b94d86992ea',3,'The limit of w at x = -3 exists and equals the finite number -3/4, but w(-3) is not defined, so the discontinuity at x = -3 is removable.','part-b-criterion-01'),
('7e4245f8-4ccc-4510-8100-9b94d86992ea',5,'Assigning w(-3) = -3/4, the value of the limit, makes w continuous at x = -3.','part-b-criterion-02'),
('7e4245f8-4ccc-4510-8100-9b94d86992ea',7,'Near x = 1, w(x) = (2x + 3)/(1 - x) and the numerator approaches 2(1) + 3 = 5, which is positive. From the left, 1 - x is small and positive, so lim(x->1-) w(x) = infinity. From the right, 1 - x is small and negative, so lim(x->1+) w(x) = -infinity.','part-c-criterion-01'),
('eee4bcfa-d137-4b03-82a3-1c55d857569a',1,'x^2 + x - 12 = (x - 3)(x + 4), so the denominator is 0 at x = 3 and x = -4. The numerator 2x - 1 is 5 at x = 3 and -9 at x = -4, nonzero at both, so the vertical asymptotes are x = 3 and x = -4.','part-a-criterion-01'),
('eee4bcfa-d137-4b03-82a3-1c55d857569a',3,'lim(x->3+) R(x) = infinity: near x = 3 the numerator is positive (about 5), x - 3 is small and positive, and x + 4 is positive (about 7), so R(x) is large and positive.','part-b-criterion-01'),
('eee4bcfa-d137-4b03-82a3-1c55d857569a',5,'lim(x->-4-) R(x) = -infinity: near x = -4 the numerator is negative (about -9), x + 4 is small and negative, and x - 3 is negative (about -7), so the denominator is small and positive and R(x) is large and negative.','part-c-criterion-01'),
('eee4bcfa-d137-4b03-82a3-1c55d857569a',7,'The horizontal asymptote is y = 0, because the degree of the denominator (2) exceeds the degree of the numerator (1), so lim(x->infinity) R(x) = lim(x->-infinity) R(x) = 0.','part-d-criterion-01'),
('4645223d-2a13-4603-8d18-b756bbd1a088',1,'2x^2 - 8x = 2x(x - 4), so the denominator is 0 at x = 0 and x = 4. The numerator 5x^2 - 3 is -3 at x = 0 and 77 at x = 4, nonzero at both, so the vertical asymptotes are x = 0 and x = 4.','part-a-criterion-01'),
('4645223d-2a13-4603-8d18-b756bbd1a088',3,'lim(x->4-) D(x) = -infinity: near x = 4 the numerator is positive (about 77), 2x is positive (about 8), and x - 4 is small and negative, so the denominator is small and negative and D(x) is large and negative.','part-b-criterion-01'),
('4645223d-2a13-4603-8d18-b756bbd1a088',5,'lim(x->0+) D(x) = infinity: near x = 0 the numerator is negative (about -3), 2x is small and positive, and x - 4 is negative (about -4), so the denominator is small and negative and the quotient is large and positive.','part-c-criterion-01'),
('4645223d-2a13-4603-8d18-b756bbd1a088',7,'The horizontal asymptote is y = 5/2: the numerator and denominator have equal degree (2), so dividing by x^2 gives lim(x->+/-infinity) D(x) = 5/2, the ratio of the leading coefficients 5 and 2.','part-d-criterion-01'),
('fc8a3696-9e13-479e-90ea-5619cfe264cb',1,'The denominator (x - 1)^2 (x + 2) is 0 at x = 1 and x = -2. The numerator x + 4 is 5 at x = 1 and 2 at x = -2, nonzero at both, so the vertical asymptotes are x = 1 and x = -2.','part-a-criterion-01'),
('fc8a3696-9e13-479e-90ea-5619cfe264cb',3,'lim(x->1) S(x) = infinity: near x = 1 the numerator is positive (about 5), (x - 1)^2 is small and positive on both sides of 1, and x + 2 is positive (about 3), so S(x) is large and positive from both the left and the right.','part-b-criterion-01'),
('fc8a3696-9e13-479e-90ea-5619cfe264cb',5,'lim(x->-2-) S(x) = -infinity: near x = -2 the numerator is positive (about 2), (x - 1)^2 is positive (about 9), and x + 2 is small and negative, so S(x) is large and negative.','part-c-criterion-01'),
('fc8a3696-9e13-479e-90ea-5619cfe264cb',7,'The horizontal asymptote is y = 0, because the degree of the denominator (3) exceeds the degree of the numerator (1), so lim(x->infinity) S(x) = lim(x->-infinity) S(x) = 0.','part-d-criterion-01'),
('3a50593d-1c22-4452-bc2b-5770489768cc',1,'Dividing numerator and denominator by t, C(t) = (72 + 30/t)/(4 + 9/t), so lim(t->infinity) C(t) = 72/4 = 18.','part-a-criterion-01'),
('3a50593d-1c22-4452-bc2b-5770489768cc',3,'As time increases without bound, the concentration of the medication in the bloodstream approaches (levels off near) 18 milligrams per liter.','part-a-criterion-02'),
('3a50593d-1c22-4452-bc2b-5770489768cc',5,'sqrt(4x^2 + 7) behaves like 2|x| for large |x|. As x -> infinity, |x| = x, so q(x) -> 5x/(2x) = 5/2; as x -> -infinity, |x| = -x, so q(x) -> 5x/(-2x) = -5/2. The horizontal asymptotes are y = 5/2 and y = -5/2.','part-b-criterion-01'),
('3a50593d-1c22-4452-bc2b-5770489768cc',7,'The limit is infinity. Dividing by 7^x gives (1 + x^6/7^x)/((4/7)^x + x^10/7^x). Because 7^x grows faster than 4^x and faster than any power of x, the numerator approaches 1 and the denominator approaches 0 from above, so the quotient increases without bound.','part-c-criterion-01'),
('fbe47044-e562-4540-bf45-53d2cef998a5',1,'Dividing numerator and denominator by t^2, v(t) = (90 + 40/t^2)/(3 + 2/t + 1/t^2), so lim(t->infinity) v(t) = 90/3 = 30.','part-a-criterion-01'),
('fbe47044-e562-4540-bf45-53d2cef998a5',3,'As time increases without bound, the speed of the sled approaches (levels off near) 30 meters per second.','part-a-criterion-02'),
('fbe47044-e562-4540-bf45-53d2cef998a5',5,'sqrt(x^2 + 5) behaves like |x| for large |x|, so q(x) behaves like (-3x)/|x|. As x -> infinity, q(x) -> -3; as x -> -infinity, q(x) -> 3. The horizontal asymptotes are y = -3 and y = 3.','part-b-criterion-01'),
('fbe47044-e562-4540-bf45-53d2cef998a5',7,'The limit is 3/5. Dividing by 2^x gives (3 + x^8/2^x)/(5 + x^3/2^x). Because 2^x grows faster than any power of x, x^8/2^x and x^3/2^x both approach 0, so the quotient approaches 3/5.','part-c-criterion-01'),
('c203cfcd-7977-46a9-aef4-d7bb9084f07d',1,'Dividing numerator and denominator by n, A(n) = (250 + 4000/n)/(1 + 50/n), so lim(n->infinity) A(n) = 250/1 = 250.','part-a-criterion-01'),
('c203cfcd-7977-46a9-aef4-d7bb9084f07d',3,'As the number of units produced increases without bound, the average cost per unit approaches (levels off near) 250 dollars per unit.','part-a-criterion-02'),
('c203cfcd-7977-46a9-aef4-d7bb9084f07d',5,'sqrt(4x^2 + 1) behaves like 2|x| for large |x|, so q(x) behaves like 2|x|/x. As x -> infinity, q(x) -> 2; as x -> -infinity, q(x) -> -2. The horizontal asymptotes are y = 2 and y = -2.','part-b-criterion-01'),
('c203cfcd-7977-46a9-aef4-d7bb9084f07d',7,'The limit is 0. Dividing by 3^x gives (x^12/3^x + (2/3)^x)/(1 + 8x^2/3^x). Because 3^x grows faster than 2^x and faster than any power of x, the numerator approaches 0 and the denominator approaches 1.','part-c-criterion-01'),
('825fc1de-ed20-4b6c-8bf4-755d47683f6d',1,'For x > 2, f(x) = (x + 3)(x - 2)/(x - 2) = x + 3, so lim(x->2+) f(x) = 2 + 3 = 5.','part-a-criterion-01'),
('825fc1de-ed20-4b6c-8bf4-755d47683f6d',3,'The left-hand limit is lim(x->2-) (kx - 1) = 2k - 1. For the limit at x = 2 to exist it must equal the right-hand limit 5, so 2k - 1 = 5 and k = 3.','part-b-criterion-01'),
('825fc1de-ed20-4b6c-8bf4-755d47683f6d',5,'Continuity at x = 2 requires f(2) to be defined, lim(x->2) f(x) to exist, and the two to be equal. With k = 3 the limit is 5, so m = f(2) = 5.','part-b-criterion-02'),
('825fc1de-ed20-4b6c-8bf4-755d47683f6d',7,'No. With k = 3, lim(x->2-) f(x) = 3(2) - 1 = 5 and lim(x->2+) f(x) = 5, so lim(x->2) f(x) = 5, but f(2) = 4 does not equal 5. f is not continuous at x = 2, and the discontinuity is removable.','part-c-criterion-01'),
('7239e911-f066-40b0-afe5-81f57272fc9b',1,'Multiply numerator and denominator by sqrt(x) + 2: for x > 4, f(x) = (x - 4)(sqrt(x) + 2)/(x - 4) = sqrt(x) + 2, so lim(x->4+) f(x) = sqrt(4) + 2 = 4.','part-a-criterion-01'),
('7239e911-f066-40b0-afe5-81f57272fc9b',3,'The left-hand limit is lim(x->4-) (kx^2 - 4) = 16k - 4. For the limit at x = 4 to exist it must equal the right-hand limit 4, so 16k - 4 = 4 and k = 1/2.','part-b-criterion-01'),
('7239e911-f066-40b0-afe5-81f57272fc9b',5,'Continuity at x = 4 requires f(4) to be defined, lim(x->4) f(x) to exist, and the two to be equal. With k = 1/2 the limit is 4, so m = f(4) = 4.','part-b-criterion-02'),
('7239e911-f066-40b0-afe5-81f57272fc9b',7,'No. With k = 1/2, lim(x->4-) f(x) = (1/2)(16) - 4 = 4 and lim(x->4+) f(x) = 4, so lim(x->4) f(x) = 4, but f(4) = 0 does not equal 4. f is not continuous at x = 4, and the discontinuity is removable.','part-c-criterion-01'),
('64cb93d4-eaa2-4a50-9fcc-d2b5a1ef2ac1',1,'For x < -3, f(x) = (2x - 1)(x + 3)/(x + 3) = 2x - 1, so lim(x->-3-) f(x) = 2(-3) - 1 = -7.','part-a-criterion-01'),
('64cb93d4-eaa2-4a50-9fcc-d2b5a1ef2ac1',3,'The right-hand limit is lim(x->-3+) (kx + 5) = -3k + 5. For the limit at x = -3 to exist it must equal the left-hand limit -7, so -3k + 5 = -7 and k = 4.','part-b-criterion-01'),
('64cb93d4-eaa2-4a50-9fcc-d2b5a1ef2ac1',5,'Continuity at x = -3 requires f(-3) to be defined, lim(x->-3) f(x) to exist, and the two to be equal. With k = 4 the limit is -7, so m = f(-3) = -7.','part-b-criterion-02'),
('64cb93d4-eaa2-4a50-9fcc-d2b5a1ef2ac1',7,'No. With k = 1, lim(x->-3-) f(x) = -7 while lim(x->-3+) f(x) = 1(-3) + 5 = 2. The one-sided limits differ, so lim(x->-3) f(x) does not exist and f is not continuous at x = -3 (even though f(-3) = -7). This is a jump discontinuity.','part-c-criterion-01'),
('a69b1047-6636-4aca-88e0-968dc94b7da5',1,'lim(x->2) h(x) is about 1.6: the values from the left (1.5122, 1.5912, 1.5991) and from the right (1.6009, 1.6088, 1.6882) both approach 1.6 as x approaches 2.','part-a-criterion-01'),
('a69b1047-6636-4aca-88e0-968dc94b7da5',3,'Factor: x^3 - 4x = x(x - 2)(x + 2) and x^2 + x - 6 = (x - 2)(x + 3). Cancel the common factor x - 2 to get h(x) = x(x + 2)/(x + 3) for x != 2.','part-b-criterion-01'),
('a69b1047-6636-4aca-88e0-968dc94b7da5',5,'So lim(x->2) h(x) = 2(2 + 2)/(2 + 3) = 8/5.','part-b-criterion-02'),
('a69b1047-6636-4aca-88e0-968dc94b7da5',7,'No. The limit 8/5 exists but does not equal h(2) = 1.5 = 3/2, so the extended function is not continuous at x = 2. The discontinuity is removable.','part-c-criterion-01'),
('070a60a3-3b03-46be-a9c7-707c621ff7ff',1,'lim(x->4) h(x) is about -0.0625 (that is, -1/16): the values from the left (-0.0641, -0.0627, -0.0625) and from the right (-0.0625, -0.0623, -0.0610) both approach -0.0625 as x approaches 4.','part-a-criterion-01'),
('070a60a3-3b03-46be-a9c7-707c621ff7ff',3,'Rewrite 1/x - 1/4 = (4 - x)/(4x), so h(x) = (4 - x)/(4x(x - 4)) = -(x - 4)/(4x(x - 4)) = -1/(4x) for x != 4 and x != 0.','part-b-criterion-01'),
('070a60a3-3b03-46be-a9c7-707c621ff7ff',5,'So lim(x->4) h(x) = -1/(4(4)) = -1/16.','part-b-criterion-02'),
('070a60a3-3b03-46be-a9c7-707c621ff7ff',7,'No. The limit -1/16 exists but does not equal h(4) = -0.05 = -1/20, so the extended function is not continuous at x = 4. The discontinuity is removable.','part-c-criterion-01'),
('a525f7e8-c50e-479e-ba2e-c6351822a1f6',1,'lim(x->6) h(x) is about 0.375 (that is, 3/8): the values from the left (0.3768, 0.3752, 0.3750) and from the right (0.3750, 0.3748, 0.3733) both approach 0.375 as x approaches 6.','part-a-criterion-01'),
('a525f7e8-c50e-479e-ba2e-c6351822a1f6',3,'Multiply numerator and denominator by sqrt(3x - 2) + 4: h(x) = ((3x - 2) - 16)/((x - 6)(sqrt(3x - 2) + 4)) = 3(x - 6)/((x - 6)(sqrt(3x - 2) + 4)) = 3/(sqrt(3x - 2) + 4) for x != 6.','part-b-criterion-01'),
('a525f7e8-c50e-479e-ba2e-c6351822a1f6',5,'So lim(x->6) h(x) = 3/(sqrt(16) + 4) = 3/(4 + 4) = 3/8.','part-b-criterion-02'),
('a525f7e8-c50e-479e-ba2e-c6351822a1f6',7,'No. The limit 3/8 exists but does not equal h(6) = 0.4 = 2/5, so the extended function is not continuous at x = 6. The discontinuity is removable.','part-c-criterion-01');

-- one drafted span per criterion (odd ordinals) and a blank-line assembly_literal between them (even ordinals)
insert into app.canonical_answer_spans (content_item_version_id, answer_field, span_ordinal, span_text, criterion_keys, provenance, proposal_run)
select civ, 'canonical_answer_1', ord, txt, array[ck], 'drafted', 'calcab-u1-canonicals-2026-10-04' from sp
union all
select civ, 'canonical_answer_1', ord + 1, E'\n\n', array[]::text[], 'assembly_literal', 'calcab-u1-canonicals-2026-10-04' from sp
where ord < (select max(s2.ord) from sp s2 where s2.civ = sp.civ);

-- canonical_answer_1 is assembled from the spans just inserted, so the two cannot differ
update app.content_item_versions civ
set canonical_answer_1 = (select string_agg(s.span_text, '' order by s.span_ordinal) from app.canonical_answer_spans s
                          where s.content_item_version_id = civ.id and s.answer_field = 'canonical_answer_1')
from target t
where civ.id = t.civ_id and civ.canonical_answer_1 is null;


-- carry the human-validated serving labels forward to the new hash (the write above made them stale)
update app.content_taxonomy_labels l
set label_status = 'validated',
    validated_by = p.validated_by, validated_at = p.validated_at, validation_decision_id = p.validation_decision_id,
    validated_against_version_id = p.civ_id,
    validated_against_taxo_hash = app.taxonomy_relevant_hash(p.civ_id),
    source_payload = l.source_payload || jsonb_build_object('carried_forward', jsonb_build_object(
      'version_id', p.civ_id,
      'reason', 'canonical_answer_1 added (servability criterion 4); question, rubric, units and topics unchanged; no relabelling',
      'approval_ref', (select ref from approval),
      'run', 'calcab-u1-canonicals-2026-10-04'))
from prior_label p
where l.content_taxonomy_label_id = p.content_taxonomy_label_id;

-- postconditions
do $$ declare n int; begin
  select count(*) into n from target t join app.content_item_versions civ on civ.id=t.civ_id
   where civ.canonical_answer_1 = (select string_agg(s.span_text, '' order by s.span_ordinal) from app.canonical_answer_spans s
                                   where s.content_item_version_id=t.civ_id and s.answer_field='canonical_answer_1');
  if n<>20 then raise exception 'postcondition: spans concatenate to canonical_answer_1 on only % of 20', n; end if;
  select count(*) into n from target t join app.content_items ci on ci.content_key=t.content_key
    join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null
   where l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.civ_id);
  if n<>20 then raise exception 'postcondition: % of 20 serving labels validated and fresh', n; end if;
  select count(*) into n from target t join app.content_items ci on ci.content_key=t.content_key
    join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.superseded_by is null and l.label_status='stale';
  if n<>0 then raise exception 'postcondition: % labels left stale', n; end if;
end $$;

commit;
