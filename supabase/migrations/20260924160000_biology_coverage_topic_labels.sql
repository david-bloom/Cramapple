-- M2 of the AP Biology completion plan (docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md).
-- D2, resolved 2026-09-24 as DECISION-0062: Biology's coverage (topic) labels land as
-- `provisional_model`, not `validated`. The six items QA flagged are written as `held`.
--
-- ---------------------------------------------------------------------------
-- What this writes, and what it deliberately does not
--
-- Coverage labels only -- `assessed_topics`. THIS MIGRATION MODIFIES NO SERVING LABEL.
-- The two are different fields answering different questions (TAXONOMY_LABELING_PLAN_V3 §7a / T9):
-- a serving label says what a student must have covered to ANSWER an item; a coverage label says
-- what the item COUNTS TOWARD. The live serving selector reads `max_required_unit`
-- (20260923150000_exclude_hand_drawn_from_text_serving.sql:169); it does not read
-- `assessed_topics`. The original D2 framing -- "the September labels supersede the August ones" --
-- was wrong: nothing is superseded, because these are the first topic-level labels Biology has ever
-- had. Across all 484 Biology label rows, zero carried a topic before this migration.
--
-- ---------------------------------------------------------------------------
-- Why `provisional_model` and not `validated`
--
-- T9/T6.b requires full human validation for ANY coverage label, on a measurement: two models
-- agreed on unit sets 16/18 (89%) but on exact topic lists only 8/18 (44%). DECISION-0055 paused
-- the human independent-review requirement for content, scope "all content types and all subjects",
-- but names §11.1 R0-R3 and DECISION-0044 specifically and does NOT name T9/T6.b. Whether the pause
-- reaches this rule is genuinely ambiguous.
--
-- DECISION-0062 does not resolve that ambiguity. It routes around it: the labels land in a status
-- that claims nothing. Three facts make that safe rather than a fudge.
--
--   1. NOTHING READS COVERAGE LABELS. Verified by grep across supabase/, web/, scripts/, schemas/:
--      `assessed_topics` appears only in DDL -- the column, a check constraint, a GIN index, a view
--      column list and a comment. No selector, no RPC, no edge function. A wrong topic label here
--      cannot mis-serve a student; it can only miscount a coverage report that is not yet computed.
--   2. THE SCHEMA CANNOT BE LIED TO. `content_taxonomy_labels_validation_check` makes
--      label_status='validated' impossible unless validated_by, validated_at, validation_decision_id,
--      validated_against_version_id and validated_against_taxo_hash are ALL present. This migration
--      leaves all five null, so `validated` is not merely unclaimed -- it is unreachable from here.
--   3. THE COVERAGE INDEX ONLY INDEXES `validated` ROWS
--      (content_taxonomy_labels_coverage_validated_idx). Provisional rows are invisible to the query
--      shape any coverage computation would use. T8's coverage recompute therefore still blocks on
--      the human-validation question -- which is where that question belongs, and it is no longer
--      blocking the storage of the data.
--
-- The builder's own confidence is the reason this matters: of 118 Biology rows, Codex rated ZERO
-- high confidence (68 low, 50 medium) and marked 69 needs_human. Those judgements are preserved
-- per row in source_payload rather than discarded, so promotion to `validated` later is a review of
-- recorded claims, not a re-derivation.
--
-- ---------------------------------------------------------------------------
-- The six held items (label_status='held', assessed_topics empty)
--
-- Held, not omitted, so that absence is legible: a missing row would be indistinguishable from
-- "never processed". Each carries its QA finding id and reason in source_payload.
--
--   TL-057  APBIO-HDG-2026-GRAPH-002  proposed 3.2  uninformative stem
--   TL-058  APBIO-HDG-2026-GRAPH-003  proposed 7.1  uninformative stem
--   TL-059  APBIO-HDG-2026-GRAPH-008  proposed 8.2  uninformative stem
--   TL-060  APBIO-HDG-2026-GRAPH-010  proposed 8.3  uninformative stem
--   TL-061  APBIO-FRQ-L-008           proposed 1.1  osmosis/water potential -> should be 2.7
--   TL-062  APBIO-FRQ-S-071           proposed 1.1  osmosis/water potential -> should be 2.7
--
-- The four HDG items are hand-drawn graph-construction prompts whose stem is a boilerplate
-- photo-submission instruction carrying no topic signal; their labels were derived from a stem that
-- could not have supported them. Re-deriving from the rubric or stimulus is work order material.
--
-- The two osmosis items have a known answer -- QA gave 2.7 Tonicity and Osmoregulation -- recorded
-- in source_payload as `suggested_topic_code`. They are held rather than corrected because the
-- Product Owner's instruction was to hold all six; landing them at 2.7 is a one-line update whenever
-- that is wanted.
--
-- ---------------------------------------------------------------------------
-- Self-verifying. Every assertion below aborts the transaction rather than applying partially.
-- In particular it aborts if reality disagrees with the QA inventory -- e.g. if any Biology item
-- turns out to already carry a coverage label with topics in it.
--
-- ---------------------------------------------------------------------------
-- REHEARSED, 2026-09-24. Dev cannot rehearse this -- it holds 1 Biology item against Production's
-- 118 -- so the rehearsal was run against a local Postgres 17 replica built from the REAL DDL of
-- app.taxonomy_source_versions, app.taxonomy_topics and app.content_taxonomy_labels (including the
-- derive trigger and all 16 constraints), seeded with all 118 Biology content_item_ids, a 60-topic
-- closed list, 118 serving labels, and 90 pre-existing EMPTY coverage shells spread across two
-- label_version histories.
--
--   Applied clean: INSERT 118, UPDATE 60.
--   112 provisional_model rows each carrying exactly one topic; 6 held rows carrying none.
--   label_version resolved per item, not assumed: 58 items -> v1 (no prior coverage row),
--     30 -> v2, 30 -> v3. Total 118.
--   Exactly one current coverage label per item afterwards; 0 items with more than one.
--   All 118 serving rows unchanged and still current; the fingerprint check passed.
--   0 rows written as validated. primary_unit null on all 118.
--
-- Both guards were then negative-tested on a second copy:
--   an invented topic code (9.9) -> 'M2: 4 staged topic codes are not in the Biology closed list'
--   a pre-existing coverage label carrying topics ->
--     'M2: 1 existing current coverage labels already carry topics; aborting rather than superseding them'
-- In both cases the transaction rolled back and 0 rows landed.
--
-- NOT YET APPLIED TO PRODUCTION.

