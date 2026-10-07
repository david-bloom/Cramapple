-- Stem/choice cleanup 2026-10-06 -- DEV REHEARSAL (project wmgjsdkphcyhngaffbqf). ONE DO statement that ends in
-- RAISE EXCEPTION so that EVERYTHING (installed functions/trigger, seeded rows, updates) is rolled back; the result
-- JSON is carried in the exception message. Dev holds none of the 198 Production items and lacks the taxonomy-hash
-- cluster (taxonomy_relevant_hash, tg_content_versions_taxonomy_stale), so this block installs the Production
-- definitions verbatim (from prod_trigger_defs.json), seeds 14 snapshot rows with their Production ids, stems,
-- choices and label states, then EXECUTEs the same generated apply / review / rollback DO bodies as prod (target
-- lists restricted to the seeded rows; approval 'DEV-REHEARSAL') and checks the Production selector
-- public.select_unit_gated_practice_items (identical md5 in both projects).
do $reh$
declare
  v_prof uuid; rr jsonb; cc jsonb; v_apply text; res jsonb := '{}'::jsonb; v_upd timestamptz; n int;
begin
  select user_id into v_prof from app.profiles order by created_at limit 1;
CREATE OR REPLACE FUNCTION app.taxonomy_relevant_hash(_content_item_version_id uuid)
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
  select encode(
    extensions.digest(
      jsonb_build_object(
        'stem', civ.stem,
        'stimulus', civ.stimulus,
        'prompt_json', coalesce(civ.prompt_json, '{}'::jsonb)
          - 'modules'
          - 'subtopics',
        'canonical_answer_1', civ.canonical_answer_1,
        'canonical_answer_2', civ.canonical_answer_2,
        'mcq_choices', coalesce((
          select jsonb_agg(
            jsonb_build_object(
              'choice_key', mc.choice_key,
              'choice_text', mc.choice_text,
              'is_correct', mc.is_correct,
              'rationale', mc.rationale
            )
            order by mc.choice_key
          )
          from app.mcq_choices mc
          where mc.content_item_version_id = civ.id
        ), '[]'::jsonb),
        'frq_criteria', coalesce((
          select jsonb_agg(
            jsonb_build_object(
              'criterion_key', fc.criterion_key,
              'learner_facing_text', fc.learner_facing_text,
              'points_possible', fc.points_possible,
              'evidence_requirements', fc.evidence_requirements,
              'minimum_fix', fc.minimum_fix
            )
            order by fc.criterion_key
          )
          from app.frq_criteria fc
          where fc.content_item_version_id = civ.id
        ), '[]'::jsonb)
      )::text,
      'sha256'
    ),
    'hex'
  )
  from app.content_item_versions civ
  where civ.id = _content_item_version_id;
