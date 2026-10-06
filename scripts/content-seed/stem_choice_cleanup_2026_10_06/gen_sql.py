#!/usr/bin/env python3
"""Generate prod_apply.sql, prod_apply_review7.sql, prod_rollback.sql, prod_verify.sql and
dev_rehearsal.sql from prod_snapshot.json + classification.json (see build.py)."""
import hashlib, json
from pathlib import Path

HERE = Path(__file__).resolve().parent
snap = json.loads((HERE / "prod_snapshot.json").read_text())
cls = {c["version_id"]: c for c in json.loads((HERE / "classification.json").read_text())}
rows = snap["rows"]
byid = {r["version_id"]: r for r in rows}

def md5(s): return hashlib.md5(s.encode()).hexdigest()
def lit(s):
    assert "$s$" not in s
    return "$s$" + s + "$s$"
def choices_sig(r):
    # same text as: string_agg(choice_key||'|'||choice_text||'|'||is_correct::text, chr(10) order by choice_key)
    return md5("\n".join(f"{c['choice_key']}|{c['choice_text']}|{'true' if c['is_correct'] else 'false'}"
                         for c in sorted(r["choices"], key=lambda c: c["choice_key"])))

clean = [byid[v] for v, c in cls.items() if c["cls"] == "clean_match"]
review = [byid[v] for v, c in cls.items() if c["cls"] == "ambiguous"]
clean.sort(key=lambda r: r["content_key"]); review.sort(key=lambda r: r["content_key"])

def body(run, approval_expr, targets, reason, expect_label):
    """targets: list of (version_id, content_key, from_md5, to_stem, choices_md5). One DO statement, no temp tables."""
    tj = json.dumps([{"version_id": v, "content_key": k, "from_md5": fm, "to_stem": ts, "choices_md5": cm}
                     for v, k, fm, ts, cm in targets], ensure_ascii=False, indent=0)
    assert "$tj$" not in tj
    n = len(targets)
    return f"""do $apply$
declare
  v_approval constant text := {approval_expr};
  v_run      constant text := '{run}';
  -- target rows: version_id, content_key, md5 of the stem we expect to find, the stem to write, md5 of the choices
  v_targets  constant jsonb := $tj${tj}$tj$::jsonb;
  v_live jsonb; v_prior jsonb;
  n_target int; n_live int; n_upd int; n_lbl int; n_bad int;
begin
  if v_approval is null or v_approval = 'PENDING' then
    raise exception '{run}: label carry-forward needs a Product Owner approval reference (set v_approval)';
  end if;
  perform pg_advisory_xact_lock(hashtext('cramapple-' || v_run));
  n_target := jsonb_array_length(v_targets);
  if n_target <> {n} then raise exception '%: expected {n} target rows, got %', v_run, n_target; end if;

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
        'reason', '{reason}',
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
"""

HEADER_APPLY = """-- Stem/choice cleanup 2026-10-06 -- PRODUCTION APPLY (NOT YET APPLIED; needs approval)
-- Removes the trailing "\\n\\nA. ..\\nB. ..\\nC. ..\\nD. .." list from {n} published MCQ stems whose inline list is
-- byte-identical to app.mcq_choices (class clean_match in classification.json). Nothing before the list changes.
-- Generated by gen_sql.py from prod_snapshot.json. See REPORT.md.
--
-- ONE statement (a DO block, no temp tables). Idempotent: a row is updated only while md5(stem) still equals the snapshot,
-- it is still the latest published MCQ version, and its choices still match the snapshot. A re-run is a no-op.
--
-- Why the label step: app.taxonomy_relevant_hash() covers `stem`, so the write fires tg_content_versions_taxonomy_stale
-- and every current validated/provisional_model label of these items goes 'stale' (the derive trigger also nulls
-- validated_by/at/decision). select_unit_gated_practice_items requires label_status='validated' AND
-- validated_against_taxo_hash = taxonomy_relevant_hash(version), so without the carry-forward 148 currently-served
-- items would drop out of unit-gated serving. Precedent: 20261004120000_apcalcab_u1_canonical_answers_20_items.sql
-- (APPROVAL-0116) and APPROVAL-0066. Set v_approval below before running.
--
-- No trigger is disabled. Triggers fired: set_updated_at (updated_at moves), content_pipeline_guard_publish (no-op:
-- status unchanged), content_item_versions_mcq_stem_choice_sync (passes: no letter lines remain),
-- tg_content_versions_taxonomy_stale (handled), tg_content_taxonomy_labels_derive (handled). publish_gate and
-- enforce_full_exam_frq_version do not fire (column lists exclude stem).
--
-- Rollback: prod_rollback.sql (restores snapshot stems with the same label carry-forward).
"""

