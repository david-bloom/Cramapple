-- Split APBIO-FRQ-L-025 into three Short FRQs, 2026-08-11.
--
-- Context: docs/Q&A/REVIEWER_QA_SWEEP_2026_08_11.md and the 08-11 remediation batch
-- deliberately left this open ("Adil Abbasi's format-mismatch note... would require
-- splitting it into two separate content items, an authoring-scale decision, not a QA
-- remediation one"). Owner-directed follow-up: "execute the follow ups."
--
-- Adil Abbasi's 08-09 note: "Format mismatch: 10 points with parts A-D reads as a Long
-- FRQ, but AP's long questions (Q1/Q2) are experiment and graphing-based. This has no
-- investigation, variables, or data to plot. As written it's a 4-part conceptual essay,
-- which AP doesn't use. Fix: split into two short FRQs: a 4-pt Analyze Model or Visual
-- Representation (Part A + C) and a 4-pt Analyze Data (Part B), with Part D folded into
-- a 4-pt Conceptual Analysis."
--
-- Implemented as three self-contained Short FRQs (APBIO-FRQ-S-101/102/103), reusing the
-- already-de-bundled 08-11 criteria verbatim (no content rewritten, only regrouped):
--   S-101 "Phylogenetic Cladogram Construction and Parsimony" (Analyze Model/Visual
--     Representation) -- original Part A (a-i..a-iv), 4 pts, character-matrix stimulus.
--   S-102 "Molecular Clock Divergence-Time Calculation" (Analyze Data) -- original
--     Part B (b-i..b-iv), 4 pts, Table 1 stimulus.
--   S-103 "Homoplasy, Molecular Reliability, and Species-Delimitation Evidence"
--     (Conceptual Analysis) -- original Parts C+D combined (c-i,c-ii,d-i,d-ii,d-iii),
--     5 pts, no stimulus needed (pure conceptual, matching Adil's framing). Grouped
--     together rather than force-splitting to exactly 4 pts each, since both parts share
--     the same underlying question (what counts as valid evidence for evolutionary
--     relationships) and neither is large enough to stand alone as its own FRQ.
--
-- The original Long FRQ is retired, not left live in parallel -- its content is fully
-- redistributed, and leaving both would double-test the same material under two
-- point-value schemes.

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-frq-l025-split-20260811'));

-- ---------------------------------------------------------------------------
-- Retire the original Long FRQ.
-- ---------------------------------------------------------------------------
update app.content_item_versions civ
set status='retired', updated_at=now()
from app.content_items ci
where ci.content_key='APBIO-FRQ-L-025' and civ.content_item_id=ci.id and civ.status='published';

update app.content_items ci
set status='retired', updated_at=now()
where ci.content_key='APBIO-FRQ-L-025';

-- ---------------------------------------------------------------------------
-- Create the three new Short FRQs.
-- ---------------------------------------------------------------------------
create temporary table new_items (
  content_key text primary key,
  title text not null,
  stem text not null,
  stimulus text,
  item_id uuid not null default gen_random_uuid(),
  version_id uuid not null default gen_random_uuid()
) on commit drop;

insert into new_items (content_key, title, stem, stimulus) values
('APBIO-FRQ-S-101', 'Phylogenetic Cladogram Construction and Parsimony',
 'Answer all parts of the following question.

(a)(i) Define synapomorphy and explain why it is more informative for constructing phylogenies than symplesiomorphy (a shared ancestral character).
(a)(ii) Using the character matrix data, construct the most parsimonious cladogram for species A–E, identify the outgroup, and explain your reasoning.
(a)(iii) Explain what "most parsimonious" means in phylogenetic analysis.
(a)(iv) Explain why parsimony is preferred when building cladograms.',
 'Character matrix (1 = character present, 0 = absent):
               | Char 1 | Char 2 | Char 3 | Char 4
Species A      |   0    |   0    |   0    |   0    (outgroup)
Species B      |   1    |   0    |   0    |   0
Species C      |   1    |   1    |   0    |   0
Species D      |   1    |   1    |   1    |   0
Species E      |   1    |   1    |   1    |   1'),
('APBIO-FRQ-S-102', 'Molecular Clock Divergence-Time Calculation',
 E'Answer all parts of the following question. The molecular clock hypothesis proposes that DNA sequences accumulate mutations at an approximately constant rate over time.\n\n(b)(i) Explain the molecular basis for the molecular clock — why do neutral mutations accumulate at a relatively constant rate?\n(b)(ii) Use the data in Table 1 to estimate the divergence time for the third pair (Human–Gorilla) and show your work.\n(b)(iii) Describe ONE reason why the molecular clock is not perfectly constant and can give inaccurate divergence estimates.\n(b)(iv) Describe a SECOND, distinct reason why the molecular clock is not perfectly constant.',
 E'Table 1: Molecular clock data — Cytochrome b sequence divergence\nSpecies pair         | % sequence difference | Known divergence (Mya)\nHuman–Chimpanzee     |       2.5%            |      5-7 Mya\nRhesus–Baboon        |       5.4%            |     10-12 Mya\nHuman–Gorilla        |       4.0%            |      ?\n\nCalculation setup: Assume 1% cytochrome b divergence ≈ 2 Mya\n(calibrated from the known pairs above)'),
('APBIO-FRQ-S-103', 'Homoplasy, Molecular Reliability, and Species-Delimitation Evidence',
 E'Answer all parts of the following question.\n\n(c)(i) Explain how analogous structures (homoplasy) can cause morphological phylogenies to incorrectly group unrelated organisms together.\n(c)(ii) Explain why molecular phylogenies are generally considered more reliable than morphological phylogenies for resolving deep evolutionary relationships, and give a specific example of a case where molecular data overturned a morphologically derived phylogeny.\n(d)(i)-(d)(iii) A researcher wants to determine whether two geographically isolated populations of mice are separate species or subspecies. Describe THREE lines of evidence the researcher could collect (one per sub-part) and explain how each line of evidence would contribute to a decision.',
 null);

do $$
declare
  v_epv uuid;
  n record;
begin
  select exam_pack_version_id into strict v_epv
  from app.content_items where content_key='APBIO-FRQ-S-100';

  for n in select * from new_items loop
    insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status, created_by, frq_form, practice_format, frq_archetype)
    values (n.item_id, v_epv, n.content_key, 'frq', n.title, 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'short', 'targeted_drill', null);

    insert into app.content_item_versions (
      id, content_item_id, version_num, stem, stimulus, prompt_json,
      content_hash, status, created_by, review_status, rubric_type, evaluator_strategy
    ) values (
      n.version_id, n.item_id, 1, n.stem, n.stimulus,
      jsonb_build_object(
        'split_from', 'APBIO-FRQ-L-025',
        'qa_remediation', '2026-08-11 APBIO-FRQ-L-025 split (protocol format-mismatch follow-up)'
      ),
      md5(coalesce(n.stem,'')), 'draft', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      null, 'discrete_text', 'llm_discrete_text'
    );
  end loop;
end $$;

insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select n.version_id, v.criterion_key, v.learner_facing_text, v.points_possible, v.evidence_requirements, v.minimum_fix, '[]'::jsonb
from new_items n
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
  'State that parsimony minimizes the number of required evolutionary changes, and that this is preferred because it assumes the fewest independent, unsupported evolutionary events.')
) as v(criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix) on true
where n.content_key='APBIO-FRQ-S-101';

insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select n.version_id, v.criterion_key, v.learner_facing_text, v.points_possible, v.evidence_requirements, v.minimum_fix, '[]'::jsonb
from new_items n
join (values
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
  'Give a second, different valid reason, such as repair-rate differences between lineages or calibration uncertainty.')
) as v(criterion_key,learner_facing_text,points_possible,evidence_requirements,minimum_fix) on true
where n.content_key='APBIO-FRQ-S-102';

insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants)
select n.version_id, v.criterion_key, v.learner_facing_text, v.points_possible, v.evidence_requirements, v.minimum_fix, '[]'::jsonb
from new_items n
join (values
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
where n.content_key='APBIO-FRQ-S-103';

update app.content_item_versions civ
set content_hash = md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(fc.criterion_key||':'||fc.learner_facing_text||':'||fc.points_possible::text, E'\n' order by fc.criterion_key)
            from app.frq_criteria fc where fc.content_item_version_id=civ.id),''))
from new_items n where civ.id=n.version_id;

-- ---------------------------------------------------------------------------
-- Owner remediation approval + publish, gated on structural QA.
-- ---------------------------------------------------------------------------
insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select gen_random_uuid(), version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','frq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from new_items;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,tutor_decision,decision_payload,
  decision_hash,created_by
)
select cra.content_review_assignment_id, n.version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question',1,'Medium',false,array[]::text[],
       'Owner-directed split of APBIO-FRQ-L-025 into Short FRQs, 2026-08-11, per Adil Abbasi''s 08-09 format-mismatch finding (docs/Q&A/REVIEWER_QA_SWEEP_2026_08_09.md, 2026-08-11 remediation follow-up). Content reused verbatim from the 08-11 de-bundled criteria, only regrouped into self-contained Short FRQs -- ' || n.content_key || ', split from APBIO-FRQ-L-025.',
       'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_frq_l025_split_20260811','content_key',n.content_key,'qa_date','2026-08-11'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_frq_l025_split_20260811','content_key',n.content_key,'qa_date','2026-08-11')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from new_items n
