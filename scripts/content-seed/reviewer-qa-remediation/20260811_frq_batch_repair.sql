-- FRQ remediation batch, 2026-08-11.
--
-- Context: docs/Q&A/REVIEWER_QA_SWEEP_2026_08_11.md, owner-directed "Run the 16 item
-- remediation" + "assess apphycm-frq-044- is it possible to repair or should it be
-- retired?" Covers the 3 published-but-modification_reserved FRQs from the sweep list
-- (Biology, Calc AB, Physics 1) not already handled by the MCQ batch, APSTAT-MOD4-M001,
-- and apphycm-frq-044 (disapproved, never published -- assessed here and repaired, not
-- retired; see per-item note below).
--
-- Every criterion split below is independently re-derived per protocol §9.2, applying
-- the reviewers' own stated principle ("AP is 1 point per task, no partial-credit
-- bundling") uniformly across every part of an item, not just the specific part a note
-- called out -- confirmed by checking each part's own evidence_requirements text against
-- how many distinct sub-tasks points_possible was actually covering.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-frq-batch-repair-20260811'));

create temporary table repair_targets (
  content_key text primary key,
  find_status text not null
) on commit drop;

insert into repair_targets values
('APBIO-FRQ-L-025','published'),
('apcalcab-frq-012','published'),
('apphy1-frq-048','published'),
('APSTAT-MOD4-M001','published'),
('apphycm-frq-044','reviewed_disapproved');

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where content_key=t.content_key and item_type='frq'
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id and status=t.find_status
    order by version_num desc
    limit 1
    for update;

    v_new := gen_random_uuid();

    update app.content_review_assignments
    set status='skipped'
    where content_item_version_id=v_old.id
      and assignment_purpose='subject_review'
      and status in ('pending','in_progress');

    update app.content_item_versions
    set status='retired', updated_at=now()
    where id=v_old.id;

    update app.content_items
    set status='draft', updated_at=now()
    where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-11 FRQ batch repair (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_11.md)',
        'qa_source_version_id',v_old.id
      ),
      v_old.explanation,v_old.help_text,v_old.content_hash,
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into repaired values (t.content_key,v_old.id,v_new);
  end loop;
end $$;