$function$;
CREATE OR REPLACE FUNCTION app.mark_content_taxonomy_labels_stale_for_version(_content_item_version_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_content_item_id uuid;
  v_taxo_hash text;
begin
  select civ.content_item_id, app.taxonomy_relevant_hash(civ.id)
    into v_content_item_id, v_taxo_hash
  from app.content_item_versions civ
  where civ.id = _content_item_version_id;

  if v_content_item_id is null or v_taxo_hash is null then
    return;
  end if;

  update app.content_taxonomy_labels ctl
  set label_status = 'stale'
  where ctl.content_item_id = v_content_item_id
    and ctl.superseded_by is null
    and ctl.label_status in ('validated', 'provisional_model')
    and ctl.validated_against_taxo_hash is distinct from v_taxo_hash;
end;
$function$;
CREATE OR REPLACE FUNCTION app.mark_content_taxonomy_labels_stale_from_version_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
begin
  perform app.mark_content_taxonomy_labels_stale_for_version(new.id);
  return new;
end;
$function$;
CREATE OR REPLACE FUNCTION app.set_content_taxonomy_label_derived_fields()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_max integer;
begin
  if new.label_scope = 'serving' then
    select max(unit_number)
      into v_max
    from unnest(new.required_units) as units(unit_number);
    new.max_required_unit := v_max;
  else
    new.required_units := '{}'::integer[];
    new.max_required_unit := null;
    new.primary_unit := null;
    new.required_units_by_criterion := null;
  end if;

  if new.label_status <> 'validated' then
    new.validated_by := null;
    new.validated_at := null;
    new.validation_decision_id := null;
  end if;

  return new;
end;
$function$;
CREATE OR REPLACE FUNCTION app.mark_content_taxonomy_labels_stale_from_child_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO 'pg_catalog'
AS $function$
declare
  v_content_item_version_id uuid;
begin
  if tg_op = 'DELETE' then
    v_content_item_version_id := old.content_item_version_id;
  else
    v_content_item_version_id := new.content_item_version_id;
  end if;

  perform app.mark_content_taxonomy_labels_stale_for_version(v_content_item_version_id);
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end;
$function$;
  CREATE TRIGGER tg_content_versions_taxonomy_stale AFTER INSERT OR UPDATE OF stem, stimulus, prompt_json, canonical_answer_1, canonical_answer_2 ON app.content_item_versions FOR EACH ROW EXECUTE FUNCTION app.mark_content_taxonomy_labels_stale_from_version_trigger();
  insert into app.home_release_manifest (exam_pack_version_id, allowed_unit_numbers)
  values ('b119fcbf-e665-41f6-8dce-ce6263a0f2b3', array[1,2,3,4,5,6,7,8,9,10,11,12,13,14])
  on conflict (exam_pack_version_id) do update set allowed_unit_numbers = excluded.allowed_unit_numbers;

  for rr in select * from jsonb_array_elements($seed$[{"ci": "61ac5c7b-bff8-413f-a62d-01a4c4e06c2f", "v": "d5ce86ce-69e0-4e02-80d6-12b2e47cfb19", "k": "apcalcab-mcq-021", "vn": 1, "rs": "question_review_approved", "stem": "What is lim(x→2) (x²−4)/(x−2)?\n\nA. 4\nB. 2\nC. 0\nD. The limit does not exist", "ch": [{"choice_key": "A", "choice_text": "4", "is_correct": true}, {"choice_key": "B", "choice_text": "2", "is_correct": false}, {"choice_key": "C", "choice_text": "0", "is_correct": false}, {"choice_key": "D", "choice_text": "The limit does not exist", "is_correct": false}], "lid": "f025c644-41bc-45d1-adcb-46753a328fe9", "lv": 2, "ls": "validated", "kind": "validated_fresh", "mu": 1, "vat": "2026-09-26T23:33:19.426331+00:00", "vdec": "fcf5aa98-aa67-4b76-8a14-8c6c9fd2b334"}, {"ci": "92c8a8ea-cbf1-4aaf-aed3-0f3203f4c0aa", "v": "84b735fd-c0c5-43e9-a061-3c1d49d6faa6", "k": "apcalcab-mcq-023", "vn": 1, "rs": "question_review_approved", "stem": "A function f is continuous on [1,4], with f(1)=−2 and f(4)=5. Which conclusion is guaranteed?\n\nA. f has an absolute minimum at x=1.\nB. There is a c in (1,4) with f′(c)=7/3.\nC. There is a c in (1,4) with f(c)=0.\nD. f is increasing on [1,4].", "ch": [{"choice_key": "A", "choice_text": "f has an absolute minimum at x=1.", "is_correct": false}, {"choice_key": "B", "choice_text": "There is a c in (1,4) with f′(c)=7/3.", "is_correct": false}, {"choice_key": "C", "choice_text": "There is a c in (1,4) with f(c)=0.", "is_correct": true}, {"choice_key": "D", "choice_text": "f is increasing on [1,4].", "is_correct": false}], "lid": "a9c1ef56-6c39-414c-b1b7-5f4f1c181f62", "lv": 2, "ls": "provisional_model", "kind": "provisional_model_fresh", "mu": 5, "vat": null, "vdec": null}, {"ci": "c2459b67-2ebb-4fac-8e8e-f03f86bcb940", "v": "c7d521ad-bc8a-404c-abd9-0e68350e7afd", "k": "apcalcbc-mcq-032", "vn": 1, "rs": "question_review_approved", "stem": "If f′(x)=x²(x−1)³(x+2)², which statement is true?\n\nA. f has local maxima at x=−2 and x=0, but no extremum at x=1.\nB. f has a local maximum at x=1 and no extrema at x=−2 or x=0.\nC. f has local minima at x=−2 and x=0, but no extremum at x=1.\nD. f has a local minimum at x=1 and no extrema at x=−2 or x=0.", "ch": [{"choice_key": "A", "choice_text": "f has local maxima at x=−2 and x=0, but no extremum at x=1.", "is_correct": false}, {"choice_key": "B", "choice_text": "f has a local maximum at x=1 and no extrema at x=−2 or x=0.", "is_correct": false}, {"choice_key": "C", "choice_text": "f has local minima at x=−2 and x=0, but no extremum at x=1.", "is_correct": false}, {"choice_key": "D", "choice_text": "f has a local minimum at x=1 and no extrema at x=−2 or x=0.", "is_correct": true}], "lid": "0fe7571a-b646-4ad7-ab79-654224ff5d29", "lv": 2, "ls": "held", "kind": "held_fresh", "mu": null, "vat": null, "vdec": null}, {"ci": "bfc233c8-149d-4a2b-b0d0-1728aeb3a5d0", "v": "76895682-1bb0-4be4-95d0-4a197edb866f", "k": "apchem-mcq-007", "vn": 2, "rs": "question_review_approved", "stem": "Which change most increases the solubility of a nonreactive gas in water?\n\nA. Raise temperature and lower pressure\nB. Raise temperature and raise pressure\nC. Lower temperature and raise pressure\nD. Lower temperature and lower pressure\nAssume pressure refers to the gas partial pressure above the solution.", "ch": [{"choice_key": "A", "choice_text": "Raise temperature and lower pressure", "is_correct": false}, {"choice_key": "B", "choice_text": "Raise temperature and raise pressure", "is_correct": false}, {"choice_key": "C", "choice_text": "Lower temperature and raise pressure", "is_correct": true}, {"choice_key": "D", "choice_text": "Lower temperature and lower pressure", "is_correct": false}], "lid": "de9fe517-63bb-4a8d-b81e-91ad7945a776", "lv": 3, "ls": "validated", "kind": "validated_fresh", "mu": 3, "vat": "2026-10-02T18:45:36.244497+00:00", "vdec": "0222037d-1e50-4fb5-ae18-6ee92af2c3db"}, {"ci": "5fbb2145-297c-49fe-ba1a-2311892bf572", "v": "ec5e88d3-622a-482a-b89d-cefc3cf7afd5", "k": "apchem-mcq-013", "vn": 1, "rs": "question_review_approved", "stem": "A 100 g metal absorbs 2.50 kJ and warms by 50.0°C. Its specific heat is\n\nA. 0.050 J g⁻¹°C⁻¹\nB. 0.500 J g⁻¹°C⁻¹\nC. 5.00 J g⁻¹°C⁻¹\nD. 50.0 J g⁻¹°C⁻¹", "ch": [{"choice_key": "A", "choice_text": "0.050 J g⁻¹°C⁻¹", "is_correct": false}, {"choice_key": "B", "choice_text": "0.500 J g⁻¹°C⁻¹", "is_correct": true}, {"choice_key": "C", "choice_text": "5.00 J g⁻¹°C⁻¹", "is_correct": false}, {"choice_key": "D", "choice_text": "50.0 J g⁻¹°C⁻¹", "is_correct": false}], "lid": "b1ffb2e2-60c9-4b74-a897-95d48ea9d8e5", "lv": 3, "ls": "validated", "kind": "validated_fresh", "mu": 6, "vat": "2026-09-24T18:07:09.591146+00:00", "vdec": "22805bc9-1394-4a51-b47e-4939a8c0dc7b"}, {"ci": "2138f053-3974-4645-b6aa-41a837e5d58f", "v": "9e7fff7f-3d3c-491a-9b12-4aaba7890769", "k": "apchem-mcq-014", "vn": 4, "rs": "question_review_approved", "stem": "If ΔH is negative for a process at constant pressure, the system\n\nA. absorbs heat\nB. releases heat\nC. must have greater entropy\nD. cannot be spontaneous", "ch": [{"choice_key": "A", "choice_text": "absorbs heat", "is_correct": false}, {"choice_key": "B", "choice_text": "releases heat", "is_correct": true}, {"choice_key": "C", "choice_text": "must have greater entropy", "is_correct": false}, {"choice_key": "D", "choice_text": "cannot be spontaneous", "is_correct": false}], "lid": "88ef9b87-742e-4582-a14b-1929e276ac42", "lv": 3, "ls": "held", "kind": "held_nonfresh", "mu": null, "vat": null, "vdec": null}, {"ci": "8feea5f3-5cbc-4e40-97f0-e06841ba35d6", "v": "1a1fb40c-1fb1-4127-bb24-9fd2ee067131", "k": "apchem-mcq-017", "vn": 2, "rs": "question_review_approved", "stem": "The pH of 1.0×10⁻³ M HCl is approximately\n\nA. 1.00\nB. 3.00\nC. 7.00\nD. 11.00\n\nAssume 25 C.", "ch": [{"choice_key": "A", "choice_text": "1.00", "is_correct": false}, {"choice_key": "B", "choice_text": "3.00", "is_correct": true}, {"choice_key": "C", "choice_text": "7.00", "is_correct": false}, {"choice_key": "D", "choice_text": "11.00", "is_correct": false}], "lid": "8923510b-df84-4fe6-84de-d77ee7ac2902", "lv": 2, "ls": "validated", "kind": "validated_fresh", "mu": 8, "vat": "2026-09-24T18:07:09.591146+00:00", "vdec": "9d683636-a1f9-42fd-9cb5-576088959376"}, {"ci": "6fc7e1c5-8d24-4276-8c37-b3145d3a3d6d", "v": "4d27c8d2-8521-4043-a254-09a6f5c85998", "k": "apchem-mcq-048", "vn": 1, "rs": "question_review_approved", "stem": "Which of the following correctly describes how a catalyst increases the rate of a chemical reaction?\n\nA. It increases the average kinetic energy of the reactant molecules, so more collisions occur per second.\nB. It provides an alternative reaction pathway with a lower activation energy, increasing the fraction of collisions with sufficient energy to react.\nC. It shifts the reaction equilibrium further toward products.\nD. It increases the magnitude of deltaH, making the reaction more exothermic.", "ch": [{"choice_key": "A", "choice_text": "It increases the average kinetic energy of the reactant molecules, so more collisions occur per second.", "is_correct": false}, {"choice_key": "B", "choice_text": "It provides an alternative reaction pathway with a lower activation energy, increasing the fraction of collisions with sufficient energy to react.", "is_correct": true}, {"choice_key": "C", "choice_text": "It shifts the reaction equilibrium further toward products.", "is_correct": false}, {"choice_key": "D", "choice_text": "It increases the magnitude of deltaH, making the reaction more exothermic.", "is_correct": false}], "lid": "8afd55b7-aedf-41a6-a840-897e4aa08e83", "lv": 4, "ls": "provisional_model", "kind": "provisional_model_null", "mu": 5, "vat": null, "vdec": null}, {"ci": "67be4368-824f-497b-85a7-338719560d61", "v": "ad10a23b-bc26-45e7-ab78-47c9cea66001", "k": "apchem-mcq-049", "vn": 3, "rs": "question_review_approved", "stem": "A student dissolves a sample of solid ammonium nitrate in water inside a coffee-cup calorimeter. As the solid dissolves, the temperature of the solution drops from 25.0 C to 18.5 C. Which statement correctly describes this dissolution process?\n\nA. The process is exothermic because the dissolving solid releases heat directly into the solution, which is why the temperature changed.\nB. The process is endothermic; the dissolving ions absorb heat from the surrounding solution, so the solution's own temperature falls, and deltaH for the process is positive.\nC. The process is endothermic, and therefore deltaH for the dissolution must be negative.\nD. The process is exothermic because the water temperature decreases as heat leaves the solution.", "ch": [{"choice_key": "A", "choice_text": "The process is exothermic because the dissolving solid releases heat directly into the solution, which is why the temperature changed.", "is_correct": false}, {"choice_key": "B", "choice_text": "The process is endothermic; the dissolving ions absorb heat from the surrounding solution, so the solution's own temperature falls, and deltaH for the process is positive.", "is_correct": true}, {"choice_key": "C", "choice_text": "The process is endothermic, and therefore deltaH for the dissolution must be negative.", "is_correct": false}, {"choice_key": "D", "choice_text": "The process is exothermic because the water temperature decreases as heat leaves the solution.", "is_correct": false}], "lid": "e84b1ffd-4351-479f-9494-39cccd627584", "lv": 3, "ls": "validated", "kind": "validated_fresh", "mu": 6, "vat": "2026-09-26T23:33:19.426331+00:00", "vdec": "144da7e6-ef4b-4f95-a691-c64b4a9ff578"}, {"ci": "65a74e55-1f56-4d8f-8443-fbf504027015", "v": "80ab716d-cb3c-4226-a9c2-627e21309f9e", "k": "apphy2-mcq-010", "vn": 2, "rs": "question_review_approved", "stem": "A particle with charge q moves with speed v in a direction parallel to a uniform magnetic field of magnitude B. The magnetic force on the particle is--\n\nA. qvB\nB. qvB, directed parallel to v\nC. zero\nD. qvB, directed perpendicular to both v and B", "ch": [{"choice_key": "A", "choice_text": "qvB", "is_correct": false}, {"choice_key": "B", "choice_text": "qvB, directed parallel to v", "is_correct": false}, {"choice_key": "C", "choice_text": "zero", "is_correct": true}, {"choice_key": "D", "choice_text": "qvB, directed perpendicular to both v and B", "is_correct": false}], "lid": "5f75c823-64dc-41c6-82f5-4af09bd2062f", "lv": 2, "ls": "validated", "kind": "validated_fresh", "mu": 12, "vat": "2026-09-26T23:33:19.426331+00:00", "vdec": "38efc6c8-b10e-4cf0-8df9-95a31729b10b"}, {"ci": "e29f8faa-83a8-44d5-bcef-bac6e4c28c8b", "v": "9add92ae-19a8-4b53-aaeb-24362f0f4842", "k": "apphy2-mcq-032", "vn": 1, "rs": "question_review_approved", "stem": "A charged particle moves perpendicular to uniform B. If its speed doubles with q, m, and B fixed, its circular-path radius\n\nA. halves\nB. stays the same\nC. doubles\nD. quadruples", "ch": [{"choice_key": "A", "choice_text": "halves", "is_correct": false}, {"choice_key": "B", "choice_text": "stays the same", "is_correct": false}, {"choice_key": "C", "choice_text": "doubles", "is_correct": true}, {"choice_key": "D", "choice_text": "quadruples", "is_correct": false}], "lid": "15ebd8d8-1955-45ff-90a4-218525df6a00", "lv": 2, "ls": "validated", "kind": "validated_fresh", "mu": 12, "vat": "2026-09-26T23:33:19.426331+00:00", "vdec": "6ba2eb6d-d4b3-488c-bbbc-f54a88387959"}, {"ci": "8f7e09a7-512d-4836-98a9-962fa28b5aae", "v": "3d8748d0-fdb6-47fa-bf9a-378ac440435c", "k": "apphycem-mcq-010", "vn": 2, "rs": "question_review_approved", "stem": "For capacitor discharge through R, charge follows\n\nA. Q₀e^{-t/RC}\nB. Q₀e^{t/RC}\nC. Q₀t/RC\nD. Q₀cos(t/RC)", "ch": [{"choice_key": "A", "choice_text": "Q₀e^{-t/RC}", "is_correct": true}, {"choice_key": "B", "choice_text": "Q₀e^{t/RC}", "is_correct": false}, {"choice_key": "C", "choice_text": "Q₀t/RC", "is_correct": false}, {"choice_key": "D", "choice_text": "Q₀cos(t/RC)", "is_correct": false}], "lid": "421a3eba-a4b2-4d4b-be09-dd2b0d67b368", "lv": 2, "ls": "validated", "kind": "validated_fresh", "mu": 11, "vat": "2026-09-27T11:41:20.527812+00:00", "vdec": "e3e903ee-3236-4c30-8a08-3b3aac1e4fc3"}, {"ci": "e29897be-8d72-466a-aeca-3575543dca53", "v": "afe405bd-b6f6-4591-84e9-39b28c97962e", "k": "apphycem-mcq-013", "vn": 2, "rs": "question_review_approved", "stem": "In the Biot-Savart law, the direction of the differential magnetic field contribution dB from a current element is set by\n\nA. dl×r-hat\nB. r-hat×dl\nC. dl·r-hat\nD. charge velocity only\n\n(Here r-hat is the unit vector pointing from the current element toward the observation point.)", "ch": [{"choice_key": "A", "choice_text": "dl×r-hat", "is_correct": true}, {"choice_key": "B", "choice_text": "r-hat×dl", "is_correct": false}, {"choice_key": "C", "choice_text": "dl·r-hat", "is_correct": false}, {"choice_key": "D", "choice_text": "charge velocity only", "is_correct": false}], "lid": "b809627f-131d-4681-b2da-63693feaded4", "lv": 2, "ls": "validated", "kind": "validated_fresh", "mu": 12, "vat": "2026-09-27T11:41:20.527812+00:00", "vdec": "c697bb84-6366-40e2-aa63-c1e64e4377b0"}, {"ci": "e2fea63c-362e-49ab-9bd6-4a8af594fe61", "v": "f0d61bed-eb70-4a59-a66d-b5a2c8f0c654", "k": "apphycm-mcq-016", "vn": 1, "rs": "question_review_approved", "stem": "The period for x''+ω²x=0 is\n\nA. ω/2π\nB. 2πω\nC. 2π/ω\nD. 1/ω²", "ch": [{"choice_key": "A", "choice_text": "ω/2π", "is_correct": false}, {"choice_key": "B", "choice_text": "2πω", "is_correct": false}, {"choice_key": "C", "choice_text": "2π/ω", "is_correct": true}, {"choice_key": "D", "choice_text": "1/ω²", "is_correct": false}], "lid": "6fcd2eed-c01a-4adf-bb30-ee65e148a670", "lv": 2, "ls": "validated", "kind": "validated_fresh", "mu": 7, "vat": "2026-09-27T11:41:28.834511+00:00", "vdec": "5c1207bb-e99d-4d6d-a29f-fe5e11877d86"}]$seed$::jsonb) loop
    insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
    values ((rr->>'ci')::uuid, 'b119fcbf-e665-41f6-8dce-ce6263a0f2b3', rr->>'k', 'mcq', 'rehearsal ' || (rr->>'k'), 'published');
    insert into app.content_item_versions (id, content_item_id, version_num, stem, content_hash, status, review_status, published_at)
    values ((rr->>'v')::uuid, (rr->>'ci')::uuid, (rr->>'vn')::int, rr->>'stem', 'rehearsal', 'published', rr->>'rs', now());
    for cc in select * from jsonb_array_elements(rr->'ch') loop
      insert into app.mcq_choices (content_item_version_id, choice_key, choice_text, is_correct)
      values ((rr->>'v')::uuid, cc->>'choice_key', cc->>'choice_text', (cc->>'is_correct')::boolean);
    end loop;
    insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope,
      validated_against_version_id, validated_against_taxo_hash, required_units, label_status, source,
      validated_by, validated_at, validation_decision_id)
    values ((rr->>'lid')::uuid, (rr->>'ci')::uuid, (rr->>'lv')::int, 'serving',
      case when right(rr->>'kind', 5) = '_null' then null else (rr->>'v')::uuid end,
      case when right(rr->>'kind', 6) = '_fresh' then app.taxonomy_relevant_hash((rr->>'v')::uuid)
           when right(rr->>'kind', 5) = '_null' then null else 'not-fresh-in-production' end,
      case when rr->>'mu' is null then '{}'::int[] else array[(rr->>'mu')::int] end, rr->>'ls', 'rehearsal',
      case when rr->>'ls'='validated' then v_prof end, case when rr->>'ls'='validated' then (rr->>'vat')::timestamptz end,
      case when rr->>'ls'='validated' then (rr->>'vdec')::uuid end);
  end loop;
  CREATE TRIGGER tg_mcq_choices_taxonomy_stale AFTER INSERT OR DELETE OR UPDATE ON app.mcq_choices FOR EACH ROW EXECUTE FUNCTION app.mark_content_taxonomy_labels_stale_from_child_trigger();

  create temporary table _reh (v uuid, lid uuid, old_md5 text, new_md5 text, cmd5 text, cls text) on commit drop;
  insert into _reh values ('d5ce86ce-69e0-4e02-80d6-12b2e47cfb19','f025c644-41bc-45d1-adcb-46753a328fe9','575d6b06c192c30964109a41afeac1b3','5a48ef6d535146e462dbdc013b66086b','2e9f06f5e3cc5c17fc410d7a82b5b7b0','clean_match'),('84b735fd-c0c5-43e9-a061-3c1d49d6faa6','a9c1ef56-6c39-414c-b1b7-5f4f1c181f62','370bb7f4735808ca9cb1609f808a7203','88519f8c555db4bc6a496fd180510eaf','890c9d96c8eae5adab319a3668b03251','clean_match'),('c7d521ad-bc8a-404c-abd9-0e68350e7afd','0fe7571a-b646-4ad7-ab79-654224ff5d29','0cb90ebeda42f3b5986b75040e1b58d3','36ee7546bf5f2c15e6ba0a52b6be30d5','c167cdf5b35579aba49412ad735f6d12','clean_match'),('76895682-1bb0-4be4-95d0-4a197edb866f','de9fe517-63bb-4a8d-b81e-91ad7945a776','b9df817745aa3300062e00c439710a4d','87b71b82d4c7283f71bd436c7b567efa','39c232230f1bd9e8f2ed5e5ceacbde19','ambiguous'),('ec5e88d3-622a-482a-b89d-cefc3cf7afd5','b1ffb2e2-60c9-4b74-a897-95d48ea9d8e5','34e151472b3461e15441aae405f6e96b','6d9c9ef783640d1bae0ddef4c7b85005','b6cbb289b5db41e2ff05201f4ab81a6e','clean_match'),('9e7fff7f-3d3c-491a-9b12-4aaba7890769','88ef9b87-742e-4582-a14b-1929e276ac42','779e1d1adc1964af5e7e837af1f04e52','444739e2d05805625f7035dd8a2570b1','ec7eefb4ffae7761f78bd97925a80f7b','clean_match'),('1a1fb40c-1fb1-4127-bb24-9fd2ee067131','8923510b-df84-4fe6-84de-d77ee7ac2902','9c9689aee4964548f9a7c243f28ad0ed','50fdeb9f9589e2159ac66c17a42c49ec','0582d959fe774d86f384929b3536202b','ambiguous'),('4d27c8d2-8521-4043-a254-09a6f5c85998','8afd55b7-aedf-41a6-a840-897e4aa08e83','7b8c7a5318dbd49d78b88f4f50c1242d','0924ba2dadfda9e848fa2e38ce4f1a18','692a405e96f2ac377c90f7cc7c7d8da0','clean_match'),('ad10a23b-bc26-45e7-ab78-47c9cea66001','e84b1ffd-4351-479f-9494-39cccd627584','235b16ec0a24dea12afda7a46b60fc1f','c59e6fe326b4e1e355f69e52e2f33c18','50803c06235bff406950c8b46f8db630','clean_match'),('80ab716d-cb3c-4226-a9c2-627e21309f9e','5f75c823-64dc-41c6-82f5-4af09bd2062f','beb16cc6a960879abcf813d3e13ae402','7690b44d1d4945bf0e701c3678c8b070','1fee493380a7dd0cc5ed7f59bfe814c5','clean_match'),('9add92ae-19a8-4b53-aaeb-24362f0f4842','15ebd8d8-1955-45ff-90a4-218525df6a00','f981d2a7f7491d5df1d9d85910fde935','4ac40bfbb6e9de772fa9716067c55ab1','eeaa3a58b4095409a165ef0318377f16','clean_match'),('3d8748d0-fdb6-47fa-bf9a-378ac440435c','421a3eba-a4b2-4d4b-be09-dd2b0d67b368','3ea14a48f97f973ec98010215c32369d','0df4e58de81885b0cf279dd3d64fc5df','885e231f011856980877a144ac0f77ed','clean_match'),('afe405bd-b6f6-4591-84e9-39b28c97962e','b809627f-131d-4681-b2da-63693feaded4','480b752d64ff76b1b1328bb811f26200','00c47d6dbe5c9ea55f4a99f83ed84ab1','d6b1fd892b77c5b2a6c79d13620424dc','ambiguous'),('f0d61bed-eb70-4a59-a66d-b5a2c8f0c654','6fcd2eed-c01a-4adf-bb30-ee65e148a670','e91468e1744c0314d2c40c1d15cba409','131a2692e5df5955cfeb3ce521caf273','d914ee7f2b0343195f5419dce39bcd74','clean_match');
  res := res || jsonb_build_object('seeded', (select count(*) from _reh), 'before', jsonb_build_object(
      'stems_cleaned', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.new_md5),
      'stems_old', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.old_md5),
      'published', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where civ.status='published'),
      'choices_same', (select count(*) from _reh r where (select md5(string_agg(mc.choice_key||'|'||mc.choice_text||'|'||mc.is_correct::text, chr(10) order by mc.choice_key)) from app.mcq_choices mc where mc.content_item_version_id=r.v)=r.cmd5),
      'labels', (select jsonb_object_agg(k, c) from (select l.label_status||case when l.validated_against_taxo_hash=app.taxonomy_relevant_hash(r.v) then '_fresh' when l.validated_against_taxo_hash is null then '_null' else '_nonfresh' end k, count(*) c
                 from _reh r join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r.lid group by 1) x),
      'served_by_selector', (select count(*) from public.select_unit_gated_practice_items('b119fcbf-e665-41f6-8dce-ce6263a0f2b3'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id),
      'served_clean_stem', (select count(*) from public.select_unit_gated_practice_items('b119fcbf-e665-41f6-8dce-ce6263a0f2b3'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id where s.stem !~ '\mA\. .+\mB\. .+\mC\. ')));

  -- negative control: a bare in-place stem update (no carry-forward) on one validated item, in a sub-transaction
  begin
    update app.content_item_versions set stem = stem || ' ' where id = (select r2.v from _reh r2 join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r2.lid where l.label_status='validated' limit 1);
    res := res || jsonb_build_object('negative_control_bare_update', jsonb_build_object(
      'labels_stale', (select count(*) from _reh r2 join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r2.lid where l.label_status='stale'),
      'stale_validated_by_nulled', (select count(*) from _reh r2 join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r2.lid where l.label_status='stale' and l.validated_by is null),
      'served_by_selector', (select count(*) from public.select_unit_gated_practice_items('b119fcbf-e665-41f6-8dce-ce6263a0f2b3'::uuid, 14, null, 'mcq', 50) s join _reh r2 on r2.v=s.content_item_version_id)));
    raise exception 'undo-negative-control';
  exception when raise_exception then
    if sqlerrm <> 'undo-negative-control' then raise; end if;
  end;

  -- the Production apply body (subset of targets)
  v_apply := $applytxt$
