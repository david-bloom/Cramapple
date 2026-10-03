-- AP Physics 1 skill grid, 2026-10-03 (Product Owner: "Do it for units 1-3"; follows the AP Biology grid of TASK-0050 Phase A / DECISION-0088).
-- Source: AP Physics 1 Course and Exam Description, Course Framework V.1, Science Practices (p. 10). 10 skills. Full cross-product of the 43 registered topics x 10 skills = 430 cells (the CED says any topic can pair with any skill). Reference data only.
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphysics1-skill-grid-20261003'));
do $$ begin
 if (select count(*) from app.taxonomy_topics where taxonomy_source_version='27111dec-ee07-48f1-86cf-1a5833dd2962')<>43 then raise exception 'expected 43 topics'; end if;
 if exists (select 1 from app.taxonomy_skills where taxonomy_source_version='27111dec-ee07-48f1-86cf-1a5833dd2962') or exists (select 1 from app.taxonomy_cells where taxonomy_source_version='27111dec-ee07-48f1-86cf-1a5833dd2962' and skill_code is not null) then raise exception 'grid already present'; end if;
end $$;
insert into app.taxonomy_skills (taxonomy_source_version, skill_code, practice_number, label)
select '27111dec-ee07-48f1-86cf-1a5833dd2962'::uuid, v.c, v.p, v.l from (values ('1.A',1,$q$Create diagrams, tables, charts, or schematics to represent physical situations.$q$),('1.B',1,$q$Create quantitative graphs with appropriate scales and units, including plotting data.$q$),('1.C',1,$q$Create qualitative sketches of graphs that represent features of a model or the behavior of a physical system.$q$),('2.A',2,$q$Derive a symbolic expression from known quantities by selecting and following a logical mathematical pathway.$q$),('2.B',2,$q$Calculate or estimate an unknown quantity with units from known quantities, by selecting and following a logical computational pathway.$q$),('2.C',2,$q$Compare physical quantities between two or more scenarios or at different times and locations in a single scenario.$q$),('2.D',2,$q$Predict new values or factors of change of physical quantities using functional dependence between variables.$q$),('3.A',3,$q$Create experimental procedures that are appropriate for a given scientific question.$q$),('3.B',3,$q$Apply an appropriate law, definition, theoretical relationship, or model to make a claim.$q$),('3.C',3,$q$Justify or support a claim using evidence from experimental data, physical representations, or physical principles or laws.$q$)) as v(c,p,l);
insert into app.taxonomy_cells (taxonomy_source_version, topic_code, skill_code)
select '27111dec-ee07-48f1-86cf-1a5833dd2962'::uuid, t.topic_code, s.skill_code from app.taxonomy_topics t cross join app.taxonomy_skills s where t.taxonomy_source_version='27111dec-ee07-48f1-86cf-1a5833dd2962' and s.taxonomy_source_version='27111dec-ee07-48f1-86cf-1a5833dd2962';
do $$ begin
 if (select count(*) from app.taxonomy_skills where taxonomy_source_version='27111dec-ee07-48f1-86cf-1a5833dd2962')<>10 then raise exception 'skill count'; end if;
 if (select count(*) from app.taxonomy_cells where taxonomy_source_version='27111dec-ee07-48f1-86cf-1a5833dd2962' and skill_code is not null)<>430 then raise exception 'cell count'; end if;
end $$;
commit;
select (select count(*) from app.taxonomy_skills where taxonomy_source_version='27111dec-ee07-48f1-86cf-1a5833dd2962') skills, (select count(*) from app.taxonomy_cells where taxonomy_source_version='27111dec-ee07-48f1-86cf-1a5833dd2962' and skill_code is not null) cells;
