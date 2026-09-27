#!/usr/bin/env python3
"""Build deterministic Tier 3 difficulty artifacts for the remaining subjects.

This is an offline artifact builder. It reads committed research packets plus the
preserved candidate-packet snapshots under docs/research and writes CSVs,
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
import os
import re
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SOURCE_PACKETS = Path(os.environ.get(
    "CRAMAPPLE_DIFFICULTY_SOURCE_DIR",
    ROOT / "docs/research/content_pipeline_difficulty_2026_09_26/source_packets",
))
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


# Exact applied-state values for the five QA-approved corrections. The base
# migrations were already applied to Production, so the generator emits a new
# corrective migration instead of rewriting those migration files in place.
METHOD_CORRECTIONS = {
    "80649e35-7e85-49bb-a863-7a53c80699d3": {
        "content_key": "apphycem-frq-021",
        "old_difficulty": "Medium",
        "old_rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=1; uncued=3/8.",
        "new_difficulty": "Hard",
        "new_rationale": "QA correction under DECISION-0061: `predict` is a Hard task verb; corrected from the already-applied Medium row to Hard.",
    },
    "43a19e11-5d0b-437f-9d9b-7098ee87e22e": {
        "content_key": "apphycem-frq-025",
        "old_difficulty": "Medium",
        "old_rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=4, Hard=0; uncued=3/8.",
        "new_difficulty": "Hard",
        "new_rationale": "QA correction under DECISION-0061: `predict` is a Hard task verb; corrected from the already-applied Medium row to Hard.",
    },
    "57c6fbdf-72dc-4205-9d04-8dc339144511": {
        "content_key": "apphycm-frq-017",
        "old_difficulty": "Medium",
        "old_rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=2; uncued=2/7.",
        "new_difficulty": "Hard",
        "new_rationale": "QA correction under DECISION-0061: `predict` is a Hard task verb; corrected from the already-applied Medium row to Hard.",
    },
    "5fcb4563-b353-4692-98aa-af5b356af902": {
        "content_key": "apphycm-frq-024",
        "old_difficulty": "Medium",
        "old_rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=3, Hard=0; uncued=2/7.",
        "new_difficulty": "Hard",
        "new_rationale": "QA correction under DECISION-0061: `predict` is a Hard task verb; corrected from the already-applied Medium row to Hard.",
    },
    "5a71d645-8c9a-4b00-a91b-e45bdc91c184": {
        "content_key": "apcalcbc-frq-np1-006",
        "old_difficulty": "Medium",
        "old_rationale": "Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=1; uncued=0/4.",
        "new_difficulty": "Hard",
        "new_rationale": "QA correction under DECISION-0061: `integrate` is a Hard task verb; corrected from the already-applied Medium row to Hard.",
    },
}

BASE_MIGRATION_APPLIED_VALUES = {
    version_id: {
        "difficulty": correction["old_difficulty"],
        "rationale": correction["old_rationale"],
    }
    for version_id, correction in METHOD_CORRECTIONS.items()
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
    row = {
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
    correction = METHOD_CORRECTIONS.get(item["content_item_version_id"])
    if correction:
        row["difficulty"] = correction["new_difficulty"]
        row["basis"] = "calibrated_task_verb"
        row["confidence"] = "medium"
        row["rationale"] = correction["new_rationale"]
    return row


def load_subject(subject_key: str, config: dict) -> tuple[list[dict], list[dict]]:
    candidate_path = SOURCE_PACKETS / f"{subject_key}_packets.json"
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
        writer = csv.DictWriter(handle, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)
    return path


def write_migration(subject_key: str, config: dict, rows: list[dict], csv_path: Path) -> Path:
    expected = len(rows)
    values = []
    for row in rows:
        source = "null" if not row["source_value"] else sql_text(row["source_value"])
        applied_value = BASE_MIGRATION_APPLIED_VALUES.get(row["content_item_version_id"], {})
        migration_difficulty = applied_value.get("difficulty", row["difficulty"])
        migration_rationale = applied_value.get("rationale", row["rationale"])
        values.append(
            "  ("
            + ", ".join(
                [
                    sql_text(row["content_key"]),
                    sql_text(row["content_item_version_id"]) + "::uuid",
                    sql_text(migration_difficulty),
                    sql_text(row["basis"]),
                    source,
                    sql_text(migration_rationale),
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


def write_correction_migration(all_rows: list[dict]) -> Path:
    by_version = {row["content_item_version_id"]: row for row in all_rows}
    missing = sorted(set(METHOD_CORRECTIONS) - set(by_version))
    if missing:
        raise ValueError(f"missing correction rows: {missing}")

    values = []
    for version_id, correction in METHOD_CORRECTIONS.items():
        row = by_version[version_id]
        if row["content_key"] != correction["content_key"]:
            raise ValueError(
                f"correction key mismatch for {version_id}: {row['content_key']}"
            )
        if row["difficulty"] != correction["new_difficulty"]:
            raise ValueError(
                f"correction difficulty mismatch for {correction['content_key']}: {row['difficulty']}"
            )
        values.append(
            "  ("
            + ", ".join(
                [
                    sql_text(correction["content_key"]),
                    sql_text(version_id) + "::uuid",
                    sql_text(correction["old_difficulty"]),
                    sql_text(correction["old_rationale"]),
                    sql_text(correction["new_difficulty"]),
                    sql_text(correction["new_rationale"]),
                ]
            )
            + ")"
        )

    joined_values = ",\n".join(values)
    expected = len(METHOD_CORRECTIONS)
    migration = f"""-- Correct DECISION-0061 predict/integrate difficulty tier assignments.