do $apply$
declare
  v_approval constant text := 'DEV-REHEARSAL';
  v_run      constant text := 'stem-choice-cleanup-2026-10-06';
  -- target rows: version_id, content_key, md5 of the stem we expect to find, the stem to write, md5 of the choices
  v_targets  constant jsonb := $tj$[
{
"version_id": "d5ce86ce-69e0-4e02-80d6-12b2e47cfb19",
"content_key": "apcalcab-mcq-021",
"from_md5": "575d6b06c192c30964109a41afeac1b3",
"to_stem": "What is lim(x→2) (x²−4)/(x−2)?",
"choices_md5": "2e9f06f5e3cc5c17fc410d7a82b5b7b0"
},
{
"version_id": "84b735fd-c0c5-43e9-a061-3c1d49d6faa6",
"content_key": "apcalcab-mcq-023",
"from_md5": "370bb7f4735808ca9cb1609f808a7203",
"to_stem": "A function f is continuous on [1,4], with f(1)=−2 and f(4)=5. Which conclusion is guaranteed?",
"choices_md5": "890c9d96c8eae5adab319a3668b03251"
},
{
"version_id": "c7d521ad-bc8a-404c-abd9-0e68350e7afd",
"content_key": "apcalcbc-mcq-032",
"from_md5": "0cb90ebeda42f3b5986b75040e1b58d3",
"to_stem": "If f′(x)=x²(x−1)³(x+2)², which statement is true?",
"choices_md5": "c167cdf5b35579aba49412ad735f6d12"
},
{
"version_id": "ec5e88d3-622a-482a-b89d-cefc3cf7afd5",
"content_key": "apchem-mcq-013",
"from_md5": "34e151472b3461e15441aae405f6e96b",
"to_stem": "A 100 g metal absorbs 2.50 kJ and warms by 50.0°C. Its specific heat is",
"choices_md5": "b6cbb289b5db41e2ff05201f4ab81a6e"
},
{
"version_id": "9e7fff7f-3d3c-491a-9b12-4aaba7890769",
"content_key": "apchem-mcq-014",
"from_md5": "779e1d1adc1964af5e7e837af1f04e52",
"to_stem": "If ΔH is negative for a process at constant pressure, the system",
"choices_md5": "ec7eefb4ffae7761f78bd97925a80f7b"
},
{
"version_id": "4d27c8d2-8521-4043-a254-09a6f5c85998",
"content_key": "apchem-mcq-048",
"from_md5": "7b8c7a5318dbd49d78b88f4f50c1242d",
"to_stem": "Which of the following correctly describes how a catalyst increases the rate of a chemical reaction?",
"choices_md5": "692a405e96f2ac377c90f7cc7c7d8da0"
},
{
"version_id": "ad10a23b-bc26-45e7-ab78-47c9cea66001",
"content_key": "apchem-mcq-049",
"from_md5": "235b16ec0a24dea12afda7a46b60fc1f",
"to_stem": "A student dissolves a sample of solid ammonium nitrate in water inside a coffee-cup calorimeter. As the solid dissolves, the temperature of the solution drops from 25.0 C to 18.5 C. Which statement correctly describes this dissolution process?",
"choices_md5": "50803c06235bff406950c8b46f8db630"
},
{
"version_id": "80ab716d-cb3c-4226-a9c2-627e21309f9e",
"content_key": "apphy2-mcq-010",
"from_md5": "beb16cc6a960879abcf813d3e13ae402",
"to_stem": "A particle with charge q moves with speed v in a direction parallel to a uniform magnetic field of magnitude B. The magnetic force on the particle is--",
"choices_md5": "1fee493380a7dd0cc5ed7f59bfe814c5"
},
{
"version_id": "9add92ae-19a8-4b53-aaeb-24362f0f4842",
"content_key": "apphy2-mcq-032",
"from_md5": "f981d2a7f7491d5df1d9d85910fde935",
"to_stem": "A charged particle moves perpendicular to uniform B. If its speed doubles with q, m, and B fixed, its circular-path radius",
"choices_md5": "eeaa3a58b4095409a165ef0318377f16"
},
{
"version_id": "3d8748d0-fdb6-47fa-bf9a-378ac440435c",
"content_key": "apphycem-mcq-010",
"from_md5": "3ea14a48f97f973ec98010215c32369d",
"to_stem": "For capacitor discharge through R, charge follows",
"choices_md5": "885e231f011856980877a144ac0f77ed"
},
{
"version_id": "f0d61bed-eb70-4a59-a66d-b5a2c8f0c654",
"content_key": "apphycm-mcq-016",
"from_md5": "e91468e1744c0314d2c40c1d15cba409",
"to_stem": "The period for x''+ω²x=0 is",
"choices_md5": "d914ee7f2b0343195f5419dce39bcd74"
}
]$tj$::jsonb;
  v_live jsonb; v_prior jsonb;
  n_target int; n_live int; n_upd int; n_lbl int; n_bad int;
