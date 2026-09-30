#!/usr/bin/env python3
"""Build the load SQL for the 24 seeded variants (pilot 16 + Unit 3 8). Random correct-letter draw per item happens ONCE here;
NEVER re-run after any chunk is loaded (it would redraw). Writes batch_manifest.json, load/chunk_NN.sql, load/verify_hashes.sql."""
import hashlib, json, secrets, sys
from pathlib import Path
sys.path.insert(0, "../calc-ab-pilot-2026-09-30"); sys.path.insert(0, "../calc-ab-unit3-variants-2026-09-30")
import pilot, unit3
if Path("batch_manifest.json").exists() and "--force" not in sys.argv:
    sys.exit("batch_manifest.json exists: refusing to redraw letters (use --force only before anything is loaded)")
def q(s): return "'" + s.replace("'", "''") + "'"
def md5(s): return hashlib.md5(s.encode()).hexdigest()
rng = secrets.SystemRandom(); L = "ABCD"; items = []
for src, mod in (("pilot", pilot), ("unit3", unit3)):
    for v in mod.V:
        assert v["key_calc"]() == v["correct"][0]
        ch = [(v["correct"][0], v["correct"][1], True)] + [(w[0], w[1], False) for w in v["wrong"]]; rng.shuffle(ch)
        seedshort = v["seed"].replace("apcalcab-mcq-", "")
        key = f"apcalcab-mcq-sv-{v['id']}"
        assert v["id"].startswith(seedshort + "-v") or v["id"].startswith(seedshort.split("-")[-1]) , (v["id"], seedshort)
        rows = [f"{c[0]}|{str(c[2]).lower()}|{c[1]}" for c in ch]
        items.append(dict(key=key, src=src, seed=v["seed"], title=v["title"], stem=v["stem"], stimulus=v["stimulus"],
                          choices=[dict(k=L[i], t=c[0], r=c[1], c=c[2]) for i, c in enumerate(ch)],
                          letter=next(L[i] for i, c in enumerate(ch) if c[2]),
                          h_stem=md5(v["stem"]), h_body=md5("\n".join(sorted(rows))), change=v["change"]))
assert len({i["key"] for i in items}) == len(items) == 24
Path("load").mkdir(exist_ok=True)
json.dump(items, open("batch_manifest.json", "w"), indent=1)
HEAD = """begin;
create temporary table epv (epv_id uuid) on commit drop;
insert into epv select epv.id from app.exam_pack_versions epv join app.exam_packs e on e.id = epv.exam_pack_id where e.exam_name = 'AP Calculus AB';
do $$ begin
  if (select count(*) from epv) <> 1 then raise exception 'exam pack version lookup failed'; end if;
  if exists (select 1 from app.content_items ci join epv on ci.exam_pack_version_id = epv.epv_id where ci.content_key = any (array[%s])) then
    raise exception 'chunk already loaded';
  end if;
end $$;
"""
def block(it):
    s = [f"-- {it['key']} (seed {it['seed']})", "with item_ins as (",
         "  insert into app.content_items (id, exam_pack_version_id, content_key, item_type, title, status)",
         f"  select gen_random_uuid(), epv_id, {q(it['key'])}, 'mcq', {q(it['title'])}, 'draft' from epv returning id",
         "), version_ins as (",
         "  insert into app.content_item_versions (id, content_item_id, version_num, stem, stimulus, content_hash, status, review_status, canonical_answer_1)",
         f"  select gen_random_uuid(), id, 1, {q(it['stem'])}, {q(it['stimulus']) if it['stimulus'] else 'null'}, md5({q(it['key'])}), 'draft', 'tutor_review_pending', {q(it['letter'])}",
         "  from item_ins returning id", ")",
         "insert into app.mcq_choices (id, content_item_version_id, choice_key, choice_text, is_correct, rationale)"]
    parts = [f"select gen_random_uuid(), id, {q(c['k'])}, {q(c['t'])}, {str(c['c']).lower()}, {q(c['r'])} from version_ins" for c in it["choices"]]
    s.append(("\nunion all ").join(parts) + "\n;")
    return "\n".join(s)
for n in range(0, 24, 8):
    grp = items[n:n + 8]
    body = HEAD % ",".join(q(i["key"]) for i in grp) + "\n".join(block(i) for i in grp) + "\ncommit;\n"
    Path(f"load/chunk_{n//8+1:02d}.sql").write_text(body)
exp = ",\n".join(f"({q(i['key'])},{q(i['h_stem'])},{q(i['h_body'])},{q(i['stimulus'] or '')})" for i in items)
Path("load/verify_hashes.sql").write_text(f"""with exp(content_key, h_stem, h_body, stim) as (values
{exp}
), act as (
  select ci.content_key, md5(civ.stem) h_stem,
    md5((select string_agg(m.choice_text || '|' || m.is_correct::text || '|' || m.rationale, E'\\n' order by (m.choice_text || '|' || m.is_correct::text || '|' || m.rationale) collate "C") from app.mcq_choices m where m.content_item_version_id = civ.id)) h_body,
    coalesce(civ.stimulus,'') stim, civ.canonical_answer_1,
    (select m.choice_key from app.mcq_choices m where m.content_item_version_id = civ.id and m.is_correct limit 1) correct_letter
  from app.content_items ci join app.content_item_versions civ on civ.content_item_id = ci.id and civ.version_num = 1
  where ci.exam_pack_version_id = '826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.content_key like 'apcalcab-mcq-sv-%'
)
select (select count(*) from exp) expected_items, (select count(*) from act) loaded_items,
  (select count(*) from exp e join act a using (content_key) where e.h_stem = a.h_stem and e.h_body = a.h_body and e.stim = a.stim) exact_matches,
  (select coalesce(string_agg(e.content_key, ', '), 'none') from exp e join act a using (content_key) where e.h_stem <> a.h_stem or e.h_body <> a.h_body or e.stim <> a.stim) loaded_but_mismatched,
  (select count(*) from exp e left join act a using (content_key) where a.content_key is null) not_yet_loaded,
  (select count(*) from act where canonical_answer_1 is distinct from correct_letter) letter_key_inconsistent;
""")
import collections
print(len(items), "items;", "letters:", dict(collections.Counter(i["letter"] for i in items)))
