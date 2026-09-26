#!/usr/bin/env python3
"""Build deterministic AP Calculus AB Tier 3 migration batches."""

import csv
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RUN_ID = "serving-units-mcp-2026-09-25-20260926030346"
PROPOSAL_RUN = "apcalcab_tier3_difficulty_2026_09_25"


def sql_text(value):
    return "'" + str(value).replace("'", "''") + "'"


def extract_value_tuples(sql):
    start_marker = ") values\n"
    end_marker = ";\n\nwith numbered as ("
    start = sql.index(start_marker, sql.index("insert into tmp_math_serving_labels")) + len(start_marker)
    end = sql.index(end_marker, start)
    body = sql[start:end].strip()
    tuples, depth, quote, tuple_start, i = [], 0, False, None, 0
    while i < len(body):
        char = body[i]
        if quote:
            if char == "'" and i + 1 < len(body) and body[i + 1] == "'":
                i += 2
                continue
            if char == "'":
                quote = False
        else:
            if char == "'":
                quote = True
            elif char == "(":
                if depth == 0:
                    tuple_start = i
                depth += 1
            elif char == ")":
                depth -= 1
                if depth == 0 and tuple_start is not None:
                    tuples.append(body[tuple_start : i + 1])
                    tuple_start = None
                if depth < 0:
                    raise ValueError("negative tuple depth")
        i += 1
    if quote or depth != 0 or tuple_start is not None:
        raise ValueError("unterminated quote or tuple")
    return start, end, tuples


def build_label_batches(source_path):
    sql = Path(source_path).read_text(encoding="utf-8")
    start, end, tuples = extract_value_tuples(sql)
    if len(tuples) != 93:
        raise ValueError(f"expected 93 label tuples, got {len(tuples)}")
    prefix = sql[:start]
    suffix = sql[end + 2 :]  # keep `with numbered...`, omit source semicolon/newlines
    sizes = [31, 31, 31]
    offset = 0
    outputs = []
    for index, size in enumerate(sizes, 1):
        selected = tuples[offset : offset + size]
        offset += size
        precheck = f""";

do $$
declare
  v_expected int := {size};
  v_rows int;
  v_prior int;
  v_bad_subject int;
begin
  select count(*) into v_rows from tmp_math_serving_labels;
  if v_rows <> v_expected then
    raise exception 'AP Calculus AB label batch {index}: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_prior
  from tmp_math_serving_labels tmp
  join app.content_taxonomy_labels ctl
    on ctl.content_item_id = tmp.content_item_id
   and ctl.model_run_id = tmp.model_run_id;
  if v_prior <> 0 then
    raise exception 'AP Calculus AB label batch {index}: % rows already exist for this model_run_id', v_prior;
  end if;

  select count(*) into v_bad_subject
  from tmp_math_serving_labels tmp
  where not exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id and epv.retired_at is null
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join lateral (
      select civ.id, civ.status
      from app.content_item_versions civ
      where civ.content_item_id = ci.id
      order by civ.version_num desc
      limit 1
    ) latest on true
    where ci.id = tmp.content_item_id
      and latest.id = tmp.validated_against_version_id
      and ep.exam_code = 'ap_calculus_ab'
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_bad_subject <> 0 then
    raise exception 'AP Calculus AB label batch {index}: % contaminated or non-current rows', v_bad_subject;
  end if;
end $$;

"""
        batch = (
            f"-- AP Calculus AB Tier 3 serving labels, batch {index}/3.\n"
            f"-- Programmatically split from generated write_labels.sql. Run ID: {RUN_ID}.\n"
            f"-- Batch rows: {size}.\n\n"
            + prefix.lstrip("\n")
            + ",\n".join(selected)
            + precheck
            + suffix
        )
        if re.search(r"\),\s*,\s*\(", batch):
            raise ValueError(f"double comma in label batch {index}")
        path = ROOT / "supabase/migrations" / f"20260925220{index}00_apcalcab_serving_labels_batch_{index:02d}.sql"
        path.write_text(batch, encoding="utf-8")
        outputs.append(path)
    return outputs


