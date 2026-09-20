#!/usr/bin/env python3
"""F4 intake/loader — turn generated item-packages into a fail-closed load SQL.

Reads the `course-mode-generated-0.1` packages in ./out and emits a single,
transactional, idempotent SQL script that lands each one as an UNRELEASED draft
plus its F4 rows:

  app.content_items            (draft)
  app.content_item_versions    (version 1; item_package_payload/sha256; draft;
                                review_status NULL  -> NOT approved / not served)
  app.mcq_choices              (one per MCQ option; distractor rationale = its
                                canonical misconception label)
  app.content_item_checks      (one per criterion; the deterministic_checks that
                                are otherwise dropped at load -- CM-FACT-20)
  app.content_item_cells       (one per (topic x skill) cell; composite-FK'd to
                                app.taxonomy_cells)

This is the emission->DB path (plan A6/F4). It does NOT apply anything itself:
it writes a .sql file for review and later psql/Supabase application to DEV.

DESIGN DECISIONS THIS LOADER ENCODES (flagged for review; conservative + reversible):
  1. Everything lands as status='draft' with review_status NULL -> nothing is
     served. Releasing is the CM-D19 machine-stamping step, which is GATED on D8
     (on hold) and deliberately NOT done here.
  2. rubric_type / evaluator_strategy (Course Mode "Fix 1", 2026-08-24):
       Course-mode practice is SERVED and GRADED as MCQ (front-end route
       /session/mcq -> usePublishedMcqs). The grading router (grading-router.ts)
       prioritizes rubric_type above evaluator_strategy, so EVERY loaded item is
       stamped rubric_type='mcq' -> the deterministic exact-match path
       (rule_based_mcq / mcq_rule) grades the chosen option against
       mcq_choices.is_correct.
       This fixes the session-2 mismatch: computational items were loaded with
       rubric_type NULL + evaluator_strategy='data_driven_deterministic', so a
       CHOICE answer routed to the NUMERIC verifier, which abstained ("no
       parseable number") -> the attempt graded content_uncertain and promoted no
       cell. rubric_type='mcq' was applied by hand to the 3 released Dev lsrl
       items to prove the loop end-to-end; this loader now stamps it so future
       items grade without a manual DB touch.
       evaluator_strategy is still split and preserved as a data marker (it no
       longer decides routing while rubric_type='mcq' wins):
       - computational procedures keep 'data_driven_deterministic' -- the honest
         description of their free-entry verification substrate (the persisted
         content_item_checks), kept so a future NUMERIC-ENTRY serving mode could
         NULL rubric_type and fall back to the F4 verifier without a reload.
       - the conceptual 4.B slot-frame keeps 'rule_based_mcq' (option selection).
     mcq_choices + content_item_checks are inserted for every item regardless; the
     strategy only records how a free-entry (non-MCQ) response would be graded.
  3. exam_pack_version + taxonomy_source_version are resolved with `into strict`
     (fail-closed): if the ap_statistics exam-pack version for the package's cycle,
     or the F1 cell registry, is missing in the target DB, the load ABORTS with a
     clear error rather than guessing. Those are Dev-setup prerequisites.

Rights/governance: packages are synthetic (no CB content). Loading releases
nothing. §3/§10 tags remain under the D2 SME gate.

Usage:
    python3 build_load_sql.py            # -> out/f4_load_DRAFT.sql
    python3 build_load_sql.py --check    # validate packages only, write nothing
"""
from __future__ import annotations

import glob
import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT_DIR = HERE / "out"
LOAD_SQL = OUT_DIR / "f4_load_DRAFT.sql"

# Which generated templates answer with a numeric/interval value (graded by the
# data-driven verifier) vs. the conceptual slot-frame (graded as an MCQ).
COMPUTATIONAL_PREFIXES = (
    "one_prop_ci", "two_prop_ztest", "lsrl_predict", "normal_prob", "summary_stats",
    "compare_stats",
    "t_test_mean", "t_interval_mean", "chi_square_test",
    "two_sample_t_test", "two_sample_t_interval",
)
# cycle (in exam_pack_ref) -> exam_pack_versions.school_year
CYCLE_TO_SCHOOL_YEAR = {"2026-27": "2026-27"}


def _load_packages() -> list[dict]:
    files = sorted(glob.glob(str(OUT_DIR / "*.json")))
    pkgs = []
    for f in files:
        if Path(f).name.startswith("f1_"):
            continue  # F1 registry seed, not an item package
        data = json.loads(Path(f).read_text())
        if data.get("schema_version") == "course-mode-generated-0.1":
            pkgs.append(data)
    return pkgs


