"""Build the review-only, guarded SQL for one-candidate Statistics skill cells."""

import glob
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PACK = "548f06be-ccf4-426d-b82b-b424137a4438"
RUN = "task0050-stats-phase-b-2026-11-11:deterministic_single_candidate"


def quote(value):
    return "'" + str(value).replace("'", "''") + "'"


packets = [p for name in sorted(glob.glob(str(HERE / "packets_*.json"))) for p in json.loads(Path(name).read_text())]
assert len(packets) == len({p["v"] for p in packets}) == 390
one = [p for p in packets if len(p["cands"]) == 1]
assert len(one) == 99

values = ",\n".join(
    "  (" + ", ".join(quote(x) for x in (p["k"], p["v"], p["tc"], p["cands"][0]["c"])) + ")"
    for p in one
)
sql = f"""-- TASK-0050 Statistics Phase B: deterministic single-candidate cells only.
-- REVIEW ONLY. Production write requires a fresh subject-specific Hard-Gate approval.
-- Exactly 99 currently published versions had one registered skill at export time.
-- Source: the 20 packets_*.json files in this directory (Production read, 2026-11-11 ET).
-- Rollback after an authorized apply: delete from app.content_item_cells
--   where model_run_id = {quote(RUN)};
begin;
do $task0050$
declare inserted_count integer;
begin
  insert into app.content_item_cells (
    content_item_id, content_item_version_id, taxonomy_source_version,
    topic_code, skill_code, is_primary, assignment_status, source, model_run_id
  )
  select ci.id, v.id, p.taxonomy_source_version, p.topic_code, proposed.skill_code,
         false, 'provisional_model', 'skill_dimension_phase_b_deterministic', {quote(RUN)}
  from (values
{values}
  ) as proposed(content_key, version_id, topic_code, skill_code)
  join app.content_items ci
    on ci.content_key = proposed.content_key
   and ci.exam_pack_version_id = {quote(PACK)}::uuid
   and ci.status = 'published'
  join app.content_item_versions v
    on v.id = proposed.version_id::uuid
   and v.content_item_id = ci.id
   and v.status = 'published'
  join app.content_item_cells p
    on p.content_item_version_id = v.id
   and p.is_primary
   and p.topic_code = proposed.topic_code
  join app.taxonomy_cells tc
    on tc.taxonomy_source_version = p.taxonomy_source_version
   and tc.topic_code = p.topic_code
   and tc.skill_code = proposed.skill_code
  where not exists (
    select 1 from app.content_item_cells existing
    where existing.content_item_version_id = v.id and existing.skill_code is not null
  );
  get diagnostics inserted_count = row_count;
  if inserted_count <> 99 then
    raise exception 'TASK-0050 deterministic count changed: expected 99, inserted %', inserted_count;
  end if;
end
$task0050$;
commit;
"""
(HERE / "deterministic_review_only.sql").write_text(sql)
print(f"{len(one)} deterministic cells; wrote {HERE / 'deterministic_review_only.sql'}")