def build_difficulty_batches(items_path, csv_path):
    items = {item["content_key"]: item for item in json.loads(Path(items_path).read_text(encoding="utf-8"))}
    with Path(csv_path).open(newline="", encoding="utf-8") as handle:
        rows = list(csv.DictReader(handle))
    if len(rows) != 122 or set(items) != {row["content_key"] for row in rows}:
        raise ValueError("difficulty CSV and 122-item Production packet keys differ")
    rows.sort(key=lambda row: row["content_key"])
    sizes = [31, 31, 30, 30]
    offset, outputs = 0, []
    for index, size in enumerate(sizes, 1):
        selected = rows[offset : offset + size]
        offset += size
        values = []
        for row in selected:
            item = items[row["content_key"]]
            db_basis = "calibrated_judgement" if row["basis"] == "judgement" else "calibrated_task_verb"
            audit = json.dumps({
                "framework": "ap_calculus_ab_calculus_specific_task_cues",
                "csv_basis": row["basis"],
                "item_type": row["item_type"],
                "source_file": "docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv",
            }, separators=(",", ":"))
            values.append(
                "  ("
                + ", ".join([
                    sql_text(row["content_key"]),
                    sql_text(item["content_item_version_id"]) + "::uuid",
                    sql_text(row["difficulty"]),
                    sql_text(db_basis),
                    sql_text(audit) + "::jsonb",
                    sql_text(row["rationale"]),
                ])
                + ")"
            )
        joined_values = ",\n".join(values)
        batch = f"""-- AP Calculus AB Tier 3 difficulty, batch {index}/4.
-- Generated from APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv. Batch rows: {size}.

begin;

create temporary table tmp_apcalcab_difficulty (
  content_key text not null,
  content_item_version_id uuid not null,
  difficulty text not null,
  basis text not null,
  subject_cut_points jsonb not null,
  rationale text not null
) on commit drop;

insert into tmp_apcalcab_difficulty (
  content_key, content_item_version_id, difficulty, basis, subject_cut_points, rationale
) values
{joined_values};

do $$
declare
  v_expected int := {size};
  v_rows int;
  v_prior int;
  v_bad_subject int;
begin
  select count(*) into v_rows from tmp_apcalcab_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Calculus AB difficulty batch {index}: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_prior
  from tmp_apcalcab_difficulty tmp
  join app.content_item_difficulty cid on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception 'AP Calculus AB difficulty batch {index}: % versions already have difficulty rows', v_prior;
  end if;

  select count(*) into v_bad_subject
  from tmp_apcalcab_difficulty tmp
  where not exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id and epv.retired_at is null
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join lateral (
      select civ.id, civ.status
      from app.content_item_versions civ
      where civ.content_item_id = ci.id
      order by civ.version_num desc
      limit 1
    ) latest on true
    where ci.content_key = tmp.content_key
      and latest.id = tmp.content_item_version_id
      and ep.exam_code = 'ap_calculus_ab'
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_bad_subject <> 0 then
    raise exception 'AP Calculus AB difficulty batch {index}: % contaminated or non-current rows', v_bad_subject;
  end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio,
  ratio_source, subject_cut_points, source_value, rationale, confidence, proposal_run
)
select
  content_item_version_id, difficulty, basis, null,
  null, subject_cut_points, null, rationale, 'medium', {sql_text(PROPOSAL_RUN)}
from tmp_apcalcab_difficulty;

commit;
"""
        path = ROOT / "supabase/migrations" / f"20260925221{index}00_apcalcab_difficulty_batch_{index:02d}.sql"
        path.write_text(batch, encoding="utf-8")
        outputs.append(path)
    return outputs


def main():
    if len(sys.argv) != 4:
        raise SystemExit("usage: build_apcalcab_tier3_migrations.py WRITE_LABELS.sql ITEMS.json ASSIGNMENTS.csv")
    paths = build_label_batches(sys.argv[1])
    paths += build_difficulty_batches(sys.argv[2], sys.argv[3])
    for path in paths:
        print(path.relative_to(ROOT))


if __name__ == "__main__":
    main()