begin
  if v_approval is null or v_approval = 'PENDING' then
    raise exception 'stem-choice-cleanup-2026-10-06: label carry-forward needs a Product Owner approval reference (set v_approval)';
  end if;
  perform pg_advisory_xact_lock(hashtext('cramapple-' || v_run));
  n_target := jsonb_array_length(v_targets);
  if n_target <> 11 then raise exception '%: expected 11 target rows, got %', v_run, n_target; end if;

  -- idempotence: only rows whose stem is still byte-identical to the expected one, still the current published
  -- MCQ version, with choices unchanged since the snapshot
  select coalesce(jsonb_agg(jsonb_build_object('version_id', t.version_id, 'from_md5', t.from_md5, 'to_stem', t.to_stem,
           'choices_md5', t.choices_md5, 'content_item_id', civ.content_item_id,
           'old_taxo_hash', app.taxonomy_relevant_hash(civ.id))), '[]'::jsonb)
    into v_live
  from jsonb_to_recordset(v_targets) as t(version_id uuid, content_key text, from_md5 text, to_stem text, choices_md5 text)
  join app.content_item_versions civ on civ.id = t.version_id
  join app.content_items ci on ci.id = civ.content_item_id and ci.content_key = t.content_key
  where md5(civ.stem) = t.from_md5
    and civ.status = 'published' and ci.item_type = 'mcq'
    and not exists (select 1 from app.content_item_versions later
                    where later.content_item_id = civ.content_item_id and later.version_num > civ.version_num)
    and (select md5(string_agg(mc.choice_key || '|' || mc.choice_text || '|' || mc.is_correct::text, chr(10) order by mc.choice_key))
         from app.mcq_choices mc where mc.content_item_version_id = civ.id) = t.choices_md5;
  n_live := jsonb_array_length(v_live);
  raise notice '%: % of % target rows still match and will be updated', v_run, n_live, n_target;
  if n_live = 0 then
    return;  -- already applied (or every row drifted): nothing to do
  end if;

  -- capture every current label the stale trigger can touch (validated / provisional_model), BEFORE the write:
  -- the derive trigger nulls validated_by/at/decision when the status flips to stale. 'held' labels are not touched
  -- by the trigger but carry the same hash; re-point them too so a later hold release is not blocked by this edit.
  select coalesce(jsonb_agg(jsonb_build_object('content_taxonomy_label_id', l.content_taxonomy_label_id,
           'version_id', lv.version_id, 'label_status', l.label_status, 'validated_by', l.validated_by,
           'validated_at', l.validated_at, 'validation_decision_id', l.validation_decision_id,
           'validated_against_version_id', l.validated_against_version_id,
           'was_fresh', (l.validated_against_taxo_hash is not distinct from lv.old_taxo_hash))), '[]'::jsonb)
    into v_prior
  from jsonb_to_recordset(v_live) as lv(version_id uuid, content_item_id uuid, old_taxo_hash text)
  join app.content_taxonomy_labels l on l.content_item_id = lv.content_item_id
  where l.superseded_by is null and l.label_status in ('validated', 'provisional_model', 'held');

  update app.content_item_versions civ
  set stem = lv.to_stem
  from jsonb_to_recordset(v_live) as lv(version_id uuid, from_md5 text, to_stem text)
  where civ.id = lv.version_id and md5(civ.stem) = lv.from_md5;
  get diagnostics n_upd = row_count;
  if n_upd <> n_live then raise exception '%: updated % rows, expected %', v_run, n_upd, n_live; end if;

  -- carry labels forward: restore the exact prior status/validation; re-point the hash only where it was fresh
  update app.content_taxonomy_labels l
  set label_status = p.label_status,
      validated_by = p.validated_by,
      validated_at = p.validated_at,
      validation_decision_id = p.validation_decision_id,
      validated_against_version_id = p.validated_against_version_id,
      validated_against_taxo_hash = case when p.was_fresh then app.taxonomy_relevant_hash(p.version_id)
                                         else l.validated_against_taxo_hash end,
      source_payload = l.source_payload || jsonb_build_object('carried_forward_' || replace(v_run, '-', '_'), jsonb_build_object(
        'version_id', p.version_id,
        'reason', 'stem/choice cleanup: duplicated inline answer-choice list removed from stem; question text, choices, units and topics unchanged; no relabelling',
        'approval_ref', v_approval, 'run', v_run))
  from jsonb_to_recordset(v_prior) as p(content_taxonomy_label_id uuid, version_id uuid, label_status text,
       validated_by uuid, validated_at timestamptz, validation_decision_id uuid, validated_against_version_id uuid, was_fresh boolean)
  where l.content_taxonomy_label_id = p.content_taxonomy_label_id;
  get diagnostics n_lbl = row_count;

  -- postconditions
  select count(*) into n_bad
  from jsonb_to_recordset(v_live) as lv(version_id uuid, to_stem text, choices_md5 text)
  join app.content_item_versions civ on civ.id = lv.version_id
  where civ.stem is distinct from lv.to_stem or civ.status <> 'published'
     or cardinality(app.mcq_stem_choice_desync(civ.id, civ.stem)) > 0
     or (select md5(string_agg(mc.choice_key || '|' || mc.choice_text || '|' || mc.is_correct::text, chr(10) order by mc.choice_key))
         from app.mcq_choices mc where mc.content_item_version_id = civ.id) is distinct from lv.choices_md5;
  if n_bad > 0 then raise exception '%: % rows fail stem/status/choices/desync postconditions', v_run, n_bad; end if;
  select count(*) into n_bad
  from jsonb_to_recordset(v_prior) as p(content_taxonomy_label_id uuid, version_id uuid, label_status text, was_fresh boolean)
  join app.content_taxonomy_labels l on l.content_taxonomy_label_id = p.content_taxonomy_label_id
  where l.label_status <> p.label_status
     or (p.was_fresh and l.validated_against_taxo_hash is distinct from app.taxonomy_relevant_hash(p.version_id));
  if n_bad > 0 then raise exception '%: % labels not carried forward', v_run, n_bad; end if;
  select count(*) into n_bad
  from jsonb_to_recordset(v_live) as lv(content_item_id uuid)
  join app.content_taxonomy_labels l on l.content_item_id = lv.content_item_id
  where l.superseded_by is null and l.label_status = 'stale';
  if n_bad > 0 then raise exception '%: % target labels left stale', v_run, n_bad; end if;

  raise notice '%: stems updated %, labels carried forward %', v_run, n_upd, n_lbl;