def _validate(pkg: dict) -> list[str]:
    """Fail-closed pre-checks so the SQL never carries a malformed package."""
    problems = []
    cid = pkg.get("content_key", "<no content_key>")
    if pkg.get("item_type") != "mcq":
        problems.append(f"{cid}: item_type must be mcq")
    opts = pkg.get("mcq_form", {}).get("options", [])
    if len(opts) != 4:
        problems.append(f"{cid}: expected 4 mcq options, got {len(opts)}")
    if sum(1 for o in opts if o.get("correct")) != 1:
        problems.append(f"{cid}: expected exactly one correct option")
    cells = pkg.get("cells", [])
    if not cells:
        problems.append(f"{cid}: no cells to tag")
    for cell in cells:
        if not cell.get("topic") or not cell.get("skill"):
            problems.append(f"{cid}: malformed cell {cell}")
    # every part criterion must carry a non-empty deterministic_checks array
    for part in pkg.get("parts", []):
        for crit in part.get("criteria", []):
            checks = crit.get("deterministic_checks")
            if not isinstance(checks, list) or not checks:
                problems.append(
                    f"{cid}: criterion {crit.get('criterion_key')} has no deterministic_checks"
                )
    cyc = pkg.get("exam_pack_ref", {}).get("cycle")
    if cyc not in CYCLE_TO_SCHOOL_YEAR:
        problems.append(f"{cid}: unmapped exam cycle {cyc!r}")
    return problems


def _enrich(pkg: dict) -> dict:
    """Add loader-computed fields the SQL reads: sha256, strategy, school_year."""
    canonical = json.dumps(pkg, sort_keys=True, separators=(",", ":"))
    pkg = dict(pkg)
    pkg["_load"] = {
        "content_sha256": hashlib.sha256(canonical.encode()).hexdigest(),
        "school_year": CYCLE_TO_SCHOOL_YEAR[pkg["exam_pack_ref"]["cycle"]],
        "is_computational": pkg["package_id"].rsplit("-", 1)[0] in COMPUTATIONAL_PREFIXES,
    }
    return pkg


SQL_TEMPLATE = """\
-- Course Mode F4 — load generated AP Statistics items as UNRELEASED drafts.
-- GENERATED by scripts/course_mode_stats_generator/build_load_sql.py — do not edit by hand.
--
-- Fail-closed: if any target content_key already exists, or the ap_statistics
-- exam-pack version / F1 cell registry is missing, the whole transaction aborts.
-- Loads nothing as approved/served (CM-D19 release stays gated on D8).
--
-- Items: {n_items}  (schema course-mode-generated-0.1)

begin;

select pg_advisory_xact_lock(hashtext('cramapple-course-mode-f4-load'));

do $load$
declare
  v_exam_pack_version_id uuid;
  v_tsv uuid;
  v_item jsonb;
  v_part jsonb;
  v_crit jsonb;
  v_opt jsonb;
  v_cell jsonb;
  v_ci uuid;
  v_civ uuid;
  v_choice_idx int;
  v_is_comp boolean;
begin
  -- Track exactly the content_item_versions THIS load inserts, so the post-load
  -- invariant and counts are scoped to this load's rows only -- not pre-existing
  -- released apstat content (e.g. the already-approved lsrl proof cell on Dev).
  create temporary table _f4_loaded_civ (civ_id uuid) on commit drop;

  -- Resolve the ap_statistics exam-pack version (2026-27). Fail-closed.
  select epv.id into strict v_exam_pack_version_id
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where ep.exam_code = 'ap_statistics'
    and epv.school_year = '{school_year}';

  -- Resolve the F1 taxonomy version that actually carries seeded cells. Fail-closed.
  select distinct tc.taxonomy_source_version into strict v_tsv
  from app.taxonomy_cells tc
  join app.taxonomy_source_versions tsv
    on tsv.taxonomy_source_version = tc.taxonomy_source_version
  where tsv.subject_key = 'ap_statistics';

  for v_item in
    select value from jsonb_array_elements($payload${payload}$payload$::jsonb)
  loop
    if exists (
      select 1 from app.content_items ci
      where ci.exam_pack_version_id = v_exam_pack_version_id
        and ci.content_key = v_item->>'content_key'
    ) then
      raise exception 'Target content key already exists: %', v_item->>'content_key';
    end if;

    v_is_comp := (v_item#>>'{{_load,is_computational}}')::boolean;

    insert into app.content_items (
      exam_pack_version_id, content_key, item_type, title, status
    ) values (
      v_exam_pack_version_id, v_item->>'content_key', v_item->>'item_type',
      v_item->>'content_key', 'draft'
    ) returning id into v_ci;

    insert into app.content_item_versions (
      content_item_id, version_num, stem, prompt_json, explanation,
      rubric_type, evaluator_strategy, status, review_status, content_hash,
      item_package_schema_version, item_package_payload, item_package_sha256
    ) values (
      v_ci, 1, v_item->>'prompt',
      jsonb_build_object(
        'subject', 'ap_statistics',
        'item_type', v_item->>'item_type',
        'difficulty', v_item->>'difficulty',
        'content_key', v_item->>'content_key',
        'package_schema_version', v_item->>'schema_version',
        'scenario_provenance', coalesce(v_item->'scenario_provenance','{{}}'::jsonb)
      ),
      v_item->>'worked_solution',
      -- Fix 1: always 'mcq' -> the router's rule_based_mcq/mcq_rule path grades the
      -- chosen option (rubric_type wins over evaluator_strategy). See loader docstring.
      'mcq',
      -- evaluator_strategy kept split as a data marker (inert while rubric_type='mcq').
      case when v_is_comp then 'data_driven_deterministic' else 'rule_based_mcq' end,
      'draft',
      null,  -- review_status NULL: not approved, not served (CM-D19 gated)
      v_item#>>'{{_load,content_sha256}}',
      v_item->>'schema_version',
      v_item->'item_package_payload_self',
      v_item#>>'{{_load,content_sha256}}'
    ) returning id into v_civ;

    insert into _f4_loaded_civ (civ_id) values (v_civ);

    -- MCQ options -> mcq_choices (distractor rationale = its misconception label)
    v_choice_idx := 0;
    for v_opt in select value from jsonb_array_elements(v_item#>'{{mcq_form,options}}')
    loop
      insert into app.mcq_choices (
        content_item_version_id, choice_key, choice_text, is_correct, rationale
      ) values (
        v_civ, chr(65 + v_choice_idx), v_opt->>'text',
        coalesce((v_opt->>'correct')::boolean, false),
        coalesce(
          nullif(v_opt#>>'{{misconception_source,label}}', ''),
          v_opt->>'misconception',
          'Correct answer.'
        )
      );
      v_choice_idx := v_choice_idx + 1;
    end loop;

    -- Per-criterion deterministic checks (F4 part 1)
    for v_part in select value from jsonb_array_elements(v_item->'parts')
    loop
      for v_crit in select value from jsonb_array_elements(v_part->'criteria')
      loop
        insert into app.content_item_checks (
          content_item_version_id, criterion_key, checks, check_schema_version
        ) values (
          v_civ, v_crit->>'criterion_key',
          v_crit->'deterministic_checks', v_item->>'schema_version'
        );
      end loop;
    end loop;

    -- Item -> cell tags (F4 part 3). Composite FK guarantees each is a real cell.
    for v_cell in select value from jsonb_array_elements(v_item->'cells')
    loop
      insert into app.content_item_cells (
        content_item_version_id, content_item_id, taxonomy_source_version,
        topic_code, skill_code
      ) values (
        v_civ, v_ci, v_tsv, v_cell->>'topic', v_cell->>'skill'
      );
    end loop;
  end loop;
end
$load$;

do $verify$
declare
  v_items int; v_checks int; v_cells int; v_unreleased int;
begin
  -- Scoped to THIS load's inserted rows (see _f4_loaded_civ), so a Dev that already
  -- carries released apstat content does not trip the fail-closed invariant.
  select count(*) into v_items from _f4_loaded_civ;

  select count(*) into v_checks
    from app.content_item_checks c
    join _f4_loaded_civ l on l.civ_id = c.content_item_version_id;

  select count(*) into v_cells
    from app.content_item_cells cc
    join _f4_loaded_civ l on l.civ_id = cc.content_item_version_id;

  select count(*) into v_unreleased
    from app.content_item_versions civ
    join _f4_loaded_civ l on l.civ_id = civ.id
   where civ.review_status is distinct from null;

  raise notice 'F4 load: % items, % check rows, % cell rows', v_items, v_checks, v_cells;
  if v_unreleased > 0 then
    raise exception 'INVARIANT: % loaded items are not review_status NULL (must stay unreleased)', v_unreleased;
  end if;
end
$verify$;

-- This script COMMITS. For a dry run, apply it inside a transaction you control
-- (or change the line below to `rollback;`) and inspect the NOTICE counts first.
commit;
"""


