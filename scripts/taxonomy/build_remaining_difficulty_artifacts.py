#!/usr/bin/env python3
"""Build deterministic Tier 3 difficulty artifacts for the remaining subjects.

This is an offline artifact builder. It reads committed research packets plus the
explicitly exported candidate packets under /private/tmp and writes CSVs,
reports, and SQL migration artifacts. It never connects to Supabase.

DECISION-0061/0065 rules implemented here:

* Easy / Medium / Hard is the operative vocabulary.
* ``Very Hard`` is translated to ``Hard`` while preserving the source value.
* Existing three-level authored values are preserved as normalized source data.
* Items without an authored value use the approved task-verb framework; FRQs
  take the modal criterion tier with an upward tie-break.
* No continuous attainment evidence is inferred. ``attainment_ratio``,
  ``ratio_source``, and ``subject_cut_points`` remain null for every row.
"""

from __future__ import annotations

import csv
import json
import re
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
TMP = Path("/private/tmp/cramapple-content-pipeline-2026-09-26")
OUT = ROOT / "docs/research/content_pipeline_difficulty_2026_09_26"
MIGRATIONS = ROOT / "supabase/migrations"
RUN_DATE = "2026-09-26"
TIERS = {"Easy": 1, "Medium": 2, "Hard": 3}


SUBJECTS = {
    "ap_physics_1": {
        "title": "AP Physics 1",
        "full": ROOT / "docs/research/remaining_subjects_topic_labels_2026_09_23/ap-physics-1/packet.jsonl",
        "expected": 117,
        "migration": "20260926234000_apphysics1_difficulty.sql",
    },
    "ap_physics_2": {
        "title": "AP Physics 2",
        "full": None,
        "expected": 68,
        "migration": "20260926234100_apphysics2_difficulty.sql",
    },
    "ap_physics_c_mechanics": {
        "title": "AP Physics C: Mechanics",
        "full": ROOT / "docs/research/remaining_subjects_topic_labels_2026_09_23/ap-physics-c-mechanics/packet.jsonl",
        "expected": 77,
        "migration": "20260926234200_apphysicscm_difficulty.sql",
    },
    "ap_physics_c_em": {
        "title": "AP Physics C: Electricity and Magnetism",
        "full": ROOT / "docs/research/remaining_subjects_topic_labels_2026_09_23/ap-physics-c-em/packet.jsonl",
        "expected": 97,
        "migration": "20260926234300_apphysicscem_difficulty.sql",
    },
    "ap_calculus_bc": {
        "title": "AP Calculus BC",
        "full": ROOT / "docs/research/remaining_subjects_topic_labels_2026_09_23/ap-calculus-bc/packet.jsonl",
        "expected": 127,
        "migration": "20260926234400_apcalcbc_difficulty.sql",
    },
}


# Two AP Physics 2 rows already had current serving labels and were therefore
# absent from the candidate-label export. Their current version identity and
# authored source values were recovered from the Production census/export lane.
SUPPLEMENTAL_ITEMS = {
    "ap_physics_2": [
        {
            "content_key": "apphy2-mcq-001",
            "content_item_version_id": "da82cdbc-afc0-4e9c-85b1-a6c10b5eb761",
            "item_type": "mcq",
            "stem": "For an ideal gas at fixed volume, doubling absolute temperature makes pressure\n\nA. half\nB. unchanged\nC. double\nD. four times",
            "stimulus": None,
            "author_signals": {"difficulty": "Easy"},
            "frq_criteria": [],
        },
        {
            "content_key": "apphy2-mcq-009",
            "content_item_version_id": "b8dd7e16-c158-4213-8642-0fa0b878af86",
            "item_type": "mcq",
            "stem": "Immediately after an uncharged capacitor is connected through a resistor to a battery, the capacitor behaves approximately like\n\nA. an open circuit\nB. a wire\nC. a charged battery\nD. an inductor",
            "stimulus": None,
            "author_signals": {"difficulty": "Medium"},
            "frq_criteria": [],
        },
    ]
}


