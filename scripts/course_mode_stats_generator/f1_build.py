#!/usr/bin/env python3
"""F1 build: emit the AP Statistics cell-registry seed (JSON) and a DRAFT
migration. The migration is DRAFT ONLY and is intentionally written to
scripts/.../ (NOT supabase/migrations/) so it cannot be auto-applied. Applying
to Dev awaits David's review (Dev/Prod are otherwise out of sync; the taxonomy_*
tables F1 touches ARE in sync, so F1 is drift-safe once approved).
"""
from __future__ import annotations

import json
from pathlib import Path

from cells import SKILLS, TOPICS, PRACTICE_LABELS, all_cells, practice_of, unit_of

HERE = Path(__file__).resolve().parent
OUT = HERE / "out"


def build_seed() -> dict:
    return {
        "subject": "ap_statistics",
        "cycle": "2026-27",
        "source": "docs/product/AP_STATISTICS_2027_CED_FACT_PACK.md §3 (David reviewer of record; Jill SME as needed)",
        "practices": PRACTICE_LABELS,
        "skills": [{"skill_code": k, "practice": v[0], "label": v[1]} for k, v in SKILLS.items()],
        "topics": [{"topic_code": t, "unit": unit_of(t), "title": info[0], "skills": info[1]}
                   for t, info in TOPICS.items()],
        "cells": [{"topic_code": t, "skill_code": s, "practice": practice_of(s)} for t, s in all_cells()],
        "counts": {"topics": len(TOPICS), "cells": len(all_cells())},
    }


MIGRATION_HEADER = """-- DRAFT MIGRATION — NOT APPLIED. Do not move to supabase/migrations/ until reviewed.
-- F1: AP Statistics skill taxonomy + cell registry (course-mode mastery unit = topic x skill).
-- Keyed by taxonomy_source_version UUID + subject_id UUID (never raw subject_key text; hyphen/underscore trap).
-- Drift-safe: taxonomy_source_versions / taxonomy_topics are confirmed in sync Dev<->Prod (2026-08-23).
-- Additive only; no changes to existing objects; no collision with existing app tables (verified: no %cell%/%skill%).
"""

MIGRATION_BODY = """
create table if not exists app.taxonomy_skills (
  id uuid primary key default gen_random_uuid(),
  taxonomy_source_version uuid not null references app.taxonomy_source_versions(id),
  skill_code text not null,
  practice_number int not null check (practice_number between 1 and 4),
  label text not null,
  created_at timestamptz not null default now(),
  unique (taxonomy_source_version, skill_code)
);

create table if not exists app.taxonomy_cells (
  id uuid primary key default gen_random_uuid(),
  taxonomy_source_version uuid not null references app.taxonomy_source_versions(id),
  topic_code text not null,
  skill_code text not null,
  created_at timestamptz not null default now(),
  unique (taxonomy_source_version, topic_code, skill_code)
);

-- Seed is applied via the F1 loader keyed on the resolved ap_statistics
-- taxonomy_source_version id (see f1_cell_registry_seed.json). Left as a loader
-- step rather than inlined literals so the source version is resolved at apply time.
"""


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    seed = build_seed()
    (OUT / "f1_cell_registry_seed.json").write_text(json.dumps(seed, indent=2))
    (HERE / "f1_migration_DRAFT.sql").write_text(MIGRATION_HEADER + MIGRATION_BODY)
    print(f"F1 seed: {seed['counts']} -> out/f1_cell_registry_seed.json")
    print(f"F1 migration DRAFT (not applied) -> f1_migration_DRAFT.sql")


if __name__ == "__main__":
    main()
