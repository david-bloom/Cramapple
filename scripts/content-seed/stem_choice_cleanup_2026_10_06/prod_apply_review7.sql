-- Stem/choice cleanup 2026-10-06 -- OPTIONAL, NEEDS A CONTENT DECISION (class ambiguous)
-- 7 stems where the inline list is followed by an assumption sentence ("Assume 25 C." etc.). The list text matches
-- app.mcq_choices exactly; the proposal removes the list and keeps the trailing sentence after a blank line, i.e.
-- "<question>\n\n<assumption>". Review each proposed_stem in REPORT.md before setting v_approval.
-- Same mechanics/idempotence/label carry-forward as prod_apply.sql.
do $apply$
declare
  v_approval constant text := 'PENDING';
  v_run      constant text := 'stem-choice-cleanup-review7-2026-10-06';
  -- target rows: version_id, content_key, md5 of the stem we expect to find, the stem to write, md5 of the choices
  v_targets  constant jsonb := $tj$[
{
"version_id": "71881e36-c4b2-4336-9796-9b4cb4689e61",
"content_key": "apchem-mcq-006",
"from_md5": "0e30cd482f6ff0cf91bdb1a5de53e302",
"to_stem": "A solution has absorbance 0.60 in a 1.0 cm cell. If concentration is halved, the absorbance is approximately\n\nAssume the diluted solution is measured at the same wavelength in the same 1.0 cm cell and remains in the linear Beer-Lambert range.",
"choices_md5": "9c5bba84fb47010606cf6d1ba39b7ad4"
},
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
"version_id": "5a6405c0-7c21-4333-8269-1a6ac8792f4d",
"content_key": "apchem-mcq-057",
"from_md5": "495e0e16fc556c8ffd40845852287f22",
"to_stem": "A saturated aqueous solution of CaF2 is at equilibrium: CaF2(s) <-> Ca2+(aq) + 2F-(aq). A small amount of soluble NaF is added to the solution and stirred until it fully dissolves. What happens to the molar solubility of CaF2?\n\nAssume ideal solution behavior and no complex-ion formation.",
"choices_md5": "1f64c92b6625f5fc737bf329c08a1afe"
},
{
"version_id": "758bafd5-9407-4a0c-a4ee-dcd375ab1d29",
"content_key": "apchem-mcq-061",
"from_md5": "c61bfccdb7b661ea4a5750776ddee03e",
"to_stem": "50.0 mL of 0.20 M HCl is mixed with 50.0 mL of 0.30 M NaOH. What is the pH of the resulting solution?\n\nAssume 25 C and additive volumes.",
"choices_md5": "8efd92a0adeaa1e691a849a544532761"
},
{
"version_id": "510c04d3-678d-4bc9-a050-4462d34b933c",
"content_key": "apchem-mcq-066",
"from_md5": "c316f60a7721adac373355bf6b46c804",
"to_stem": "A reaction has deltaH = -92 kJ/mol and deltaS = +198 J/(mol*K). Which statement correctly describes the thermodynamic favorability of this reaction?\n\nAssume Delta H and Delta S remain approximately temperature-independent over the temperature range considered.",
"choices_md5": "0f760e849daed7b697ff001c53582148"
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
  if n_target <> 7 then raise exception '%: expected 7 target rows, got %', v_run, n_target; end if;

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
        'reason', 'stem/choice cleanup (reviewed): inline answer-choice list removed, trailing assumption sentence kept; choices, units and topics unchanged',
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
$apply$;