join app.content_review_assignments cra on cra.content_item_version_id=n.version_id and cra.assignment_purpose='owner_remediation_approval' and cra.status='pending';

create temporary table qa_blocked as
select n.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.frq_criteria f where f.content_item_version_id=civ.id)=0 then 'no criteria'
    when coalesce((select sum(f.points_possible) from app.frq_criteria f where f.content_item_version_id=civ.id),0)<=0 then 'frq rubric gate'
  end reason
from new_items n
join app.content_item_versions civ on civ.id=n.version_id;
delete from qa_blocked where reason is null;

do $$ declare n int; begin
  select count(*) into n from qa_blocked;
  if n<>0 then raise exception 'split blocked by structural QA gate: %',
    (select string_agg(content_key||':'||reason, ', ' order by content_key) from qa_blocked);
  end if;
end $$;

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=now(),
    updated_at=now()
from new_items n where civ.id=n.version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from new_items n where ci.id=n.item_id;

update app.content_item_versions civ
set status='published', published_at=now(), updated_at=now()
from new_items n where civ.id=n.version_id;

update app.content_items ci
set status='published', updated_at=now()
from new_items n where ci.id=n.item_id;

do $$
declare n integer;
begin
  select count(*) into n from app.content_items where content_key in ('APBIO-FRQ-S-101','APBIO-FRQ-S-102','APBIO-FRQ-S-103') and status='published';
  if n<>3 then raise exception 'expected 3 published split FRQs, got %', n; end if;

  select count(*) into n from app.content_items where content_key='APBIO-FRQ-L-025' and status='retired';
  if n<>1 then raise exception 'expected APBIO-FRQ-L-025 retired, got %', n; end if;
end $$;

commit;

select ci.content_key, ci.status, ci.frq_form,
  (select sum(f.points_possible) from app.frq_criteria f
   join app.content_item_versions civ on civ.id=f.content_item_version_id
   where civ.content_item_id=ci.id and civ.status='published') as points
from app.content_items ci
where ci.content_key in ('APBIO-FRQ-L-025','APBIO-FRQ-S-101','APBIO-FRQ-S-102','APBIO-FRQ-S-103')
order by ci.content_key;
