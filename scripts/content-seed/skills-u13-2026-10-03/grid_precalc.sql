-- AP Precalculus skill grid, 2026-10-03 (Product Owner: "Do it for units 1-3"; follows the AP Biology grid of TASK-0050 Phase A / DECISION-0088).
-- Source: AP Precalculus Course and Exam Description, Course Framework, Mathematical Practices (p. 14). 8 skills. Full cross-product of the 58 registered topics x 8 skills = 464 cells (the CED says any topic can pair with any skill). Reference data only.
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalculus-skill-grid-20261003'));
do $$ begin
 if (select count(*) from app.taxonomy_topics where taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972')<>58 then raise exception 'expected 58 topics'; end if;
 if exists (select 1 from app.taxonomy_skills where taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972') or exists (select 1 from app.taxonomy_cells where taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972' and skill_code is not null) then raise exception 'grid already present'; end if;
end $$;
insert into app.taxonomy_skills (taxonomy_source_version, skill_code, practice_number, label)
select '16383753-6775-430d-960a-544cd6ee0972'::uuid, v.c, v.p, v.l from (values ('1.A',1,$q$Solve equations and inequalities represented analytically, with and without technology.$q$),('1.B',1,$q$Express functions, equations, or expressions in analytically equivalent forms that are useful in a given mathematical or applied context.$q$),('1.C',1,$q$Construct new functions, using transformations, compositions, inverses, or regressions, that may be useful in modeling contexts, criteria, or data, with and without technology.$q$),('2.A',2,$q$Identify information from graphical, numerical, analytical, and verbal representations to answer a question or construct a model, with and without technology.$q$),('2.B',2,$q$Construct equivalent graphical, numerical, analytical, and verbal representations of functions that are useful in a given mathematical or applied context, with and without technology.$q$),('3.A',3,$q$Describe the characteristics of a function with varying levels of precision, depending on the function representation and available mathematical tools.$q$),('3.B',3,$q$Apply numerical results in a given mathematical or applied context.$q$),('3.C',3,$q$Support conclusions or choices with a logical rationale or appropriate data.$q$)) as v(c,p,l);
insert into app.taxonomy_cells (taxonomy_source_version, topic_code, skill_code)
select '16383753-6775-430d-960a-544cd6ee0972'::uuid, t.topic_code, s.skill_code from app.taxonomy_topics t cross join app.taxonomy_skills s where t.taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972' and s.taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972';
do $$ begin
 if (select count(*) from app.taxonomy_skills where taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972')<>8 then raise exception 'skill count'; end if;
 if (select count(*) from app.taxonomy_cells where taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972' and skill_code is not null)<>464 then raise exception 'cell count'; end if;
end $$;
commit;
select (select count(*) from app.taxonomy_skills where taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972') skills, (select count(*) from app.taxonomy_cells where taxonomy_source_version='16383753-6775-430d-960a-544cd6ee0972' and skill_code is not null) cells;
