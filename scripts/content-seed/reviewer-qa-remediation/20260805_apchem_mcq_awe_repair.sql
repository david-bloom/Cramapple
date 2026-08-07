-- AP Chemistry MCQ AWE blocker repairs, 2026-08-05.
-- Explicit owner approval in chat:
-- "Create and apply a reviewed SQL remediation file that repairs the 41 AP
-- Chemistry MCQ approve-with-edits blockers with item-specific edits, adds
-- owner/admin QA approvals to the repaired successor versions, and publishes
-- the versions that pass structural QA gates in Production project
-- pcntajvbdfqhbeewmdry."

begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-mcq-awe-repair-20260805'));

create temporary table repair_targets (
  content_key text primary key,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

insert into repair_targets values
('apchem-mcq-003','f4a5d849-2d1b-4b54-b67f-10a96db13476'::uuid,gen_random_uuid()),
('apchem-mcq-005','1afd984f-19d9-43af-ac78-f333ef19e6fe'::uuid,gen_random_uuid()),
('apchem-mcq-006','98d7f865-9e09-4e21-b53f-e1fc2ddcfc49'::uuid,gen_random_uuid()),
('apchem-mcq-007','b3c3b230-1ac4-4f66-be3a-182283de7994'::uuid,gen_random_uuid()),
('apchem-mcq-008','fba19e78-fecf-4143-bbe7-7b181287cced'::uuid,gen_random_uuid()),
('apchem-mcq-011','13cb644b-1f53-40ac-8394-c50ee23ba228'::uuid,gen_random_uuid()),
('apchem-mcq-012','be58587e-930c-42de-b17e-5483781885eb'::uuid,gen_random_uuid()),
('apchem-mcq-017','5953366a-24b2-4f6b-b391-d9841b03a85b'::uuid,gen_random_uuid()),
('apchem-mcq-018','75651717-fbcc-42ab-afb2-555e7b9f3629'::uuid,gen_random_uuid()),
('apchem-mcq-019','718eb3a6-aeb7-44b8-81ad-9b2cb8237e71'::uuid,gen_random_uuid()),
('apchem-mcq-020','c76dcbbb-0d43-4c33-934b-04d8307f3466'::uuid,gen_random_uuid()),
('apchem-mcq-021','edf85fd7-01aa-4c90-a06b-06134cffc689'::uuid,gen_random_uuid()),
('apchem-mcq-022','d7e006a8-eed4-42b6-a8f2-9f12ccaffbd4'::uuid,gen_random_uuid()),
('apchem-mcq-023','8e7d93ba-6d85-4820-befc-f00e5d6638cb'::uuid,gen_random_uuid()),
('apchem-mcq-024','bce2d3b1-4349-4971-bb62-aae4d27507f9'::uuid,gen_random_uuid()),
('apchem-mcq-025','dd29e597-5edf-4ce0-98ef-5fc57e5402c6'::uuid,gen_random_uuid()),
('apchem-mcq-027','5a85393c-c269-44de-9aab-7fee23f9ebd2'::uuid,gen_random_uuid()),
('apchem-mcq-028','f58361c8-4d89-4775-b85f-a0d522d8baa4'::uuid,gen_random_uuid()),
('apchem-mcq-033','0e0d567a-6e23-4202-8e7e-6e6137f4e0a0'::uuid,gen_random_uuid()),
('apchem-mcq-034','2acf261a-ab29-4924-9cfc-790cfbcb3b29'::uuid,gen_random_uuid()),
('apchem-mcq-035','df9a33ee-9e75-41c1-818d-97ef3d0ea7fe'::uuid,gen_random_uuid()),
('apchem-mcq-037','3d79e1d3-7a05-410f-82eb-83559e24f47f'::uuid,gen_random_uuid()),
('apchem-mcq-039','c0c661e8-e094-4154-91f0-3fd5c4c843dc'::uuid,gen_random_uuid()),
('apchem-mcq-042','fcfd7773-2ce7-4a83-ba15-8972fdb4e391'::uuid,gen_random_uuid()),
('apchem-mcq-043','77a37658-4820-4fb2-b17d-328d37b7a983'::uuid,gen_random_uuid()),
('apchem-mcq-044','a9055bbf-5245-42a5-af18-e19a07128ff5'::uuid,gen_random_uuid()),
('apchem-mcq-046','7f28faa2-122d-4592-ad3a-c28ceaf2e656'::uuid,gen_random_uuid()),
('apchem-mcq-049','2995a533-849e-414b-bf22-85136236505f'::uuid,gen_random_uuid()),
('apchem-mcq-051','d3877da2-0e81-45f4-ac29-5ebf4163503e'::uuid,gen_random_uuid()),
('apchem-mcq-052','687b1ed3-7d7d-4df8-bb93-2559aef463eb'::uuid,gen_random_uuid()),
('apchem-mcq-053','40de7bdf-149a-4938-92f4-1811d5d3b66a'::uuid,gen_random_uuid()),
('apchem-mcq-055','5283e6ae-3003-4043-8d92-6845831b270e'::uuid,gen_random_uuid()),
('apchem-mcq-056','216d2b15-91ba-4f6f-95ff-591916a66ef0'::uuid,gen_random_uuid()),
('apchem-mcq-057','91175d64-1047-422f-b95f-847bd1bbb38e'::uuid,gen_random_uuid()),
('apchem-mcq-059','76efb941-7aa7-4dd4-8789-5c3b0dfe13a9'::uuid,gen_random_uuid()),
('apchem-mcq-061','9750d8e4-7442-4714-ae49-054c3f43d2eb'::uuid,gen_random_uuid()),
('apchem-mcq-062','e9969b03-000f-4a57-b041-df0d485d86b1'::uuid,gen_random_uuid()),
('apchem-mcq-063','e287ea02-e1f6-416a-9d96-18f6a3452d41'::uuid,gen_random_uuid()),
('apchem-mcq-066','eef6ee2e-e2ad-45ae-9113-d822cf0529b3'::uuid,gen_random_uuid()),
('apchem-mcq-067','e0ce01af-a2d3-4e2c-93bf-9495ffa496f8'::uuid,gen_random_uuid()),
('apchem-mcq-069','c4bc2680-1176-42b5-87fb-76a045791003'::uuid,gen_random_uuid());

create temporary table repaired (
  content_key text primary key,
  old_version_id uuid not null,
  new_version_id uuid not null,
  source_decision_id uuid not null,
  assignment_id uuid not null
) on commit drop;

do $$
declare
  t record;
  v_item app.content_items%rowtype;
  v_old app.content_item_versions%rowtype;
  v_new uuid;
begin
  for t in select * from repair_targets order by content_key loop
    select * into strict v_item
    from app.content_items
    where content_key=t.content_key and item_type='mcq'
    for update;

    select * into strict v_old
    from app.content_item_versions
    where content_item_id=v_item.id
      and status='reviewed_approved'
      and not exists (
        select 1 from app.content_item_versions newer
        where newer.content_item_id=app.content_item_versions.content_item_id
          and newer.version_num>app.content_item_versions.version_num
      )
    order by version_num desc, created_at desc
    limit 1
    for update;

    v_new := gen_random_uuid();

    update app.content_review_assignments
    set status='skipped'
    where content_item_version_id=v_old.id
      and assignment_purpose='subject_review'
      and status in ('pending','in_progress');

    update app.content_item_versions
    set status='retired', updated_at=now()
    where id=v_old.id;

    update app.content_items
    set status='draft', updated_at=now()
    where id=v_item.id;

    insert into app.content_item_versions (
      id,content_item_id,version_num,stem,stimulus,prompt_json,
      explanation,help_text,content_hash,status,created_by,
      canonical_answer_1,canonical_answer_2,review_status,
      rubric_type,evaluator_strategy,stimulus_image_path
    ) values (
      v_new,v_item.id,v_old.version_num+1,v_old.stem,v_old.stimulus,
      coalesce(v_old.prompt_json,'{}'::jsonb) || jsonb_build_object(
        'content_version',v_old.version_num+1,
        'qa_remediation','2026-08-05 AP Chemistry MCQ AWE repair',
        'qa_source_decision_id',t.source_decision_id
      ),
      v_old.explanation,v_old.help_text,md5(coalesce(v_old.stem,'')),
      'draft','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
      v_old.canonical_answer_1,v_old.canonical_answer_2,null,
      v_old.rubric_type,v_old.evaluator_strategy,v_old.stimulus_image_path
    );

    insert into app.mcq_choices (
      content_item_version_id,choice_key,choice_text,is_correct,rationale
    )
    select v_new,choice_key,choice_text,is_correct,rationale
    from app.mcq_choices
    where content_item_version_id=v_old.id;

    insert into repaired values (t.content_key,v_old.id,v_new,t.source_decision_id,t.assignment_id);
  end loop;
end $$;

-- Per-item repairs.
update app.mcq_choices m set rationale='Correct. BF3 has three bonding regions and no lone pair on boron, giving trigonal planar molecular geometry.'
from repaired r where r.content_key='apchem-mcq-003' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

update app.content_item_versions civ set stem=replace(stem,'average molecular speed','average particle speed')
from repaired r where r.content_key='apchem-mcq-005' and civ.id=r.new_version_id;
update app.mcq_choices m set rationale=replace(replace(rationale,'rms speed','average speed'),'molecular speed','particle speed')
from repaired r where r.content_key='apchem-mcq-005' and m.content_item_version_id=r.new_version_id;

update app.content_item_versions civ set stem=stem || E'\n\nAssume the diluted solution is measured at the same wavelength in the same 1.0 cm cell and remains in the linear Beer-Lambert range.'
from repaired r where r.content_key='apchem-mcq-006' and civ.id=r.new_version_id;
update app.mcq_choices m set rationale='Correct. In the linear Beer-Lambert range with the same wavelength and path length, absorbance is directly proportional to concentration, so halving concentration halves absorbance from 0.60 to 0.30.'
from repaired r where r.content_key='apchem-mcq-006' and m.content_item_version_id=r.new_version_id and m.is_correct;

update app.content_item_versions civ set stem=replace(stem,'a gas in water','a nonreactive gas in water') || E'\nAssume pressure refers to the gas partial pressure above the solution.'
from repaired r where r.content_key='apchem-mcq-007' and civ.id=r.new_version_id;
update app.mcq_choices m set rationale='Incorrect. Raising temperature decreases gas solubility, and lowering the gas partial pressure also decreases dissolution.'
from repaired r where r.content_key='apchem-mcq-007' and m.content_item_version_id=r.new_version_id and m.choice_key='A';

update app.content_item_versions civ set stem=replace(stem,'At constant temperature','At constant temperature and fixed amount of gas')
from repaired r where r.content_key='apchem-mcq-008' and civ.id=r.new_version_id;
update app.mcq_choices m set rationale='Incorrect. This doubles the initial volume, as if the fourfold pressure increase caused a partial direct increase rather than the inverse Boyle-law decrease.'
from repaired r where r.content_key='apchem-mcq-008' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

update app.mcq_choices m set rationale=case m.choice_key
  when 'C' then 'Correct. For rate proportional to [A]^n, doubling [A] changes rate by 2^n. Since the rate quadruples, 2^n = 4 and n = 2.'
  when 'D' then 'Incorrect. Fourth order would make doubling [A] increase the rate by 2^4 = 16, not by 4.'
  else rationale end
from repaired r where r.content_key='apchem-mcq-011' and m.content_item_version_id=r.new_version_id and m.choice_key in ('C','D');

update app.mcq_choices m set choice_text='provides an alternative pathway with lower activation energy', rationale='Correct. A catalyst provides an alternative pathway with lower activation energy, increasing the fraction of collisions that can overcome the barrier while leaving Delta G and K unchanged.'
from repaired r where r.content_key='apchem-mcq-012' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.content_item_versions civ set stem=stem || E'\n\nAssume 25 C.'
from repaired r where r.content_key='apchem-mcq-017' and civ.id=r.new_version_id;
update app.mcq_choices m set rationale='Correct. HCl is a strong acid, so [H+] = 1.0 x 10^-3 M and pH = -log(1.0 x 10^-3) = 3.00.'
from repaired r where r.content_key='apchem-mcq-017' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

update app.mcq_choices m set choice_text='most of the added H+ remains free in solution', rationale='Incorrect. The conjugate base A- in the buffer consumes much of the added acid, limiting the increase in free H+.'
from repaired r where r.content_key='apchem-mcq-018' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.mcq_choices m set rationale='Correct. The conjugate base consumes added acid; in water this can be represented as A- + H3O+ -> HA + H2O.'
from repaired r where r.content_key='apchem-mcq-018' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

update app.mcq_choices m set choice_text=case m.choice_key when 'C' then 'Delta H < 0' when 'D' then 'Delta G = 0' else choice_text end,
  rationale=case m.choice_key
    when 'A' then 'Correct. Delta G < 0 indicates the forward process is thermodynamically favorable under the stated conditions; it does not indicate how fast the process occurs.'
    when 'C' then 'Incorrect. An exothermic enthalpy change can favor a process, but the criterion at constant temperature and pressure is Delta G < 0.'
    when 'D' then 'Incorrect. Delta G = 0 describes equilibrium, not a process that is thermodynamically favorable in the forward direction.'
    else rationale end
from repaired r where r.content_key='apchem-mcq-019' and m.content_item_version_id=r.new_version_id and m.choice_key in ('A','C','D');
update app.content_item_versions civ set stem=replace(replace(stem,'C. ΔH=0 always','C. Delta H < 0'),'D. ΔS=0 always','D. Delta G = 0')
from repaired r where r.content_key='apchem-mcq-019' and civ.id=r.new_version_id;

update app.mcq_choices m set rationale='Correct. Delta G standard = -nF Ecell standard, so a positive standard cell potential gives Delta G standard < 0 and a thermodynamically favorable reaction under standard conditions.'
from repaired r where r.content_key='apchem-mcq-020' and m.content_item_version_id=r.new_version_id and m.choice_key='C';

update app.mcq_choices m set rationale=case m.choice_key
  when 'A' then 'Incorrect. This divides by about double the given molar mass, producing too few moles.'
  when 'D' then 'Incorrect. This divides by about half the given molar mass, producing too many moles.'
  else rationale end
from repaired r where r.content_key='apchem-mcq-021' and m.content_item_version_id=r.new_version_id and m.choice_key in ('A','D');

update app.mcq_choices m set rationale='Incorrect. This is the configuration of Fe2+, obtained after removal of only the two 4s electrons; Fe3+ loses one additional 3d electron.'
from repaired r where r.content_key='apchem-mcq-022' and m.content_item_version_id=r.new_version_id and m.choice_key='A';

update app.mcq_choices m set rationale=case m.choice_key
  when 'C' then 'Incorrect. Silicon would have 14 total electrons and an additional 3p peak beyond the 1s, 2s, 2p, and 3s peaks shown.'
  when 'D' then 'Incorrect. Sodium would have a final 3s peak area of 1, but the observed final peak area is 2.'
  else rationale end
from repaired r where r.content_key='apchem-mcq-023' and m.content_item_version_id=r.new_version_id and m.choice_key in ('C','D');

update app.mcq_choices m set choice_text=case m.choice_key
  when 'A' then 'Aluminum has greater nuclear charge, so its valence electron should always be harder to remove.'
  when 'D' then 'Aluminum''s lower ionization energy is explained by its larger atomic radius from magnesium to aluminum.'
  else choice_text end,
  is_correct=(m.choice_key='B'),
  rationale=case m.choice_key
    when 'A' then 'Incorrect. This applies the general nuclear-charge trend but ignores the Mg-Al subshell exception involving removal of a higher-energy 3p electron from Al.'
    when 'B' then 'Correct. Magnesium ends in a filled 3s subshell, while aluminum''s first removed electron is a higher-energy 3p electron that is less penetrating and more shielded, so it is easier to remove.'
    when 'D' then 'Incorrect. Atomic radius does not increase from Mg to Al; the anomaly is due to the 3p versus 3s subshell-energy and shielding comparison.'
    else rationale end
from repaired r where r.content_key='apchem-mcq-024' and m.content_item_version_id=r.new_version_id and m.choice_key in ('A','B','D');
update app.content_item_versions civ set stem=replace(replace(stem,'B. Magnesium''s 3s² subshell is completely filled, giving it extra stability, while aluminum''s outermost electron occupies the higher-energy 3p subshell, which is shielded by the filled 3s² subshell and thus more easily removed.','B. Magnesium ends in a filled 3s subshell, while aluminum''s first removed electron is a higher-energy 3p electron that is less penetrating and more shielded, so it is easier to remove.'),'D. Aluminum''s increased nuclear charge pulls its 3s electrons closer to the nucleus, which destabilizes the 3p electron and causes it to be lost first.','D. Aluminum''s lower ionization energy is explained by its larger atomic radius from magnesium to aluminum.')
from repaired r where r.content_key='apchem-mcq-024' and civ.id=r.new_version_id;

update app.mcq_choices m set rationale=replace(rationale,'F can strip the valence electron from Cs','the large electronegativity difference favors substantial electron transfer from Cs to F and predominantly ionic bonding')
from repaired r where r.content_key='apchem-mcq-025' and m.content_item_version_id=r.new_version_id;

update app.mcq_choices m set rationale='Incorrect. Assigning four lone pairs to the singly bonded oxygen would give a formal charge of -3, not -2; the actual singly bonded oxygen has formal charge -1.'
from repaired r where r.content_key='apchem-mcq-027' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.content_item_versions civ set stem=replace(stem,'best represented by a resonance structure','represented by two equivalent resonance contributors')
from repaired r where r.content_key='apchem-mcq-027' and civ.id=r.new_version_id;

update app.content_item_versions civ set stem=replace(stem,'molecular-domain shape','molecular geometry')
from repaired r where r.content_key='apchem-mcq-028' and civ.id=r.new_version_id;
update app.mcq_choices m set rationale=replace(rationale,'distorted tetrahedron-like','seesaw')
from repaired r where r.content_key='apchem-mcq-028' and m.content_item_version_id=r.new_version_id;

update app.content_item_versions civ set stem=replace(stem,'He and O2 molecules','He atoms and O2 molecules')
from repaired r where r.content_key='apchem-mcq-033' and civ.id=r.new_version_id;
update app.mcq_choices m set choice_text=replace(choice_text,'He molecules','He atoms'), rationale=replace(rationale,'He molecules','He atoms')
from repaired r where r.content_key='apchem-mcq-033' and m.content_item_version_id=r.new_version_id;

update app.mcq_choices m set rationale='Incorrect. Lower temperature does not give attractions more time to act; lower average kinetic energy makes attractions and molecular volume more significant relative to ideal-gas assumptions.'
from repaired r where r.content_key='apchem-mcq-034' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

update app.mcq_choices m set choice_text=case m.choice_key
  when 'C' then 'Temperature breaks O2 molecules apart into atoms, so fewer O2 molecules remain dissolved.'
  when 'D' then 'The decrease is caused only by evaporation of water, which makes the remaining dissolved oxygen concentration appear lower.'
  else choice_text end,
  rationale=case m.choice_key
    when 'A' then 'Correct. Gas dissolution is generally exothermic; heating favors the gas phase and decreases dissolved O2 at constant O2 partial pressure.'
    when 'C' then 'Incorrect. The decrease in dissolved O2 is not due to dissociation into atoms under these conditions.'
    when 'D' then 'Incorrect. The main effect is the temperature-dependent gas-solution equilibrium, not simply water evaporation.'
    else rationale end
from repaired r where r.content_key='apchem-mcq-035' and m.content_item_version_id=r.new_version_id and m.choice_key in ('A','C','D');

update app.mcq_choices m set choice_text='UV photons have more energy because they have higher frequency, even though all electromagnetic radiation travels at the same speed in vacuum.', rationale='Incorrect. The first clause is true, but the explanation contradicts the choice: equal speed does not mean equal photon energy; energy depends on frequency.'
from repaired r where r.content_key='apchem-mcq-037' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.mcq_choices m set choice_text='0.167 M', rationale='Incorrect. This divides the original moles by only the volume of water added rather than by the final total solution volume.'
from repaired r where r.content_key='apchem-mcq-039' and m.content_item_version_id=r.new_version_id and m.choice_key='D';
update app.content_item_versions civ set stem=replace(stem,'D. 0.125 M','D. 0.167 M')
from repaired r where r.content_key='apchem-mcq-039' and civ.id=r.new_version_id;

update app.mcq_choices m set choice_text='H2O is the oxidizing agent because it supplies oxygen atoms to the reaction.', rationale='Incorrect. Oxidizing agents are identified by reduction/electron gain, not merely by supplying oxygen atoms.'
from repaired r where r.content_key='apchem-mcq-042' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.mcq_choices m set choice_text='Combustion, because CO2 is produced during heating.', rationale='Incorrect. Producing CO2 does not by itself make a reaction combustion; combustion requires reaction with O2 as a reactant.'
from repaired r where r.content_key='apchem-mcq-043' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.mcq_choices m set rationale='Incorrect. This assumes a 1 mol HCl : 2 mol NaOH stoichiometric ratio, effectively dividing the correct acid amount by two.'
from repaired r where r.content_key='apchem-mcq-044' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.mcq_choices m set choice_text='rate = k[X]^3', rationale='Incorrect. This incorrectly uses the overall order as an exponent on X instead of using the elementary-step molecularity rate = k[X]^2[Y].'
from repaired r where r.content_key='apchem-mcq-046' and m.content_item_version_id=r.new_version_id and m.choice_key='D';
update app.content_item_versions civ set stem=replace(stem,'D. rate = k([X]+[Y])','D. rate = k[X]^3')
from repaired r where r.content_key='apchem-mcq-046' and civ.id=r.new_version_id;

update app.content_item_versions civ set stem=replace(replace(stem,'25.0C','25.0 C'),'18.5C','18.5 C')
from repaired r where r.content_key='apchem-mcq-049' and civ.id=r.new_version_id;
update app.mcq_choices m set choice_text='The process is exothermic because the water temperature decreases as heat leaves the solution.', rationale='Incorrect. The temperature decrease shows the dissolution process absorbs heat from the solution; the solution cools because the process is endothermic.'
from repaired r where r.content_key='apchem-mcq-049' and m.content_item_version_id=r.new_version_id and m.choice_key='D';

update app.mcq_choices m set choice_text='+679 kJ/mol', rationale='Incorrect. This counts only the energy required to break H-H and Cl-Cl bonds, which is positive, and omits energy released when H-Cl bonds form.'
from repaired r where r.content_key='apchem-mcq-051' and m.content_item_version_id=r.new_version_id and m.choice_key='D';
update app.content_item_versions civ set stem=replace(stem,'D. -679 kJ/mol','D. +679 kJ/mol')
from repaired r where r.content_key='apchem-mcq-051' and civ.id=r.new_version_id;

update app.content_item_versions civ set stem=replace(replace(stem,'deltaHf','Delta Hf standard'),'deltaH','Delta H')
from repaired r where r.content_key='apchem-mcq-052' and civ.id=r.new_version_id;
update app.mcq_choices m set rationale=replace(rationale,'kJ/mol','kJ per mole of reaction as written')
from repaired r where r.content_key='apchem-mcq-052' and m.content_item_version_id=r.new_version_id;

update app.mcq_choices m set rationale='Correct. Reversing equation (2) gives CO2(g) -> CO(g) + 1/2 O2(g), Delta H = +283.0 kJ. Adding that to equation (1) gives Delta H = -393.5 + 283.0 = -110.5 kJ and cancels CO2 to give the target equation.'
from repaired r where r.content_key='apchem-mcq-053' and m.content_item_version_id=r.new_version_id and m.choice_key='A';

update app.mcq_choices m set choice_text='At equilibrium, the reaction strongly favors reactants.', rationale='Correct. A very small Kc means the equilibrium expression is small and the reaction strongly favors reactants; it is not a universal direct count of total product and reactant particles.'
from repaired r where r.content_key='apchem-mcq-055' and m.content_item_version_id=r.new_version_id and m.choice_key='B';

update app.mcq_choices m set choice_text='The reaction will proceed in the forward direction because Kc is less than 1.', rationale='Incorrect. Kc < 1 describes an equilibrium that favors reactants, but the direction of shift for a particular mixture is determined by comparing Qc with Kc.'
from repaired r where r.content_key='apchem-mcq-056' and m.content_item_version_id=r.new_version_id and m.choice_key='D';
update app.content_item_versions civ set stem=replace(stem,'D. The reaction will proceed in the forward direction because Q is less than K.','D. The reaction will proceed in the forward direction because Kc is less than 1.')
from repaired r where r.content_key='apchem-mcq-056' and civ.id=r.new_version_id;

update app.content_item_versions civ set stem=replace(stem,'Solid NaF is added','A small amount of soluble NaF is added') || E'\nAssume ideal solution behavior and no complex-ion formation.'
from repaired r where r.content_key='apchem-mcq-057' and civ.id=r.new_version_id;
update app.mcq_choices m set choice_text=case m.choice_key
  when 'A' then 'The molar solubility of CaF2 increases because Na+ removes F- from solution.'
  when 'D' then 'The molar solubility increases because Ksp must increase when more ions are added.'
  else choice_text end,
  rationale=case m.choice_key
    when 'A' then 'Incorrect. Na+ is a spectator ion here and does not remove F-; adding F- as a common ion suppresses CaF2 dissolution.'
    when 'D' then 'Incorrect. Ksp is constant at fixed temperature; the ion concentrations adjust instead.'
    else rationale end
from repaired r where r.content_key='apchem-mcq-057' and m.content_item_version_id=r.new_version_id and m.choice_key in ('A','D');

update app.content_item_versions civ set stem=replace(stem,'25C','25 C')
from repaired r where r.content_key='apchem-mcq-059' and civ.id=r.new_version_id;
update app.mcq_choices m set choice_text='11.00', rationale='Incorrect. This rounds the pH too coarsely to 3.00 before subtracting from 14.00, giving pOH = 11.00.'
from repaired r where r.content_key='apchem-mcq-059' and m.content_item_version_id=r.new_version_id and m.choice_key='C';
update app.content_item_versions civ set stem=replace(stem,'C. 11.60','C. 11.00')
from repaired r where r.content_key='apchem-mcq-059' and civ.id=r.new_version_id;

update app.content_item_versions civ set stem=stem || E'\n\nAssume 25 C and additive volumes.'
from repaired r where r.content_key='apchem-mcq-061' and civ.id=r.new_version_id;

update app.mcq_choices m set choice_text=case m.choice_key
  when 'C' then 'HOI, because iodine forms the strongest binary acid trend and that trend also applies to HOX acids.'
  when 'D' then 'HOBr, because bromine is between chlorine and iodine so it should have the intermediate but strongest balance of effects.'
  else choice_text end,
  rationale=case m.choice_key
    when 'C' then 'Incorrect. This confuses the acidity trend for binary hydrogen halides with the hypohalous acid trend, where electronegativity of X dominates.'
    when 'D' then 'Incorrect. Being intermediate does not make HOBr strongest; chlorine provides the strongest inductive stabilization in HOX acids.'
    else rationale end
from repaired r where r.content_key='apchem-mcq-062' and m.content_item_version_id=r.new_version_id and m.choice_key in ('C','D');

update app.content_item_versions civ set stem=replace(replace(replace(stem,'1.8x10^-5','1.8 x 10^-5'),'5.5x10^-10','5.5 x 10^-10'),'5.5x10^4','5.5 x 10^4')
from repaired r where r.content_key='apchem-mcq-063' and civ.id=r.new_version_id;
update app.mcq_choices m set rationale=case m.choice_key
  when 'C' then 'Incorrect. This treats 4.74 as pOH, giving pH = 9.26 and then Ka = 10^-9.26 = 5.5 x 10^-10.'
  else replace(replace(rationale,'1.8x10^-5','1.8 x 10^-5'),'10^-4.74','10^(-4.74)') end
from repaired r where r.content_key='apchem-mcq-063' and m.content_item_version_id=r.new_version_id;

update app.content_item_versions civ set stem=stem || E'\n\nAssume Delta H and Delta S remain approximately temperature-independent over the temperature range considered.'
from repaired r where r.content_key='apchem-mcq-066' and civ.id=r.new_version_id;

update app.content_item_versions civ set stem=replace(replace(replace(stem,'1 M','1.0 M'),'E(Cu2+/Cu)','E standard reduction (Cu2+/Cu)'),'E(Zn2+/Zn)','E standard reduction (Zn2+/Zn)')
from repaired r where r.content_key='apchem-mcq-067' and civ.id=r.new_version_id;

update app.content_item_versions civ set stem=replace(stem,'Ecell(standard)','E standard cell')
from repaired r where r.content_key='apchem-mcq-069' and civ.id=r.new_version_id;
update app.mcq_choices m set choice_text=replace(choice_text,'Ecell(standard)','E standard cell'),
  rationale=case when m.choice_key='C' then 'Incorrect. Standard potentials are fixed reference values, but the actual cell potential under nonstandard concentrations changes according to the Nernst equation.' else replace(rationale,'Ecell(standard)','E standard cell') end
from repaired r where r.content_key='apchem-mcq-069' and m.content_item_version_id=r.new_version_id;

update app.content_item_versions civ
set content_hash=md5(coalesce(civ.stem,'')||E'\n'||coalesce(civ.stimulus,'')||E'\n'||
  coalesce((select string_agg(m.choice_key||':'||m.choice_text||':'||m.is_correct::text||':'||coalesce(m.rationale,''), E'\n' order by m.choice_key)
            from app.mcq_choices m where m.content_item_version_id=civ.id),''))
from repaired r where civ.id=r.new_version_id;

insert into app.content_review_assignments (
  content_review_assignment_id, content_item_version_id, reviewer_id,
  review_stage, review_kind, status, assignment_purpose, created_by
)
select assignment_id,new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       'tutor_question','mcq','pending','owner_remediation_approval','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired;

insert into app.content_review_decisions (
  content_review_assignment_id,content_item_version_id,reviewer_id,
  supersedes_id,review_stage,tutor_score,difficulty_label,diagnostic_flag,
  concern_codes,note,topic_selections,tutor_decision,decision_payload,
  decision_hash,created_by
)
select r.assignment_id,r.new_version_id,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
       r.source_decision_id,'tutor_question',1,
       coalesce(src.difficulty_label,'Medium'),false,array[]::text[],
       'AP Chemistry MCQ approve-with-edits repair applied and owner QA verified.',
       src.topic_selections,'approve',
       jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_mcq_awe_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-05'),
       encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_mcq_awe_repair','source_review_decision_id',r.source_decision_id,'qa_date','2026-08-05')::text,'sha256'),'hex'),
       'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from repaired r
join app.content_review_decisions src on src.content_review_decision_id=r.source_decision_id;

create temporary table qa_blocked as
select r.content_key,
  case
    when nullif(trim(civ.stem),'') is null then 'blank stem'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
    when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
    when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
    when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
    when exists (select 1 from app.content_item_versions other where other.content_item_id=civ.content_item_id and other.id<>civ.id and other.status='published') then 'competing published version'
  end reason
from repaired r
join app.content_item_versions civ on civ.id=r.new_version_id;
delete from qa_blocked where reason is null;

create temporary table publish_set on commit drop as
select r.content_key, r.new_version_id
from repaired r
where not exists (select 1 from qa_blocked b where b.content_key=r.content_key);

update app.content_item_versions civ
set status='reviewed_approved',
    review_status='question_review_approved',
    approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
    approved_at=coalesce(civ.approved_at,now()),
    updated_at=now()
from publish_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='reviewed_approved', updated_at=now()
from publish_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

update app.content_item_versions civ
set status='published',
    review_status='question_review_approved',
    approved_by=coalesce(civ.approved_by,'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid),
    approved_at=coalesce(civ.approved_at,now()),
    published_at=coalesce(civ.published_at,now()),
    updated_at=now()
from publish_set p
where civ.id=p.new_version_id;

update app.content_items ci
set status='published', updated_at=now()
from publish_set p
join app.content_item_versions civ on civ.id=p.new_version_id
where ci.id=civ.content_item_id;

do $$
declare n integer;
begin
  select count(*) into n from repaired;
  if n<>41 then raise exception 'expected 41 repaired MCQs, got %', n; end if;
  select count(*) into n from (
    select content_item_id from app.content_item_versions where status='published'
    group by content_item_id having count(*)>1
  ) d;
  if n<>0 then raise exception 'duplicate published versions after MCQ repair: %', n; end if;
end $$;

select 'repaired_mcq' metric, count(*)::text value from repaired
union all select 'published_mcq', count(*)::text from publish_set
union all select 'qa_blocked', count(*)::text from qa_blocked
union all select 'blocked_keys', coalesce(string_agg(content_key||':'||reason, ', ' order by content_key),'') from qa_blocked
union all select 'published_keys', string_agg(content_key, ', ' order by content_key) from publish_set;

commit;
