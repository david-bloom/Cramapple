begin;
do $$ begin
  if exists (select 1 from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.2-a-v1','apchem-mcq-b4-sv-h-4.2-a-v2','apchem-mcq-b4-sv-h-4.2-a-v3','apchem-mcq-b4-h-4.2-b','apchem-mcq-b4-sv-h-4.2-b-v1','apchem-mcq-b4-sv-h-4.2-b-v2','apchem-mcq-b4-sv-h-4.2-b-v3','apchem-mcq-b4-h-4.3-a','apchem-mcq-b4-sv-h-4.3-a-v1'])) then raise exception 'chunk 2 already loaded'; end if;
end $$;
-- apchem-mcq-b4-sv-h-4.2-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.2-a-v1', 'mcq', 'write the net ionic equation when every ion in the mixture takes part in a precipitate (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Aqueous Ba(OH)2 and aqueous Fe2(SO4)3 are mixed. Both BaSO4 and Fe(OH)3 are insoluble. Which is the net ionic equation?', null, md5('apchem-mcq-b4-sv-h-4.2-a-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '3 Ba²⁺(aq) + 3 SO4²⁻(aq) → 3 BaSO4(s)', false, 'It leaves out the iron(III) hydroxide precipitate, but Fe³⁺ and OH⁻ also leave solution.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Ba²⁺(aq) + 2 OH⁻(aq) + Fe³⁺(aq) + SO4²⁻(aq) → BaSO4(s) + Fe(OH)3(s)', false, 'It is unbalanced, with 1 Fe on the left and a charge of +1 left over instead of zero.' from version_ins
union all select gen_random_uuid(), id, 'C', '3 Ba²⁺(aq) + 6 OH⁻(aq) + 2 Fe³⁺(aq) + 3 SO4²⁻(aq) → 3 BaSO4(s) + 2 Fe(OH)3(s)', true, 'Correct: the ions Ba²⁺, OH⁻, Fe³⁺ and SO4²⁻ all end up in solids. Charge: left 6 + (-6) + 6 + (-6) = 0, and atoms balance.' from version_ins
union all select gen_random_uuid(), id, 'D', '2 Fe³⁺(aq) + 6 OH⁻(aq) → 2 Fe(OH)3(s)', false, 'It leaves out the barium sulfate precipitate, although Ba²⁺ and SO4²⁻ also leave solution.' from version_ins;
-- apchem-mcq-b4-sv-h-4.2-a-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.2-a-v2', 'mcq', 'write the net ionic equation when every ion in the mixture takes part in a precipitate (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Aqueous Pb(NO3)2 and aqueous KI are mixed, and yellow solid PbI2 forms. KNO3 is soluble. Which is the net ionic equation?', null, md5('apchem-mcq-b4-sv-h-4.2-a-v2'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Pb²⁺(aq) + I⁻(aq) → PbI(s)', false, 'Lead here is Pb²⁺, which needs two I⁻ ions to balance its charge, so the formula PbI is wrong and must be PbI2.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Pb(NO3)2(aq) + 2 KI(aq) → PbI2(s) + 2 KNO3(aq)', false, 'It is the molecular equation and shows no ions.' from version_ins
union all select gen_random_uuid(), id, 'C', 'Pb²⁺(aq) + 2 NO3⁻(aq) + 2 K⁺(aq) + 2 I⁻(aq) → PbI2(s) + 2 K⁺(aq) + 2 NO3⁻(aq)', false, 'It is the complete ionic equation, which keeps the spectator ions K⁺ and NO3⁻ on both sides.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Pb²⁺(aq) + 2 I⁻(aq) → PbI2(s)', true, 'Correct: K⁺ and NO3⁻ stay dissolved and are spectators; only Pb²⁺ and I⁻ combine, in a 1:2 ratio for charge balance.' from version_ins;
-- apchem-mcq-b4-sv-h-4.2-a-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.2-a-v3', 'mcq', 'write the net ionic equation when every ion in the mixture takes part in a precipitate (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Aqueous KI and aqueous NaNO3 are mixed. Both possible products, KNO3 and NaI, are soluble. Which statement is correct?', null, md5('apchem-mcq-b4-sv-h-4.2-a-v3'), 'draft', 'tutor_review_pending', 'D'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'K⁺(aq) + NO3⁻(aq) → KNO3(s) is the net ionic equation.', false, 'KNO3 is soluble, so K⁺ and NO3⁻ do not combine into a solid.' from version_ins
union all select gen_random_uuid(), id, 'B', 'Na⁺(aq) + I⁻(aq) → NaI(s) is the net ionic equation.', false, 'NaI is soluble, so Na⁺ and I⁻ stay as separate ions in solution.' from version_ins
union all select gen_random_uuid(), id, 'C', 'A reaction occurs because the molecular equation KI + NaNO3 → KNO3 + NaI can be written.', false, 'A balanced swap of partners can always be written on paper, but a reaction occurs only if something removes ions from solution.' from version_ins
union all select gen_random_uuid(), id, 'D', 'All four ions stay dissolved and are spectators, so there is no net ionic equation.', true, 'Correct: since no product is insoluble, a gas or a weak electrolyte, no ions are removed from solution.' from version_ins;
-- apchem-mcq-b4-h-4.2-b
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.2-b', 'mcq', 'write the net ionic equation for an acid-base reaction, keeping a weak acid in molecular form', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Aqueous acetic acid, HC2H3O2, a weak acid, is mixed with aqueous sodium hydroxide. Which is the net ionic equation for the reaction?', null, md5('apchem-mcq-b4-h-4.2-b'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'HC2H3O2(aq) + OH⁻(aq) → C2H3O2⁻(aq) + H2O(l)', true, 'Correct: acetic acid is mostly molecular in water, so it is written as HC2H3O2; Na⁺ is a spectator and is omitted.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H⁺(aq) + OH⁻(aq) → H2O(l)', false, 'It treats acetic acid as fully dissociated into H⁺, but a weak acid is mostly un-ionized and should be written as the molecule.' from version_ins
union all select gen_random_uuid(), id, 'C', 'HC2H3O2(aq) + Na⁺(aq) + OH⁻(aq) → Na⁺(aq) + C2H3O2⁻(aq) + H2O(l)', false, 'It is the complete ionic equation, which shows the spectator ion Na⁺ on both sides.' from version_ins
union all select gen_random_uuid(), id, 'D', 'HC2H3O2(aq) + NaOH(aq) → NaC2H3O2(aq) + H2O(l)', false, 'It is the molecular equation, which writes the soluble ionic compounds as formula units.' from version_ins;
-- apchem-mcq-b4-sv-h-4.2-b-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.2-b-v1', 'mcq', 'write the net ionic equation for an acid-base reaction, keeping a weak acid in molecular form (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Aqueous hydrofluoric acid, HF, a weak acid, is mixed with aqueous potassium hydroxide. Which is the net ionic equation?', null, md5('apchem-mcq-b4-sv-h-4.2-b-v1'), 'draft', 'tutor_review_pending', 'C'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H⁺(aq) + OH⁻(aq) → H2O(l)', false, 'It treats HF as a strong acid that is fully ionized to H⁺, which it is not.' from version_ins
union all select gen_random_uuid(), id, 'B', 'HF(aq) + K⁺(aq) + OH⁻(aq) → K⁺(aq) + F⁻(aq) + H2O(l)', false, 'It is the complete ionic equation and includes the spectator ion K⁺.' from version_ins
union all select gen_random_uuid(), id, 'C', 'HF(aq) + OH⁻(aq) → F⁻(aq) + H2O(l)', true, 'Correct: HF is a weak acid and stays as a molecule; K⁺ is a spectator.' from version_ins
union all select gen_random_uuid(), id, 'D', 'HF(aq) + KOH(aq) → KF(aq) + H2O(l)', false, 'It is the molecular equation and not a net ionic equation.' from version_ins;
-- apchem-mcq-b4-sv-h-4.2-b-v2
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.2-b-v2', 'mcq', 'write the net ionic equation for an acid-base reaction, keeping a weak acid in molecular form (variant 2)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Aqueous ammonia, NH3, a weak base, is mixed with aqueous hydrochloric acid. Which is the net ionic equation?', null, md5('apchem-mcq-b4-sv-h-4.2-b-v2'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'H⁺(aq) + OH⁻(aq) → H2O(l)', false, 'Aqueous ammonia contains only a tiny concentration of OH⁻, and the main base species is NH3, which reacts directly with H⁺.' from version_ins
union all select gen_random_uuid(), id, 'B', 'NH3(aq) + H⁺(aq) → NH4⁺(aq)', true, 'Correct: HCl is a strong acid, so it supplies H⁺; NH3 accepts the proton to form NH4⁺; Cl⁻ is a spectator.' from version_ins
union all select gen_random_uuid(), id, 'C', 'NH4⁺(aq) + Cl⁻(aq) → NH4Cl(s)', false, 'NH4Cl is soluble, so NH4⁺ and Cl⁻ do not form a solid.' from version_ins
union all select gen_random_uuid(), id, 'D', 'NH3(aq) + H⁺(aq) + Cl⁻(aq) → NH4⁺(aq) + Cl⁻(aq)', false, 'It is the complete ionic equation, which keeps the spectator ion Cl⁻ on both sides.' from version_ins;
-- apchem-mcq-b4-sv-h-4.2-b-v3
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.2-b-v3', 'mcq', 'write the net ionic equation for an acid-base reaction, keeping a weak acid in molecular form (variant 3)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'Solid Mg(OH)2, which is essentially insoluble in water, dissolves in aqueous HCl. Which is the net ionic equation?', null, md5('apchem-mcq-b4-sv-h-4.2-b-v3'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', 'Mg(OH)2(s) + 2 H⁺(aq) → Mg²⁺(aq) + 2 H2O(l)', true, 'Correct: the insoluble solid is written as a formula unit; Cl⁻ is a spectator; charge is +2 on both sides.' from version_ins
union all select gen_random_uuid(), id, 'B', 'H⁺(aq) + OH⁻(aq) → H2O(l)', false, 'It treats the Mg(OH)2 as if it were already dissolved to supply free OH⁻, but it is a solid and must be written as Mg(OH)2(s).' from version_ins
union all select gen_random_uuid(), id, 'C', 'Mg²⁺(aq) + 2 Cl⁻(aq) → MgCl2(s)', false, 'MgCl2 is soluble, so Mg²⁺ and Cl⁻ remain dissolved.' from version_ins
union all select gen_random_uuid(), id, 'D', 'Mg(OH)2(s) + 2 H⁺(aq) + 2 Cl⁻(aq) → Mg²⁺(aq) + 2 Cl⁻(aq) + 2 H2O(l)', false, 'It is the complete ionic equation and includes the spectator ion Cl⁻ on both sides.' from version_ins;
-- apchem-mcq-b4-h-4.3-a
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-h-4.3-a', 'mcq', 'draw the product mixture from a particle count using the mole ratio and conservation of atoms', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle drawing of the reactant mixture shows 3 N2 molecules and 6 H2 molecules in a sealed container. The reaction N2 + 3 H2 → 2 NH3 then goes to completion. Which description of the final mixture is correct?', null, md5('apchem-mcq-b4-h-4.3-a'), 'draft', 'tutor_review_pending', 'A'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '4 NH3 molecules and 1 N2 molecule', true, 'Correct: 6 H2 molecules supply 12 H atoms, enough for 4 NH3; these use 4 N atoms (2 N2), leaving 1 N2. Totals: N = 4 + 2 = 6 atoms, H = 12 atoms, as in the reactants.' from version_ins
union all select gen_random_uuid(), id, 'B', '6 NH3 molecules and nothing else', false, '6 NH3 would need 18 H atoms, but only 12 are present, and it ignores that H2 runs out first.' from version_ins
union all select gen_random_uuid(), id, 'C', '6 NH3 molecules and 3 H2 molecules', false, '6 NH3 and 3 H2 contain 24 H atoms, twice as many as were available, so atoms are not conserved.' from version_ins
union all select gen_random_uuid(), id, 'D', '4 NH3 molecules and 2 N2 molecules', false, '4 NH3 and 2 N2 contain 8 N atoms, but only 6 were present, so atoms are not conserved.' from version_ins;
-- apchem-mcq-b4-sv-h-4.3-a-v1
with item_ins as (
  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
  select gen_random_uuid(), 'c9ca46b2-b529-4ed3-9741-dddea455ab9b', 'apchem-mcq-b4-sv-h-4.3-a-v1', 'mcq', 'draw the product mixture from a particle count using the mole ratio and conservation of atoms (variant 1)', 'draft' returning id
), version_ins as (
  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)
  select gen_random_uuid(), id, 1, 'A particle drawing of the reactant mixture shows 6 H2 molecules and 4 O2 molecules in a sealed container. The reaction 2 H2 + O2 → 2 H2O then goes to completion. Which description of the final mixture is correct?', null, md5('apchem-mcq-b4-sv-h-4.3-a-v1'), 'draft', 'tutor_review_pending', 'B'
  from item_ins returning id
)
insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)
select gen_random_uuid(), id, 'A', '8 H2O molecules', false, '8 H2O would need 16 H atoms but only 12 are available, so hydrogen is limiting.' from version_ins
union all select gen_random_uuid(), id, 'B', '6 H2O molecules and 1 O2 molecule', true, 'Correct: 6 H2 needs 3 O2 and makes 6 H2O, leaving 4 - 3 = 1 O2. Atoms: O = 6 + 2 = 8, H = 12, as before.' from version_ins
union all select gen_random_uuid(), id, 'C', '6 H2O molecules and 3 O2 molecules', false, 'It makes 6 H2O but does not subtract the O2 consumed, so oxygen atoms would not be conserved (12 O instead of 8).' from version_ins
union all select gen_random_uuid(), id, 'D', '6 H2O molecules and 2 O2 molecules', false, 'It leaves 2 O2, giving 10 O atoms in total instead of 8, so atoms are not conserved.' from version_ins;
do $$ begin
  if (select count(*) from app.content_items where exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and content_key = any (array['apchem-mcq-b4-sv-h-4.2-a-v1','apchem-mcq-b4-sv-h-4.2-a-v2','apchem-mcq-b4-sv-h-4.2-a-v3','apchem-mcq-b4-h-4.2-b','apchem-mcq-b4-sv-h-4.2-b-v1','apchem-mcq-b4-sv-h-4.2-b-v2','apchem-mcq-b4-sv-h-4.2-b-v3','apchem-mcq-b4-h-4.3-a','apchem-mcq-b4-sv-h-4.3-a-v1']) and status='draft')<>9 then raise exception 'chunk 2: expected 9 draft items'; end if;
  if (select count(*) from app.mcq_choices m join app.content_item_versions v on v.id=m.content_item_version_id join app.content_items ci on ci.id=v.content_item_id where ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.content_key = any (array['apchem-mcq-b4-sv-h-4.2-a-v1','apchem-mcq-b4-sv-h-4.2-a-v2','apchem-mcq-b4-sv-h-4.2-a-v3','apchem-mcq-b4-h-4.2-b','apchem-mcq-b4-sv-h-4.2-b-v1','apchem-mcq-b4-sv-h-4.2-b-v2','apchem-mcq-b4-sv-h-4.2-b-v3','apchem-mcq-b4-h-4.3-a','apchem-mcq-b4-sv-h-4.3-a-v1']))<>36 then raise exception 'chunk 2: expected 36 choices'; end if;
end $$;
commit;