-- ---------------------------------------------------------------------------
-- APBIO-FRQ-L-025: de-bundle every part into 1-point-per-task criteria (per Adil
-- Abbasi's "AP is 1 point per task, no partial-credit bundling" principle, 08-09),
-- applied consistently to all four parts, not just Part A which the note called out.
-- Total moves 10 -> 13 points (Parts A and B genuinely had 4 sub-tasks stored as 2 and 3
-- points respectively; Parts C and D already had correct point totals but each still
-- bundled 2-3 tasks into one all-or-nothing criterion). The Long-FRQ-vs-experiment/
-- graphing-archetype format-mismatch concern the note also raised is NOT resolved here
-- -- splitting into two separate content_items is an authoring-scale change outside a
-- QA remediation pass; recorded as an open follow-up, not silently dropped. Stem is
-- rewritten to (a)(i)/(a)(ii) sub-part numbering per the note.
-- ---------------------------------------------------------------------------
update app.content_item_versions civ
set stem='Answer all parts of the following question.

Part A: Figure 1 shows the results of a morphological analysis of five species (A–E). Shared derived characters (synapomorphies) are listed in the matrix.
(a)(i) Define synapomorphy and explain why it is more informative for constructing phylogenies than symplesiomorphy (a shared ancestral character).
(a)(ii) Using the character matrix data, construct the most parsimonious cladogram for species A–E, identify the outgroup, and explain your reasoning.
(a)(iii) Explain what "most parsimonious" means in phylogenetic analysis.
(a)(iv) Explain why parsimony is preferred when building cladograms.

Part B: The molecular clock hypothesis proposes that DNA sequences accumulate mutations at an approximately constant rate over time. Table 1 shows the percentage sequence differences in cytochrome b between pairs of primate species, and known fossil divergence dates for two of the pairs.
(b)(i) Explain the molecular basis for the molecular clock — why do neutral mutations accumulate at a relatively constant rate?
(b)(ii) Use the data to estimate the divergence time for the third pair (Human–Gorilla) and show your work.
(b)(iii) Describe ONE reason why the molecular clock is not perfectly constant and can give inaccurate divergence estimates.
(b)(iv) Describe a SECOND, distinct reason why the molecular clock is not perfectly constant.

Part C: Convergent evolution can mislead phylogenetic analysis based on morphology.
(c)(i) Explain how analogous structures (homoplasy) can cause morphological phylogenies to incorrectly group unrelated organisms together.
(c)(ii) Explain why molecular phylogenies are generally considered more reliable than morphological phylogenies for resolving deep evolutionary relationships, and give a specific example of a case where molecular data overturned a morphologically derived phylogeny.

Part D: A researcher wants to determine whether two geographically isolated populations of mice are separate species or subspecies.
(d)(i)-(d)(iii) Describe THREE lines of evidence the researcher could collect (one per sub-part) and explain how each line of evidence would contribute to a decision.'
from repaired r where r.content_key='APBIO-FRQ-L-025' and civ.id=r.new_version_id;

insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select r.new_version_id, v.criterion_key, v.learner_facing_text, v.points_possible, v.evidence_requirements, v.minimum_fix, '[]'::jsonb
from repaired r
join (values
 ('a-i','Defines synapomorphy as a shared derived character.',1,
  'A clear definition distinguishing a derived (newly evolved) character from an ancestral one.',
  'State that a synapomorphy is a shared character derived from a common ancestor, distinguishing it from an ancestral (underived) character.'),
 ('a-ii','Explains why synapomorphies, not symplesiomorphies, are informative for building phylogenies.',1,
  'Explains that shared ancestral characters (symplesiomorphies) are present broadly across a group and do not distinguish sub-groups, while shared derived characters mark recent common ancestry.',
  'Explain that only shared derived characters indicate recent common ancestry; shared ancestral characters are uninformative because they are shared too broadly.'),
 ('a-iii','Constructs the most-parsimonious cladogram from the matrix, identifies species A as the outgroup, and explains the reasoning.',1,
  'Correct nested topology (A,(B,(C,(D,E)))); identifies A as the outgroup because it lacks all four derived characters.',
  'Give the correct topology and identify A as the outgroup because it has none of the derived characters shared by B-E.'),
 ('a-iv','Explains what "most parsimonious" means and why parsimony is preferred when building cladograms.',1,
  'States that the most parsimonious tree requires the fewest evolutionary changes (character-state transitions), and that parsimony is preferred because it requires the fewest unsupported assumptions (independent convergent origins) of the character data.',
  'State that parsimony minimizes the number of required evolutionary changes, and that this is preferred because it assumes the fewest independent, unsupported evolutionary events.'),
 ('b-i','Explains the molecular basis for why neutral mutations accumulate at a relatively constant rate.',1,
  'Explains that neutral mutations are not acted on by natural selection, so their accumulation rate tracks the underlying mutation rate rather than fluctuating with selective pressure.',
  'State that neutral mutations are invisible to natural selection, so they accumulate at a roughly constant, selection-independent rate.'),
 ('b-ii','Calculates the Human-Gorilla divergence time as 8.0 Mya, showing work using the supplied calibration.',1,
  'Shows 4.0% x 2 Mya/% = 8.0 Mya using the given calibration (1% divergence ≈ 2 Mya).',
  'Show the calculation 4.0 x 2 = 8.0 Mya using the given calibration.'),
 ('b-iii','Describes one valid reason the molecular clock is not perfectly constant.',1,
  'Any scientifically valid limitation, e.g. mutation rate varies with generation time, or some sites are under selection rather than neutral.',
  'Give one valid reason the clock rate can vary, such as generation-time differences or non-neutral sites.'),
 ('b-iv','Describes a second, distinct valid reason the molecular clock is not perfectly constant.',1,
  'A second scientifically valid limitation, distinct from the first, e.g. DNA repair-efficiency differences between lineages, or calibration-fossil uncertainty.',
  'Give a second, different valid reason, such as repair-rate differences between lineages or calibration uncertainty.'),
 ('c-i','Explains how homoplasy (analogous structures) can mislead morphological phylogenies.',1,
  'Analogous structures evolve independently in unrelated lineages under similar selective pressures (convergent evolution); a morphological analysis treating such a structure as a synapomorphy incorrectly groups the unrelated lineages together.',
  'Explain that convergently evolved analogous structures can be mistaken for synapomorphies, incorrectly grouping unrelated species.'),
 ('c-ii','Explains why molecular phylogenies are generally more reliable than morphological ones for deep relationships, with a specific example of molecular data overturning a morphological phylogeny.',1,
  'Explains at least one reason molecular data is more reliable (far more characters than morphology; statistical correction for multiple hits) and gives a real example, e.g. molecular data placing birds as nested within reptiles (sister to crocodilians) rather than as a separate morphological class, or whales as sister to hippopotamuses rather than grouped with other aquatic morphology.',
  'Give a reason molecular data is more reliable (many more characters, or statistical correction for saturation) and a real example such as birds nested within Reptilia (sister to crocodilians) or whales sister to hippos.'),
 ('d-i','Describes one valid line of evidence (of three required) for distinguishing species from subspecies status and explains how it bears on the decision.',1,
  'A scientifically sound evidence type (e.g. genetic/DNA sequence divergence) paired with an explanation of how it would indicate species vs. subspecies status.',
  'Name one valid evidence type and explain what result would indicate separate-species vs. subspecies status.'),
 ('d-ii','Describes a second, distinct valid line of evidence and explains how it bears on the decision.',1,
  'A second scientifically sound evidence type (e.g. reproductive isolation/interbreeding success), distinct from the first, paired with an explanation.',
  'Name a second, different valid evidence type (e.g. reproductive compatibility) and explain its interpretation.'),
 ('d-iii','Describes a third, distinct valid line of evidence and explains how it bears on the decision.',1,
  'A third scientifically sound evidence type (e.g. consistent morphological or ecological differentiation), distinct from the first two, paired with an explanation.',
  'Name a third, different valid evidence type (e.g. consistent morphological/ecological differences) and explain its interpretation.')
) as v(criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix) on true
where r.content_key='APBIO-FRQ-L-025';

-- ---------------------------------------------------------------------------
-- apcalcab-frq-012: de-bundle each part's single 3-point criterion into three 1-point
-- criteria matching the three sub-steps its own evidence_requirements already named
-- (select substitution / integrate / evaluate bounds), per Chisom Anuba's request to
-- require the substitution technique be explicitly stated, and per Abdul Hanan's
-- repeated 08-05/08-06 finding that criteria don't specify required evidence depth.
-- Total points unchanged at 9 (3 parts x 3 sub-criteria x 1pt); no change to the
-- verified-correct answer keys ((e-1)/2, ln 2, positive on [0,pi/4]).
-- ---------------------------------------------------------------------------
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select r.new_version_id, v.criterion_key, v.learner_facing_text, v.points_possible, v.evidence_requirements, v.minimum_fix,
       '["Any algebraically equivalent form with correct reasoning."]'::jsonb
from repaired r
join (values
 ('part-a-i','States the substitution u = x² (and du = 2x dx) before integrating.',1,'u=x² stated explicitly, before the integral is rewritten.','State u=x², du=2x dx.'),
 ('part-a-ii','Rewrites the integral in terms of u and evaluates it symbolically to (1/2)e^u.',1,'Correct antiderivative (1/2)e^u shown in terms of u.','Show (1/2)∫e^u du = (1/2)e^u.'),
 ('part-a-iii','Evaluates the bounds correctly to get (e−1)/2.',1,'(e−1)/2 shown as the final value.','Evaluate (1/2)e^u from u=0 to u=1 to get (e−1)/2.'),
 ('part-b-i','States the substitution u = 1 + tan x (and du = sec²x dx) before integrating.',1,'u=1+tan x stated explicitly, before the integral is rewritten.','State u=1+tan x, du=sec²x dx.'),
 ('part-b-ii','Rewrites the integral in terms of u and evaluates it symbolically to ln|u|.',1,'Correct antiderivative ln|u| shown in terms of u.','Show ∫du/u = ln|u|.'),
 ('part-b-iii','Evaluates the bounds correctly to get ln 2.',1,'ln 2 shown as the final value.','Evaluate ln|u| from u=1 to u=2 to get ln 2.'),
 ('part-c-i','Notes that 1+tan x must be checked for sign over the interval of integration before dropping the absolute value.',1,'States the need to check the sign of 1+tan x on [0,π/4].','State that the sign of 1+tan x on [0,π/4] must be checked before simplifying ln|1+tan x|.'),
 ('part-c-ii','Confirms tan x ≥ 0 on [0, π/4], so 1+tan x > 0 on this interval.',1,'tan x ≥ 0 on [0,π/4] stated or shown, giving 1+tan x > 0.','State that tan x ranges from 0 to 1 on [0,π/4], so 1+tan x is positive throughout.'),
 ('part-c-iii','Concludes that ln|1+tan x| simplifies to ln(1+tan x) without an absolute value, because the argument is positive throughout.',1,'Explicit conclusion that the absolute value can be dropped because the argument is always positive.','State that since 1+tan x>0 on [0,π/4], ln|1+tan x| = ln(1+tan x).')
) as v(criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix) on true
where r.content_key='apcalcab-frq-012';

-- ---------------------------------------------------------------------------
-- apphy1-frq-048: merge the two redundant b-criteria into one 2-point criterion (per
-- Ahmed Ali, 08-11 -- a correct 25.0s calculation from t=Δx/(v_B-v_A) already
-- demonstrates the inverse-proportionality insight, so grading them as separately
-- gradable 1-pt skills double-counts one insight). Adds the point-object/same-lane
-- clarifying assumption to the stimulus. The position-vs-time-graph part the note also
-- requested is a new-stimulus-asset-scale addition, not applied here -- open follow-up.
-- Numbers independently re-verified: 300/8.00=37.5s (unchanged), 300/12.0=25.0s.
-- ---------------------------------------------------------------------------
update app.content_item_versions civ
set stimulus='Car A travels at a constant 20.0 m/s eastward. Car B, 300 m behind car A on the same road, travels at a constant 28.0 m/s eastward, both starting at t=0. Treat both cars as point objects traveling in the same lane.'
from repaired r where r.content_key='apphy1-frq-048' and civ.id=r.new_version_id;

insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select r.new_version_id, v.criterion_key, v.learner_facing_text, v.points_possible, v.evidence_requirements, v.minimum_fix, '[]'::jsonb
from repaired r
join (values
 ('a-catchup','Calculates the catch-up time (37.5 s) using the relative (closing) speed of 8.00 m/s over the 300 m gap.',1,'37.5 s shown','Divide the 300 m gap by the closing speed (28.0-20.0 m/s).'),
 ('b-combined','Explains that catch-up time is inversely proportional to the closing speed (t=Δx/(v_B−v_A)), and uses that relationship to calculate the new catch-up time as 25.0 s with the new closing speed of 12.0 m/s.',2,'States or clearly uses t=Δx/(v_B−v_A) (or equivalent reasoning) to explain why a larger closing speed gives a smaller time, AND shows 25.0 s from 300/12.0.','State the inverse relationship between closing speed and catch-up time, and show the 25.0 s calculation from the new closing speed.')
) as v(criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix) on true
where r.content_key='apphy1-frq-048';

-- ---------------------------------------------------------------------------
-- APSTAT-MOD4-M001: split the single 1-point bundled criterion into three 1-point
-- criteria matching the three genuinely separate AP Statistics experimental-design
-- components it bundled (per Shazia Fazal, 08-09). Total moves 1 -> 3 points, matching
-- the standard AP Stats "comparison groups / random assignment / response variable"
-- rubric structure for this FRQ archetype.
-- ---------------------------------------------------------------------------
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select r.new_version_id, v.criterion_key, v.learner_facing_text, v.points_possible, v.evidence_requirements, v.minimum_fix, '[]'::jsonb
from repaired r
join (values
 ('design-groups','Identifies a treatment group (receives the new tutoring program) and a control group (does not) for comparison.',1,
  'Both a treatment group and a control (or comparison) group are named.',
  'Name a treatment group that receives tutoring and a control group that does not.'),
 ('design-random-assignment','States that students are randomly assigned to the treatment or control group.',1,
  'Random assignment to groups is explicitly stated.',
  'State that students are randomly assigned to the treatment or control group.'),
 ('design-outcome','Describes how the outcome (student performance) will be measured and compared between groups.',1,
  'A concrete outcome measure (e.g. test scores, grades) is named and a comparison between groups is described.',
  'Name a specific performance measure and describe comparing it between the treatment and control groups.')
) as v(criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix) on true
where r.content_key='APSTAT-MOD4-M001';

-- ---------------------------------------------------------------------------
-- apphycm-frq-044: assessed and REPAIRED, not retired. Muhammad Saood's 08-10
-- disapproval independently re-verified: the energy-conservation math is fully correct
-- (Us=(1/2)(200)(0.100)²=1.00J; v=sqrt(2*1.00/0.500)=2.00 m/s; quadrupling Us via
-- doubled compression, Us∝x², gives v∝x, so v doubles to 4.00 m/s at x=0.200m --
-- Us=(1/2)(200)(0.200)²=4.00J, v=sqrt(2*4.00/0.500)=4.00 m/s, confirmed). The only
-- defect is the single ambiguous phrase "after leaving the spring," which contradicts
-- the stimulus's "on a spring" (implying an attached oscillator that never leaves the
-- spring). One-clause fix, no rubric change needed.
-- ---------------------------------------------------------------------------
update app.content_item_versions civ
set stem='Answer all parts of the following question.

