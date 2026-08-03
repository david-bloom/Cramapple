-- Fix: gold-set queue seeding did not actually guarantee sibling separation.
--
-- The original implementation interleaved round-robin by (rank within item,
-- item position). That spaces siblings by the number of distinct items ONLY
-- when every item contributes the same number of answers. Stage 1 dropped 8
-- script-non-compliant answers unevenly across 6 items, so the tail rounds
-- contained only the items that still had answers left, and two answers to the
-- same question ended up adjacent. Observed on the first real seeding:
-- min sibling gap = 1, against a requested minimum of 3.
--
-- The up-front check (distinct_items >= p_min_sibling_gap) passed and told us
-- nothing, because it validated an input rather than the result.
--
-- Replaced with a greedy max-spread: repeatedly place an answer from whichever
-- item has the most remaining, excluding any item used in the last
-- (gap - 1) placements. That yields gap >= p_min_sibling_gap whenever it is
-- achievable, and the function now VERIFIES the achieved gap before returning
-- instead of assuming it.
--
-- Why this matters: siblings seen back to back anchor the reader's marking, and
-- that bias is systematic rather than random, so it does not average out.

begin;

create or replace function app.seed_gold_set_verification_assignments(
  p_reviewer_id uuid,
  p_answer_ids uuid[],
  p_min_sibling_gap integer default 3
)
returns integer
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_total integer;
  v_max_per_item integer;
  v_seq_offset integer;
  v_inserted integer;
  v_placed uuid[] := '{}';
  v_recent uuid[] := '{}';
  v_pick record;
  v_i integer;
  v_achieved integer;
begin
  if not app.gold_set_reader_is_eligible(p_reviewer_id) then
    raise exception 'reviewer_not_eligible' using errcode = '42501';
  end if;

  create temporary table _gs_pool on commit drop as
  select ans.gold_set_answer_id, ans.content_item_version_id
  from app.gold_set_answers ans
  where ans.gold_set_answer_id = any(p_answer_ids)
    and not exists (
      select 1 from app.gold_set_verification_assignments a
      where a.reviewer_id = p_reviewer_id
        and a.gold_set_answer_id = ans.gold_set_answer_id
    );

  select count(*) into v_total from _gs_pool;
  if v_total = 0 then return 0; end if;

  -- Feasibility: an item holding more than ceil(total / gap) answers cannot be
  -- spaced that widely no matter how the rest are arranged.
  select max(c) into v_max_per_item
  from (select count(*) c from _gs_pool group by content_item_version_id) s;

  if v_max_per_item > ceil(v_total::numeric / p_min_sibling_gap) then
    raise exception 'sibling_gap_infeasible'
      using errcode = '23514',
            detail = format(
              'one item has %s of %s answers; a gap of %s needs no more than %s',
              v_max_per_item, v_total, p_min_sibling_gap,
              ceil(v_total::numeric / p_min_sibling_gap)
            );
  end if;

  -- Greedy max-spread.
  for v_i in 1..v_total loop
    select p.gold_set_answer_id, p.content_item_version_id
      into v_pick
    from _gs_pool p
    where p.gold_set_answer_id <> all(v_placed)
      and (array_length(v_recent, 1) is null
           or p.content_item_version_id <> all(v_recent))
    group by p.gold_set_answer_id, p.content_item_version_id
    order by (select count(*) from _gs_pool q
              where q.content_item_version_id = p.content_item_version_id
                and q.gold_set_answer_id <> all(v_placed)) desc,
             p.gold_set_answer_id
    limit 1;

    if not found then
      raise exception 'sibling_gap_unsatisfiable'
        using errcode = '23514',
              detail = format('stalled after %s of %s placements', v_i - 1, v_total);
    end if;

    v_placed := v_placed || v_pick.gold_set_answer_id;
    v_recent := (v_recent || v_pick.content_item_version_id);
    if array_length(v_recent, 1) > p_min_sibling_gap - 1 then
      v_recent := v_recent[2:array_length(v_recent, 1)];
    end if;
  end loop;

  select coalesce(max(seq), 0) into v_seq_offset
  from app.gold_set_verification_assignments
  where reviewer_id = p_reviewer_id;

  insert into app.gold_set_verification_assignments (
    gold_set_answer_id, reviewer_id, seq
  )
  select id, p_reviewer_id, v_seq_offset + ord
  from unnest(v_placed) with ordinality as t(id, ord)
  on conflict (reviewer_id, gold_set_answer_id) do nothing;

  get diagnostics v_inserted = row_count;

  -- Verify the RESULT, not the input. The original function's failure was
  -- precisely that it checked a precondition and reported success regardless.
  select min(gap) into v_achieved from (
    select a.seq - lag(a.seq) over (
             partition by ans.content_item_version_id order by a.seq) as gap
    from app.gold_set_verification_assignments a
    join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
    where a.reviewer_id = p_reviewer_id
  ) g where gap is not null;

  if v_achieved is not null and v_achieved < p_min_sibling_gap then
    raise exception 'sibling_gap_not_achieved'
      using errcode = '23514',
            detail = format('achieved gap %s, required %s', v_achieved, p_min_sibling_gap);
  end if;

  return v_inserted;
end;
$$;

revoke all on function app.seed_gold_set_verification_assignments(uuid, uuid[], integer)
  from public, anon, authenticated;
grant execute on function app.seed_gold_set_verification_assignments(uuid, uuid[], integer)
  to service_role;

commit;
