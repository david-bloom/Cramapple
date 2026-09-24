-- M1 of the AP Biology completion plan (docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md).
-- Product Owner direction 2026-09-24: the assembled document becomes canonical_answer_1.
--
-- APPLIED TO PRODUCTION 2026-09-24. 67 of 71 items written; 4 deliberately held (see below).
--
-- This file records what was applied. The 548 spans and 67 answer texts were loaded through a
-- temporary app.m1_staging table in five batches and then applied by the transaction below; the
-- staging table was dropped inside that same transaction. The span data itself lives in
-- docs/research/apbio_drafted_criteria_2026_09_23/canonical_proposal.jsonl at commit 76ac3066.
--
-- ---------------------------------------------------------------------------
-- What changed, measured rather than assumed
--
-- Of the 71 items in work order F's proposal, compared against Production before writing:
--
--   16  unchanged  -- the long APBIO-FRQ-L-* items; full_text already equalled the stored
--                     canonical_answer_1 byte for byte, so their text was never transmitted. The
--                     migration fills it from Production and proves the fill by md5.
--    3  new        -- S-101, S-102, S-103 had a blank canonical_answer_1.
--   49  additive   -- the existing canonical survives inside the new text; what is added is
--                     canonical_answer_2's content plus newly drafted coverage.
--    3  REPLACEMENT -- S-021, S-023, S-058. Work order F judged the existing canonical
--                     insufficient and drafted over it, so the published text would be discarded
--                     entirely. That is a substitution, not an assembly, and it is NOT what was
--                     authorised. HELD.
--
-- Also held: S-101, which scores 100% on only 1 of 3 grader runs (M1-B-001). Writing its canonical
-- would have foreclosed that measurement permanently -- the QA gate refuses any item that already
-- has one.
--
-- The additive guarantee is enforced, not just asserted: the migration aborts if any item's
-- existing canonical_answer_1 is not a substring of its replacement. Negative-tested locally.
--
-- ---------------------------------------------------------------------------
-- Two contract changes this required
--
-- 1. answer_field. M0 assumed spans belong to one stored field. For 36 items F's document splices
--    canonical_answer_1 and canonical_answer_2 together. Making the assembled document THE
--    canonical_answer_1 resolves this: every span now belongs to canonical_answer_1, and M0's
--    invariant -- spans ordered by ordinal reconstruct the field exactly -- holds again. Verified
--    for all 67, 0 mismatches.
--
-- 2. source_field. F emits prior_canonical_answer_1/2 and authored_work_order_F; M0's check allowed
--    neither. The prior_* values were mapped to canonical_answer_1/2 before staging -- justified
--    because the recovered spans' concatenation was verified md5-identical to Production's stored
--    fields on 37 of 39 items, and the 2 that failed are among the held items. authored_work_order_F
--    has no equivalent, so 'authored' is added to the constraint below.
--
-- ---------------------------------------------------------------------------
-- VERIFIED ON PRODUCTION AFTER APPLYING, by query rather than by trusting the migration's guards:
--
--   75 Biology FRQ; 70 now carry a canonical (was 68)
--   5 still blank, all deliberate: APBIO-FRQ-S-101 (held) and the 4 APBIO-HDG-*-GRAPH-* items
--     (hand-drawn; text cannot earn their spatial criteria)
--   548 spans across 67 items
--   0 items where the spans fail to reconstruct canonical_answer_1
--   245 stored criteria on those items; 0 without a span tagged to that criterion ALONE
--   provenance: unchanged_from_prior_run 153, assembly_literal 126, recovered_ca1 104,
--               recovered_ca2 78, drafted 77, recovered_parent 10
--   source_field: canonical_answer_1 244, canonical_answer_2 91, authored 77,
--                 parent_canonical_answer_1 10, null 126
--   the 3 held items keep their published text untouched: S-021 104 chars, S-023 100, S-058 138
--   RLS enabled, 0 grants to anon/authenticated/public
--
-- ---------------------------------------------------------------------------
-- OPEN, and worth a decision rather than a drift
--
-- canonical_answer_2 is still populated on 52 Biology FRQ, and its text is now ALSO inside
-- canonical_answer_1. It was verified fully preserved -- 39 of 39 items whose spans recovered from
-- it matched byte for byte -- so nothing was lost by assembling. But the field is now redundant and
-- duplicated. Nothing in supabase/functions/ reads canonical_answer_2, so this is inert today.
-- Clearing it was not authorised and was not done. Left as an explicit open item rather than a
-- silent inconsistency.
--
-- content_hash goes stale here for the same reason recorded in M4: it is sha256Hex(JSON.stringify())
-- over an unstored intake payload, so no in-place migration can recompute it, and nothing verifies
-- it at grade time.

