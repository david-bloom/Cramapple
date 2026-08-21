-- Seed the AP Chemistry taxonomy topic map (91 topics across 9 units).
--
-- Source: docs/product/AP_CHEMISTRY_CED_FACT_PACK.md "Topic map" section,
-- itself transcribed and primary-source verified from the AP Chemistry Course
-- and Exam Description (Subject Packs/Chemistry/, docs/teaching/). Unit titles
-- already present in app.taxonomy_units match the fact pack exactly.
--
-- Per-unit counts: {1: 8, 2: 7, 3: 13, 4: 9, 5: 11, 6: 9, 7: 12, 8: 11, 9: 11}
--
-- Note (from the fact pack): Unit 9 runs through Topic 9.11, not the older
-- 9.7-9.10 numbering. Unit 7's CED title is "Equilibrium", aliased in the
-- course framework header as "Principles of Equilibrium", which is the form
-- app.taxonomy_units already uses.
--
-- Structural transcription of a published unit/topic map. Not authored
-- teaching content. Idempotent.

insert into app.taxonomy_topics (taxonomy_source_version, unit_number, unit_title, topic_code, topic_title)
select tsv.taxonomy_source_version, v.unit_number, tu.unit_title, v.topic_code, v.topic_title
from app.taxonomy_source_versions tsv
join app.taxonomy_units tu
  on tu.taxonomy_source_version = tsv.taxonomy_source_version
join (values
  (1,'1.1','Moles and Molar Mass'),
  (1,'1.2','Mass Spectra of Elements'),
  (1,'1.3','Elemental Composition of Pure Substances'),
  (1,'1.4','Composition of Mixtures'),
  (1,'1.5','Atomic Structure and Electron Configuration'),
  (1,'1.6','Photoelectron Spectroscopy'),
  (1,'1.7','Periodic Trends'),
  (1,'1.8','Valence Electrons and Ionic Compounds'),
  (2,'2.1','Types of Chemical Bonds'),
  (2,'2.2','Intramolecular Force and Potential Energy'),
  (2,'2.3','Structure of Ionic Solids'),
  (2,'2.4','Structure of Metals and Alloys'),
  (2,'2.5','Lewis Diagrams'),
  (2,'2.6','Resonance and Formal Charge'),
  (2,'2.7','VSEPR and Hybridization'),
  (3,'3.1','Intermolecular and Interparticle Forces'),
  (3,'3.2','Properties of Solids'),
  (3,'3.3','Solids, Liquids, and Gases'),
  (3,'3.4','Ideal Gas Law'),
  (3,'3.5','Kinetic Molecular Theory'),
  (3,'3.6','Deviation from Ideal Gas Law'),
  (3,'3.7','Solutions and Mixtures'),
  (3,'3.8','Representations of Solutions'),
  (3,'3.9','Separation of Solutions and Mixtures'),
  (3,'3.10','Solubility'),
  (3,'3.11','Spectroscopy and the Electromagnetic Spectrum'),
  (3,'3.12','Properties of Photons'),
  (3,'3.13','Beer-Lambert Law'),
  (4,'4.1','Introduction for Reactions'),
  (4,'4.2','Net Ionic Equations'),
  (4,'4.3','Representations of Reactions'),
  (4,'4.4','Physical and Chemical Changes'),
  (4,'4.5','Stoichiometry'),
  (4,'4.6','Introduction to Titration'),
  (4,'4.7','Types of Chemical Reactions'),
  (4,'4.8','Introduction to Acid-Base Reactions'),
  (4,'4.9','Oxidation-Reduction Reactions'),
  (5,'5.1','Reaction Rates'),
  (5,'5.2','Introduction to Rate Law'),
  (5,'5.3','Concentration Changes over Time'),
  (5,'5.4','Elementary Reactions'),
  (5,'5.5','Collision Model'),
  (5,'5.6','Reaction Energy Profile'),
  (5,'5.7','Introduction to Reaction Mechanisms'),
  (5,'5.8','Reaction Mechanism and Rate Law'),
  (5,'5.9','Pre-Equilibrium Approximation'),
  (5,'5.10','Multistep Reaction Energy Profile'),
  (5,'5.11','Catalysis'),
  (6,'6.1','Endothermic and Exothermic Processes'),
  (6,'6.2','Energy Diagrams'),
  (6,'6.3','Heat Transfer and Thermal Equilibrium'),
  (6,'6.4','Heat Capacity and Calorimetry'),
  (6,'6.5','Energy of Phase Changes'),
  (6,'6.6','Introduction to Enthalpy of Reaction'),
  (6,'6.7','Bond Enthalpies'),
  (6,'6.8','Enthalpy of Formation'),
  (6,'6.9','Hess''s Law'),
  (7,'7.1','Introduction to Equilibrium'),
  (7,'7.2','Direction of Reversible Reactions'),
  (7,'7.3','Reaction Quotient and Equilibrium Constant'),
  (7,'7.4','Calculating the Equilibrium Constant'),
  (7,'7.5','Magnitude of the Equilibrium Constant'),
  (7,'7.6','Properties of the Equilibrium Constant'),
  (7,'7.7','Calculating Equilibrium Concentrations'),
  (7,'7.8','Representations of Equilibrium'),
  (7,'7.9','Introduction to Le Chatelier''s Principle'),
  (7,'7.10','Reaction Quotient and Le Chatelier''s Principle'),
  (7,'7.11','Introduction to Solubility Equilibria'),
  (7,'7.12','Common-Ion Effect'),
  (8,'8.1','Introduction to Acids and Bases'),
  (8,'8.2','pH and pOH of Strong Acids and Bases'),
  (8,'8.3','Weak Acid and Base Equilibria'),
  (8,'8.4','Acid-Base Reactions and Buffers'),
  (8,'8.5','Acid-Base Titrations'),
  (8,'8.6','Molecular Structure of Acids and Bases'),
  (8,'8.7','pH and pKa'),
  (8,'8.8','Properties of Buffers'),
  (8,'8.9','Henderson-Hasselbalch Equation'),
  (8,'8.10','Buffer Capacity'),
  (8,'8.11','pH and Solubility'),
  (9,'9.1','Introduction to Entropy'),
  (9,'9.2','Absolute Entropy and Entropy Change'),
  (9,'9.3','Gibbs Free Energy and Thermodynamic Favorability'),
  (9,'9.4','Thermodynamic and Kinetic Control'),
  (9,'9.5','Free Energy and Equilibrium'),
  (9,'9.6','Free Energy of Dissolution'),
  (9,'9.7','Coupled Reactions'),
  (9,'9.8','Galvanic and Electrolytic Cells'),
  (9,'9.9','Cell Potential and Free Energy'),
  (9,'9.10','Cell Potential under Nonstandard Conditions'),
  (9,'9.11','Electrolysis and Faraday''s Law')
) as v(unit_number, topic_code, topic_title)
  on v.unit_number = tu.unit_number
where tsv.subject_key = 'ap_chemistry'
  and tsv.taxonomy_confidence = 'verified'
on conflict (taxonomy_source_version, topic_code) do nothing;

do $$
declare n integer;
begin
  select count(*) into n
    from app.taxonomy_topics tt
    join app.taxonomy_source_versions tsv
      on tsv.taxonomy_source_version = tt.taxonomy_source_version
   where tsv.subject_key = 'ap_chemistry';
  if n <> 91 then
    raise exception 'AP Chemistry taxonomy topics: expected 91, found %', n;
  end if;
end $$;
