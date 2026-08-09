-- Physics draft FRQ batch (049-058, x3 subjects): §9 QA repair + assignment, 2026-08-09.
--
-- Context: these 30 items (apphy2-frq-049..058, apphycem-frq-049..058,
-- apphycm-frq-049..058) are the second half of a 60-item orphan-bug fix from
-- 2026-08-08 (docs/activity_log/ACTIVITY_LOG.md, "Ghazanfar Withdrawal Orphan
-- Bug Found and Fixed") -- reset to status='draft' and deliberately left
-- unassigned for a future decision. Owner directed: QA first, then assign to
-- Muhammad Saood.
--
-- §9 independent re-derivation (3 parallel agents, one per subject) found:
-- Physics 2 (10/10 clean), Physics C: E&M (10/10 clean), Physics C: Mechanics
-- (7/10 clean, 3 defects). The 3 Mechanics defects share one root cause: part
-- (a) of each stem asks the student to "design a feasible procedure," but the
-- stored rubric only graded independent/dependent/control variable
-- identification -- never the procedure itself. Fixed by adding a fourth
-- "a-procedure" criterion to each (1 point), grading the actual measurement
-- method the stem asks for, and updating prompt_json.total_points to match.
--
-- Applied as a direct edit-in-place (not a new version) because these are
-- pure drafts -- never reviewed, never assigned to an active reviewer, no
-- decision on record to preserve. The "never edit published/reviewed content
-- in place" discipline (protocol §9.4) protects content that has already
-- been decided on; it doesn't apply to unreviewed drafts pre-assignment.

-- 1. Add the missing "a-procedure" criterion to the 3 Mechanics items.
insert into app.frq_criteria (content_item_version_id, criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix)
values
('9ce7016b-120e-40b3-ae00-389655a71989','a-procedure',
 'Describes a feasible measurement procedure: release each stack of filters from the same fixed height and use a timer, photogate, or video analysis to measure the constant (terminal) fall speed after the filters stop accelerating, repeating for stacks of different total weight.',
 1,
 'References releasing from a fixed height, a method to measure constant fall speed (timing over a measured distance, photogate, or video), and repeating across different total weights.',
 'State how terminal speed is actually measured (e.g., time the fall over a marked distance once speed is constant, or use a photogate/video) for each of several stacked-filter weights.'),
('a8f725f4-0a18-480c-ac25-53ea5b5fa382','a-procedure',
 'Describes a feasible measurement procedure: measure the vertical height climbed and the person''s mass beforehand, then time the climb with a stopwatch from start to finish, repeating multiple trials for consistency.',
 1,
 'References measuring height climbed and mass beforehand, timing the climb with a stopwatch, and taking repeated trials.',
 'State how height, mass, and climb time are actually measured (e.g., stopwatch for Delta t, known/measured stair height and person mass), with repeated trials.'),
('dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7','a-procedure',
 'Describes a feasible measurement procedure: compress the spring by a measured distance x0, release the block, and use a photogate or motion sensor to measure its maximum speed as it leaves the spring at its natural length, repeating for several different values of x0.',
 1,
 'References measuring the compression distance x0, a method to measure the block''s maximum speed (photogate or motion sensor) at the point the spring reaches natural length, and repeating across multiple x0 values.',
 'State how x0 is set and how maximum speed is actually measured (e.g., photogate at the spring''s natural length) across several different compression distances.');

update app.content_item_versions v
set prompt_json = jsonb_set(v.prompt_json, '{total_points}', '5'::jsonb), updated_at = now()
where v.id in ('9ce7016b-120e-40b3-ae00-389655a71989','a8f725f4-0a18-480c-ac25-53ea5b5fa382');

update app.content_item_versions v
set prompt_json = jsonb_set(v.prompt_json, '{total_points}', '7'::jsonb), updated_at = now()
where v.id = 'dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7';

update app.content_item_versions v
set content_hash = md5(coalesce(v.stem,'')||E'\n'||coalesce(v.stimulus,'')||E'\n'||
  (select string_agg(fc.criterion_key||':'||fc.learner_facing_text, E'\n' order by fc.criterion_key)
   from app.frq_criteria fc where fc.content_item_version_id=v.id))
where v.id in ('9ce7016b-120e-40b3-ae00-389655a71989','a8f725f4-0a18-480c-ac25-53ea5b5fa382','dec3b26f-e17d-4c5c-a6c6-108f4cd2b0d7');

-- 2. Assign all 30 items to Muhammad Saood, tutor_question / subject_review.
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select gen_random_uuid(), v.id, 'cee0cee4-fc59-4084-9a83-b24ccca940b9'::uuid, 'tutor_question', 'frq', 'pending', 'subject_review', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from app.content_items ci
join app.content_item_versions v on v.content_item_id = ci.id
where ci.content_key in (
  'apphy2-frq-049','apphy2-frq-050','apphy2-frq-051','apphy2-frq-052','apphy2-frq-053',
  'apphy2-frq-054','apphy2-frq-055','apphy2-frq-056','apphy2-frq-057','apphy2-frq-058',
  'apphycem-frq-049','apphycem-frq-050','apphycem-frq-051','apphycem-frq-052','apphycem-frq-053',
  'apphycem-frq-054','apphycem-frq-055','apphycem-frq-056','apphycem-frq-057','apphycem-frq-058',
  'apphycm-frq-049','apphycm-frq-050','apphycm-frq-051','apphycm-frq-052','apphycm-frq-053',
  'apphycm-frq-054','apphycm-frq-055','apphycm-frq-056','apphycm-frq-057','apphycm-frq-058'
) and ci.status='draft';

update app.content_items
set status='assigned', updated_at=now()
where content_key in (
  'apphy2-frq-049','apphy2-frq-050','apphy2-frq-051','apphy2-frq-052','apphy2-frq-053',
  'apphy2-frq-054','apphy2-frq-055','apphy2-frq-056','apphy2-frq-057','apphy2-frq-058',
  'apphycem-frq-049','apphycem-frq-050','apphycem-frq-051','apphycem-frq-052','apphycem-frq-053',
  'apphycem-frq-054','apphycem-frq-055','apphycem-frq-056','apphycem-frq-057','apphycem-frq-058',
  'apphycm-frq-049','apphycm-frq-050','apphycm-frq-051','apphycm-frq-052','apphycm-frq-053',
  'apphycm-frq-054','apphycm-frq-055','apphycm-frq-056','apphycm-frq-057','apphycm-frq-058'
) and status='draft';