end
$apply$
$applytxt$;
  execute v_apply;
  res := res || jsonb_build_object('after_apply', jsonb_build_object(
      'stems_cleaned', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.new_md5),
      'stems_old', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.old_md5),
      'published', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where civ.status='published'),
      'choices_same', (select count(*) from _reh r where (select md5(string_agg(mc.choice_key||'|'||mc.choice_text||'|'||mc.is_correct::text, chr(10) order by mc.choice_key)) from app.mcq_choices mc where mc.content_item_version_id=r.v)=r.cmd5),
      'labels', (select jsonb_object_agg(k, c) from (select l.label_status||case when l.validated_against_taxo_hash=app.taxonomy_relevant_hash(r.v) then '_fresh' when l.validated_against_taxo_hash is null then '_null' else '_nonfresh' end k, count(*) c
                 from _reh r join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r.lid group by 1) x),
      'served_by_selector', (select count(*) from public.select_unit_gated_practice_items('b119fcbf-e665-41f6-8dce-ce6263a0f2b3'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id),
      'served_clean_stem', (select count(*) from public.select_unit_gated_practice_items('b119fcbf-e665-41f6-8dce-ce6263a0f2b3'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id where s.stem !~ '\mA\. .+\mB\. .+\mC\. ')));
  select max(civ.updated_at) into v_upd from _reh r2 join app.content_item_versions civ on civ.id=r2.v where r2.cls='clean_match';

  -- idempotence: second run must be a no-op
  execute v_apply;
  res := res || jsonb_build_object('after_rerun_cleaned', (select count(*) from _reh r2 join app.content_item_versions civ on civ.id=r2.v where md5(civ.stem)=r2.new_md5),
     'rerun_touched_rows', (select count(*) from _reh r2 join app.content_item_versions civ on civ.id=r2.v where r2.cls='clean_match' and civ.updated_at > v_upd));

  -- optional review7 body (subset)
  execute $revtxt$
