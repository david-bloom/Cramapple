begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Chemistry';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array['apchem-mcq-sv-022-v1','apchem-mcq-sv-022-v2','apchem-mcq-sv-022-v3','apchem-mcq-sv-023-v1','apchem-mcq-sv-023-v2','apchem-mcq-sv-023-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apchem-mcq-sv-022-v1 (seed apchem-mcq-022)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-022-v1', 'mcq', 'Configuration of Mn²⁺', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'What is the ground-state electron configuration of the Mn2+ ion (Mn, Z = 25, ground-state configuration [Ar]3d^5 4s^2)?', null, md5('apchem-mcq-sv-022-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[Ar]3d^5', true, 'Correct. For transition-metal cations, the 4s electrons are removed before any 3d electrons. Mn2+ loses both 4s electrons and keeps all five 3d electrons: [Ar]3d^5.' from version_ins
union all select gen_random_uuid(), id, 'B', '[Ar]3d^3 4s^2', false, 'Incorrect. This removes two electrons from the 3d subshell and leaves 4s^2, reflecting the idea that the last-filled (3d) electrons leave first. In cations, 4s electrons are removed first.' from version_ins
union all select gen_random_uuid(), id, 'C', '[Ar]3d^5 4s^2', false, 'Incorrect. This is the neutral Mn atom; the 2+ charge was ignored, so no electrons were removed.' from version_ins
union all select gen_random_uuid(), id, 'D', '[Ar]3d^4 4s^1', false, 'Incorrect. This removes one electron from each of 4s and 3d. Both 4s electrons must be removed before any 3d electron is, so Mn2+ is 3d^5 with no 4s electrons.' from version_ins
;
-- apchem-mcq-sv-022-v2 (seed apchem-mcq-022)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-022-v2', 'mcq', 'Configuration of Co³⁺', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'In a cobalt(III) coordination compound, the metal exists as the Co3+ ion (Co, Z = 27, ground-state configuration [Ar]3d^7 4s^2). Which of the following is the ground-state electron configuration of Co3+?', null, md5('apchem-mcq-sv-022-v2'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[Ar]3d^7', false, 'Incorrect. This is the Co2+ configuration (only the two 4s electrons removed); Co3+ must lose one more electron, from 3d.' from version_ins
union all select gen_random_uuid(), id, 'B', '[Ar]3d^5 4s^1', false, 'Incorrect. This has the correct number of removed electrons (three) but takes only one from 4s and two from 3d; both 4s electrons must be removed before any 3d electron.' from version_ins
union all select gen_random_uuid(), id, 'C', '[Ar]3d^6', true, 'Correct. The two 4s electrons are removed first, then one 3d electron, leaving [Ar]3d^6 (6 electrons beyond [Ar], three fewer than the neutral atom''s 9).' from version_ins
union all select gen_random_uuid(), id, 'D', '[Ar]3d^4 4s^2', false, 'Incorrect. This removes three electrons from 3d and keeps 4s^2, as if 3d electrons were lost first. In a cation the 4s electrons are removed first.' from version_ins
;
-- apchem-mcq-sv-022-v3 (seed apchem-mcq-022)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-022-v3', 'mcq', 'Configuration of Ti²⁺', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Titanium(II) ions are studied in a solid-state chemistry lab. Which configuration is the ground state of the Ti2+ ion (Ti, Z = 22, ground-state configuration [Ar]3d^2 4s^2)?', null, md5('apchem-mcq-sv-022-v3'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '[Ar]3d^1 4s^1', false, 'Incorrect. This removes one electron from each subshell. Both 4s electrons are lost before any 3d electron is.' from version_ins
union all select gen_random_uuid(), id, 'B', '[Ar]3d^4', false, 'Incorrect. This moves the two 4s electrons into the 3d subshell instead of removing them; the ion would then have the same number of electrons as the neutral atom, so it would not be 2+.' from version_ins
union all select gen_random_uuid(), id, 'C', '[Ar]3d^2', true, 'Correct. Both 4s electrons are removed first, which removes the two electrons needed for a 2+ charge, so the 3d electrons are untouched: [Ar]3d^2.' from version_ins
union all select gen_random_uuid(), id, 'D', '[Ar]4s^2', false, 'Incorrect. This removes the two 3d electrons and keeps 4s^2, treating 3d as the subshell that fills last and therefore empties first. 4s electrons are removed first.' from version_ins
;
-- apchem-mcq-sv-023-v1 (seed apchem-mcq-023)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-023-v1', 'mcq', 'PES: six-peak atom', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A chemist records the photoelectron spectrum of a neutral gaseous atom. In order of decreasing binding energy, the six peaks have relative areas 2, 2, 6, 2, 6, and 1. Which element produced the spectrum?', null, md5('apchem-mcq-sv-023-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Calcium', false, 'Incorrect. Calcium would have a final 4s peak of area 2 (20 electrons), but the observed last peak has area 1.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Potassium', true, 'Correct. The areas sum to 2 + 2 + 6 + 2 + 6 + 1 = 19 electrons, giving 1s²2s²2p⁶3s²3p⁶4s¹ for K (Z = 19); the last peak (area 1) is the single 4s electron.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Carbon', false, 'Incorrect. This takes the number of peaks (six) as the atomic number; peak count equals the number of occupied subshells, not Z. Carbon would show only three peaks (2, 2, 2).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Argon', false, 'Incorrect. Summing only the first five peaks (2+2+6+2+6 = 18) and ignoring the sixth peak gives argon; the sixth peak means an additional subshell is occupied.' from version_ins
;
-- apchem-mcq-sv-023-v2 (seed apchem-mcq-023)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-023-v2', 'mcq', 'PES: five-peak atom', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The photoelectron spectrum of a neutral atom has five peaks. From highest to lowest binding energy, their relative areas are 2, 2, 6, 2, and 3. Identify the element.', null, md5('apchem-mcq-sv-023-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Boron', false, 'Incorrect. This takes the number of peaks (five) as the atomic number; boron would show three peaks (2, 2, 1).' from version_ins
union all select gen_random_uuid(), id, 'B', 'Nitrogen', false, 'Incorrect. Nitrogen also has five valence electrons, but its spectrum would have only three peaks (2, 2, 3). Matching only the outer-peak pattern ignores the 2p and 3s peaks seen here.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Magnesium', false, 'Incorrect. Adding only the first four peaks (2+2+6+2 = 12) and dropping the last peak gives magnesium; the fifth peak (area 3) shows 3p electrons are present.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Phosphorus', true, 'Correct. The areas sum to 2+2+6+2+3 = 15 electrons, matching 1s²2s²2p⁶3s²3p³ for phosphorus (Z = 15); the five peaks are 1s, 2s, 2p, 3s and 3p.' from version_ins
;
-- apchem-mcq-sv-023-v3 (seed apchem-mcq-023)
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), epv_id, 'apchem-mcq-sv-023-v3', 'mcq', 'PES: predicting the atom', 'draft' from epv returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A neutral atom''s photoelectron spectrum is predicted to show exactly three peaks, in the relative-area ratio 2 : 2 : 1 from highest to lowest binding energy. Which element fits this prediction?', null, md5('apchem-mcq-sv-023-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Boron', true, 'Correct. 1s²2s²2p¹ gives three peaks (1s, 2s, 2p) with relative areas 2 : 2 : 1, a total of 5 electrons (Z = 5).' from version_ins
union all select gen_random_uuid(), id, 'B', 'Aluminum', false, 'Incorrect. Aluminum is in the same group (one p electron), but its spectrum would have five peaks (2, 2, 6, 2, 1), not three.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Sodium', false, 'Incorrect. A final peak of area 1 suggests one valence electron, but sodium (1s²2s²2p⁶3s¹) would show four peaks (2, 2, 6, 1).' from version_ins
union all select gen_random_uuid(), id, 'D', 'Lithium', false, 'Incorrect. This takes the number of peaks (three) as Z; lithium (1s²2s¹) would show only two peaks, in the ratio 2 : 1.' from version_ins
;
do $$ begin if (select count(*) from app.content_items where content_key = any (array['apchem-mcq-sv-022-v1','apchem-mcq-sv-022-v2','apchem-mcq-sv-022-v3','apchem-mcq-sv-023-v1','apchem-mcq-sv-023-v2','apchem-mcq-sv-023-v3']))<>6 then raise exception 'chunk count mismatch'; end if; end $$;
commit;