# Exact values applied by the five base migrations before QA caught that the
# approved README places `predict` and `integrate` in Hard, not Medium. These
# values are retained solely to build a strict old -> new corrective migration.
METHOD_CORRECTION_OLD = {
    "827cc508-251e-4288-8be6-700541d5ee09": {
        "difficulty": "Hard",
        "basis": "calibrated_task_verb",
        "rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=2; uncued=1/6.",
    },
    "80649e35-7e85-49bb-a863-7a53c80699d3": {
        "difficulty": "Medium",
        "basis": "calibrated_task_verb",
        "rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=1; uncued=3/8.",
    },
    "43a19e11-5d0b-437f-9d9b-7098ee87e22e": {
        "difficulty": "Medium",
        "basis": "calibrated_task_verb",
        "rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=4, Hard=0; uncued=3/8.",
    },
    "44478991-915a-4e3e-b521-b2ae3b310558": {
        "difficulty": "Medium",
        "basis": "calibrated_task_verb",
        "rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=5, Hard=1; uncued=0/6.",
    },
    "599dcf66-fca5-4c7d-b46b-eebdaab9316a": {
        "difficulty": "Medium",
        "basis": "calibrated_task_verb",
        "rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=1; uncued=0/5.",
    },
    "57aeed25-7535-4055-b1a6-45bb9d51b505": {
        "difficulty": "Medium",
        "basis": "calibrated_task_verb",
        "rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=5, Hard=0; uncued=0/6.",
    },
    "57c6fbdf-72dc-4205-9d04-8dc339144511": {
        "difficulty": "Medium",
        "basis": "calibrated_task_verb",
        "rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=2; uncued=2/7.",
    },
    "086cbead-f233-42d0-ada2-a1f48dfa51ec": {
        "difficulty": "Medium",
        "basis": "calibrated_task_verb",
        "rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=3, Hard=0; uncued=2/6.",
    },
    "5fcb4563-b353-4692-98aa-af5b356af902": {
        "difficulty": "Medium",
        "basis": "calibrated_task_verb",
        "rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=3, Hard=0; uncued=2/7.",
    },
}


# DECISION-0061 method table. Argumentation cues outrank all other cues.
HARD = re.compile(
    r"\b(justif\w*|evaluat\w*|design\w*|propos\w*|synthesi[sz]\w*|"
    r"critiqu\w*|prove\w*|proof|support\w* (?:a |the |your )?claim|"
    r"refut\w*|evidence that|derive\w*|calculat\w*|predict\w*|integrat\w*)\b",
    re.I,
)
MEDIUM = re.compile(
    r"\b(describ\w*|explain\w*|determin\w*|compar\w*|contrast\w*|"
    r"distinguish\w*|construct\w*|represent\w*|write\w*|analy[sz]\w*|"
    r"apply\w*|trace\w*|graph\w*|plot\w*|"
    r"differentiat\w*|solv\w*|comput\w*|find\w*)\b",
    re.I,
)
EASY = re.compile(
    r"\b(identif\w*|state[sd]?|name\w*|list\w*|label\w*|annotat\w*|"
    r"indicat\w*|select\w*|classif\w*|recall\w*)\b",
    re.I,
)
ARGUMENT_MARKER = re.compile(
    r"\b(claim|argument|support\w*|refut\w*|justif\w*|evidence|why|"
    r"limitation|validity|error|uncertaint\w*)\b",
    re.I,
)


def read_jsonl(path: Path) -> list[dict]:
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def text(value) -> str:
    if value is None:
        return ""
    if isinstance(value, (dict, list)):
        return json.dumps(value, ensure_ascii=False)
    return str(value)


def sql_text(value) -> str:
    return "'" + str(value).replace("'", "''") + "'"