begin;

-- 1. The 16 long items were not transmitted: their full_text already equals the stored
--    canonical_answer_1. Fill from Production, then prove it by md5 rather than assuming it.
update app.m1_staging s
set full_text = civ.canonical_answer_1
from app.content_item_versions civ
where civ.id = s.content_item_version_id and s.full_text is null;

do $$
declare v_n integer; v_bad text;
begin
  select count(*) into v_n from app.m1_staging;
  if v_n <> 67 then raise exception 'M1: expected 67 staged items, got %', v_n; end if;

  select count(*) into v_n from app.m1_staging where full_text is null;
  if v_n <> 0 then raise exception 'M1: % staged items still have no full_text', v_n; end if;

  -- md5 and length must match what the proposal computed, for every item including the
  -- 16 filled in above. A wrong fill dies here rather than being written.
  select string_agg(content_key, ', ') into v_bad from app.m1_staging
  where md5(full_text) <> full_text_md5 or length(full_text) <> full_text_len;
  if v_bad is not null then raise exception 'M1: full_text md5/length mismatch on %', v_bad; end if;

  -- every staged item is a published Biology FRQ
  select count(*) into v_n from app.m1_staging s
  where not exists (
    select 1 from app.content_item_versions civ
    join app.content_items ci on ci.id = civ.content_item_id
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    where civ.id = s.content_item_version_id and civ.status = 'published'
      and ep.exam_code = 'ap_biology' and ci.item_type = 'frq');
  if v_n <> 0 then raise exception 'M1: % staged items are not published Biology FRQ', v_n; end if;

  -- span offsets must tile full_text exactly, with no gap and no overlap
  select string_agg(content_key, ', ') into v_bad from (
    select s.content_key from app.m1_staging s,
      lateral (select coalesce(sum((e->>'len')::int),0) as tot,
                      min((e->>'off')::int) as min_off
               from jsonb_array_elements(s.spans) e) x
    where x.tot <> s.full_text_len or x.min_off <> 0
  ) y;
  if v_bad is not null then raise exception 'M1: span offsets do not tile full_text on %', v_bad; end if;

  -- THE ADDITIVE GUARANTEE. Where an item already has a canonical, the existing text must
  -- survive inside the new one. The three items where it would not (S-021, S-023, S-058) are
  -- deliberately not staged; if one reappears, stop.
  select string_agg(s.content_key, ', ') into v_bad
  from app.m1_staging s
  join app.content_item_versions civ on civ.id = s.content_item_version_id
  where coalesce(civ.canonical_answer_1, '') <> ''
    and position(civ.canonical_answer_1 in s.full_text) = 0;
  if v_bad is not null then
    raise exception 'M1: existing canonical_answer_1 would be DISCARDED on %; aborting', v_bad;
  end if;
end $$;

-- 2. M0's source_field vocabulary did not anticipate newly authored spans. Work order F emits
--    prior_canonical_answer_1/2 (mapped to canonical_answer_1/2 before staging, verified by the
--    md5 checks above) and authored_work_order_F, which has no equivalent. Add 'authored'.
alter table app.canonical_answer_spans
  drop constraint if exists canonical_answer_spans_source_field_check;
