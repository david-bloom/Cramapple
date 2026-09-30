#!/usr/bin/env python3
"""Split the two generated batch SQL files into small independent transactions and emit a database-side hash check.
Nothing here touches a database. Output: load/chunk_NN.sql, load/verify_hashes.sql, load/manifest.json"""
import hashlib, importlib, json, re
from pathlib import Path
from items import MCQS, FRQS

HERE = Path(__file__).parent
OUT = HERE / "load"; OUT.mkdir(exist_ok=True)
for f in OUT.glob("chunk_*.sql"): f.unlink()

def blocks(path):
    s = path.read_text()
    parts = re.split(r"\n(?=-- (?:MCQ|FRQ) (?:variant )?\S+ )", s)
    body = parts[1:]
    body[-1] = re.sub(r"\ncommit;\s*$", "\n", body[-1])
    return body
orig = blocks(HERE / "20260929_apcalcab_unit1_original_batch.sql")
var = blocks(HERE / "20260929_apcalcab_unit1_variants_batch.sql")
allb = orig + var
assert len(orig) == 34 and len(var) == 102, (len(orig), len(var))

def key_of(b): return re.search(r"'(apcalcab-(?:mcq|frq)-u1[nv]-[0-9a-z-]+)'", b).group(1)
keys = [key_of(b) for b in allb]
assert len(set(keys)) == 136

HEAD = """begin;
create temporary table u1n_epv (epv_id uuid) on commit drop;
create temporary table u1v_epv (epv_id uuid) on commit drop;
insert into u1n_epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
insert into u1v_epv select epv_id from u1n_epv;
do $$ begin
  if (select count(*) from u1n_epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join u1n_epv on ci.exam_pack_version_id = u1n_epv.epv_id where ci.content_key = any (array[__KEYS__])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
"""
chunks, cur, size = [], [], 0
for b in allb:
    if cur and size + len(b) > 22000:
        chunks.append(cur); cur, size = [], 0
    cur.append(b); size += len(b)
chunks.append(cur)
manifest = []
for i, ch in enumerate(chunks, 1):
    ks = [key_of(b) for b in ch]
    sql = HEAD.replace("__KEYS__", ",".join("'" + k + "'" for k in ks)) + "".join(ch).rstrip() + "\n\ncommit;\n"
    (OUT / f"chunk_{i:02d}.sql").write_text(sql)
    manifest.append(dict(chunk=i, items=len(ks), bytes=len(sql), first=ks[0], last=ks[-1]))

# expected hashes from the Python source data (not from the SQL text)
vs = []
for n in ["variants_mcq_a", "variants_mcq_b", "variants_mcq_c", "variants_frq"]:
    vs += importlib.import_module(n).VARIANTS
tv = ["0.16713", "0.16671", "0.16667", "0.16666", "0.16662", "0.16621"]
def md5(s): return hashlib.md5(s.encode()).hexdigest()
def mcq_h(key, stem, correct, wrong):
    ch = sorted([f"{correct[0]}|true|{correct[1]}"] + [f"{w[0]}|false|{w[1]}" for w in wrong])
    return (key, md5(stem), md5("\n".join(ch)))
def frq_h(key, stem, stim, crit):
    cs = sorted(f"{c[0]}|{c[1]}|{c[2]}|{c[3]}|{c[4]}" for c in crit)
    return (key, md5(stem + "\n" + stim), md5("\n".join(cs)))
exp = []
for m in MCQS: exp.append(mcq_h(f"apcalcab-mcq-u1n-{m['id']}", m["stem"], m["correct"], m["wrong"]))
for f in FRQS:
    st = f["stimulus"]
    for n_, v in enumerate(tv, 1): st = st.replace(f"TABLE_H{n_}", v)
    exp.append(frq_h(f"apcalcab-frq-u1n-{f['id']}", f["stem"], st, f["criteria"]))
for v in vs:
    if v["kind"] == "mcq": exp.append(mcq_h(f"apcalcab-mcq-u1v-{v['id']}", v["stem"], v["correct"], v["wrong"]))
    else: exp.append(frq_h(f"apcalcab-frq-u1v-{v['id']}", v["stem"], v["stimulus"], v["criteria"]))
assert sorted(e[0] for e in exp) == sorted(keys)
vals = ",\n".join(f"('{k}','{a}','{b}')" for k, a, b in sorted(exp))
(OUT / "verify_hashes.sql").write_text(f"""with exp(content_key, h_stem, h_body) as (values
{vals}
), act as (
  select ci.content_key,
    case when ci.item_type = 'mcq'
      then md5(civ.stem)
      else md5(coalesce(civ.stem,'') || E'\\n' || coalesce(civ.stimulus,'')) end as h_stem,
    case when ci.item_type = 'mcq'
      then md5((select string_agg(m.choice_text || '|' || m.is_correct::text || '|' || m.rationale, E'\\n' order by (m.choice_text || '|' || m.is_correct::text || '|' || m.rationale) collate "C") from app.mcq_choices m where m.content_item_version_id = civ.id))
      else md5((select string_agg(c.criterion_key || '|' || c.learner_facing_text || '|' || c.points_possible::text || '|' || c.evidence_requirements || '|' || c.minimum_fix, E'\\n' order by (c.criterion_key || '|' || c.learner_facing_text || '|' || c.points_possible::text || '|' || c.evidence_requirements || '|' || c.minimum_fix) collate "C") from app.frq_criteria c where c.content_item_version_id = civ.id)) end as h_body,
    ci.item_type, civ.canonical_answer_1,
    (select m.choice_key from app.mcq_choices m where m.content_item_version_id = civ.id and m.is_correct limit 1) as correct_letter
  from app.content_items ci
  join app.content_item_versions civ on civ.content_item_id = ci.id and civ.version_num = 1
  where ci.exam_pack_version_id = '826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and (ci.content_key like 'apcalcab-%-u1n-%' or ci.content_key like 'apcalcab-%-u1v-%')
)
select
  (select count(*) from exp) as expected_items,
  (select count(*) from act) as loaded_items,
  (select count(*) from exp e join act a using (content_key) where e.h_stem = a.h_stem and e.h_body = a.h_body) as exact_matches,
  (select coalesce(string_agg(e.content_key, ', '), 'none') from exp e join act a using (content_key) where e.h_stem <> a.h_stem or e.h_body <> a.h_body) as loaded_but_mismatched,
  (select count(*) from exp e left join act a using (content_key) where a.content_key is null) as not_yet_loaded,
  (select count(*) from act where item_type = 'mcq' and canonical_answer_1 is distinct from correct_letter) as letter_key_inconsistent;
""")
json.dump(manifest, open(OUT / "manifest.json", "w"), indent=1)
# per-chunk verification: same query, expected values restricted to the chunk's keys
full = (OUT / "verify_hashes.sql").read_text()
head, rest = full.split("\n), act as (", 1)
rest = "\n), act as (" + rest
expd = {k: (a, b) for k, a, b in exp}
for i, ch in enumerate(chunks, 1):
    ks = [key_of(b) for b in ch]
    vv = ",\n".join(f"('{k}','{expd[k][0]}','{expd[k][1]}')" for k in sorted(ks))
    (OUT / f"verify_{i:02d}.sql").write_text("with exp(content_key, h_stem, h_body) as (values\n" + vv + rest)
print(len(chunks), "chunks;", "sizes(KB):", [round(m["bytes"] / 1024, 1) for m in manifest])
print("expected hashes:", len(exp))