def package_difficulty(subject_key: str, content_key: str) -> str | None:
    folder = {
        "ap_physics_1": "ap-physics-1",
        "ap_physics_2": "ap-physics-2",
        "ap_physics_c_mechanics": "ap-physics-c-mechanics",
        "ap_physics_c_em": "ap-physics-c-em",
        "ap_calculus_bc": "ap-calculus-bc",
    }[subject_key]
    path = ROOT / "content/item-packages" / folder / f"{content_key}.json"
    if not path.exists():
        return None
    return json.loads(path.read_text(encoding="utf-8")).get("difficulty")


def criterion_blob(criterion: dict) -> str:
    return " ".join(
        text(criterion.get(field))
        for field in ("learner_facing_text", "evidence_requirements", "minimum_fix")
    )


def cue_tier(blob: str) -> tuple[str | None, str]:
    # Explain is Hard only with an explicit argumentation marker; otherwise it
    # remains Medium per the approved explain split.
    if re.search(r"\bexplain\w*", blob, re.I) and ARGUMENT_MARKER.search(blob):
        return "Hard", "explain-plus-argumentation cue"
    if HARD.search(blob):
        return "Hard", "hard task-verb cue"
    if MEDIUM.search(blob):
        return "Medium", "medium task-verb cue"
    if EASY.search(blob):
        return "Easy", "easy task-verb cue"
    return None, "no explicit task-verb cue"


def modal_upward(tiers: list[str]) -> str:
    counts = Counter(tiers)
    highest_count = max(counts.values())
    return max((tier for tier, count in counts.items() if count == highest_count), key=TIERS.get)


def classify_unlabelled(item: dict) -> tuple[str, str, str, str]:
    if item.get("item_type") == "frq":
        criteria = item.get("frq_criteria") or []
        classified = [cue_tier(criterion_blob(criterion)) for criterion in criteria]
        tiers = [tier for tier, _ in classified if tier]
        if tiers:
            level = modal_upward(tiers)
            counts = Counter(tiers)
            rationale = (
                "Per-criterion approved task-verb tiers, modal with upward tie-break: "
                + ", ".join(f"{tier}={counts.get(tier, 0)}" for tier in TIERS)
                + f"; uncued={len(criteria) - len(tiers)}/{len(criteria)}."
            )
            return level, "calibrated_task_verb", "medium", rationale
        level, why = cue_tier(" ".join((text(item.get("stem")), text(item.get("stimulus")))))
        if level:
            return level, "calibrated_task_verb", "low", f"No criterion cue; {why} found in the item stem."
        return "Medium", "calibrated_judgement", "low", "No usable task-verb cue; defaulted to the undiscriminated middle band."

    level, why = cue_tier(" ".join((text(item.get("stem")), text(item.get("stimulus")))))
    if level:
        return level, "calibrated_task_verb", "medium", f"MCQ stem classified by the approved task-verb framework: {why}."
    return "Medium", "calibrated_judgement", "low", "No decisive MCQ task-verb cue; standard one-concept item judged Medium."


def authored_value(subject_key: str, item: dict, candidate: dict | None) -> str | None:
    if candidate:
        value = (candidate.get("prompt_json_without_legacy_taxonomy") or {}).get("difficulty")
        if value:
            return str(value)
    value = (item.get("author_signals") or {}).get("difficulty")
    if value:
        return str(value)
    return package_difficulty(subject_key, item["content_key"])


def assign(subject_key: str, item: dict, candidate: dict | None) -> dict:
    raw = authored_value(subject_key, item, candidate)
    normalized = {
        "easy": "Easy",
        "medium": "Medium",
        "hard": "Hard",
        "very hard": "Hard",
        "very_hard": "Hard",
    }.get((raw or "").strip().lower())
    if normalized:
        translated = (raw or "").strip().lower() in {"very hard", "very_hard"}
        basis = "translated" if translated else "normalised_casing"
        rationale = (
            f"Translated authored source value {raw!r} to the operative three-level band {normalized!r}; raw value preserved."
            if translated
            else f"Preserved authored three-level source value {raw!r} as operative band {normalized!r}; raw value preserved."
        )
        confidence = "high" if translated or raw in TIERS else "medium"
        difficulty = normalized
    else:
        difficulty, basis, confidence, rationale = classify_unlabelled(candidate or item)
    return {
        "content_key": item["content_key"],
        "content_item_version_id": item["content_item_version_id"],
        "item_type": item["item_type"],
        "difficulty": difficulty,
        "basis": basis,
        "attainment_ratio": "",
        "ratio_source": "",
        "source_value": raw or "",
        "confidence": confidence,
        "rationale": rationale,
    }