def apply_targets(rs, use_proposed=False):
    out = []
    for r in rs:
        c = cls[r["version_id"]]
        to = c["proposed_stem"] if use_proposed else c["cleaned_stem"]
        out.append((r["version_id"], r["content_key"], r["stem_md5"], to, choices_sig(r)))
    return out

reason_apply = "stem/choice cleanup: duplicated inline answer-choice list removed from stem; question text, choices, units and topics unchanged; no relabelling"
t_clean = apply_targets(clean)
(HERE / "prod_apply.sql").write_text(HEADER_APPLY.format(n=len(t_clean)) +
    body("stem-choice-cleanup-2026-10-06", "'PENDING'", t_clean, reason_apply, True))

t_rev = apply_targets(review, use_proposed=True)
(HERE / "prod_apply_review7.sql").write_text(
"""-- Stem/choice cleanup 2026-10-06 -- OPTIONAL, NEEDS A CONTENT DECISION (class ambiguous)
-- 7 stems where the inline list is followed by an assumption sentence ("Assume 25 C." etc.). The list text matches
-- app.mcq_choices exactly; the proposal removes the list and keeps the trailing sentence after a blank line, i.e.
-- "<question>\\n\\n<assumption>". Review each proposed_stem in REPORT.md before setting v_approval.
-- Same mechanics/idempotence/label carry-forward as prod_apply.sql.
""" + body("stem-choice-cleanup-review7-2026-10-06", "'PENDING'", t_rev,
           "stem/choice cleanup (reviewed): inline answer-choice list removed, trailing assumption sentence kept; choices, units and topics unchanged", True))

# rollback: from cleaned (or proposed) back to snapshot stem
rb = []
for r in clean + review:
    c = cls[r["version_id"]]
    to_now = c.get("cleaned_stem") or c["proposed_stem"]
    rb.append((r["version_id"], r["content_key"], md5(to_now), r["stem"], choices_sig(r)))
(HERE / "prod_rollback.sql").write_text(
"""-- Stem/choice cleanup 2026-10-06 -- ROLLBACK. Restores the snapshot stem (prod_snapshot.json) on every row whose
-- current stem equals the cleaned/proposed stem; rows never cleaned are skipped. Same label carry-forward, because
-- restoring the stem changes taxonomy_relevant_hash again. Re-run safe.
""" + body("stem-choice-cleanup-rollback-2026-10-06", "'PENDING'", rb,
           "rollback of stem/choice cleanup: snapshot stem restored; choices, units and topics unchanged", True))

