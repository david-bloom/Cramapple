begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-030-v1','apphycm-mcq-sv-030-v2','apphycm-mcq-sv-030-v3'])) then raise exception 'chunk already loaded'; end if;
end $$;
-- apphycm-mcq-sv-030-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-030-v1', 'mcq', 'Rope pulling a crate at an angle', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A rope pulls a crate with a constant force of 50 N directed 60° above the horizontal. The crate moves horizontally at a constant 4.0 m/s. What power does the rope''s force deliver to the crate?', null, md5('apphycm-mcq-sv-030-v1'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '100 W', true, 'Power is the dot product P = F·v = Fv cos θ = (50)(4.0)cos 60° = 100 W.' from version_ins
union all select gen_random_uuid(), id, 'B', '6.3 W', false, 'This divides the parallel force component by the speed (25 N ÷ 4.0 m/s ≈ 6.3, which is not a power) instead of multiplying. Power is P = F·v = 25 N × 4.0 m/s = 100 W.' from version_ins
union all select gen_random_uuid(), id, 'C', '170 W', false, 'This uses sin 60° instead of cos 60°. The angle is measured from the horizontal motion, so the parallel component is F cos 60°, giving 100 W.' from version_ins
union all select gen_random_uuid(), id, 'D', '200 W', false, 'This is Fv with no angle. Only the component of the force parallel to the velocity delivers power, so the cosine factor is needed: 100 W.' from version_ins;
-- apphycm-mcq-sv-030-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-030-v2', 'mcq', 'Power from a work function', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'The total work done on a cart by the net force is W(t) = 2.0t³ joules, where t is in seconds. What is the instantaneous power delivered to the cart at t = 2.0 s?', null, md5('apphycm-mcq-sv-030-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '16 W', false, 'This is the work done so far, 16 J, reported as a power. Power is the rate of change of work, dW/dt = 24 W.' from version_ins
union all select gen_random_uuid(), id, 'B', '12 W', false, 'This differentiates 2.0t³ as 3t², dropping the coefficient 2.0. The derivative is 6.0t², giving 24 W.' from version_ins
union all select gen_random_uuid(), id, 'C', '8.0 W', false, 'This is the average power over the first 2.0 s, W/t = 16 J/2.0 s. Instantaneous power is the derivative dW/dt, which is 24 W at this instant.' from version_ins
union all select gen_random_uuid(), id, 'D', '24 W', true, 'Instantaneous power is the time derivative of work: P = dW/dt = 6.0t². At t = 2.0 s, P = 6.0(4.0) = 24 W.' from version_ins;
-- apphycm-mcq-sv-030-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9', 'apphycm-mcq-sv-030-v3', 'mcq', 'Power from a time-dependent force', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A 2.0 kg cart starts from rest on a frictionless track. A force along the track, F = 8.0t newtons (t in seconds), is the only horizontal force on it. What power does this force deliver at t = 1.5 s?', null, md5('apphycm-mcq-sv-030-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '108 W', false, 'This uses the constant-acceleration formula v = at with the final acceleration (6.0 m/s²), giving v = 9.0 m/s. The acceleration grows with time, so v must be found by integrating: v = 4.5 m/s and P = 54 W.' from version_ins
union all select gen_random_uuid(), id, 'B', '13.5 W', false, 'This is the average power over the first 1.5 s: the work is ∫Fv dt = 4.0t⁴ = 20.25 J, and 20.25 J ÷ 1.5 s = 13.5 W. The question asks for the instantaneous power, 54 W.' from version_ins
union all select gen_random_uuid(), id, 'C', '72 W', false, 'This multiplies force by acceleration (12 N × 6.0 m/s²), which is not a rate of energy transfer. Power is F·v, with v = 4.5 m/s, giving 54 W.' from version_ins
union all select gen_random_uuid(), id, 'D', '54 W', true, 'a = F/m = 4.0t, so v = ∫a dt = 2.0t². At t = 1.5 s, v = 4.5 m/s and F = 12 N, so P = Fv = 54 W.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and content_key = any (array['apphycm-mcq-sv-030-v1','apphycm-mcq-sv-030-v2','apphycm-mcq-sv-030-v3']) and status='draft')<>3 then raise exception 'chunk 5: expected 3 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and ci.content_key = any (array['apphycm-mcq-sv-030-v1','apphycm-mcq-sv-030-v2','apphycm-mcq-sv-030-v3']))<>12 then raise exception 'chunk 5: choice rows'; end if;
end $$;
commit;
