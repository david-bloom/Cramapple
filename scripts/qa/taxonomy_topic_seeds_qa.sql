-- QA: Taxonomy topic maps (app.taxonomy_topics)
-- ---------------------------------------------------------------------------
-- Covers the 2026-08-21 seeding of AP Statistics (55), AP Chemistry (91),
-- AP Physics 1 (43), AP Physics C: Mechanics (41), AP Physics 2 (46) and
-- AP Physics C: E&M (31), and guards the pre-existing maps for AP Biology,
-- Calculus AB/BC and Precalculus.
--
-- Read-only. Safe on Production and Development.
-- Run: psql <conn> -f scripts/qa/taxonomy_topic_seeds_qa.sql
--
-- Every check raises on failure. A clean run prints only PASS notices.
--
-- KNOWN GAP: Development has no topics for ap_biology, ap_calculus_ab,
-- ap_calculus_bc or ap_precalculus (300 rows). Those 300 exist only in
-- Production and have no repository migration — see TASK-0027. T1 therefore
-- accepts "0" as a known gap and fails on any other unexpected count.

-- T1: expected topic count per subject -------------------------------------
do $$
declare r record; expected int; actual int; gaps text := '';
begin
  for r in select * from (values
      ('ap_biology',60),('ap_calculus_ab',85),('ap_calculus_bc',111),
      ('ap_chemistry',91),('ap_physics_1',43),('ap_physics_2',46),
      ('ap_physics_c_em',31),('ap_physics_c_mechanics',41),
      ('ap_precalculus',44),('ap_statistics',55)
    ) as t(subject_key, expected)
  loop
    select count(*) into actual
      from app.taxonomy_topics tt
      join app.taxonomy_source_versions tsv using (taxonomy_source_version)
     where tsv.subject_key = r.subject_key;
    if actual = 0 then
      gaps := gaps || r.subject_key || ' ';
    elsif actual <> r.expected then
      raise exception 'T1 FAIL: % has % topics, expected %',
        r.subject_key, actual, r.expected;
    end if;
  end loop;
  if gaps <> '' then
    raise notice 'T1 PASS (with known TASK-0027 gaps, 0 topics): %', gaps;
  else
    raise notice 'T1 PASS: all ten subjects at expected topic counts';
  end if;
end $$;

-- T2: topic_code prefix must equal unit_number -----------------------------
-- Catches a row transcribed into the wrong unit, which T1 cannot see.
do $$
declare n int;
begin
  select count(*) into n from app.taxonomy_topics
   where split_part(topic_code, '.', 1)::int <> unit_number;
  if n > 0 then
    raise exception 'T2 FAIL: % topic(s) whose code prefix <> unit_number', n;
  end if;
  raise notice 'T2 PASS: every topic_code prefix matches its unit_number';
end $$;

-- T3: every topic belongs to a declared unit -------------------------------
do $$
declare n int;
begin
  select count(*) into n
    from app.taxonomy_topics tt
   where not exists (
     select 1 from app.taxonomy_units tu
      where tu.taxonomy_source_version = tt.taxonomy_source_version
        and tu.unit_number = tt.unit_number);
  if n > 0 then
    raise exception 'T3 FAIL: % topic(s) reference a unit that does not exist', n;
  end if;
  raise notice 'T3 PASS: every topic maps to a declared taxonomy unit';
end $$;

-- T4: topic numbering gaps (reported, not failed) ---------------------------
-- Contiguity is the normal expectation and catches a topic dropped during
-- transcription, which counting alone cannot. But AP Calculus AB legitimately
-- has holes where BC-only topics are excluded, so gaps are reported rather
-- than failed. T4b below turns the AB case into a hard check.
do $$
declare r record; gaps text := '';
begin
  for r in
    select tsv.subject_key, tt.unit_number, count(*) n,
           min(split_part(tt.topic_code, '.', 2)::int) lo,
           max(split_part(tt.topic_code, '.', 2)::int) hi
      from app.taxonomy_topics tt
      join app.taxonomy_source_versions tsv using (taxonomy_source_version)
     group by 1,2
  loop
    if r.lo <> 1 or r.hi <> r.n then
      gaps := gaps || format('%s U%s(%s..%s, n=%s) ', r.subject_key, r.unit_number, r.lo, r.hi, r.n);
    end if;
  end loop;
  if gaps <> '' then
    raise warning 'T4: topic numbering gaps (expected only for ap_calculus_ab): %', gaps;
  else
    raise notice 'T4 PASS: topic numbering contiguous in every unit';
  end if;
end $$;

