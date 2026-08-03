-- DECISION-0045 gold-set verification — repeatable rollback-only integration coverage.
--
-- Run as postgres/service administration after the gold-set migrations
-- (20260803120000, 20260803140000). Creates only gold-set rows and a temporary
-- feature-flag grant, and rolls every change back.
--
-- THE ASSERTION THAT MATTERS IS T3. The certification this whole programme
-- produces is only valid if a reader never sees the writer's script, the machine
-- verifiers' marks, or the item's canonical answer. That guarantee is a fixed
-- column projection in public.gold_set_verification_next(). If someone adds a
-- convenience field to that projection, nothing breaks, no test fails, readers
-- keep working — and every number the pilot produces becomes meaningless.
-- T3 pins the projection so that change cannot land silently.

begin;

do $$
declare
  v_alpha uuid := 'aaaaaaaa-0001-0000-0000-000000000001';  -- tutor, no flag
  v_other uuid;
  v_admin uuid;
  v_vers uuid[];
  v_v uuid;
  v_answers uuid[] := '{}';
  v_aid uuid;
  v_payload jsonb;
  v_keys text;
  v_expected_keys text :=
    'answer_text,assignment_id,elements,seq,stem,stimulus,stimulus_image_path';
  v_assignment uuid;
  v_marks jsonb;
  v_err text;
  v_n integer;
  v_distinct_items integer;
  v_min_gap integer;