def load_subject(subject_key: str, config: dict) -> tuple[list[dict], list[dict]]:
    candidate_path = TMP / f"{subject_key}_packets.json"
    candidates = json.loads(candidate_path.read_text(encoding="utf-8"))
    candidate_by_key = {row["content_key"]: row for row in candidates}
    if config["full"] is None:
        items = candidates + SUPPLEMENTAL_ITEMS.get(subject_key, [])
    else:
        items = read_jsonl(config["full"])
        full_by_key = {row["content_key"]: row for row in items}
        mismatches = [
            key
            for key, candidate in candidate_by_key.items()
            if full_by_key[key]["content_item_version_id"] != candidate["content_item_version_id"]
        ]
        if mismatches:
            raise ValueError(f"{subject_key}: stale full-packet versions for {mismatches}")
    rows = [assign(subject_key, item, candidate_by_key.get(item["content_key"])) for item in items]
    rows.sort(key=lambda row: row["content_key"])
    if len(rows) != len({row["content_key"] for row in rows}):
        raise ValueError(f"{subject_key}: duplicate content_key")
    if len(rows) != len({row["content_item_version_id"] for row in rows}):
        raise ValueError(f"{subject_key}: duplicate content_item_version_id")
    if len(rows) != config["expected"]:
        raise ValueError(f"{subject_key}: expected {config['expected']} current rows, found {len(rows)}")
    return rows, candidates


def write_csv(subject_key: str, rows: list[dict]) -> Path:
    path = OUT / f"{subject_key.upper()}_DIFFICULTY_ASSIGNMENTS_2026_09_26.csv"
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    return path


def write_migration(subject_key: str, config: dict, rows: list[dict], csv_path: Path) -> Path:
    expected = len(rows)
    values = []
    for row in rows:
        source = "null" if not row["source_value"] else sql_text(row["source_value"])
        values.append(
            "  ("
            + ", ".join(
                [
                    sql_text(row["content_key"]),
                    sql_text(row["content_item_version_id"]) + "::uuid",
                    sql_text(row["difficulty"]),
                    sql_text(row["basis"]),
                    source,
                    sql_text(row["rationale"]),
                    sql_text(row["confidence"]),
                ]
            )
            + ")"
        )
    joined_values = ",\n".join(values)
    migration = f"""-- {config['title']} Tier 3 difficulty calibration.
-- Generated offline on {RUN_DATE}; not applied by the generator.
-- DECISION-0061/0065: three bands; source preserved; honest null ratios.
-- Expected rows: {expected}. Source: {csv_path.relative_to(ROOT)}.

begin;

create temporary table tmp_subject_difficulty (
  content_key text not null,
  content_item_version_id uuid not null,
  difficulty text not null,
  basis text not null,
  source_value text,
  rationale text not null,
  confidence text not null
) on commit drop;

insert into tmp_subject_difficulty (
  content_key, content_item_version_id, difficulty, basis, source_value,
  rationale, confidence
) values
{joined_values};

do $$
declare
  v_expected int := {expected};
  v_rows int;
  v_bad_subject int;
  v_prior int;
begin
  select count(*) into v_rows from tmp_subject_difficulty;
  if v_rows <> v_expected then
    raise exception '{config['title']} difficulty: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_bad_subject
  from tmp_subject_difficulty tmp
  where not exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
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
      and ep.exam_code = {sql_text(subject_key)}
      and epv.status = 'published'
      and epv.retired_at is null
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_bad_subject <> 0 then
    raise exception '{config['title']} difficulty: % rows are contaminated, retired, or non-current', v_bad_subject;
  end if;

  select count(*) into v_prior
  from tmp_subject_difficulty tmp
  join app.content_item_difficulty cid
    on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception '{config['title']} difficulty: % versions already have difficulty rows', v_prior;
  end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio, ratio_source,
  subject_cut_points, source_value, rationale, confidence, proposal_run
)
select
  content_item_version_id, difficulty, basis, null, null,
  null, source_value, rationale, confidence,
  {sql_text(subject_key + '_tier3_difficulty_2026_09_26')}
from tmp_subject_difficulty;

commit;
"""
    path = MIGRATIONS / config["migration"]
    path.write_text(migration, encoding="utf-8")
    return path