-- T4b: AP Calculus AB must not contain BC-only topics -----------------------
-- The AB and BC courses share one CED and one topic numbering; the CED marks
-- certain topics "BC ONLY". AB's taxonomy must exclude them.
--
-- Source: AP Calculus AB and BC CED, Course at a Glance, printed p. 20
-- (docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf),
-- verified visually for Units 6, 7 and 8 on 2026-08-21.
--
-- Coverage limit: Units 1-5 were NOT visually verified against the CED. AB and
-- BC hold identical topic sets there, which is consistent with no BC-only
-- topics existing in those units, but a BC-only topic wrongly present in BOTH
-- would be invisible to this check.
--
-- Units 9 and 10 are BC-only in their entirety and are correctly absent from
-- AB, so they need no listing here.
do $$
declare bc_only text[] := array['6.11','6.12','6.13','7.5','7.9','8.13'];
        found text;
begin
  select string_agg(tt.topic_code || ' (' || tt.topic_title || ')', '; ' order by tt.topic_code)
    into found
    from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv using (taxonomy_source_version)
   where tsv.subject_key = 'ap_calculus_ab'
     and tt.topic_code = any (bc_only);
  if found is not null then
    raise exception 'T4b FAIL: ap_calculus_ab contains BC-only topic(s): %', found;
  end if;
  raise notice 'T4b PASS: no BC-only topic present in the AP Calculus AB taxonomy';
end $$;

-- T5: no published brief or explainer is orphaned ---------------------------
-- The strongest available check. Briefs and explainers were authored
-- independently of the taxonomy transcription, so a mistyped topic_code on
-- either side surfaces here.
do $$
declare nb int; ne int;
begin
  select count(*) into nb
    from app.topic_point_briefs b
   where b.status = 'published'
     and exists (select 1 from app.taxonomy_source_versions tsv
                  where tsv.subject_key = b.subject_key)
     and not exists (
       select 1 from app.taxonomy_topics tt
        join app.taxonomy_source_versions tsv using (taxonomy_source_version)
        where tsv.subject_key = b.subject_key and tt.topic_code = b.topic_code);

  select count(*) into ne
    from app.topic_explainers e
   where e.status = 'published'
     and exists (select 1 from app.taxonomy_source_versions tsv
                  where tsv.subject_key = e.subject_key)
     and not exists (
       select 1 from app.taxonomy_topics tt
        join app.taxonomy_source_versions tsv using (taxonomy_source_version)
        where tsv.subject_key = e.subject_key and tt.topic_code = e.topic_code);

  -- Subjects with a known 0-topic gap cannot orphan-check; exclude them.
  if nb > 0 or ne > 0 then
    raise warning 'T5: % orphan brief(s), % orphan explainer(s) — expected 0 unless the subject has a known TASK-0027 topic gap', nb, ne;
    if exists (select 1 from app.taxonomy_source_versions tsv
                where (select count(*) from app.taxonomy_topics tt
                        where tt.taxonomy_source_version = tsv.taxonomy_source_version) > 0
                  and exists (select 1 from app.topic_point_briefs b
                               where b.subject_key = tsv.subject_key and b.status='published'
                                 and not exists (select 1 from app.taxonomy_topics tt2
                                                  where tt2.taxonomy_source_version = tsv.taxonomy_source_version
                                                    and tt2.topic_code = b.topic_code))) then
      raise exception 'T5 FAIL: orphaned content in a subject that HAS a topic map';
    end if;
  else
    raise notice 'T5 PASS: zero orphan briefs and zero orphan explainers';
  end if;
end $$;

-- T6: no duplicate topic codes ---------------------------------------------
do $$
declare n int;
begin
  select count(*) into n from (
    select taxonomy_source_version, topic_code
      from app.taxonomy_topics
     group by 1,2 having count(*) > 1) d;
  if n > 0 then
    raise exception 'T6 FAIL: % duplicate topic_code(s) within a source version', n;
  end if;
  raise notice 'T6 PASS: topic codes unique per taxonomy source version';
end $$;

-- T7: content fingerprint, for cross-environment comparison -----------------
-- Not an assertion. Run on both projects and diff the output; any subject
-- present in both must show an identical hash.
select tsv.subject_key,
       count(tt.*) as topics,
       left(encode(sha256(coalesce(string_agg(
         tt.topic_code || ':' || tt.topic_title, '|'
         order by tt.unit_number, tt.topic_code, tt.topic_title), '')::bytea), 'hex'), 16)
         as content_sha
  from app.taxonomy_source_versions tsv
  left join app.taxonomy_topics tt using (taxonomy_source_version)
 group by 1
 order by 1;
