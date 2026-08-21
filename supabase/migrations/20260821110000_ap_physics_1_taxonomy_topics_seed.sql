-- Seed the AP Physics 1 taxonomy topic map (43 topics across 8 units).
--
-- Source: Subject Packs/Physics 1/ap-physics-1-course-and-exam-description.pdf
-- "Course at a Glance", printed pp. 13-15 (PDF pp. 20-22), read directly from
-- the primary source. Unit titles already in app.taxonomy_units match.
--
-- Per-unit counts: U1 5, U2 9, U3 5, U4 4, U5 6, U6 6, U7 4, U8 4
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
  (1,'1.1','Scalars and Vectors in One Dimension'),
  (1,'1.2','Displacement, Velocity, and Acceleration'),
  (1,'1.3','Representing Motion'),
  (1,'1.4','Reference Frames and Relative Motion'),
  (1,'1.5','Vectors and Motion in Two Dimensions'),
  (2,'2.1','Systems and Center of Mass'),
  (2,'2.2','Forces and Free-Body Diagrams'),
  (2,'2.3','Newton''s Third Law'),
  (2,'2.4','Newton''s First Law'),
  (2,'2.5','Newton''s Second Law'),
  (2,'2.6','Gravitational Force'),
  (2,'2.7','Kinetic and Static Friction'),
  (2,'2.8','Spring Forces'),
  (2,'2.9','Circular Motion'),
  (3,'3.1','Translational Kinetic Energy'),
  (3,'3.2','Work'),
  (3,'3.3','Potential Energy'),
  (3,'3.4','Conservation of Energy'),
  (3,'3.5','Power'),
  (4,'4.1','Linear Momentum'),
  (4,'4.2','Change in Momentum and Impulse'),
  (4,'4.3','Conservation of Linear Momentum'),
  (4,'4.4','Elastic and Inelastic Collisions'),
  (5,'5.1','Rotational Kinematics'),
  (5,'5.2','Connecting Linear and Rotational Motion'),
  (5,'5.3','Torque'),
  (5,'5.4','Rotational Inertia'),
  (5,'5.5','Rotational Equilibrium and Newton''s First Law in Rotational Form'),
  (5,'5.6','Newton''s Second Law in Rotational Form'),
  (6,'6.1','Rotational Kinetic Energy'),
  (6,'6.2','Torque and Work'),
  (6,'6.3','Angular Momentum and Angular Impulse'),
  (6,'6.4','Conservation of Angular Momentum'),
  (6,'6.5','Rolling'),
  (6,'6.6','Motion of Orbiting Satellites'),
  (7,'7.1','Defining Simple Harmonic Motion (SHM)'),
  (7,'7.2','Frequency and Period of SHM'),
  (7,'7.3','Representing and Analyzing SHM'),
  (7,'7.4','Energy of Simple Harmonic Oscillators'),
  (8,'8.1','Internal Structure and Density'),
  (8,'8.2','Pressure'),
  (8,'8.3','Fluids and Newton''s Laws'),
  (8,'8.4','Fluids and Conservation Laws')
) as v(unit_number, topic_code, topic_title)
  on v.unit_number = tu.unit_number
where tsv.subject_key = 'ap_physics_1' and tsv.taxonomy_confidence = 'verified'
on conflict (taxonomy_source_version, topic_code) do nothing;

do $$
declare n integer;
begin
  select count(*) into n from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv on tsv.taxonomy_source_version = tt.taxonomy_source_version
   where tsv.subject_key = 'ap_physics_1';
  if n <> 43 then raise exception 'AP Physics 1 taxonomy topics: expected 43, found %', n; end if;
end $$;