# verify (one read-only statement returning a JSON report, plus the residual count)
vals = ",".join(f"('{r['version_id']}','{r['exam_code']}','{cls[r['version_id']]['cls']}','{r['stem_md5']}','{md5(cls[r['version_id']].get('cleaned_stem') or cls[r['version_id']].get('proposed_stem'))}','{choices_sig(r)}')" for r in rows)
(HERE / "prod_verify.sql").write_text(f"""-- Stem/choice cleanup 2026-10-06 -- VERIFY (read-only). Run before and after prod_apply.sql.
-- Expected BEFORE: every row still_old; labels validated_fresh 148, provisional_model_fresh 15, provisional_model_null 1,
--   held_fresh 32, held_nonfresh 2; servable 148; residual 198.
-- Expected AFTER prod_apply.sql: clean_match rows cleaned=191, ambiguous still_old=7; label counts IDENTICAL to before
--   (no stale); servable 148; choices_changed 0; residual 7 (0 after prod_apply_review7.sql too).

-- 1. One JSON report for the 198 snapshot rows
with snap(version_id, exam_code, cls, old_md5, new_md5, choices_md5) as (values {vals}
), cur as (
  select s.*, civ.status, md5(civ.stem) cur_md5, ci.id content_item_id,
         (select md5(string_agg(mc.choice_key||'|'||mc.choice_text||'|'||mc.is_correct::text, chr(10) order by mc.choice_key))
            from app.mcq_choices mc where mc.content_item_version_id = civ.id) cur_choices_md5,
         app.taxonomy_relevant_hash(civ.id) taxo_hash,
         not exists (select 1 from app.content_item_versions later where later.content_item_id = ci.id and later.version_num > civ.version_num) is_latest
  from snap s join app.content_item_versions civ on civ.id = s.version_id::uuid join app.content_items ci on ci.id = civ.content_item_id
), lab as (
  select cur.*, l.label_status, l.validated_against_taxo_hash, l.source_payload
  from cur left join app.content_taxonomy_labels l on l.content_item_id = cur.content_item_id and l.label_scope = 'serving' and l.superseded_by is null
)
select jsonb_build_object(
  'rows', (select count(*) from cur),
  'by_subject_class', (select jsonb_object_agg(k, v) from (select exam_code || '/' || cls k, jsonb_build_object(
      'n', count(*), 'still_old', count(*) filter (where cur_md5 = old_md5), 'cleaned', count(*) filter (where cur_md5 = new_md5),
      'other', count(*) filter (where cur_md5 not in (old_md5, new_md5)), 'not_published', count(*) filter (where status <> 'published'),
      'not_latest', count(*) filter (where not is_latest), 'choices_changed', count(*) filter (where cur_choices_md5 is distinct from choices_md5)) v
      from cur group by 1) x),
  'labels', (select jsonb_object_agg(k, c) from (select coalesce(label_status, 'none') || case when validated_against_taxo_hash = taxo_hash then '_fresh'
      when validated_against_taxo_hash is null then '_null' else '_nonfresh' end k, count(*) c from lab group by 1) y),
  'servable', (select count(*) from lab where status = 'published' and is_latest and label_status = 'validated' and validated_against_taxo_hash = taxo_hash),
  'carried_forward', (select count(*) from lab where source_payload ? 'carried_forward_stem_choice_cleanup_2026_10_06'),
  'desync_now', (select count(*) from cur where cardinality(app.mcq_stem_choice_desync(version_id::uuid, (select stem from app.content_item_versions where id = version_id::uuid))) > 0)
) report;

-- 2. Residual defect across all published MCQs
select count(*) residual
from app.content_item_versions civ join app.content_items ci on ci.id = civ.content_item_id
where civ.status = 'published' and ci.item_type = 'mcq' and civ.stem ~ '\\mA\\. .+\\mB\\. .+\\mC\\. ';
""")
print("clean", len(t_clean), "review", len(t_rev), "rollback", len(rb))


# ---------------------------------------------------------------- Dev rehearsal (subset, fully rolled back)
import re as _re
raw = json.loads(Path(__import__("sys").argv[1]).read_text())["result"] if len(__import__("sys").argv) > 1 else None
if raw:
    m = _re.search(r"<untrusted-data-[0-9a-f-]+>\n(.*)\n</untrusted-data-", raw, _re.S)
    prod = json.loads(m.group(1))[0]["j"]
    (HERE / "prod_trigger_defs.json").write_text(json.dumps({"defs": prod["defs"], "trg": prod["trg"]}, indent=1) + "\n")
defs = json.loads((HERE / "prod_trigger_defs.json").read_text())

def label_kind(r):
    l = r["labels"][0]
    fresh = l["validated_against_taxo_hash"] == r["taxo_hash"]
    return l["label_status"] + ("_fresh" if fresh else ("_null" if l["validated_against_taxo_hash"] is None else "_nonfresh"))

want = ["apcalcab-mcq-021", "apchem-mcq-013", "apphy2-mcq-010", "apphycm-mcq-016", "apcalcbc-mcq-032",
        "apchem-mcq-049", "apphy2-mcq-032", "apphycem-mcq-010", "apchem-mcq-048"]
kinds = {}
for r in sorted(rows, key=lambda r: r["content_key"]):
    kinds.setdefault((label_kind(r), r["exam_code"]), []).append(r["content_key"])
seen_kinds = {label_kind(r) for r in rows if r["content_key"] in want}
for (k, e), keys in sorted(kinds.items()):
    if k not in seen_kinds and cls[[r for r in rows if r["content_key"] == keys[0]][0]["version_id"]]["cls"] == "clean_match":
        want.append(keys[0]); seen_kinds.add(k)
for key in ["apchem-mcq-017", "apchem-mcq-007", "apphycem-mcq-013"]:  # 3 of the 7 review rows
    want.append(key)
sub = [r for r in rows if r["content_key"] in want]
sub_clean = [r for r in sub if cls[r["version_id"]]["cls"] == "clean_match"]
sub_rev = [r for r in sub if cls[r["version_id"]]["cls"] == "ambiguous"]

