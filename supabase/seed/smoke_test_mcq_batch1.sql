-- Smoke test: Upload MCQ-001, MCQ-002, MCQ-003 from AP Biology Batch 1.
-- Run AFTER migration 202606260001_frq_form_canonical.sql has been applied.
-- Idempotent: ON CONFLICT DO NOTHING on all inserts.
--
-- Verify after running:
--   SELECT ci.content_key, civ.stem, count(mc.id) AS choices
--   FROM app.content_items ci
--   JOIN app.content_item_versions civ ON civ.content_item_id = ci.id
--   JOIN app.mcq_choices mc ON mc.content_item_version_id = civ.id
--   WHERE ci.content_key LIKE 'APBIO-MCQ-00%'
--   GROUP BY ci.content_key, civ.stem
--   ORDER BY ci.content_key;

do $$
declare
  v_epv_id  uuid;
  v_ci_id   uuid;
  v_civ_id  uuid;
begin

  -- ── Resolve AP Biology 2026 exam pack version ───────────────────────────────
  select epv.id into strict v_epv_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_biology'
    and epv.school_year = '2026';

  -- ── APBIO-MCQ-001 ───────────────────────────────────────────────────────────

  insert into app.content_items
    (exam_pack_version_id, content_key, item_type, title, status)
  values
    (v_epv_id, 'APBIO-MCQ-001', 'mcq', 'APBIO-MCQ-001', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing
  returning id into v_ci_id;

  if v_ci_id is null then
    select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-MCQ-001';
  end if;

  insert into app.content_item_versions
    (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (
    v_ci_id, 1,
    'Which property of water is most directly responsible for the needle remaining on the surface before soap was added?',
    'A student placed a steel needle carefully on the surface of water in a bowl. The needle floated despite being denser than water. When a drop of dish soap was added near the needle, it immediately sank. A classmate observed that water strider insects exploit the same property to walk across pond surfaces.',
    '{"modules":["1"],"subtopics":["1.1 Structure of Water and Hydrogen Bonding"],"intended_difficulty":"Easy"}'::jsonb,
    md5('APBIO-MCQ-001'),
    'draft'
  )
  on conflict (content_item_id, version_num) do nothing
  returning id into v_civ_id;

  if v_civ_id is null then
    select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1;
  end if;

  insert into app.mcq_choices
    (content_item_version_id, choice_key, choice_text, is_correct, rationale)
  values
    (v_civ_id, 'A',
     'Adhesion between water molecules and the needle''s metal surface',
     false,
     'Adhesion describes water''s attraction to other materials, not water-to-water attraction. Adhesion to the needle would pull water up the sides, not support it from below. This conflates adhesion with cohesion.'),
    (v_civ_id, 'B',
     'Cohesion between water molecules generating surface tension',
     true,
     'Hydrogen bonds between water molecules create cohesion, which manifests as surface tension — the tendency of water''s surface to resist penetration. Soap disrupts these bonds, eliminating surface tension and allowing the needle to sink.'),
    (v_civ_id, 'C',
     'Water''s high specific heat capacity, which slows the needle''s movement into the surface',
     false,
     'Specific heat capacity describes resistance to temperature change, not surface resistance to penetration. This distractor targets students who list water''s properties without connecting each to specific physical behaviors.'),
    (v_civ_id, 'D',
     'The evaporation of water from the surface creating an upward pressure on the needle',
     false,
     'Evaporation removes molecules from the surface; it does not create upward pressure. This targets students who do not reason carefully about forces at the water surface.')
  on conflict (content_item_version_id, choice_key) do nothing;

  -- ── APBIO-MCQ-002 ───────────────────────────────────────────────────────────

  insert into app.content_items
    (exam_pack_version_id, content_key, item_type, title, status)
  values
    (v_epv_id, 'APBIO-MCQ-002', 'mcq', 'APBIO-MCQ-002', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing
  returning id into v_ci_id;

  if v_ci_id is null then
    select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-MCQ-002';
  end if;

  insert into app.content_item_versions
    (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (
    v_ci_id, 1,
    'Which concept best explains why amylase acted on starch but not on the other substrates?',
    'A researcher tested the enzyme amylase (which digests starch) by mixing it separately with: (1) a starch solution, (2) a gelatin solution (protein chains), and (3) a sucrose solution. After 30 minutes at 37°C and pH 7, iodine tests revealed starch breakdown only in the first tube. No detectable products appeared in the protein or sucrose tubes.',
    '{"modules":["1"],"subtopics":["1.4 Properties of Biological Macromolecules"],"intended_difficulty":"Easy"}'::jsonb,
    md5('APBIO-MCQ-002'),
    'draft'
  )
  on conflict (content_item_id, version_num) do nothing
  returning id into v_civ_id;

  if v_civ_id is null then
    select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1;
  end if;

  insert into app.mcq_choices
    (content_item_version_id, choice_key, choice_text, is_correct, rationale)
  values
    (v_civ_id, 'A',
     'Amylase requires a metal cofactor found only in starch solutions',
     false,
     'Cofactors are not substrate-specific and would not confine amylase activity to a single substrate. This conflates enzyme cofactor requirements with substrate specificity.'),
    (v_civ_id, 'B',
     'Starch is negatively charged, attracting it to the positively charged active site of amylase',
     false,
     'Enzyme-substrate specificity is primarily shape-based, not simple electrostatic attraction. Reducing specificity to charge misrepresents enzyme biochemistry and cannot explain why structurally distinct uncharged substrates are also excluded.'),
    (v_civ_id, 'C',
     'Only starch has the complementary shape to fit amylase''s active site, enabling enzyme-substrate binding',
     true,
     'Enzyme specificity arises from the precise shape complementarity between the active site and its substrate. Amylase''s active site binds α(1→4) glycosidic linkages of starch; sucrose and protein chains have incompatible geometries.'),
    (v_civ_id, 'D',
     'Protein and sucrose molecules are too large to fit inside the enzyme''s active site',
     false,
     'Starch molecules are far larger than sucrose, yet amylase acts on starch. Size alone does not determine enzyme specificity; sucrose would fit physically if the shape were complementary.')
  on conflict (content_item_version_id, choice_key) do nothing;

  -- ── APBIO-MCQ-003 ───────────────────────────────────────────────────────────

  insert into app.content_items
    (exam_pack_version_id, content_key, item_type, title, status)
  values
    (v_epv_id, 'APBIO-MCQ-003', 'mcq', 'APBIO-MCQ-003', 'draft')
  on conflict (exam_pack_version_id, content_key) do nothing
  returning id into v_ci_id;

  if v_ci_id is null then
    select id into v_ci_id from app.content_items
    where exam_pack_version_id = v_epv_id and content_key = 'APBIO-MCQ-003';
  end if;

  insert into app.content_item_versions
    (content_item_id, version_num, stem, stimulus, prompt_json, content_hash, status)
  values (
    v_ci_id, 1,
    'Which best explains why pepsin activity was lost under both conditions (2) and (3), given that the protein remained detectable?',
    'Pepsin is a protease that functions optimally at pH 2 in the stomach. A researcher compared pepsin activity under three conditions: (1) 37°C, pH 2 — maximum activity observed; (2) 37°C, pH 7 — near-zero activity; (3) boiled at 100°C for 10 min, then returned to 37°C and pH 2 — near-zero activity. A Western blot confirmed that pepsin protein was still detectable under all three conditions.',
    '{"modules":["1"],"subtopics":["1.4 Properties of Biological Macromolecules"],"intended_difficulty":"Medium"}'::jsonb,
    md5('APBIO-MCQ-003'),
    'draft'
  )
  on conflict (content_item_id, version_num) do nothing
  returning id into v_civ_id;

  if v_civ_id is null then
    select id into v_civ_id from app.content_item_versions
    where content_item_id = v_ci_id and version_num = 1;
  end if;

  insert into app.mcq_choices
    (content_item_version_id, choice_key, choice_text, is_correct, rationale)
  values
    (v_civ_id, 'A',
     'In both conditions, pepsin''s primary structure (peptide bonds) was disrupted, destroying the active site',
     false,
     'Peptide bonds are covalent and are not broken by mild pH shifts or brief boiling at 100°C. The Western blot confirming intact protein supports this — denatured pepsin still migrates as a detectable band.'),
    (v_civ_id, 'B',
     'At pH 7, the substrate was destroyed; at 100°C, the substrate concentration became too dilute',
     false,
     'Protein substrates are stable at pH 7, and temperature changes do not dilute substrate. These are invented mechanisms inconsistent with enzyme biochemistry.'),
    (v_civ_id, 'C',
     'At pH 7, pepsin''s substrate could no longer enter the active site due to increased water viscosity; at 100°C, the substrate was digested before activity could be measured',
     false,
     'Water viscosity does not change appreciably between pH 2 and pH 7, and substrates do not preferentially digest themselves at 100°C. Both explanations are mechanistically unsupported.'),
    (v_civ_id, 'D',
     'At pH 7, altered ionization of R-groups disrupted ionic and hydrogen bonds maintaining pepsin''s tertiary structure; at 100°C, thermal energy disrupted hydrophobic interactions, hydrogen bonds, and ionic bonds, denaturing the protein',
     true,
     'Protein tertiary structure is maintained by non-covalent interactions. pH changes alter the ionization states of charged R-groups, disrupting ionic bonds and hydrogen bonds critical to active-site geometry. High temperature overcomes all non-covalent stabilizing interactions simultaneously, causing irreversible denaturation.')
  on conflict (content_item_version_id, choice_key) do nothing;

  raise notice 'Smoke test complete: inserted APBIO-MCQ-001, 002, 003 with choices.';

end $$;

-- ── Verify ────────────────────────────────────────────────────────────────────
select
  ci.content_key,
  left(civ.stem, 60) || '...' as stem_preview,
  civ.status,
  count(mc.id)          as choice_count,
  count(mc.id) filter (where mc.is_correct) as correct_count
from app.content_items ci
join app.content_item_versions civ on civ.content_item_id = ci.id
join app.mcq_choices mc on mc.content_item_version_id = civ.id
where ci.content_key in ('APBIO-MCQ-001', 'APBIO-MCQ-002', 'APBIO-MCQ-003')
group by ci.content_key, civ.stem, civ.status
order by ci.content_key;