-- Generated offline on {RUN_DATE}; applies only after the 20260926234000-234400
-- base difficulty migrations have inserted their original Medium rows.

begin;

create temporary table tmp_difficulty_method_corrections (
  content_key text not null,
  content_item_version_id uuid not null,
  old_difficulty text not null,
  old_rationale text not null,
  new_difficulty text not null,
  new_rationale text not null
) on commit drop;

insert into tmp_difficulty_method_corrections (
  content_key, content_item_version_id, old_difficulty, old_rationale,
  new_difficulty, new_rationale
) values
{joined_values};

do $$
declare
  v_expected int := {expected};
  v_rows int;
  v_missing int;
  v_wrong_old int;
  v_wrong_subject int;
begin
  select count(*) into v_rows from tmp_difficulty_method_corrections;
  if v_rows <> v_expected then
    raise exception 'difficulty method correction: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_missing
  from tmp_difficulty_method_corrections tmp
  where not exists (
    select 1
    from app.content_item_difficulty cid
    where cid.content_item_version_id = tmp.content_item_version_id
  );
  if v_missing <> 0 then
    raise exception 'difficulty method correction: % target rows are missing', v_missing;
  end if;

  select count(*) into v_wrong_old
  from tmp_difficulty_method_corrections tmp
  join app.content_item_difficulty cid
    on cid.content_item_version_id = tmp.content_item_version_id
  where cid.difficulty is distinct from tmp.old_difficulty
     or cid.basis is distinct from 'calibrated_task_verb'
     or cid.rationale is distinct from tmp.old_rationale;
  if v_wrong_old <> 0 then
    raise exception 'difficulty method correction: % rows are not at the expected applied old state', v_wrong_old;
  end if;

  select count(*) into v_wrong_subject
  from tmp_difficulty_method_corrections tmp
  where not exists (
    select 1
    from app.content_items ci
    join lateral (
      select civ.id, civ.status
      from app.content_item_versions civ
      where civ.content_item_id = ci.id
      order by civ.version_num desc
      limit 1
    ) latest on true
    where ci.content_key = tmp.content_key
      and latest.id = tmp.content_item_version_id
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_wrong_subject <> 0 then
    raise exception 'difficulty method correction: % rows are not current published versions', v_wrong_subject;
  end if;
end $$;

update app.content_item_difficulty cid
set
  difficulty = tmp.new_difficulty,
  rationale = tmp.new_rationale,
  proposal_run = cid.proposal_run || '_method_correction_predict_integrate_2026_09_27'
from tmp_difficulty_method_corrections tmp
where cid.content_item_version_id = tmp.content_item_version_id;

do $$
declare
  v_corrected int;
begin
  select count(*) into v_corrected
  from tmp_difficulty_method_corrections tmp
  join app.content_item_difficulty cid
    on cid.content_item_version_id = tmp.content_item_version_id
  where cid.difficulty = tmp.new_difficulty
    and cid.rationale = tmp.new_rationale;

  if v_corrected <> {expected} then
    raise exception 'difficulty method correction verification failed: expected %, found %', {expected}, v_corrected;
  end if;
end $$;

commit;
"""
    path = MIGRATIONS / "20260927112232_correct_remaining_difficulty_predict_integrate.sql"
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

Status: **{'Complete artifact; base migration applied to Production 2026-09-26; method correction applied to Production 2026-09-27' if complete else 'Partial artifact — source export incomplete'}**

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
  `supabase/migrations/20260927112232_correct_remaining_difficulty_predict_integrate.sql`
- Rebuild script: `scripts/taxonomy/build_remaining_difficulty_artifacts.py`

## Gate note

{'The local artifact covers the complete current-published census supplied to this run.' if complete else f'The local source packet contains {len(rows)} of {expected} current-published rows. Do not apply this migration until the missing {expected - len(rows)} row(s) are added and the generated count reaches {expected}.'}
"""
    path = OUT / f"{subject_key.upper()}_DIFFICULTY_RUN_2026_09_26.md"
    path.write_text(report, encoding="utf-8")
    return path


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    all_rows = []
    generated = []
    for subject_key, config in SUBJECTS.items():
        rows, _ = load_subject(subject_key, config)
        all_rows.extend(rows)
        csv_path = write_csv(subject_key, rows)
        migration_path = write_migration(subject_key, config, rows, csv_path)
        generated.append((subject_key, config, rows, csv_path, migration_path))

    correction_path = write_correction_migration(all_rows)

    for subject_key, config, rows, csv_path, migration_path in generated:
        report_path = write_report(subject_key, config, rows, csv_path, migration_path)
        bands = Counter(row["difficulty"] for row in rows)
        bases = Counter(row["basis"] for row in rows)
        print(subject_key, len(rows), dict(bands), dict(bases), report_path.relative_to(ROOT))
    print("correction_migration", correction_path.relative_to(ROOT))


if __name__ == "__main__":
    main()