seed = []
for r in sub:
    l = r["labels"][0]
    seed.append({"ci": r["content_item_id"], "v": r["version_id"], "k": r["content_key"], "vn": r["version_num"],
                 "rs": r["review_status"], "stem": r["stem"], "ch": r["choices"],
                 "lid": l["content_taxonomy_label_id"], "lv": l["label_version"], "ls": l["label_status"],
                 "kind": label_kind(r), "mu": l["max_required_unit"], "vat": l["validated_at"], "vdec": l["validation_decision_id"]})
seed_json = json.dumps(seed, ensure_ascii=False)
assert "$seed$" not in seed_json

def exs(sql_text, tag):
    sql_text = sql_text.strip().rstrip(";").replace(":= 'PENDING'", ":= 'DEV-REHEARSAL'")
    assert f"${tag}$" not in sql_text
    return f"${tag}$\n{sql_text}\n${tag}$"

def ex(sql_text, tag):
    sql_text = sql_text.strip().rstrip(";").replace(":= 'PENDING'", ":= 'DEV-REHEARSAL'")
    assert f"${tag}$" not in sql_text
    return f"execute ${tag}$\n{sql_text}\n${tag}$;"

RB_KEYS = {"apcalcab-mcq-021", "apcalcab-mcq-023", "apchem-mcq-048", "apchem-mcq-014", "apchem-mcq-017"}
apply_sub = body("stem-choice-cleanup-2026-10-06", "'PENDING'", apply_targets(sub_clean), reason_apply, True)
rev_sub = body("stem-choice-cleanup-review7-2026-10-06", "'PENDING'", apply_targets(sub_rev, True), "rehearsal review7", True)
rb_sub = body("stem-choice-cleanup-rollback-2026-10-06", "'PENDING'",
              [(r["version_id"], r["content_key"], md5(cls[r["version_id"]].get("cleaned_stem") or cls[r["version_id"]]["proposed_stem"]), r["stem"], choices_sig(r)) for r in sub if r["content_key"] in RB_KEYS],
              "rehearsal rollback", True)
fn_install = "\n".join(defs["defs"][n].strip().rstrip(";") + ";" for n in
    ["taxonomy_relevant_hash", "mark_content_taxonomy_labels_stale_for_version",
     "mark_content_taxonomy_labels_stale_from_version_trigger", "set_content_taxonomy_label_derived_fields",
     "mark_content_taxonomy_labels_stale_from_child_trigger"])
pack = "b119fcbf-e665-41f6-8dce-ce6263a0f2b3"
N, NC, NR = len(sub), len(sub_clean), len(sub_rev)
stat = """jsonb_build_object(
      'stems_cleaned', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.new_md5),
      'stems_old', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where md5(civ.stem)=r.old_md5),
      'published', (select count(*) from _reh r join app.content_item_versions civ on civ.id=r.v where civ.status='published'),
      'choices_same', (select count(*) from _reh r where (select md5(string_agg(mc.choice_key||'|'||mc.choice_text||'|'||mc.is_correct::text, chr(10) order by mc.choice_key)) from app.mcq_choices mc where mc.content_item_version_id=r.v)=r.cmd5),
      'labels', (select jsonb_object_agg(k, c) from (select l.label_status||case when l.validated_against_taxo_hash=app.taxonomy_relevant_hash(r.v) then '_fresh' when l.validated_against_taxo_hash is null then '_null' else '_nonfresh' end k, count(*) c
                 from _reh r join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r.lid group by 1) x),
      'served_by_selector', (select count(*) from public.select_unit_gated_practice_items('%s'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id),
      'served_clean_stem', (select count(*) from public.select_unit_gated_practice_items('%s'::uuid, 14, null, 'mcq', 50) s join _reh r on r.v=s.content_item_version_id where s.stem !~ '\\mA\\. .+\\mB\\. .+\\mC\\. '))""" % (pack, pack)

# old/new md5 + choices md5 per seed row for checks
reh_vals = ",".join(f"('{r['version_id']}','{r['labels'][0]['content_taxonomy_label_id']}','{r['stem_md5']}','{md5(cls[r['version_id']].get('cleaned_stem') or cls[r['version_id']]['proposed_stem'])}','{choices_sig(r)}','{cls[r['version_id']]['cls']}')" for r in sub)