begin
  -- ── T0. Objects exist and nothing leaked into public as a table ────────────
  if to_regclass('app.gold_set_answers') is null
     or to_regclass('app.gold_set_elements') is null
     or to_regclass('app.gold_set_verification_assignments') is null
     or to_regclass('app.gold_set_element_marks') is null then
    raise exception 'T0 failed: gold-set tables missing';
  end if;

  if to_regclass('public.gold_set_answers') is not null
     or to_regclass('public.gold_set_element_marks') is not null then
    raise exception 'T0 failed: gold-set tables must not be exposed in public';
  end if;

  -- ── T1. authenticated holds NO table privileges anywhere ───────────────────
  -- The reader's only path is the definer RPCs. A direct grant here would let a
  -- client read app.gold_set_answers.script and end the exercise.
  if has_table_privilege('authenticated', 'app.gold_set_answers', 'select')
     or has_table_privilege('authenticated', 'app.gold_set_elements', 'select')
     or has_table_privilege('authenticated', 'app.gold_set_verification_assignments', 'select')
     or has_table_privilege('authenticated', 'app.gold_set_element_marks', 'select')
     or has_table_privilege('anon', 'app.gold_set_answers', 'select') then
    raise exception 'T1 failed: authenticated/anon must hold no gold-set table privileges';
  end if;

  -- ── Fixture ────────────────────────────────────────────────────────────────
  select array_agg(civ.id order by ci.content_key) into v_vers
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id and civ.status = 'published'
  where ci.content_key in (
    'APSTATS-SFRQ-001','APSTATS-SFRQ-004','APSTATS-SFRQ-006','APSTATS-SFRQ-008');

  if coalesce(array_length(v_vers, 1), 0) < 4 then
    raise exception 'fixture failed: expected 4 published Statistics FRQ versions, got %',
      coalesce(array_length(v_vers, 1), 0);
  end if;

  foreach v_v in array v_vers loop
    perform app.seed_gold_set_elements_single_point(v_v);
    for i in 1..2 loop
      insert into app.gold_set_answers (
        set_key, content_item_version_id, answer_type, answer_text,
        writer_family, script, script_hash, route, item_content_hash)
      values ('B', v_v, 'A' || i::text, 'integration fixture ' || i::text, 'anthropic',
              '{"omit":["e1"]}'::jsonb, 'testhash', 'provisional_accept', 'itemhash')
      returning gold_set_answer_id into v_aid;
      v_answers := v_answers || v_aid;
    end loop;
  end loop;

  -- ── T2. A tutor without the flag is denied ─────────────────────────────────
  if app.gold_set_reader_is_eligible(v_alpha) then
    raise exception 'T2 failed: unflagged tutor must not be eligible';
  end if;

  perform set_config('request.jwt.claims',
                     json_build_object('sub', v_alpha)::text, true);
  if public.gold_set_access() then
    raise exception 'T2 failed: gold_set_access() true for unflagged tutor';
  end if;

  v_err := 'NOT_RAISED';
  begin
    perform public.gold_set_verification_next();
  exception when others then v_err := SQLERRM; end;
  if v_err <> 'not_authorized' then
    raise exception 'T2 failed: expected not_authorized, got %', v_err;
  end if;

  -- Seeding a queue to an ineligible reviewer must also fail.
  v_err := 'NOT_RAISED';
  begin
    perform app.seed_gold_set_verification_assignments(v_alpha, v_answers, 3);
  exception when others then v_err := SQLERRM; end;
  if v_err <> 'reviewer_not_eligible' then
    raise exception 'T2 failed: expected reviewer_not_eligible, got %', v_err;
  end if;

  -- Grant the flag; the same reviewer is now admitted.
  insert into app.feature_flag_assignments (feature_key, user_id, enabled)
  values ('gold-set-review', v_alpha, true)
  on conflict (feature_key, user_id) do update set enabled = true, expires_at = null;

  if not app.gold_set_reader_is_eligible(v_alpha) then
    raise exception 'T2 failed: flagged tutor must be eligible';
  end if;

  -- An expired flag must not admit.
  update app.feature_flag_assignments set expires_at = pg_catalog.now() - interval '1 day'
  where feature_key = 'gold-set-review' and user_id = v_alpha;
  if app.gold_set_reader_is_eligible(v_alpha) then
    raise exception 'T2 failed: expired flag must not admit';
  end if;
  update app.feature_flag_assignments set expires_at = null
  where feature_key = 'gold-set-review' and user_id = v_alpha;

  -- Admins are admitted by role, with no flag row.
  select p.user_id into v_admin
  from app.profiles p
  where p.role = 'admin'
    and not exists (
      select 1 from app.feature_flag_assignments f
      where f.user_id = p.user_id and f.feature_key = 'gold-set-review')
  limit 1;
  if v_admin is not null and not app.gold_set_reader_is_eligible(v_admin) then
    raise exception 'T2 failed: admin must be eligible without a flag';
  end if;

  -- ── Queue ──────────────────────────────────────────────────────────────────
  perform app.seed_gold_set_verification_assignments(v_alpha, v_answers, 3);

  -- ── T3. THE PROJECTION. Exactly the safe keys, nothing more. ───────────────
  perform set_config('request.jwt.claims',
                     json_build_object('sub', v_alpha)::text, true);
  v_payload := public.gold_set_verification_next();
  if v_payload is null then
    raise exception 'T3 failed: queue unexpectedly empty';
  end if;

  select string_agg(k, ',' order by k) into v_keys
  from jsonb_object_keys(v_payload) k;

  if v_keys is distinct from v_expected_keys then
    raise exception
      'T3 FAILED — gold-set reader projection changed. Expected [%], got [%]. '
      'A reader must never receive the script, the verifiers'' marks, the grader''s '
      'output, the writer family, the route, or canonical_answer_1. If this change '
      'is intended, it must be reviewed against GOLD_SET_GENERATION_PROTOCOL.md R3 '
      'before the expected list is updated.',
      v_expected_keys, v_keys;
  end if;

  -- ── T4. Sibling separation ─────────────────────────────────────────────────
  select count(distinct ans.content_item_version_id) into v_distinct_items
  from app.gold_set_answers ans
  where ans.gold_set_answer_id = any(v_answers);

  select min(gap) into v_min_gap from (
    select a.seq - lag(a.seq) over (
             partition by ans.content_item_version_id order by a.seq) as gap
    from app.gold_set_verification_assignments a
    join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
    where a.reviewer_id = v_alpha) g
  where gap is not null;

  if v_min_gap is null or v_min_gap < v_distinct_items then
    raise exception 'T4 failed: sibling gap % below distinct item count %',
      v_min_gap, v_distinct_items;
  end if;

  -- ── T5. Submit semantics ───────────────────────────────────────────────────
  v_assignment := (v_payload ->> 'assignment_id')::uuid;

  select jsonb_agg(jsonb_build_object(
           'element_id', e ->> 'element_id', 'present', false))
    into v_marks
  from jsonb_array_elements(v_payload -> 'elements') e;

  v_err := 'NOT_RAISED';
  begin
    perform public.submit_gold_set_verification(v_assignment, '[]'::jsonb, false);
  exception when others then v_err := SQLERRM; end;
  if v_err <> 'incomplete_marks' then
    raise exception 'T5 failed: expected incomplete_marks, got %', v_err;
  end if;

  -- A present mark with no evidence quote must be rejected.
  v_err := 'NOT_RAISED';
  begin
    perform public.submit_gold_set_verification(
      v_assignment,
      (select jsonb_agg(jsonb_build_object(
                'element_id', e ->> 'element_id', 'present', true))
       from jsonb_array_elements(v_payload -> 'elements') e),
      false);
  exception when others then v_err := SQLERRM; end;
  if v_err = 'NOT_RAISED' then
    raise exception 'T5 failed: present mark without evidence quote was accepted';
  end if;

  if (public.submit_gold_set_verification(v_assignment, v_marks, false)) ->> 'status'
     <> 'submitted' then
    raise exception 'T5 failed: valid submit did not return submitted';
  end if;

  if (public.submit_gold_set_verification(v_assignment, v_marks, false)) ->> 'status'
     <> 'already_submitted' then
    raise exception 'T5 failed: resubmit is not idempotent';
  end if;

  -- ── T6. Marks are write-once ───────────────────────────────────────────────
  v_err := 'NOT_RAISED';
  begin
    update app.gold_set_element_marks set present = true
    where gold_set_verification_assignment_id = v_assignment;
  exception when others then v_err := SQLERRM; end;
  if v_err <> 'gold_set_marks_immutable' then
    raise exception 'T6 failed: expected gold_set_marks_immutable, got %', v_err;
  end if;

  -- ── T7. A submitted answer never returns to the queue ──────────────────────
  v_payload := public.gold_set_verification_next();
  if v_payload is not null
     and (v_payload ->> 'assignment_id')::uuid = v_assignment then
    raise exception 'T7 failed: submitted assignment served again';
  end if;

  -- ── T8. One reader cannot reach another reader's assignment ────────────────
  select p.user_id into v_other from app.profiles p
  where p.role = 'tutor' and p.user_id <> v_alpha limit 1;

  perform set_config('request.jwt.claims',
                     json_build_object('sub', v_other)::text, true);
  v_err := 'NOT_RAISED';
  begin
    perform public.submit_gold_set_verification(
      (select gold_set_verification_assignment_id
       from app.gold_set_verification_assignments
       where reviewer_id = v_alpha and status = 'pending' limit 1),
      '[]'::jsonb, false);
  exception when others then v_err := SQLERRM; end;
  if v_err not in ('not_authorized', 'not_authenticated') then
    raise exception 'T8 failed: cross-reader submit not blocked, got %', v_err;
  end if;

  raise notice 'gold_set_verification integration: T0-T8 PASSED';
end
$$;

rollback;
