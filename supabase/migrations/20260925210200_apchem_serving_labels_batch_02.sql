-- AP Chemistry Tier 3 serving labels, batch 2/2.
-- Generated from /private/tmp/cramapple-math-taxonomy-serving/model_results.json.
-- Run ID: serving-units-mcp-2026-09-25-20260925203431. Batch rows: 17.
-- Status counts: {"held":6,"provisional_model":11}.

begin;

create temporary table tmp_apchem_serving_labels (
  content_key text not null,
  content_item_id uuid not null,
  validated_against_version_id uuid not null,
  validated_against_taxo_hash text not null,
  required_units integer[] not null,
  primary_unit integer,
  required_units_by_criterion jsonb,
  taxonomy_source_version uuid not null,
  label_status text not null,
  source_payload jsonb not null,
  model_run_id text not null,
  input_packet_hash text not null
) on commit drop;

insert into tmp_apchem_serving_labels (
  content_key, content_item_id, validated_against_version_id,
  validated_against_taxo_hash, required_units, primary_unit,
  required_units_by_criterion, taxonomy_source_version, label_status,
  source_payload, model_run_id, input_packet_hash
) values
  ('apchem-mcq-070', '3df565da-d28b-40be-b4a2-03e4121c9e03'::uuid, '701f1361-022e-4827-820b-60359240f885'::uuid, 'c007b5875bc0486ce293f1041aa4fba2aac25f6856f1afbf8a9fed26e21645c4', '{}'::integer[], null, null, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'held', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"model_unit_disagreement","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', 'be586b056babbb825aac2591024fd91f9859a9628385cfccf800494d132e800b'),
  ('apchem-sfrq-008', 'a1c5a615-6a76-4145-b826-2ac126f8a334'::uuid, 'a27211e9-475b-4f75-a9af-b3549bbd9bf0'::uuid, 'a575b6bdcd2ad91122aef967094e72edcf901d841f5a3be7ef727fc95feb686d', array[7]::integer[], 7, '[{"criterion_key":"part-a","units":[7],"evidence":"Requires writing a Ksp expression for MX(s) ⇌ M+(aq) + X-(aq) and calculating molar solubility from Ksp = s^2, which is Unit 7 solubility equilibria."},{"criterion_key":"part-b","units":[7],"evidence":"Requires recognizing the no-common-ion/no-side-reaction assumption needed for the solubility-equilibrium substitution [M+] = [X-] = s."},{"criterion_key":"part-c","units":[7],"evidence":"Requires calculating molar solubility in the presence of a common ion using Ksp = s(0.010 + s) and justifying the small-s approximation, which is Unit 7 common-ion effect/solubility equilibria."},{"criterion_key":"part-d","units":[7],"evidence":"Requires comparing Qsp to Ksp after adding X- and predicting precipitation until equilibrium is restored, which is Unit 7 reaction quotient and common-ion solubility reasoning."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '2a10c5d4485078934c406768f3894c4c64313142383c18fc8bfa61f9c94c0374'),
  ('apchem-sfrq-009', '3c95e382-5798-4075-bcfc-daaee60b3aed'::uuid, 'fcf5a47f-ff2e-470f-987a-160cd9ccd103'::uuid, 'b95ad54a7d816853235dfe789399de16e1231b1494e2cfb3720af8b015ca5c72', array[8]::integer[], 8, '[{"criterion_key":"part-a","units":[8],"evidence":"Calculating [H+] from Ka and initial weak-acid concentration and converting to pH are Unit 8 weak acid/base and pH skills."},{"criterion_key":"part-b","units":[8],"evidence":"Using Ka = [H3O+][A-]/[HA] for a weak acid, simplifying with the small-x approximation, and neglecting water autoionization are Unit 8 acid-base equilibrium skills."},{"criterion_key":"part-c","units":[8],"evidence":"Percent ionization of a weak acid and using it to validate the small-x approximation are part of Unit 8 weak acid equilibrium calculations."},{"criterion_key":"part-d","units":[8],"evidence":"Solving the weak-acid equilibrium without the small-x approximation and explaining approximation failure using percent ionization are Unit 8 weak acid equilibrium skills."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '64338407b5dc5f8779d6a9313e3532ca39dc1ac616b190791ea7f04380d72fc0'),
  ('apchem-sfrq-010', '797a4515-b9eb-49bc-9a26-dec105f8b04d'::uuid, 'eb3bcc60-27cc-4272-8e62-f14fc274c462'::uuid, '2aad81f6b0b8a45dae1444f6f580e7cbbae82faa3c23268f185d31ab26b70e8f', '{}'::integer[], null, null, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'held', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"model_unit_disagreement","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '3a789f29a43ff48db1eb6ecf9d888031c662fbf4586893d9ccd3e045c3d988ff'),
  ('apchem-sfrq-015', 'e39859fa-3108-4bc7-a155-c45ff3c4f185'::uuid, '4bf75a1d-647f-4737-ba8e-14f0467251da'::uuid, '769956a42650f051ceb61002556f8347266f843d88fd2c051a5ffd8f8eeea51e', '{}'::integer[], null, null, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'held', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"model_unit_disagreement","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '93302374fe5cafee389dd4b7fc1b4501ba56f3932dcb7d4bf75aa7e035dacbbc'),
  ('apchem-sfrq-016', '99b58265-c3e3-45a1-a704-fe396239bcfb'::uuid, '821308d5-a28b-4adf-9400-fe0e5444fcc1'::uuid, '637bcff82315f28b935c066e198feea105bfc788a97eb577db111d495a701ef3', array[3]::integer[], 3, '[{"criterion_key":"a1","units":[3],"evidence":"Identifying London dispersion forces in propane and hydrogen bonding in 1-propanol is Unit 3 intermolecular/interparticle forces."},{"criterion_key":"a2","units":[3],"evidence":"Explaining the higher boiling point of 1-propanol using hydrogen bonding versus acetone dipole-dipole forces requires Unit 3 intermolecular-force and boiling-point reasoning."},{"criterion_key":"a3","units":[3],"evidence":"Predicting a higher boiling point for 1-chloropropane based on stronger London dispersion forces/polarizability and dipole-dipole forces is Unit 3 intermolecular-force property reasoning."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '2ce2fc8b7fa74bbbd75d269a3baa0638a70cf5e3ce519efa6cb71cc2cc3f5598'),
  ('apchem-sfrq-019', '9cffbe88-8573-4b58-a80e-d57d0a28e087'::uuid, '13e1e478-65ba-417e-8838-dbdc10f49fd7'::uuid, '9c36a3faeb2f4c5508acccc2a2c5b4c9dde2995a269cd48c2970672b5cbdd9ba', array[1,3]::integer[], 3, '[{"criterion_key":"a1","units":[1],"evidence":"Calculating moles from mass using molar mass is Unit 1 content, specifically moles and molar mass."},{"criterion_key":"a2","units":[3],"evidence":"Calculating molarity from moles of solute and liters of solution is Unit 3 content on solutions and mixtures."},{"criterion_key":"b1","units":[3],"evidence":"Explaining a homogeneous solution as uniformly dispersed particles with consistent composition throughout is Unit 3 solution/mixture content."},{"criterion_key":"c1","units":[3],"evidence":"Identifying solute and solvent in an aqueous solution is Unit 3 solution/mixture content."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '79109048d1998fbbc108592dec4d29441ae8a368e2e10e9ed6f6bd3104eff7cd'),
  ('apchem-sfrq-021', '481ae433-b678-424d-acee-1cf3c4dd6e0c'::uuid, '68911f4e-34a0-4643-a3d6-cdbd8e6d4c56'::uuid, '5cc565f9968bf6f13d7fe79bb2d397eeba346d64a3a772b316a37f59fa655a07', array[4]::integer[], 4, '[{"criterion_key":"part-a","units":[4],"evidence":"Writing a balanced molecular equation with states for a precipitation reaction is Chemical Reactions content: symbolic reaction representation, balancing, and reaction types."},{"criterion_key":"part-b","units":[4],"evidence":"Writing complete and net ionic equations, dissociating soluble ionic compounds, canceling spectator ions, and preserving charges/states are Unit 4 Chemical Reactions skills."},{"criterion_key":"part-c","units":[4],"evidence":"Identifying spectator ions from the complete ionic equation is part of net ionic equation reasoning in Unit 4."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '9b35cb02ffcc0008ba41902d2639cf62023eef545cd23cde7e504964474f1cf5'),
  ('apchem-sfrq-022', '39f44e65-eb02-4a05-ad30-2ef4b474f0b7'::uuid, 'ec78ebda-140d-4cdf-a847-58f674a2b0ac'::uuid, 'b31ef6e68f7d5630146bb3ef52d343268af4601d350fbbf0c0d1e39fc27a236d', '{}'::integer[], null, null, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'held', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"model_call_failure","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '1b5e5e480229c4a9860d63f485e7e036810551e5890aa0e83311c6f96d6a5999'),
  ('apchem-sfrq-026', '812f202b-f3c8-4749-92bd-52b07c373da8'::uuid, 'ff4f8f58-a294-431c-ad5c-dcb3c43faa88'::uuid, '2d1f5f3dec923f84c7fe110373f4577ff7b741f7126ae4e453c338661a839cd0', array[6,9]::integer[], 6, '[{"criterion_key":"part-a","units":[6],"evidence":"Identifying dissolution as endothermic from a temperature decrease is Unit 6 thermochemistry content on endothermic/exothermic processes."},{"criterion_key":"part-a-2","units":[6],"evidence":"Justification requires connecting the colder test tube to heat transfer from surroundings into the dissolving system, which is Unit 6 thermochemistry."},{"criterion_key":"part-b","units":[6],"evidence":"Explaining that surroundings lose thermal energy to the dissolution process and therefore decrease in temperature is Unit 6 heat-transfer/thermochemistry reasoning."},{"criterion_key":"part-c","units":[9],"evidence":"Explaining why an endothermic process is thermodynamically favored requires entropy reasoning and the Gibbs free energy relationship ΔG = ΔH − TΔS, which is Unit 9 thermodynamics."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', 'c79b517c5e49f9b74fe97295b890463871faf3d77a1aa30cd1fbe902a7e28ca8'),
  ('apchem-sfrq-027', '8a8edfd3-2061-4415-b74b-c464121f25a9'::uuid, '9e108bd0-8fd6-4b3b-96e8-b3b4c45cdfe7'::uuid, '065368c5c9585c053b7d0a5448862af1f98edc90006ece08ab369194a54c3858', '{}'::integer[], null, null, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'held', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"model_unit_disagreement","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '01fd6a80c36f47b5e5bbb39e8fa920ba0f81076d5ff0fdee2f7fbf9d3d354806'),
  ('apchem-sfrq-028', 'c8311138-03b8-482c-a185-a7323e2dfa03'::uuid, '957fab7f-2e87-4ed8-b622-4c7577a9f6ec'::uuid, 'e7ef54fb212a68688efe73573b388144bea5e45917e051be8665f49aab1d32da', array[6]::integer[], 6, '[{"criterion_key":"a1","units":[6],"evidence":"Requires using average bond enthalpies to account for energy added to break reactant bonds, which is Unit 6 Thermochemistry, especially bond enthalpies."},{"criterion_key":"a2","units":[6],"evidence":"Requires treating bond formation as energy release and combining bonds broken and formed to estimate deltaH(rxn), a Unit 6 bond-enthalpy calculation."},{"criterion_key":"b1","units":[6],"evidence":"Requires interpreting a negative deltaH(rxn) as exothermic and relating enthalpy to relative bond strengths, which is Unit 6 Thermochemistry."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '2d77f01e3cf5c391c242140f4f4bc1a86b7d8b12510b1aeaabbc864b09465380'),
  ('apchem-sfrq-029', '96d33a6d-5313-4613-8ab7-255a8b17743b'::uuid, 'cdf6838f-bace-4812-bf63-c7e4046d9a02'::uuid, 'e6fa5dfbd737288fcfaa19e0d61faa4e4014a2d4e98ffab0b71fb38f11817f6f', array[7,8]::integer[], 7, '[{"criterion_key":"a1","units":[7],"evidence":"Requires writing the Ksp expression for Mg(OH)2 and calculating molar solubility from Ksp, which is Unit 7 solubility equilibria."},{"criterion_key":"a2","units":[7,8],"evidence":"Requires qualitative pH-and-solubility reasoning for a hydroxide salt: lowering pH consumes OH-, increasing dissolution. The pH-solubility relationship is Unit 8, while the explanation uses Le Chatelier/equilibrium-shift reasoning from Unit 7."},{"criterion_key":"a3","units":[7],"evidence":"Requires recognizing the common-ion effect from added Mg2+ and predicting a shift toward solid Mg(OH)2, decreasing molar solubility; this is Unit 7 common-ion/solubility-equilibrium content."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '840038e26d697e8b0a9af4e863b6ab07908b6919b99d2dcb7feb4badd65b96e4'),
  ('apchem-sfrq-033', '32c26e30-7d6e-4de3-a3ea-36816fc8abe5'::uuid, '1a1dabae-dd39-46d1-aeea-ac295a47c20f'::uuid, 'c8cb9e65425580629732bfbaeb5825fcb27685024bfdd3762108322a99e85709', '{}'::integer[], null, null, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'held', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"model_unit_disagreement","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '03fcecbbfba1ac85b8aac08c9e750689dddc02ef4f0d40c7a220b6adff1b7f3e'),
  ('apchem-sfrq-034', 'bdfadf49-6212-4519-b591-29913a8d5f8e'::uuid, 'c2cdb4ce-279a-4427-8cf0-b23d0d6a0771'::uuid, '79a36b49f66c1eff0286a50ea307c925428fef6c422eed92062038c94e49b211', array[8]::integer[], 8, '[{"criterion_key":"a1","units":[8],"evidence":"Requires use of the Henderson-Hasselbalch relationship to determine that when pH equals pKa, the conjugate base to acid ratio is 1."},{"criterion_key":"b1","units":[8],"evidence":"Requires qualitative acid-base reasoning that when pH is less than pKa, the protonated weak acid form predominates."},{"criterion_key":"b2","units":[8],"evidence":"Requires relating pH minus pKa to the conjugate base to acid ratio or an equivalent qualitative pH/pKa justification."},{"criterion_key":"c1","units":[8],"evidence":"Requires the general acid-base rule connecting pH relative to pKa with whether the acid form, conjugate base form, or equal concentrations predominate."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '5ba562971a50be25e97457798e699671117416b70ce52e35c12b69cfb11cb36e'),
  ('apchem-sfrq-036', 'f8e8cc4b-d545-4a92-a959-1d3817ffe9a7'::uuid, '2f38ca1e-55d2-45a3-9bfd-16b26d8942ad'::uuid, '3e8cb7076c95646dd9b43d7362a9ad49420f1742db2c48c48bc3252f4dd98680', array[9]::integer[], 9, '[{"criterion_key":"a1","units":[9],"evidence":"Predicting the sign of ΔS° for dissolution requires entropy reasoning, which is Unit 9."},{"criterion_key":"a2","units":[9],"evidence":"Justifying entropy increase by particle dispersal before and after dissolution is Unit 9 entropy reasoning."},{"criterion_key":"b1","units":[9],"evidence":"Using ΔG° = ΔH° − TΔS° to explain thermodynamic favorability is Unit 9 Gibbs free energy and thermodynamic favorability."},{"criterion_key":"b2","units":[9],"evidence":"Concluding ΔG° < 0 and thermodynamic favorability from the Gibbs relationship is Unit 9."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '7f43bb75825a733797a639f6456709a6fc94ebfcc66a16810521e8bd2e7dae37'),
  ('apchem-sfrq-037', 'b7f2d24a-383d-4a4d-86f3-6f1ec5fcd7c7'::uuid, 'ebccd150-e943-4784-8e29-1f07017181bd'::uuid, '56eaf2b875cff608820d288e94a988cbc42c81713ddf7e2f97b73b6cf9177ca7', array[9]::integer[], 9, '[{"criterion_key":"part-a","units":[9],"evidence":"Calculating Ecell from standard reduction potentials and identifying cathode/anode roles in a galvanic cell are Unit 9 electrochemistry skills."},{"criterion_key":"part-b","units":[9],"evidence":"Identifying n for use in deltaG = -nFE is part of Unit 9 cell potential/free energy reasoning."},{"criterion_key":"part-b-2","units":[9],"evidence":"Calculating deltaG from deltaG = -nFE is explicitly Unit 9 cell potential and free energy content."},{"criterion_key":"part-c","units":[9],"evidence":"Relating negative deltaG to thermodynamic favorability and positive Ecell to favorable galvanic-cell behavior is Unit 9 thermodynamics/electrochemistry."}]'::jsonb, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional_model', '{"run_id":"serving-units-mcp-2026-09-25-20260925203431","reason":"two_model_unit_agreement_no_usable_legacy","scope":"serving_only","coverage_deferred":true,"model_results_file":"/private/tmp/cramapple-math-taxonomy-serving/model_results.json"}'::jsonb, 'serving-units-mcp-2026-09-25-20260925203431', '55879d1444c660f3227c446a7a66f7166c537b04cef095f31bcfb714c798cdf4');

do $$
declare
  v_expected int := 17;
  v_rows int;
  v_bad_live int;
  v_prior int;
begin
  select count(*) into v_rows from tmp_apchem_serving_labels;
  if v_rows <> v_expected then
    raise exception 'AP Chemistry labels batch 2: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_bad_live
  from tmp_apchem_serving_labels tmp
  where not exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.content_item_versions civ on civ.id = tmp.validated_against_version_id
      and civ.content_item_id = ci.id
    where ci.id = tmp.content_item_id
      and ci.content_key = tmp.content_key
      and ep.exam_code = 'ap_chemistry'
      and epv.retired_at is null
      and ci.status = 'published'
      and civ.status = 'published'
  );
  if v_bad_live <> 0 then
    raise exception 'AP Chemistry labels batch 2: % rows do not belong to published live AP Chemistry content', v_bad_live;
  end if;

  select count(*) into v_prior
  from app.content_taxonomy_labels existing
  join tmp_apchem_serving_labels tmp on tmp.content_item_id = existing.content_item_id
  where existing.model_run_id = 'serving-units-mcp-2026-09-25-20260925203431';
  if v_prior <> 0 then
    raise exception 'AP Chemistry labels batch 2: % rows already exist for run serving-units-mcp-2026-09-25-20260925203431', v_prior;
  end if;
end $$;

with numbered as (
  select
    tmp.*,
    coalesce((
      select max(ctl.label_version)
      from app.content_taxonomy_labels ctl
      where ctl.content_item_id = tmp.content_item_id
        and ctl.label_scope = 'serving'
    ), 0) + 1 as next_label_version
  from tmp_apchem_serving_labels tmp
), inserted as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, validated_against_version_id,
    validated_against_taxo_hash, required_units, primary_unit,
    required_units_by_criterion, taxonomy_source_version, taxonomy_confidence,
    label_status, source, source_payload, model_run_id, input_packet_hash
  )
  select
    content_item_id, next_label_version, 'serving', validated_against_version_id,
    validated_against_taxo_hash, required_units, primary_unit,
    required_units_by_criterion, taxonomy_source_version, 'verified',
    label_status, 'vercel_ai_gateway_two_model_serving_lane',
    source_payload, model_run_id, input_packet_hash
  from numbered
  returning content_taxonomy_label_id, content_item_id
)
update app.content_taxonomy_labels old
set superseded_by = inserted.content_taxonomy_label_id
from inserted
where old.content_item_id = inserted.content_item_id
  and old.label_scope = 'serving'
  and old.superseded_by is null
  and old.content_taxonomy_label_id <> inserted.content_taxonomy_label_id;

commit;