alter table app.canonical_answer_spans
  add constraint canonical_answer_spans_source_field_check
  check (source_field is null or source_field = any (array[
    'canonical_answer_1', 'canonical_answer_2',
    'parent_canonical_answer_1', 'parent_canonical_answer_2',
    'authored'
  ]));

-- 3. The assembled document becomes canonical_answer_1 (Product Owner direction 2026-09-24).
update app.content_item_versions civ
set canonical_answer_1 = s.full_text
from app.m1_staging s
where civ.id = s.content_item_version_id;

-- 4. The segmentation. span_text is SLICED from full_text by the staged offsets rather than
--    transmitted separately, so the two cannot disagree; step 5 proves the slicing.
insert into app.canonical_answer_spans (
  content_item_version_id, answer_field, span_ordinal, span_text,
  criterion_keys, provenance, source_version_id, source_field, source_offset, proposal_run
)
select s.content_item_version_id,
       'canonical_answer_1',
       (e->>'o')::int,
       substring(s.full_text from ((e->>'off')::int + 1) for (e->>'len')::int),
       coalesce((select array_agg(x::text) from jsonb_array_elements_text(e->'ck') x), '{}'::text[]),
       e->>'p',
       null,
       nullif(e->>'sf', ''),
       case when e->>'so' is null then null else (e->>'so')::int end,
       'work_order_F_2026_09_23'
from app.m1_staging s, lateral jsonb_array_elements(s.spans) e;

-- 5. Verification.
do $$
declare v_n integer; v_bad text;
begin
  select count(*) into v_n from app.canonical_answer_spans where proposal_run = 'work_order_F_2026_09_23';
  if v_n <> 548 then raise exception 'M1: expected 548 spans, got %', v_n; end if;

  select count(distinct content_item_version_id) into v_n
  from app.canonical_answer_spans where proposal_run = 'work_order_F_2026_09_23';
  if v_n <> 67 then raise exception 'M1: spans cover % items, expected 67', v_n; end if;

  -- THE M0 INVARIANT: spans ordered by ordinal concatenate back to the stored field exactly.
  select string_agg(k, ', ') into v_bad from (
    select s.content_key as k
    from app.m1_staging s
    join app.content_item_versions civ on civ.id = s.content_item_version_id
    where civ.canonical_answer_1 <> (
      select string_agg(sp.span_text, '' order by sp.span_ordinal)
      from app.canonical_answer_spans sp
      where sp.content_item_version_id = s.content_item_version_id
        and sp.answer_field = 'canonical_answer_1')
  ) z;
  if v_bad is not null then raise exception 'M1: spans do not reconstruct canonical_answer_1 on %', v_bad; end if;

  -- every stored criterion has at least one span tagged to it ALONE (the exclusivity invariant
  -- work order F reported as 0 failures of 261; recomputed here against Production's criteria)
  select count(*) into v_n from (
    select fc.content_item_version_id, fc.criterion_key
    from app.frq_criteria fc
    join app.m1_staging s on s.content_item_version_id = fc.content_item_version_id
    where not exists (
      select 1 from app.canonical_answer_spans sp
      where sp.content_item_version_id = fc.content_item_version_id
        and sp.criterion_keys = array[fc.criterion_key])
  ) w;
  if v_n <> 0 then raise exception 'M1: % criteria have no exclusive span', v_n; end if;

  -- no Biology FRQ outside the staged set had its canonical touched
  select count(*) into v_n from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_biology' and civ.status = 'published' and ci.item_type = 'frq'
    and coalesce(civ.canonical_answer_1,'') = ''
    and ci.content_key not in ('APBIO-FRQ-S-101','APBIO-HDG-2026-GRAPH-002','APBIO-HDG-2026-GRAPH-003',
                               'APBIO-HDG-2026-GRAPH-008','APBIO-HDG-2026-GRAPH-010');
  if v_n <> 0 then raise exception 'M1: % Biology FRQ unexpectedly left with a blank canonical', v_n; end if;
end $$;

drop table app.m1_staging;

commit;