do $apply$
declare
  v_approval constant text := 'DEV-REHEARSAL';
  v_run      constant text := 'stem-choice-cleanup-review7-2026-10-06';
  -- target rows: version_id, content_key, md5 of the stem we expect to find, the stem to write, md5 of the choices
  v_targets  constant jsonb := $tj$[
{
"version_id": "76895682-1bb0-4be4-95d0-4a197edb866f",
"content_key": "apchem-mcq-007",
"from_md5": "b9df817745aa3300062e00c439710a4d",
"to_stem": "Which change most increases the solubility of a nonreactive gas in water?\n\nAssume pressure refers to the gas partial pressure above the solution.",
"choices_md5": "39c232230f1bd9e8f2ed5e5ceacbde19"
},
{
"version_id": "1a1fb40c-1fb1-4127-bb24-9fd2ee067131",
"content_key": "apchem-mcq-017",
"from_md5": "9c9689aee4964548f9a7c243f28ad0ed",
"to_stem": "The pH of 1.0×10⁻³ M HCl is approximately\n\nAssume 25 C.",
"choices_md5": "0582d959fe774d86f384929b3536202b"
},
{
"version_id": "afe405bd-b6f6-4591-84e9-39b28c97962e",
"content_key": "apphycem-mcq-013",
"from_md5": "480b752d64ff76b1b1328bb811f26200",
"to_stem": "In the Biot-Savart law, the direction of the differential magnetic field contribution dB from a current element is set by\n\n(Here r-hat is the unit vector pointing from the current element toward the observation point.)",
"choices_md5": "d6b1fd892b77c5b2a6c79d13620424dc"
}
]$tj$::jsonb;
  v_live jsonb; v_prior jsonb;
  n_target int; n_live int; n_upd int; n_lbl int; n_bad int;
