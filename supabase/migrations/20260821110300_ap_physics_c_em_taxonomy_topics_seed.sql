-- Seed the AP Physics C: Electricity and Magnetism taxonomy topic map (31 topics across 6 units).
--
-- Source: Subject Packs/Physics C (EM)/ap-physics-c-electricity-and-magnetism-course-and-exam-description.pdf
-- "Course at a Glance", printed pp. 13-15 (PDF pp. 20-22), read directly from
-- the primary source. Unit titles already in app.taxonomy_units match.
--
-- Per-unit counts: U8 6, U9 3, U10 4, U11 8, U12 4, U13 6
--
-- Structural transcription of a published unit/topic map. Not authored
-- teaching content. Idempotent, and asserts its own final count.
--
-- Cross-check: after seeding, every published topic_point_brief and
-- topic_explainer for this subject matches a taxonomy topic_code (0 orphans).

insert into app.taxonomy_topics (taxonomy_source_version, unit_number, unit_title, topic_code, topic_title)
select tsv.taxonomy_source_version, v.unit_number, tu.unit_title, v.topic_code, v.topic_title
from app.taxonomy_source_versions tsv
join app.taxonomy_units tu on tu.taxonomy_source_version = tsv.taxonomy_source_version
join (values
  (8,'8.1','Electric Charge and Electric Force'),
  (8,'8.2','Conservation of Electric Charge and the Process of Charging'),
  (8,'8.3','Electric Fields'),
  (8,'8.4','Electric Fields of Charge Distributions'),
  (8,'8.5','Electric Flux'),
  (8,'8.6','Gauss''s Law'),
  (9,'9.1','Electric Potential Energy'),
  (9,'9.2','Electric Potential'),
  (9,'9.3','Conservation of Electric Energy'),
  (10,'10.1','Electrostatics with Conductors'),
  (10,'10.2','Redistribution of Charge between Conductors'),
  (10,'10.3','Capacitors'),
  (10,'10.4','Dielectrics'),
  (11,'11.1','Electric Current'),
  (11,'11.2','Simple Circuits'),
  (11,'11.3','Resistance, Resistivity, and Ohm''s Law'),
  (11,'11.4','Electric Power'),
  (11,'11.5','Compound Direct Current Circuits'),
  (11,'11.6','Kirchhoff''s Loop Rule'),
  (11,'11.7','Kirchhoff''s Junction Rule'),
  (11,'11.8','Resistor Capacitor (RC) Circuits'),
  (12,'12.1','Magnetic Fields'),
  (12,'12.2','Magnetism and Moving Charges'),
  (12,'12.3','Magnetic Fields of Current-Carrying Wires and the Biot-Savart Law'),
  (12,'12.4','Ampère''s Law'),
  (13,'13.1','Magnetic Flux'),
  (13,'13.2','Electromagnetic Induction'),
  (13,'13.3','Induced Currents and Magnetic Forces'),
  (13,'13.4','Inductance'),
  (13,'13.5','Circuits with Resistors and Inductors (LR Circuits)'),
  (13,'13.6','Circuits with Capacitors and Inductors (LC Circuits)')
) as v(unit_number, topic_code, topic_title)
  on v.unit_number = tu.unit_number
where tsv.subject_key = 'ap_physics_c_em' and tsv.taxonomy_confidence = 'verified'
on conflict (taxonomy_source_version, topic_code) do nothing;

do $$
declare n integer;
begin
  select count(*) into n from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv on tsv.taxonomy_source_version = tt.taxonomy_source_version
   where tsv.subject_key = 'ap_physics_c_em';
  if n <> 31 then raise exception 'AP Physics C E&M taxonomy topics: expected 31, found %', n; end if;
end $$;
