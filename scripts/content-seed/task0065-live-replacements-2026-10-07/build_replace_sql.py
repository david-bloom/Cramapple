"""TASK-0065 / APPROVAL-0129: replace three live Open Hand teaching items found defective by the method test.
Loads each replacement with the APPROVAL-0125 loader's SQL (build_load_sql.py TEMPLATE), then, per topic, releases
the old generated teaching row and retires its item and published version, and asserts the topic ends with exactly
one active generated teaching item: the new one. Writes <subject>_rehearsal.sql (raises at the end, so it rolls back)
and <subject>_apply.sql per subject."""
import json, os, sys
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
sys.path.insert(0, os.path.join(ROOT, "scripts/content-seed/task0065_load"))
import build_load_sql as b
NOTE = "TASK-0065 replacement 2026-10-07 (APPROVAL-0129)"
OLD_NOTE = "TASK-0065 batch 2026-10-06"
items = json.load(open(os.path.join(HERE, "from_method_test.json"))) + json.load(open(os.path.join(HERE, "batch/accepted.json")))
REPLACE_TAIL = r"""
  -- Replace: release the old generated row for each replaced topic and retire its item.
  declare
    t text; v_old uuid; v_new int;
  begin
    foreach t in array {topics} loop
      select tt.content_item_id into v_old from app.open_hand_teaching_items tt
        join app.content_items ci on ci.id = tt.content_item_id
      where ci.exam_pack_version_id = v_pv and tt.topic_code = t and tt.source = 'generated'
        and tt.released_at is null and tt.note = '{old_note}';
      if v_old is null then raise exception 'replace: no active old item for % %', v_subject, t; end if;
      update app.open_hand_teaching_items set released_at = now(), note = note || ' | replaced 2026-10-07 (APPROVAL-0129)' where content_item_id = v_old;
      update app.content_item_versions set status = 'retired', updated_at = now() where content_item_id = v_old and status = 'published';
      update app.content_items set status = 'retired' where id = v_old;
      select count(*) into v_new from app.open_hand_teaching_items tt join app.content_items ci on ci.id = tt.content_item_id
      where ci.exam_pack_version_id = v_pv and tt.topic_code = t and tt.source = 'generated' and tt.released_at is null
        and tt.note = '{note}' and ci.status = 'published';
      if v_new <> 1 then raise exception 'replace: % % has % active new items, expected 1', v_subject, t, v_new; end if;
      if (select count(*) from app.open_hand_teaching_items tt join app.content_items ci on ci.id = tt.content_item_id
          where ci.exam_pack_version_id = v_pv and tt.topic_code = t and tt.released_at is null) <> 1 then
        raise exception 'replace: % % does not have exactly one active teaching row', v_subject, t; end if;
    end loop;
  end;
"""
by = {}
for it in items:
    by.setdefault(it["subject_key"], []).append({
        "content_key": b.PREFIX[it["subject_key"]] + it["topic_code"] + "-r2",
        "topic_code": it["topic_code"], "title": it["topic_title"], "stem": it["stem"],
        "choices": [{k: c[k] for k in ("choice_key", "choice_text", "is_correct", "rationale")} for c in sorted(it["choices"], key=lambda c: c["choice_key"])]})
for s, rows in by.items():
    for r in rows:
        assert len(r["choices"]) == 4 and sum(c["is_correct"] for c in r["choices"]) == 1
    payload = json.dumps(rows, ensure_ascii=False, separators=(",", ":"))
    sql = b.TEMPLATE.format(subject=s, n=len(rows), tsv=b.TSV[s], owner=b.OWNER, jtag=b.JTAG, payload=payload,
                            cell_source="task0065_oht_replacement_2026_10_07", note=NOTE)
    topics = "array[" + ",".join(f"'{r['topic_code']}'" for r in rows) + "]::text[]"
    tail = REPLACE_TAIL.replace("{topics}", topics).replace("{old_note}", OLD_NOTE).replace("{note}", NOTE)
    marker = "  raise notice 'task0065 %: pack %, loaded %, skipped %, spares released %'"
    assert sql.count(marker) == 1
    old_prov = "'TASK-0065 Open Hand teaching batch 2026-10-06 (authored to this topic; checked per CHECK_RESULTS.md)'"
    assert sql.count(old_prov) == 1
    sql = sql.replace(old_prov, "'TASK-0065 replacement 2026-10-07, APPROVAL-0129: generate-and-select pipeline (4 non-author checkers + veto) and held-out judges; see task0065-live-replacements-2026-10-07'")
    apply = sql.replace(marker, tail + marker)
    rehearsal = apply.replace(marker, "  raise exception 'REHEARSAL OK %: pack %, loaded %, skipped %', v_subject, v_pv, v_loaded, v_skipped;\n" + marker)
    open(os.path.join(HERE, f"{s}_apply.sql"), "w").write(apply)
    open(os.path.join(HERE, f"{s}_rehearsal.sql"), "w").write(rehearsal)
    print(s, [r["content_key"] for r in rows], len(apply))

import hashlib
hashes = {}
for s_, rows in by.items():
    for r in rows:
        blob = r["stem"] + "".join(c["choice_key"] + c["choice_text"] + str(c["is_correct"]).lower() + c["rationale"] for c in r["choices"])
        hashes[r["content_key"]] = hashlib.md5(blob.encode()).hexdigest()
json.dump(hashes, open(os.path.join(HERE, "expected_hashes.json"), "w"), indent=1)
print(hashes)