begin
  if v_approval is null or v_approval = 'PENDING' then
    raise exception 'stem-choice-cleanup-review7-2026-10-06: label carry-forward needs a Product Owner approval reference (set v_approval)';
  end if;
  perform pg_advisory_xact_lock(hashtext('cramapple-' || v_run));
  n_target := jsonb_array_length(v_targets);
  if n_target <> 3 then raise exception '%: expected 3 target rows, got %', v_run, n_target; end if;

  -- idempotence: only rows whose stem is still byte-identical to the expected one, still the current published
  -- MCQ version, with choices unchanged since the snapshot
  select coalesce(jsonb_agg(jsonb_build_object('version_id', t.version_id, 'from_md5', t.from_md5, 'to_stem', t.to_stem,
           'choices_md5', t.choices_md5, 'content_item_id', civ.content_item_id,
           'old_taxo_hash', app.taxonomy_relevant_hash(civ.id))), '[]'::jsonb)
    into v_live
  from jsonb_to_recordset(v_targets) as t(version_id uuid, content_key text, from_md5 text, to_stem text, choices_md5 text)
  join app.content_item_versions civ on civ.id = t.version_id
  join app.content_items ci on ci.id = civ.content_item_id and ci.content_key = t.content_key
  where md5(civ.stem) = t.from_md5
    and civ.status = 'published' and ci.item_type = 'mcq'
    and not exists (select 1 from app.content_item_versions later
                    where later.content_item_id = civ.content_item_id and later.version_num > civ.version_num)
    and (select md5(string_agg(mc.choice_key || '|' || mc.choice_text || '|' || mc.is_correct::text, chr(10) order by mc.choice_key))
         from app.mcq_choices mc where mc.content_item_version_id = civ.id) = t.choices_md5;
  n_live := jsonb_array_length(v_live);
  raise notice '%: % of % target rows still match and will be updated', v_run, n_live, n_target;
  if n_live = 0 then
    return;  -- already applied (or every row drifted): nothing to do
  end if;

  -- capture every current label the stale trigger can touch (validated / provisional_model), BEFORE the write:
  -- the derive trigger nulls validated_by/at/decision when the status flips to stale. 'held' labels are not touched
  -- by the trigger but carry the same hash; re-point them too so a later hold release is not blocked by this edit.
  select coalesce(jsonb_agg(jsonb_build_object('content_taxonomy_label_id', l.content_taxonomy_label_id,
           'version_id', lv.version_id, 'label_status', l.label_status, 'validated_by', l.validated_by,
           'validated_at', l.validated_at, 'validation_decision_id', l.validation_decision_id,
           'validated_against_version_id', l.validated_against_version_id,
           'was_fresh', (l.validated_against_taxo_hash is not distinct from lv.old_taxo_hash))), '[]'::jsonb)
    into v_prior
  from jsonb_to_recordset(v_live) as lv(version_id uuid, content_item_id uuid, old_taxo_hash text)
  join app.content_taxonomy_labels l on l.content_item_id = lv.content_item_id
  where l.superseded_by is null and l.label_status in ('validated', 'provisional_model', 'held');

  update app.content_item_versions civ
  set stem = lv.to_stem
  from jsonb_to_recordset(v_live) as lv(version_id uuid, from_md5 text, to_stem text)
  where civ.id = lv.version_id and md5(civ.stem) = lv.from_md5;
  get diagnostics n_upd = row_count;
  if n_upd <> n_live then raise exception '%: updated % rows, expected %', v_run, n_upd, n_live; end if;

  -- carry labels forward: restore the exact prior status/validation; re-point the hash only where it was fresh
  update app.content_taxonomy_labels l
  set label_status = p.label_status,
      validated_by = p.validated_by,
      validated_at = p.validated_at,
      validation_decision_id = p.validation_decision_id,
      validated_against_version_id = p.validated_against_version_id,
      validated_against_taxo_hash = case when p.was_fresh then app.taxonomy_relevant_hash(p.version_id)
                                         else l.validated_against_taxo_hash end,
      source_payload = l.source_payload || jsonb_build_object('carried_forward_' || replace(v_run, '-', '_'), jsonb_build_object(
        'version_id', p.version_id,
        'reason', 'rehearsal review7',
        'approval_ref', v_approval, 'run', v_run))
  from jsonb_to_recordset(v_prior) as p(content_taxonomy_label_id uuid, version_id uuid, label_status text,
       validated_by uuid, validated_at timestamptz, validation_decision_id uuid, validated_against_version_id uuid, was_fresh boolean)
  where l.content_taxonomy_label_id = p.content_taxonomy_label_id;
  get diagnostics n_lbl = row_count;

  -- postconditions
  select count(*) into n_bad
  from jsonb_to_recordset(v_live) as lv(version_id uuid, to_stem text, choices_md5 text)
  join app.content_item_versions civ on civ.id = lv.version_id
  where civ.stem is distinct from lv.to_stem or civ.status <> 'published'
     or cardinality(app.mcq_stem_choice_desync(civ.id, civ.stem)) > 0
     or (select md5(string_agg(mc.choice_key || '|' || mc.choice_text || '|' || mc.is_correct::text, chr(10) order by mc.choice_key))
         from app.mcq_choices mc where mc.content_item_version_id = civ.id) is distinct from lv.choices_md5;
  if n_bad > 0 then raise exception '%: % rows fail stem/status/choices/desync postconditions', v_run, n_bad; end if;
  select count(*) into n_bad
  from jsonb_to_recordset(v_prior) as p(content_taxonomy_label_id uuid, version_id uuid, label_status text, was_fresh boolean)
  join app.content_taxonomy_labels l on l.content_taxonomy_label_id = p.content_taxonomy_label_id
  where l.label_status <> p.label_status
     or (p.was_fresh and l.validated_against_taxo_hash is distinct from app.taxonomy_relevant_hash(p.version_id));
  if n_bad > 0 then raise exception '%: % labels not carried forward', v_run, n_bad; end if;
  select count(*) into n_bad
  from jsonb_to_recordset(v_live) as lv(content_item_id uuid)
  join app.content_taxonomy_labels l on l.content_item_id = lv.content_item_id
  where l.superseded_by is null and l.label_status = 'stale';
  if n_bad > 0 then raise exception '%: % target labels left stale', v_run, n_bad; end if;

  raise notice '%: stems updated %, labels carried forward %', v_run, n_upd, n_lbl;
end
$apply$
$revtxt$;
  res := res || jsonb_build_object('after_review7', jsonb_build_object(
      'stems_cleaned', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.new_md5),
      'stems_old', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.old_md5),
      'published', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where civ.status='published'),
      'choices_same', (select count(*) from _reh r where (select md5(string_agg(mc.choice_key||'|'||mc.choice_text||'|'||mc.is_correct::text, chr(10) order by mc.choice_key)) from app.mcq_choices mc where mc.content_item_version_id=r.v)=r.cmd5),
      'labels', (select jsonb_object_agg(k, c) from (select l.label_status||case when l.validated_against_taxo_hash=app.taxonomy_relevant_hash(r.v) then '_fresh' when l.validated_against_taxo_hash is null then '_null' else '_nonfresh' end k, count(*) c
                 from _reh r join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r.lid group by 1) x),
      'served_by_selector', (select count(*) from public.select_unit_gated_practice_items('b119fcbf-e665-41f6-8dce-ce6263a0f2b3'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id),
      'served_clean_stem', (select count(*) from public.select_unit_gated_practice_items('b119fcbf-e665-41f6-8dce-ce6263a0f2b3'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id where s.stem !~ '\mA\. .+\mB\. .+\mC\. ')));

  -- rollback body
  execute $rbtxt$
do $apply$
declare
  v_approval constant text := 'DEV-REHEARSAL';
  v_run      constant text := 'stem-choice-cleanup-rollback-2026-10-06';
  -- target rows: version_id, content_key, md5 of the stem we expect to find, the stem to write, md5 of the choices
  v_targets  constant jsonb := $tj$[
{
"version_id": "d5ce86ce-69e0-4e02-80d6-12b2e47cfb19",
"content_key": "apcalcab-mcq-021",
"from_md5": "5a48ef6d535146e462dbdc013b66086b",
"to_stem": "What is lim(x→2) (x²−4)/(x−2)?\n\nA. 4\nB. 2\nC. 0\nD. The limit does not exist",
"choices_md5": "2e9f06f5e3cc5c17fc410d7a82b5b7b0"
},
{
"version_id": "84b735fd-c0c5-43e9-a061-3c1d49d6faa6",
"content_key": "apcalcab-mcq-023",
"from_md5": "88519f8c555db4bc6a496fd180510eaf",
"to_stem": "A function f is continuous on [1,4], with f(1)=−2 and f(4)=5. Which conclusion is guaranteed?\n\nA. f has an absolute minimum at x=1.\nB. There is a c in (1,4) with f′(c)=7/3.\nC. There is a c in (1,4) with f(c)=0.\nD. f is increasing on [1,4].",
"choices_md5": "890c9d96c8eae5adab319a3668b03251"
},
{
"version_id": "9e7fff7f-3d3c-491a-9b12-4aaba7890769",
"content_key": "apchem-mcq-014",
"from_md5": "444739e2d05805625f7035dd8a2570b1",
"to_stem": "If ΔH is negative for a process at constant pressure, the system\n\nA. absorbs heat\nB. releases heat\nC. must have greater entropy\nD. cannot be spontaneous",
"choices_md5": "ec7eefb4ffae7761f78bd97925a80f7b"
},
{
"version_id": "1a1fb40c-1fb1-4127-bb24-9fd2ee067131",
"content_key": "apchem-mcq-017",
"from_md5": "50fdeb9f9589e2159ac66c17a42c49ec",
"to_stem": "The pH of 1.0×10⁻³ M HCl is approximately\n\nA. 1.00\nB. 3.00\nC. 7.00\nD. 11.00\n\nAssume 25 C.",
"choices_md5": "0582d959fe774d86f384929b3536202b"
},
{
"version_id": "4d27c8d2-8521-4043-a254-09a6f5c85998",
"content_key": "apchem-mcq-048",
"from_md5": "0924ba2dadfda9e848fa2e38ce4f1a18",
"to_stem": "Which of the following correctly describes how a catalyst increases the rate of a chemical reaction?\n\nA. It increases the average kinetic energy of the reactant molecules, so more collisions occur per second.\nB. It provides an alternative reaction pathway with a lower activation energy, increasing the fraction of collisions with sufficient energy to react.\nC. It shifts the reaction equilibrium further toward products.\nD. It increases the magnitude of deltaH, making the reaction more exothermic.",
"choices_md5": "692a405e96f2ac377c90f7cc7c7d8da0"
}
]$tj$::jsonb;
  v_live jsonb; v_prior jsonb;
  n_target int; n_live int; n_upd int; n_lbl int; n_bad int;
