-- Seed the AP Physics 2 taxonomy topic map (46 topics across 7 units).
--
-- Source: Subject Packs/Physics 2/ap-physics-2-course-and-exam-description.pdf
-- "Course at a Glance", printed pp. 13-15 (PDF pp. 20-22), read directly from
-- the primary source. Unit titles already in app.taxonomy_units match.
--
-- Per-unit counts: U9 6, U10 7, U11 8, U12 4, U13 4, U14 9, U15 8
--
-- Structural transcription of a published unit/topic map. Not authored
-- teaching content. Idempotent, and asserts its own final count.
--
-- Cross-check: after seeding, every published topic_point_brief and
-- topic_explainer for this subject matches a taxonomy topic_code (0 orphans).
--
-- Note: AP Physics 2 units are numbered 9-15 by the College Board itself,
-- continuing from AP Physics 1's units 1-8. This is CED numbering, not a
-- Cramapple renumbering. AP Physics C: E&M is likewise numbered 8-13.

insert into app.taxonomy_topics (taxonomy_source_version, unit_number, unit_title, topic_code, topic_title)
select tsv.taxonomy_source_version, v.unit_number, tu.unit_title, v.topic_code, v.topic_title
from app.taxonomy_source_versions tsv
join app.taxonomy_units tu on tu.taxonomy_source_version = tsv.taxonomy_source_version
join (values
  (9,'9.1','Kinetic Theory of Temperature and Pressure'),
  (9,'9.2','The Ideal Gas Law'),
  (9,'9.3','Thermal Energy Transfer and Equilibrium'),
  (9,'9.4','The First Law of Thermodynamics'),
  (9,'9.5','Specific Heat and Thermal Conductivity'),
  (9,'9.6','Entropy and the Second Law of Thermodynamics'),
  (10,'10.1','Electric Charge and Electric Force'),
  (10,'10.2','Conservation of Electric Charge and the Process of Charging'),
  (10,'10.3','Electric Fields'),
  (10,'10.4','Electric Potential Energy'),
  (10,'10.5','Electric Potential'),
  (10,'10.6','Capacitors'),
  (10,'10.7','Conservation of Electric Energy'),
  (11,'11.1','Electric Current'),
  (11,'11.2','Simple Circuits'),
  (11,'11.3','Resistance, Resistivity, and Ohm''s Law'),
  (11,'11.4','Electric Power'),
  (11,'11.5','Compound Direct Current (DC) Circuits'),
  (11,'11.6','Kirchhoff''s Loop Rule'),
  (11,'11.7','Kirchhoff''s Junction Rule'),
  (11,'11.8','Resistor-Capacitor (RC) Circuits'),
  (12,'12.1','Magnetic Fields'),
  (12,'12.2','Magnetism and Moving Charges'),
  (12,'12.3','Magnetism and Current-Carrying Wires'),
  (12,'12.4','Electromagnetic Induction and Faraday''s Law'),
  (13,'13.1','Reflection'),
  (13,'13.2','Images Formed by Mirrors'),
  (13,'13.3','Refraction'),
  (13,'13.4','Images Formed by Lenses'),
  (14,'14.1','Properties of Wave Pulses and Waves'),
  (14,'14.2','Periodic Waves'),
  (14,'14.3','Boundary Behavior of Waves and Polarization'),
  (14,'14.4','Electromagnetic Waves'),
  (14,'14.5','The Doppler Effect'),
  (14,'14.6','Wave Interference and Standing Waves'),
  (14,'14.7','Diffraction'),
  (14,'14.8','Double-Slit Interference and Diffraction Gratings'),
  (14,'14.9','Thin-Film Interference'),
  (15,'15.1','Quantum Theory and Wave-Particle Duality'),
  (15,'15.2','The Bohr Model of Atomic Structure'),
  (15,'15.3','Emission and Absorption Spectra'),
  (15,'15.4','Blackbody Radiation'),
  (15,'15.5','The Photoelectric Effect'),
  (15,'15.6','Compton Scattering'),
  (15,'15.7','Fission, Fusion, and Nuclear Decay'),
  (15,'15.8','Types of Radioactive Decay')
) as v(unit_number, topic_code, topic_title)
  on v.unit_number = tu.unit_number
where tsv.subject_key = 'ap_physics_2' and tsv.taxonomy_confidence = 'verified'
on conflict (taxonomy_source_version, topic_code) do nothing;

do $$
declare n integer;
begin
  select count(*) into n from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv on tsv.taxonomy_source_version = tt.taxonomy_source_version
   where tsv.subject_key = 'ap_physics_2';
  if n <> 46 then raise exception 'AP Physics 2 taxonomy topics: expected 46, found %', n; end if;
end $$;