def write_report(subject_key: str, config: dict, rows: list[dict], csv_path: Path, migration_path: Path) -> Path:
    bands = Counter(row["difficulty"] for row in rows)
    bases = Counter(row["basis"] for row in rows)
    kinds = Counter(row["item_type"] for row in rows)
    source_count = sum(bool(row["source_value"]) for row in rows)
    expected = config["expected"]
    complete = len(rows) == expected
    report = f"""# {config['title']} difficulty calibration — {RUN_DATE}

Status: **{'Complete artifact; base migration applied to Production 2026-09-26; method correction pending' if complete else 'Partial artifact — source export incomplete'}**

## Result

| Measure | Count |
|---|---:|
| Rows generated | {len(rows)} |
| Expected current published rows | {expected} |
| FRQ | {kinds.get('frq', 0)} |
| MCQ | {kinds.get('mcq', 0)} |
| Easy | {bands.get('Easy', 0)} |
| Medium | {bands.get('Medium', 0)} |
| Hard | {bands.get('Hard', 0)} |
| Rows with a preserved authored source value | {source_count} |
| Rows with null `attainment_ratio` / `ratio_source` | {len(rows)} |

Basis counts: {', '.join(f'`{key}` {value}' for key, value in sorted(bases.items()))}.

## Method and governance

- DECISION-0061's operative vocabulary is Easy / Medium / Hard.
- `Very Hard` is translated to `Hard`; the original is retained in `source_value`.
- Existing three-level source values are preserved with basis `normalised_casing`.
- Rows without authored difficulty use the approved task-verb method. FRQs use the modal
  criterion tier with an upward tie-break; cue-free items use a recorded low-confidence judgment.
- No item-level continuous attainment evidence was available for this corpus. In accordance with
  DECISION-0065, the generator emits honest null `attainment_ratio`, `ratio_source`, and
  `subject_cut_points` values.

## Artifacts

- Assignments: `{csv_path.relative_to(ROOT)}`
- Base migration (applied to Production 2026-09-26): `{migration_path.relative_to(ROOT)}`
- Corrective migration for the approved `predict` / `integrate` tier rule:
  `supabase/migrations/20260926234500_correct_remaining_difficulty_predict_integrate.sql`
- Rebuild script: `scripts/taxonomy/build_remaining_difficulty_artifacts.py`

## Gate note

{'The local artifact covers the complete current-published census supplied to this run.' if complete else f'The local source packet contains {len(rows)} of {expected} current-published rows. Do not apply this migration until the missing {expected - len(rows)} row(s) are added and the generated count reaches {expected}.'}
"""
    path = OUT / f"{subject_key.upper()}_DIFFICULTY_RUN_2026_09_26.md"
    path.write_text(report, encoding="utf-8")
    return path


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for subject_key, config in SUBJECTS.items():
        rows, _ = load_subject(subject_key, config)
        csv_path = write_csv(subject_key, rows)
        migration_path = write_migration(subject_key, config, rows, csv_path)
        report_path = write_report(subject_key, config, rows, csv_path, migration_path)
        bands = Counter(row["difficulty"] for row in rows)
        bases = Counter(row["basis"] for row in rows)
        print(subject_key, len(rows), dict(bands), dict(bases), report_path.relative_to(ROOT))


if __name__ == "__main__":
    main()