dev = f"""-- Stem/choice cleanup 2026-10-06 -- DEV REHEARSAL (project wmgjsdkphcyhngaffbqf). ONE DO statement that ends in
-- RAISE EXCEPTION so that EVERYTHING (installed functions/trigger, seeded rows, updates) is rolled back; the result
-- JSON is carried in the exception message. Dev holds none of the 198 Production items and lacks the taxonomy-hash
-- cluster (taxonomy_relevant_hash, tg_content_versions_taxonomy_stale), so this block installs the Production
-- definitions verbatim (from prod_trigger_defs.json), seeds {N} snapshot rows with their Production ids, stems,
-- choices and label states, then EXECUTEs the same generated apply / review / rollback DO bodies as prod (target
-- lists restricted to the seeded rows; approval 'DEV-REHEARSAL') and checks the Production selector
-- public.select_unit_gated_practice_items (identical md5 in both projects).
do $reh$
declare
  v_prof uuid; rr jsonb; cc jsonb; v_apply text; res jsonb := '{{}}'::jsonb; v_upd timestamptz; n int;
begin
  select user_id into v_prof from app.profiles order by created_at limit 1;
{fn_install}
  {defs["trg"]["tg_content_versions_taxonomy_stale"]};
  insert into app.home_release_manifest (exam_pack_version_id, allowed_unit_numbers)
  values ('{pack}', array[1,2,3,4,5,6,7,8,9,10,11,12,13,14])
  on conflict (exam_pack_version_id) do update set allowed_unit_numbers = excluded.allowed_unit_numbers;

  for rr in select * from jsonb_array_elements($seed${seed_json}$seed$::jsonb) loop
    insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)
    values ((rr->>'ci')::uuid, '{pack}', rr->>'k', 'mcq', 'rehearsal ' || (rr->>'k'), 'published');
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
      case when rr->>'mu' is null then '{{}}'::int[] else array[(rr->>'mu')::int] end, rr->>'ls', 'rehearsal',
      case when rr->>'ls'='validated' then v_prof end, case when rr->>'ls'='validated' then (rr->>'vat')::timestamptz end,
      case when rr->>'ls'='validated' then (rr->>'vdec')::uuid end);
  end loop;
  {defs["trg"]["tg_mcq_choices_taxonomy_stale"]};

  create temporary table _reh (v uuid, lid uuid, old_md5 text, new_md5 text, cmd5 text, cls text) on commit drop;
  insert into _reh values {reh_vals};
  res := res || jsonb_build_object('seeded', (select count(*) from _reh), 'before', {stat});

  -- negative control: a bare in-place stem update (no carry-forward) on one validated item, in a sub-transaction
  begin
    update app.content_item_versions set stem = stem || ' ' where id = (select r2.v from _reh r2 join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r2.lid where l.label_status='validated' limit 1);
    res := res || jsonb_build_object('negative_control_bare_update', jsonb_build_object(
      'labels_stale', (select count(*) from _reh r2 join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r2.lid where l.label_status='stale'),
      'stale_validated_by_nulled', (select count(*) from _reh r2 join app.content_taxonomy_labels l on l.content_taxonomy_label_id=r2.lid where l.label_status='stale' and l.validated_by is null),
      'served_by_selector', (select count(*) from public.select_unit_gated_practice_items('{pack}'::uuid, 14, null, 'mcq', 50) s join _reh r2 on r2.v=s.content_item_version_id)));
    raise exception 'undo-negative-control';
  exception when raise_exception then
    if sqlerrm <> 'undo-negative-control' then raise; end if;
  end;

  -- the Production apply body (subset of targets)
  v_apply := {exs(apply_sub, "applytxt")};
  execute v_apply;
  res := res || jsonb_build_object('after_apply', {stat});
  select max(civ.updated_at) into v_upd from _reh r2 join app.content_item_versions civ on civ.id=r2.v where r2.cls='clean_match';

  -- idempotence: second run must be a no-op
  execute v_apply;
  res := res || jsonb_build_object('after_rerun_cleaned', (select count(*) from _reh r2 join app.content_item_versions civ on civ.id=r2.v where md5(civ.stem)=r2.new_md5),
     'rerun_touched_rows', (select count(*) from _reh r2 join app.content_item_versions civ on civ.id=r2.v where r2.cls='clean_match' and civ.updated_at > v_upd));

  -- optional review7 body (subset)
  {ex(rev_sub, "revtxt")}
  res := res || jsonb_build_object('after_review7', {stat});

  -- rollback body
  {ex(rb_sub, "rbtxt")}
  res := res || jsonb_build_object('after_rollback', {stat});

  raise exception 'REHEARSAL_RESULT %', res::text using errcode = 'P0001';
end
$reh$;
"""
(HERE / "dev_rehearsal.sql").write_text(dev)
print("dev subset", N, NC, NR, "bytes", len(dev.encode()), [r["content_key"] for r in sub])