begin;

-- Pinned from the QA-verified inventory, then checked rather than trusted.
create temporary table m2_ctx on commit drop as
select 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid as taxonomy_source_version;

create temporary table m2_staging (
  content_item_id uuid not null,
  topic_code text not null,
  unit_number integer not null,
  disposition text not null check (disposition in ('provisional_model', 'held')),
  model_confidence text,
  needs_human boolean not null,
  alt_topic_code text,
  rationale text,
  hold_reason text,
  qa_finding_id text,
  suggested_topic_code text
) on commit drop;

insert into m2_staging (
  content_item_id, topic_code, unit_number, disposition, model_confidence,
  needs_human, alt_topic_code, rationale, hold_reason, qa_finding_id, suggested_topic_code
) values
  ('b8c56de7-c28f-4eb2-86d4-96d9a9186400', '5.3', 5, 'provisional_model', 'low', true, '5.4', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Mendelian Genetics".', null, null, null),
  ('905df3c1-d797-456c-8caf-cfdb3721b29e', '6.2', 6, 'provisional_model', 'medium', false, '6.1', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "DNA Replication".', null, null, null),
  ('786c5b62-f352-4077-91bf-b2a788c152c0', '7.5', 7, 'provisional_model', 'medium', false, '7.1', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Hardy-Weinberg Equilibrium".', null, null, null),
  ('5dca442d-b798-4ce8-9b1a-03ccfaf7aecc', '1.1', 1, 'held', 'low', true, '2.5', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', 'topic_misassigned: Osmosis / water-potential investigation assigned to 1.1 Structure of Water and Hydrogen Bonding.', 'TL-061', '2.7'),
  ('a1101c5f-7dfa-4899-b766-c8bdf3d1e366', '3.2', 3, 'provisional_model', 'medium', false, '1.1', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Environmental Impacts on Enzyme Function".', null, null, null),
  ('ccf9a896-ab8f-48b6-9f19-10c043ab14af', '2.1', 2, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('beb10310-b7f6-45fe-922c-b2586ac07677', '2.1', 2, 'provisional_model', 'low', true, '3.5', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('4a84a371-50b8-47a1-8089-16ead0b41331', '3.5', 3, 'provisional_model', 'medium', false, '3.3', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cellular Respiration".', null, null, null),
  ('3f243cab-1291-4bac-8b7a-17ca56aad92c', '3.5', 3, 'provisional_model', 'medium', false, '3.3', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cellular Respiration".', null, null, null),
  ('f420df2b-d478-4795-b646-0f4a13a04b59', '4.3', 4, 'provisional_model', 'medium', false, '4.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Signal Transduction Pathways".', null, null, null),
  ('65bd0d29-e854-416e-bd1c-3b5c966de99c', '5.4', 5, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Non-Mendelian Genetics".', null, null, null),
  ('0880b181-fd70-4b8e-8659-48aeac65fff0', '6.5', 6, 'provisional_model', 'medium', false, '6.6', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Regulation of Gene Expression".', null, null, null),
  ('6ee01c8f-000f-402c-b224-ada511355345', '5.2', 5, 'provisional_model', 'low', true, '7.1', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Meiosis and Genetic Diversity".', null, null, null),
  ('490a27e7-d446-4ee0-bb76-fda55d29f5d1', '3.2', 3, 'provisional_model', 'low', true, '5.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Environmental Impacts on Enzyme Function".', null, null, null),
  ('7e403aba-b29d-4d6f-9cc5-33cff23c2597', '2.1', 2, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('a0fa8005-6513-4521-8e4a-0581ac81cd7e', '6.5', 6, 'provisional_model', 'medium', false, '6.6', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Regulation of Gene Expression".', null, null, null),
  ('eeda718e-35ea-4282-884d-a235e76acd6f', '8.2', 8, 'provisional_model', 'medium', false, '2.5', 'Primary pick based on the item stem; closed-list lexical match to "Energy Flow Through Ecosystems".', null, null, null),
  ('ec8e7408-1f8a-44d9-9dbb-dd89eb8122b1', '5.2', 5, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem; closed-list lexical match to "Meiosis and Genetic Diversity".', null, null, null),
  ('f07ecf14-7cfd-423a-80d1-f83d05d34ccb', '3.3', 3, 'provisional_model', 'low', true, '3.5', 'Primary pick based on the item stem; closed-list lexical match to "Cellular Energy".', null, null, null),
  ('0cb84009-f7a4-4315-975c-34a7fbf06e2b', '2.1', 2, 'provisional_model', 'low', true, '6.3', 'Primary pick based on the item stem; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('15578bad-7da4-4a51-abde-595f5f9601d7', '5.5', 5, 'provisional_model', 'low', true, '7.4', 'Primary pick based on the item stem; closed-list lexical match to "Environmental Effects on Phenotype".', null, null, null),
  ('317c8f23-e810-4163-8f5f-f8ea0036c742', '7.5', 7, 'provisional_model', 'medium', false, '2.2', 'Primary pick based on the item stem; closed-list lexical match to "Hardy-Weinberg Equilibrium".', null, null, null),
  ('b4249345-5510-4c46-b072-a1ea8219baa4', '5.2', 5, 'provisional_model', 'low', true, '6.5', 'Primary pick based on the item stem; closed-list lexical match to "Meiosis and Genetic Diversity".', null, null, null),
  ('5924211d-ad3e-43cf-9574-f3d900b4f647', '3.3', 3, 'provisional_model', 'low', true, '3.5', 'Primary pick based on the item stem; closed-list lexical match to "Cellular Energy".', null, null, null),
  ('5055732c-6852-4429-8d71-57836d8c5226', '2.1', 2, 'provisional_model', 'low', true, '2.2', 'Primary pick based on the item stem; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('c1e627a9-49f0-4265-96fd-08cdf7169343', '2.8', 2, 'provisional_model', 'low', true, '4.4', 'Primary pick based on the item stem; closed-list lexical match to "Mechanisms of Transport".', null, null, null),
  ('c0d0ec3a-8b19-4ad4-b211-3a7083408b38', '1.1', 1, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('b76a09ff-aecf-4e87-a17b-5b04285a08e7', '3.2', 3, 'provisional_model', 'medium', false, '1.1', 'Primary pick based on the item stem; closed-list lexical match to "Environmental Impacts on Enzyme Function".', null, null, null),
  ('a3b95a8c-b537-4f07-aab6-5e3a606d930b', '1.1', 1, 'provisional_model', 'medium', false, '1.2', 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('561eb0a2-a904-41dc-baee-b1b46f057dee', '2.1', 2, 'provisional_model', 'medium', false, '4.6', 'Primary pick based on the item stem; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('a7fe6aa6-8d05-4db0-a6bf-b057f549a1ac', '2.2', 2, 'provisional_model', 'low', true, '2.3', 'Primary pick based on the item stem; closed-list lexical match to "Cell Size".', null, null, null),
  ('ea4f4f45-60ef-44c9-828b-dbf61892eff7', '1.1', 1, 'provisional_model', 'low', true, '2.1', 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('ee3aa8b2-c996-4f32-aad4-27cd68568a42', '1.1', 1, 'provisional_model', 'low', true, '1.6', 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('afd0854c-343d-4e37-a066-05f23d319e03', '2.6', 2, 'provisional_model', 'medium', false, '1.7', 'Primary pick based on the item stem; closed-list lexical match to "Facilitated Diffusion".', null, null, null),
  ('dd5e062b-5328-479c-bf77-16dc207957f4', '2.1', 2, 'provisional_model', 'low', true, '2.10', 'Primary pick based on the item stem; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('09a23a59-2ede-438d-b94f-3cbb3e12c8d0', '2.5', 2, 'provisional_model', 'low', true, '2.8', 'Primary pick based on the item stem; closed-list lexical match to "Membrane Transport".', null, null, null),
  ('7e09a039-a38b-4acf-aa67-fdcb8da6d26e', '8.2', 8, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem; closed-list lexical match to "Energy Flow Through Ecosystems".', null, null, null),
  ('d2195299-b1b0-4ae9-a109-54fa4b53a846', '1.7', 1, 'provisional_model', 'low', true, '2.1', 'Primary pick based on the item stem; closed-list lexical match to "Proteins".', null, null, null),
  ('ffb44beb-3467-4353-8b05-2715517d4cbb', '1.1', 1, 'provisional_model', 'low', true, null, 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('9e9936b4-9fa7-4e47-b6f9-7950388318ea', '1.1', 1, 'provisional_model', 'low', true, null, 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('c49484c4-5e3c-4c0c-a18d-e308055c6370', '5.5', 5, 'provisional_model', 'low', true, null, 'Primary pick based on the item stem; closed-list lexical match to "Environmental Effects on Phenotype".', null, null, null),
  ('d994c1b0-7951-4060-8053-1b4410b488b7', '5.5', 5, 'provisional_model', 'low', true, null, 'Primary pick based on the item stem; closed-list lexical match to "Environmental Effects on Phenotype".', null, null, null),
  ('b32b3a6d-ee7d-4720-b5ad-64547aebd892', '2.1', 2, 'provisional_model', 'low', true, '2.10', 'Primary pick based on the item stem; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('c41250d8-93ec-43fd-b68e-6f157d52c0c8', '6.1', 6, 'provisional_model', 'low', true, '6.3', 'Primary pick based on the item stem; closed-list lexical match to "DNA and RNA Structure".', null, null, null),
  ('dfa7018e-2ec0-409b-ae53-20895537ea68', '2.2', 2, 'provisional_model', 'low', true, '3.2', 'Primary pick based on the item stem; closed-list lexical match to "Cell Size".', null, null, null),
  ('149908e1-6c62-49d3-bae7-7ac23f12ce86', '2.2', 2, 'provisional_model', 'low', true, '6.5', 'Primary pick based on the item stem; closed-list lexical match to "Cell Size".', null, null, null),
  ('020fe264-1242-488a-aee5-9eb26d3b5faa', '7.1', 7, 'provisional_model', 'low', true, '7.2', 'Primary pick based on the item stem; closed-list lexical match to "Introduction to Natural Selection".', null, null, null),
  ('e3e2cd85-0071-4d37-800b-0cba0ae09c69', '3.3', 3, 'provisional_model', 'low', true, '3.5', 'Primary pick based on the item stem; closed-list lexical match to "Cellular Energy".', null, null, null),
  ('69c36745-2e64-4edd-a220-6b8935ed0a74', '3.3', 3, 'provisional_model', 'low', true, '3.4', 'Primary pick based on the item stem; closed-list lexical match to "Cellular Energy".', null, null, null),
  ('9e772ef8-410e-4269-a573-37aeb777833b', '7.4', 7, 'provisional_model', 'low', true, '8.3', 'Primary pick based on the item stem; closed-list lexical match to "Population Genetics".', null, null, null),
  ('004fa02d-4b3a-42f1-9159-e909ded75d7f', '1.1', 1, 'provisional_model', 'low', true, null, 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('b29147fe-ca1c-4b33-b8c7-e8e6192220e8', '4.5', 4, 'provisional_model', 'low', true, '4.6', 'Primary pick based on the item stem; closed-list lexical match to "Cell Cycle".', null, null, null),
  ('bf484484-9ce9-45fc-ab45-49b88ae745e7', '1.1', 1, 'held', 'low', true, '2.1', 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', 'topic_misassigned: Osmosis / water-potential investigation assigned to 1.1 Structure of Water and Hydrogen Bonding.', 'TL-062', '2.7'),
  ('f906df10-9c94-4432-9e4f-968e185301ac', '5.2', 5, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem; closed-list lexical match to "Meiosis and Genetic Diversity".', null, null, null),
  ('f96c2ad9-7bd0-4950-a9b0-d7492ea30803', '2.2', 2, 'provisional_model', 'low', true, '3.1', 'Primary pick based on the item stem; closed-list lexical match to "Cell Size".', null, null, null),
  ('f67ec85b-e2b0-4733-b891-c3e99e076f93', '8.5', 8, 'provisional_model', 'low', true, null, 'Primary pick based on the item stem; closed-list lexical match to "Community Ecology".', null, null, null),
  ('835d8ce4-93e2-46d2-af6d-adcd4c2713f3', '2.1', 2, 'provisional_model', 'medium', false, '1.1', 'Primary pick based on the item stem; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('e0278b91-cfc8-48ef-83b7-a9b4256ddf36', '4.5', 4, 'provisional_model', 'low', true, '4.6', 'Primary pick based on the item stem; closed-list lexical match to "Cell Cycle".', null, null, null),
  ('6d03e381-4f81-4f33-8804-7ea567f12330', '1.1', 1, 'provisional_model', 'low', true, '1.4', 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('ec200449-df12-4069-8a92-aea33feb36c9', '6.6', 6, 'provisional_model', 'medium', false, '6.5', 'Primary pick based on the item stem; closed-list lexical match to "Gene Expression and Cell Specialization".', null, null, null),
  ('907a1813-1d45-4b4f-aff7-8382632ef127', '1.1', 1, 'provisional_model', 'low', true, '2.1', 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('80e917c2-fc85-4aa6-a7e7-1f37050922f8', '5.5', 5, 'provisional_model', 'low', true, '7.1', 'Primary pick based on the item stem; closed-list lexical match to "Environmental Effects on Phenotype".', null, null, null),
  ('5dfd441b-f01b-4dc4-b327-1fe05b12f432', '5.2', 5, 'provisional_model', 'low', true, '6.5', 'Primary pick based on the item stem; closed-list lexical match to "Meiosis and Genetic Diversity".', null, null, null),
  ('c992e827-4720-4f1a-b2d4-924a9313e7b3', '3.3', 3, 'provisional_model', 'low', true, '3.4', 'Primary pick based on the item stem; closed-list lexical match to "Cellular Energy".', null, null, null),
  ('ffe8566d-7b98-4526-b58a-f37c4d8ededc', '6.4', 6, 'provisional_model', 'low', true, '6.5', 'Primary pick based on the item stem; closed-list lexical match to "Translation".', null, null, null),
  ('79cb5876-49bb-4d94-856d-414cd4c629b8', '6.5', 6, 'provisional_model', 'low', true, '6.6', 'Primary pick based on the item stem; closed-list lexical match to "Regulation of Gene Expression".', null, null, null),
  ('be78ce36-c01b-47d1-901f-7bf38caa0e7b', '6.1', 6, 'provisional_model', 'low', true, '6.6', 'Primary pick based on the item stem; closed-list lexical match to "DNA and RNA Structure".', null, null, null),
  ('016e7347-2003-45de-9967-619544d691ca', '1.1', 1, 'provisional_model', 'low', true, null, 'Primary pick based on the item stem; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('7640704b-6e1d-4bad-bc74-f3d194324805', '7.7', 7, 'provisional_model', 'medium', false, '2.10', 'Primary pick based on the item stem; closed-list lexical match to "Common Ancestry".', null, null, null),
  ('2c275bcc-2927-4910-83b6-fe61552a511b', '7.1', 7, 'provisional_model', 'low', true, '7.2', 'Primary pick based on the item stem; closed-list lexical match to "Introduction to Natural Selection".', null, null, null),
  ('ebcdd05b-73a4-49ca-9b2e-96f8bbdef234', '6.1', 6, 'provisional_model', 'low', true, '7.6', 'Primary pick based on the item stem; closed-list lexical match to "DNA and RNA Structure".', null, null, null),
  ('87874651-60bb-40cc-a634-2ce196ad996d', '3.2', 3, 'held', 'low', true, '8.4', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Environmental Impacts on Enzyme Function".', 'uninformative_stem: boilerplate photo-submission stem carries no topic signal; label was not derivable from the stem', 'TL-057', null),
  ('b738b319-8146-43d5-a2c4-5b292e1f1943', '7.1', 7, 'held', 'low', true, '7.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Introduction to Natural Selection".', 'uninformative_stem: boilerplate photo-submission stem carries no topic signal; label was not derivable from the stem', 'TL-058', null),
  ('001fef04-5272-4c9d-9d2b-cde19287bcc7', '8.2', 8, 'held', 'low', true, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Energy Flow Through Ecosystems".', 'uninformative_stem: boilerplate photo-submission stem carries no topic signal; label was not derivable from the stem', 'TL-059', null),
  ('3db8a97a-baaf-4ff4-9110-06dd4bc91892', '8.3', 8, 'held', 'medium', false, '2.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Population Ecology".', 'uninformative_stem: boilerplate photo-submission stem carries no topic signal; label was not derivable from the stem', 'TL-060', null),
  ('ccf8a3b4-88a8-4ff7-9844-85769f949666', '1.3', 1, 'provisional_model', 'low', true, '2.5', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Introduction to Macromolecules".', null, null, null),
  ('72b21db8-5964-4d58-aae4-94fca62e0224', '1.1', 1, 'provisional_model', 'low', true, '1.7', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Structure of Water and Hydrogen Bonding".', null, null, null),
  ('ca5cc6ae-774b-4500-93db-e18bddd48335', '7.12', 7, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Origins of Life on Earth".', null, null, null),
  ('7d731b39-b795-4b9c-9eea-f1f4a11c3c7e', '2.1', 2, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('cebc6511-86ef-48e7-a50b-5040fd59cc7f', '2.7', 2, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Tonicity and Osmoregulation".', null, null, null),
  ('a7f27476-2aff-455d-841d-e8cdc4cf47f8', '2.5', 2, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Membrane Transport".', null, null, null),
  ('bb7f82db-454f-4635-933c-c80567b31ff9', '2.5', 2, 'provisional_model', 'medium', false, '2.3', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Membrane Transport".', null, null, null),
  ('3509fa2a-9e58-4a28-9dc5-547451fd78a4', '2.5', 2, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Membrane Transport".', null, null, null),
  ('43774df8-fcb5-4979-af3e-e99f22651151', '2.1', 2, 'provisional_model', 'medium', false, '2.10', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('12b70712-b8e1-4c88-a199-1769d21716d8', '2.1', 2, 'provisional_model', 'medium', false, '2.10', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cell Structure and Function".', null, null, null),
  ('d64759de-72fc-4b0b-8f2a-1b6278df42d7', '2.3', 2, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Plasma Membrane".', null, null, null),
  ('09a0df29-1248-48ca-b456-860e4ee96056', '2.3', 2, 'provisional_model', 'medium', false, '3.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Plasma Membrane".', null, null, null),
  ('e8cfa78c-80db-4f78-9c92-643e71e732a9', '2.5', 2, 'provisional_model', 'medium', false, '2.1', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Membrane Transport".', null, null, null),
  ('f89cf634-d106-4e39-bd08-86bfcaee946d', '4.1', 4, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cell Communication".', null, null, null),
  ('925a8ee2-4d4f-46fa-acdf-b11ec4e4e01b', '4.2', 4, 'provisional_model', 'low', true, '4.3', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Introduction to Signal Transduction".', null, null, null),
  ('131394c0-26d6-48fd-8c30-563efe5e3d72', '4.2', 4, 'provisional_model', 'low', true, '4.3', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Introduction to Signal Transduction".', null, null, null),
  ('bb3560b1-27c2-4049-a23f-807b7c7e3336', '3.3', 3, 'provisional_model', 'medium', false, '3.5', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cellular Energy".', null, null, null),
  ('36f35384-d317-490c-9b64-e9a1c4092802', '4.2', 4, 'provisional_model', 'low', true, '4.3', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Introduction to Signal Transduction".', null, null, null),
  ('c3f31738-a35a-4fd8-979d-30ee38d2d9c7', '4.2', 4, 'provisional_model', 'low', true, '4.3', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Introduction to Signal Transduction".', null, null, null),
  ('8ef95e9f-c1a1-4b90-87d7-85658e941dc5', '4.3', 4, 'provisional_model', 'medium', false, '4.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Signal Transduction Pathways".', null, null, null),
  ('7d91a66c-cbd1-4a21-ba80-afead502c7ca', '4.5', 4, 'provisional_model', 'low', true, '4.6', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cell Cycle".', null, null, null),
  ('fc5ad24a-56b1-4eb5-84ee-73790aa4a351', '2.8', 2, 'provisional_model', 'low', true, '4.4', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Mechanisms of Transport".', null, null, null),
  ('1511bcd7-7d6a-432c-837c-5fd5e2387522', '4.2', 4, 'provisional_model', 'low', true, '4.3', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Introduction to Signal Transduction".', null, null, null),
  ('3cd93461-f154-4d7f-8acb-2ca71620cc74', '5.3', 5, 'provisional_model', 'low', true, '5.4', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Mendelian Genetics".', null, null, null),
  ('2beed8b1-f149-4acb-8b8c-46592bcb28f0', '6.5', 6, 'provisional_model', 'low', true, '6.6', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Regulation of Gene Expression".', null, null, null),
  ('b60575d3-cd19-4336-9d7b-46bd84b27907', '5.3', 5, 'provisional_model', 'low', true, '5.4', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Mendelian Genetics".', null, null, null),
  ('d0e17629-7083-4d2f-9ef6-9a76a36c3d40', '5.3', 5, 'provisional_model', 'low', true, '5.4', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Mendelian Genetics".', null, null, null),
  ('c4908388-08d4-4274-935e-dfb393077cdc', '1.6', 1, 'provisional_model', 'low', true, '6.1', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Nucleic Acids".', null, null, null),
  ('2e2c66b7-a563-47eb-abc7-37683745700d', '6.5', 6, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Regulation of Gene Expression".', null, null, null),
  ('37917d44-45e8-438d-9b90-c6ddc460f704', '6.5', 6, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Regulation of Gene Expression".', null, null, null),
  ('de3013c9-bdc6-4994-bf79-523c9c49e791', '6.5', 6, 'provisional_model', 'medium', false, '6.1', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Regulation of Gene Expression".', null, null, null),
  ('e4f47c41-420e-40dd-921f-343b0fb0b161', '6.5', 6, 'provisional_model', 'medium', false, '6.6', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Regulation of Gene Expression".', null, null, null),
  ('9b2ef7ea-ae9b-4dc9-9a9c-417eb5eee455', '6.5', 6, 'provisional_model', 'medium', false, '4.6', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Regulation of Gene Expression".', null, null, null),
  ('13a725ac-38ec-4d14-b061-ee4beec24c3d', '6.8', 6, 'provisional_model', 'medium', false, '6.1', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Biotechnology".', null, null, null),
  ('4b0b8c3f-126a-45b7-8deb-27c2baf47547', '7.1', 7, 'provisional_model', 'low', true, '7.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Introduction to Natural Selection".', null, null, null),
  ('770859c9-7ac4-4351-b5f0-49bab8ea98b2', '6.6', 6, 'provisional_model', 'low', true, '7.10', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Gene Expression and Cell Specialization".', null, null, null),
  ('768cfadd-4205-46ed-85bd-1ed667fb1728', '7.7', 7, 'provisional_model', 'medium', true, '1.1', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Common Ancestry".', null, null, null),
  ('dd29ea19-85a9-462b-a0b9-b969d861f6fa', '7.1', 7, 'provisional_model', 'low', true, '7.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Introduction to Natural Selection".', null, null, null),
  ('667ee67f-c38d-4d05-9cae-b2aea500c097', '8.5', 8, 'provisional_model', 'medium', false, '8.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Community Ecology".', null, null, null),
  ('cdd0dc50-fef1-4fcb-aa9d-a0299b8845be', '8.5', 8, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Community Ecology".', null, null, null),
  ('6c51e1d8-1b3a-4402-9b1c-c015560ee7fc', '8.2', 8, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Energy Flow Through Ecosystems".', null, null, null),
  ('95f03e91-c50d-4b14-aaca-b554c86b752f', '8.3', 8, 'provisional_model', 'medium', false, null, 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Population Ecology".', null, null, null),
  ('cbbba1c3-0859-45da-8d7d-8a99f12a55d6', '2.1', 2, 'provisional_model', 'low', true, '3.2', 'Primary pick based on the item stem and author subtopic prose; closed-list lexical match to "Cell Structure and Function".', null, null, null);

-- Snapshot the serving layer so "no serving label was touched" is proven, not asserted in prose.
create temporary table m2_serving_before on commit drop as
select count(*) as n_rows,
       count(*) filter (where superseded_by is null) as n_current,
       coalesce(md5(string_agg(content_taxonomy_label_id::text || ':' || label_status || ':' ||
                               coalesce(superseded_by::text, '-') || ':' || coalesce(max_required_unit::text, '-'),
                               ',' order by content_taxonomy_label_id)), '') as fingerprint
from app.content_taxonomy_labels
where label_scope = 'serving';

do $$
declare
  v_src uuid;
  v_n integer;
begin
  select taxonomy_source_version into v_src from m2_ctx;

  -- 1. the staged set is the whole Biology corpus, 112 + 6
  select count(*) into v_n from m2_staging;
  if v_n <> 118 then raise exception 'M2: expected 118 staged rows, got %', v_n; end if;
  select count(*) into v_n from m2_staging where disposition = 'provisional_model';
  if v_n <> 112 then raise exception 'M2: expected 112 provisional rows, got %', v_n; end if;
  select count(*) into v_n from m2_staging where disposition = 'held';
  if v_n <> 6 then raise exception 'M2: expected 6 held rows, got %', v_n; end if;
  select count(distinct content_item_id) into v_n from m2_staging;
  if v_n <> 118 then raise exception 'M2: staged content_item_id is not distinct (% distinct)', v_n; end if;

  -- 2. the pinned taxonomy source really is Biology's, with the 60 topics QA verified
  if not exists (
    select 1 from app.taxonomy_source_versions
    where taxonomy_source_version = v_src
      and subject_key in ('biology', 'ap-biology', 'ap_biology')
  ) then
    raise exception 'M2: pinned taxonomy_source_version % is not a Biology registry version', v_src;
  end if;
  select count(*) into v_n from app.taxonomy_topics where taxonomy_source_version = v_src;
  if v_n <> 60 then raise exception 'M2: expected 60 Biology topics in the closed list, got %', v_n; end if;

  -- 3. T7 closed-list check, enforced at write time. An invented topic aborts the migration.
  select count(*) into v_n
  from m2_staging s
  where s.disposition = 'provisional_model'
    and not exists (
      select 1 from app.taxonomy_topics t
      where t.taxonomy_source_version = v_src and t.topic_code = s.topic_code
    );
  if v_n <> 0 then raise exception 'M2: % staged topic codes are not in the Biology closed list', v_n; end if;

  -- 4. each code's unit matches the registry's unit for that code
  select count(*) into v_n
  from m2_staging s
  join app.taxonomy_topics t
    on t.taxonomy_source_version = v_src and t.topic_code = s.topic_code
  where s.disposition = 'provisional_model' and t.unit_number <> s.unit_number;
  if v_n <> 0 then raise exception 'M2: % staged rows disagree with the registry on unit number', v_n; end if;

  -- 5. every staged item is a published Biology item. Subject resolves through exam_packs because
  --    app.content_items has NO subject_key column -- that exists only on the public view (see M4).
  select count(*) into v_n
  from m2_staging s
  where not exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.content_item_versions civ on civ.content_item_id = ci.id
    where ci.id = s.content_item_id and ep.exam_code = 'ap_biology' and civ.status = 'published'
  );
  if v_n <> 0 then raise exception 'M2: % staged items are not published Biology items', v_n; end if;

  -- 6. the inventory claim this migration rests on: no Biology item already carries a coverage
  --    label with topics in it. If this fails, STOP -- superseding real data was never intended.
  select count(*) into v_n
  from app.content_taxonomy_labels l
  join m2_staging s on s.content_item_id = l.content_item_id
  where l.label_scope = 'coverage' and l.superseded_by is null and cardinality(l.assessed_topics) > 0;
  if v_n <> 0 then
    raise exception 'M2: % existing current coverage labels already carry topics; aborting rather than superseding them', v_n;
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- Write. label_version is computed per item rather than assumed, so this is correct whatever
-- history each item's coverage lane already has.
--
-- primary_unit is left NULL deliberately. T9: "primary_unit is an input to neither." The unit is
-- recoverable from the topic code through the registry; storing it here would re-create the
-- conflation T9 exists to prevent.
--
-- The five validation columns are left NULL, which is what makes label_status='validated'
-- unreachable for these rows under content_taxonomy_labels_validation_check.

insert into app.content_taxonomy_labels (
  content_item_id,
  label_version,
  label_scope,
  assessed_topics,
  taxonomy_source_version,
  taxonomy_confidence,
  label_status,
  source,
  source_payload,
  model_run_id
)
select
  s.content_item_id,
  coalesce((
    select max(l.label_version) from app.content_taxonomy_labels l
    where l.content_item_id = s.content_item_id and l.label_scope = 'coverage'
  ), 0) + 1,
  'coverage',
  case when s.disposition = 'provisional_model' then array[s.topic_code] else '{}'::text[] end,
  (select taxonomy_source_version from m2_ctx),
  (select tsv.taxonomy_confidence from app.taxonomy_source_versions tsv
   where tsv.taxonomy_source_version = (select taxonomy_source_version from m2_ctx)),
  s.disposition,
  'work_order_topic_tagging_2026_09_22',
  jsonb_strip_nulls(jsonb_build_object(
    'proposal_run', 'bio_stats_topic_tagging_2026_09_22',
    'proposed_topic_code', s.topic_code,
    'proposed_unit_number', s.unit_number,
    'model_confidence', s.model_confidence,
    'needs_human', s.needs_human,
    'alt_topic_code', s.alt_topic_code,
    'rationale', s.rationale,
    'qa_disposition', case when s.disposition = 'held' then 'held_by_qa' else 'accepted_by_qa' end,
    'qa_finding_id', s.qa_finding_id,
    'hold_reason', s.hold_reason,
    'suggested_topic_code', s.suggested_topic_code,
    'governance', 'DECISION-0062; provisional_model pending the T9/T6.b human-validation question'
  )),
  'bio_stats_topic_tagging_2026_09_22'
from m2_staging s;

-- Retire the empty coverage shells these rows replace. Guarded to rows carrying no topics; check 6
-- above already proved none carry any.
update app.content_taxonomy_labels old
set superseded_by = new_row.content_taxonomy_label_id
from app.content_taxonomy_labels new_row
where new_row.source = 'work_order_topic_tagging_2026_09_22'
  and new_row.label_scope = 'coverage'
  and old.content_item_id = new_row.content_item_id
  and old.label_scope = 'coverage'
  and old.content_taxonomy_label_id <> new_row.content_taxonomy_label_id
  and old.superseded_by is null
  and cardinality(old.assessed_topics) = 0;

-- ---------------------------------------------------------------------------
-- Post-write verification.

do $$
declare
  v_n integer;
  v_before record;
  v_after record;
begin
  -- 118 rows written, in the right proportions
  select count(*) into v_n from app.content_taxonomy_labels
  where source = 'work_order_topic_tagging_2026_09_22' and label_scope = 'coverage';
  if v_n <> 118 then raise exception 'M2: expected 118 written rows, got %', v_n; end if;

  select count(*) into v_n from app.content_taxonomy_labels
  where source = 'work_order_topic_tagging_2026_09_22'
    and label_status = 'provisional_model' and cardinality(assessed_topics) = 1;
  if v_n <> 112 then raise exception 'M2: expected 112 provisional rows carrying exactly one topic, got %', v_n; end if;

  select count(*) into v_n from app.content_taxonomy_labels
  where source = 'work_order_topic_tagging_2026_09_22'
    and label_status = 'held' and cardinality(assessed_topics) = 0;
  if v_n <> 6 then raise exception 'M2: expected 6 held rows carrying no topic, got %', v_n; end if;

  -- nothing was written as validated, and nothing could have been
  select count(*) into v_n from app.content_taxonomy_labels
  where source = 'work_order_topic_tagging_2026_09_22' and label_status = 'validated';
  if v_n <> 0 then raise exception 'M2: % rows written as validated; none should be', v_n; end if;

  -- exactly one current coverage label per Biology item in scope
  select count(*) into v_n from (
    select l.content_item_id
    from app.content_taxonomy_labels l
    join m2_staging s on s.content_item_id = l.content_item_id
    where l.label_scope = 'coverage' and l.superseded_by is null
    group by l.content_item_id having count(*) <> 1
  ) x;
  if v_n <> 0 then raise exception 'M2: % items have more than one current coverage label', v_n; end if;

  -- THE SERVING LAYER IS BYTE-FOR-BYTE UNCHANGED
  select * into v_before from m2_serving_before;
  select count(*) as n_rows,
         count(*) filter (where superseded_by is null) as n_current,
         coalesce(md5(string_agg(content_taxonomy_label_id::text || ':' || label_status || ':' ||
                                 coalesce(superseded_by::text, '-') || ':' || coalesce(max_required_unit::text, '-'),
                                 ',' order by content_taxonomy_label_id)), '') as fingerprint
    into v_after
  from app.content_taxonomy_labels where label_scope = 'serving';
  if v_before.fingerprint <> v_after.fingerprint
     or v_before.n_rows <> v_after.n_rows
     or v_before.n_current <> v_after.n_current then
    raise exception 'M2: the serving label layer changed (% -> % rows, % -> % current)',
      v_before.n_rows, v_after.n_rows, v_before.n_current, v_after.n_current;
  end if;
end $$;

commit;

-- ---------------------------------------------------------------------------
-- What remains open after this migration
--
-- 1. The T9/T6.b vs DECISION-0055 question is DEFERRED, not answered. It now blocks only the
--    promotion of these rows to `validated`, and with it T8's coverage recompute -- not the storage
--    of the data. Promotion requires a validator, a timestamp and a decision id per the schema's own
--    check constraint, so it cannot happen by accident.
-- 2. The six held items need a re-derivation pass from rubric/stimulus (the four HDG items) or a
--    one-line correction to 2.7 (the two osmosis items, on Product Owner word).
-- 3. AP Statistics' 384 rows from the same proposal remain REJECTED by QA -- 56 wrong topics across
--    four systematic template-shaped classes. They need a rebuild, not a repair, and nothing here
--    touches them.