begin
  if v_approval is null or v_approval = 'PENDING' then
    raise exception 'stem-choice-cleanup-rollback-2026-10-06: label carry-forward needs a Product Owner approval reference (set v_approval)';
  end if;
  perform pg_advisory_xact_lock(hashtext('cramapple-' || v_run));
  n_target := jsonb_array_length(v_targets);
  if n_target <> 5 then raise exception '%: expected 5 target rows, got %', v_run, n_target; end if;

  -- idempotence: only rows whose stem is still byte-identical to the expected one, still the current published
  -- MCQ version, with choices unchanged since the snapshot
  select coalesce(jsonb_agg(jsonb_build_object('version_id', t.version_id, 'from_md5', t.from_md5, 'to_stem', t.to_stem,
           'choices_md5', t.choices_md5, 'content_item_id', civ.content_item_id,
           'old_taxo_hash', app.taxonomy_relevant_hash(civ.id))), '[]'::jsonb)
    into v_live
  from jsonb_to_recordset(v_targets) as t(version_id uuid, content_key text, from_md5 text, to_stem text, choices_md5 text)
  join app.content_item_versions civ on civ.id = t.version_id
  join app.content_items ci on ci.id = civ.content_item_id and ci.content_key = t.content_key
  where md5(civ.stem) = t.from_md5
    and civ.status = 'published' and ci.item_type = 'mcq'
    and not exists (select 1 from app.content_item_versions later
                    where later.content_item_id = civ.content_item_id and later.version_num > civ.version_num)
    and (select md5(string_agg(mc.choice_key || '|' || mc.choice_text || '|' || mc.is_correct::text, chr(10) order by mc.choice_key))
         from app.mcq_choices mc where mc.content_item_version_id = civ.id) = t.choices_md5;
  n_live := jsonb_array_length(v_live);
  raise notice '%: % of % target rows still match and will be updated', v_run, n_live, n_target;
  if n_live = 0 then
    return;  -- already applied (or every row drifted): nothing to do
  end if;

  -- capture every current label the stale trigger can touch (validated / provisional_model), BEFORE the write:
  -- the derive trigger nulls validated_by/at/decision when the status flips to stale. 'held' labels are not touched
  -- by the trigger but carry the same hash; re-point them too so a later hold release is not blocked by this edit.
  select coalesce(jsonb_agg(jsonb_build_object('content_taxonomy_label_id', l.content_taxonomy_label_id,
           'version_id', lv.version_id, 'label_status', l.label_status, 'validated_by', l.validated_by,
           'validated_at', l.validated_at, 'validation_decision_id', l.validation_decision_id,
           'validated_against_version_id', l.validated_against_version_id,
           'was_fresh', (l.validated_against_taxo_hash is not distinct from lv.old_taxo_hash))), '[]'::jsonb)
    into v_prior
  from jsonb_to_recordset(v_live) as lv(version_id uuid, content_item_id uuid, old_taxo_hash text)
  join app.content_taxonomy_labels l on l.content_item_id = lv.content_item_id
  where l.superseded_by is null and l.label_status in ('validated', 'provisional_model', 'held');

  update app.content_item_versions civ
  set stem = lv.to_stem
  from jsonb_to_recordset(v_live) as lv(version_id uuid, from_md5 text, to_stem text)
  where civ.id = lv.version_id and md5(civ.stem) = lv.from_md5;
  get diagnostics n_upd = row_count;
  if n_upd <> n_live then raise exception '%: updated % rows, expected %', v_run, n_upd, n_live; end if;

  -- carry labels forward: restore the exact prior status/validation; re-point the hash only where it was fresh
  update app.content_taxonomy_labels l
  set label_status = p.label_status,
      validated_by = p.validated_by,
      validated_at = p.validated_at,
      validation_decision_id = p.validation_decision_id,
      validated_against_version_id = p.validated_against_version_id,
      validated_against_taxo_hash = case when p.was_fresh then app.taxonomy_relevant_hash(p.version_id)
                                         else l.validated_against_taxo_hash end,
      source_payload = l.source_payload || jsonb_build_object('carried_forward_' || replace(v_run, '-', '_'), jsonb_build_object(
        'version_id', p.version_id,
        'reason', 'rehearsal rollback',
        'approval_ref', v_approval, 'run', v_run))
  from jsonb_to_recordset(v_prior) as p(content_taxonomy_label_id uuid, version_id uuid, label_status text,
       validated_by uuid, validated_at timestamptz, validation_decision_id uuid, validated_against_version_id uuid, was_fresh boolean)
  where l.content_taxonomy_label_id = p.content_taxonomy_label_id;
  get diagnostics n_lbl = row_count;

  -- postconditions
  select count(*) into n_bad
  from jsonb_to_recordset(v_live) as lv(version_id uuid, to_stem text, choices_md5 text)
  join app.content_item_versions civ on civ.id = lv.version_id
  where civ.stem is distinct from lv.to_stem or civ.status <> 'published'
     or cardinality(app.mcq_stem_choice_desync(civ.id, civ.stem)) > 0
     or (select md5(string_agg(mc.choice_key || '|' || mc.choice_text || '|' || mc.is_correct::text, chr(10) order by mc.choice_key))
         from app.mcq_choices mc where mc.content_item_version_id = civ.id) is distinct from lv.choices_md5;
  if n_bad > 0 then raise exception '%: % rows fail stem/status/choices/desync postconditions', v_run, n_bad; end if;
  select count(*) into n_bad
  from jsonb_to_recordset(v_prior) as p(content_taxonomy_label_id uuid, version_id uuid, label_status text, was_fresh boolean)
  join app.content_taxonomy_labels l on l.content_taxonomy_label_id = p.content_taxonomy_label_id
  where l.label_status <> p.label_status
     or (p.was_fresh and l.validated_against_taxo_hash is distinct from app.taxonomy_relevant_hash(p.version_id));
  if n_bad > 0 then raise exception '%: % labels not carried forward', v_run, n_bad; end if;
  select count(*) into n_bad
  from jsonb_to_recordset(v_live) as lv(content_item_id uuid)
  join app.content_taxonomy_labels l on l.content_item_id = lv.content_item_id
  where l.superseded_by is null and l.label_status = 'stale';
  if n_bad > 0 then raise exception '%: % target labels left stale', v_run, n_bad; end if;

  raise notice '%: stems updated %, labels carried forward %', v_run, n_upd, n_lbl;
end
$apply$
$rbtxt$;
  res := res || jsonb_build_object('after_rollback', jsonb_build_object(
      'stems_cleaned', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.new_md5),
      'stems_old', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.old_md5),
      'published', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where civ.status='published'),
      'choices_same', (select count(*) from _reh r where (select md5(string_agg(mc.choice_key||'|'||mc.choice_text||'|'||mc.is_correct::text, chr(10) order by mc.choice_key)) from app.mcq_choices mc where mc.content_item_version_id=r.v)=r.cmd5),
      'labels', (select jsonb_object_agg(k, c) from (select l.label_status||case when l.validated_against_taxo_hash=app.taxonomy_relevant_hash(r.v) then '_fresh' when l.validated_against_taxo_hash is null then '_null' else '_nonfresh' end k, count(*) c
                 from _reh r join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r.lid group by 1) x),
      'served_by_selector', (select count(*) from public.select_unit_gated_practice_items('b119fcbf-e665-41f6-8dce-ce6263a0f2b3'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id),
      'served_clean_stem', (select count(*) from public.select_unit_gated_practice_items('b119fcbf-e665-41f6-8dce-ce6263a0f2b3'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id where s.stem !~ '\mA\. .+\mB\. .+\mC\. ')));

  raise exception 'REHEARSAL_RESULT %', res::text using errcode = 'P0001';
end
$reh$;