def build_sql(pkgs: list[dict]) -> str:
    if not pkgs:
        raise SystemExit("no course-mode-generated-0.1 packages found in out/")
    school_years = {p["_load"]["school_year"] for p in pkgs}
    if len(school_years) != 1:
        raise SystemExit(f"packages span multiple school years {school_years}; load one cycle at a time")
    # embed each package's own payload for item_package_payload (self-reference)
    for p in pkgs:
        p["item_package_payload_self"] = {k: v for k, v in p.items()
                                          if k not in ("_load", "item_package_payload_self")}
    payload = json.dumps(pkgs, separators=(",", ":"))
    # The payload is embedded inside the $load$-quoted DO body, itself alongside a
    # $verify$ block, so a literal occurrence of ANY of these delimiters would end
    # a dollar-quoted string early and turn the rest into raw SQL. Abort on all
    # three, not just $payload$ (Fable QA #5).
    for delim in ("$payload$", "$load$", "$verify$"):
        if delim in payload:
            raise SystemExit(f"payload contains the dollar-quote delimiter {delim}; aborting")
    return SQL_TEMPLATE.format(
        n_items=len(pkgs), school_year=school_years.pop(), payload=payload
    )


def main() -> int:
    pkgs = _load_packages()
    problems = [p for pkg in pkgs for p in _validate(pkg)]
    if problems:
        print("VALIDATION FAILED:")
        for p in problems:
            print("  -", p)
        return 1
    print(f"validated {len(pkgs)} packages, 0 problems")
    if "--check" in sys.argv:
        return 0
    enriched = [_enrich(p) for p in pkgs]
    sql = build_sql(enriched)
    LOAD_SQL.write_text(sql)
    print(f"wrote {LOAD_SQL} ({len(sql)} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