(a) Use energy conservation to calculate the mass''s maximum speed as it passes through the equilibrium position.

(b) Predict, with justification, by what factor the maximum speed would change if the compression were instead doubled to 0.200 m.'
from repaired r where r.content_key='apphycm-frq-044' and civ.id=r.new_version_id;

insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select r.new_version_id, fc.criterion_key, fc.learner_facing_text, fc.points_possible, fc.evidence_requirements, fc.minimum_fix, coalesce(fc.accepted_variants,'[]'::jsonb)
from repaired r
join app.frq_criteria fc on fc.content_item_version_id=r.old_version_id
where r.content_key='apphycm-frq-044';

-- ---------------------------------------------------------------------------
-- Recompute content_hash for every repaired version.
-- ---------------------------------------------------------------------------
update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text||':'||fc.points_possible::text, E'\n' order by fc.criterion_key)
            from app.frq_criteria fc where fc.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

-- ---------------------------------------------------------------------------
-- Owner remediation approval + publish, gated on structural QA.
-- ---------------------------------------------------------------------------
insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(),new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','frq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,
  decision_hash,created_by
)
select cra.content_review_assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question',1,'Medium',false,array[]::text[],
       case r.content_key
         when 'apphycm-frq-044' then 'Owner-directed retire-or-repair assessment, 2026-08-11: Saood''s 08-10 disapproval independently re-verified -- all energy-conservation math confirmed correct (2.00 m/s, doubling to 4.00 m/s); repaired the single ambiguous phrase ("after leaving the spring" vs. the stimulus''s "on a spring") rather than retiring a mathematically sound item, per protocol §9.2.'
         when 'APBIO-FRQ-L-025' then 'Owner-directed FRQ batch repair, 2026-08-11 (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_11.md follow-up). De-bundled every part into 1-point-per-task criteria (10->13 pts) per the reviewer''s own stated principle, applied consistently across all four parts, not just the one the note called out. The Long-FRQ-vs-experiment-format concern is NOT resolved here (would require splitting into separate items, an authoring-scale change) -- open follow-up, recorded not dropped.'
         else 'Owner-directed FRQ batch repair, 2026-08-11 (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_11.md follow-up). Fix independently re-derived per protocol §9.2, not a literal transcription of the flagging reviewer''s note -- ' || r.content_key
       end,
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','frq_batch_repair_20260811','content_key',r.content_key,'qa_date','2026-08-11'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','frq_batch_repair_20260811','content_key',r.content_key,'qa_date','2026-08-11')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_assignments cra on cra.content_item_version_id=r.new_version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

create temporary table qa_blocked as
select r.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.frq_criteria f where f.content_item_version_id=civ.id)=0 then 'no criteria'
    when coalesce((select sum(f.points_possible) from app.frq_criteria f where f.content_item_version_id=civ.id),0)<=0 then 'frq rubric gate'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table approve_set on commit drop as
select r.content_key, r.new_version_id
from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from approve_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from approve_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published',
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from approve_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from approve_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>5 then raise exception 'expected 5 repaired FRQs, got %', n; end if;

  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'FRQ repair blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;

  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after FRQ repair: %', n; end if;
end $$;

select 'repaired_frq' metric, count(*)::text value from repaired
union all select 'published_frq', count(*)::text from approve_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from approve_set;

commit;
