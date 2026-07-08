# Bootstrap FRQ Supabase Setup
**Date:** 2026-07-07  
**Task:** TASK-0013 Phase 5 - Grader Calibration Corpus  
**Status:** Schema created, ready for data load

---

## Overview

The AP Statistics FRQ bootstrap corpus (100 FRQs + 220 synthetic responses) is stored in Supabase for the Phase 5 grader calibration workflow.

## Database Schema

### Tables Created

#### `app.bootstrap_frqs`
Stores individual FRQ items with metadata and rubrics.

**Columns:**
- `bootstrap_frq_id` (UUID, PK) — Unique identifier
- `calibration_set_id` (UUID, FK) — Reference to calibration set
- `content_key` (TEXT) — Unique content identifier (e.g., `APSTAT-MOD3-H001-INV`)
- `module` (INTEGER) — Module 1-9
- `difficulty` (TEXT) — easy | medium | hard | very_hard
- `form` (TEXT) — short | long
- `hdr` (BOOLEAN) — Hand-drawn response indicator
- `question_text` (TEXT) — Full question text
- `rubric` (JSONB) — Array of criterion objects with points_possible
- `codex` (JSONB) — Codex metadata (question_type, frq_form, frq_subtype, tags)
- `investigative_task` (BOOLEAN) — Investigative task flag
- `module_span` (INTEGER[]) — Modules covered (e.g., {2,3,6})
- `created_at`, `updated_at` (TIMESTAMPTZ)

For AP Statistics, `codex.frq_subtype = investigative_task` is the canonical label for Question 6-style long prompts. The top-level `investigative_task` boolean is a helper flag for loaders and may be absent on some long rows, so downstream code should prefer the Codex subtype when filtering or reporting.

**Indexes:**
- `calibration_set_id`, `content_key`, `module`, `difficulty`, `form`

**Unique Constraints:**
- `(calibration_set_id, content_key)`

---

#### `app.bootstrap_frq_synthetic_responses`
Stores synthetic student responses for each FRQ.

**Columns:**
- `synthetic_response_id` (UUID, PK) — Unique identifier
- `bootstrap_frq_id` (UUID, FK) — Reference to FRQ
- `response_type` (TEXT) — fully_correct | borderline | partially_correct | subtly_wrong | incorrect
- `student_response` (TEXT) — Full response text
- `created_at` (TIMESTAMPTZ)

**Indexes:**
- `bootstrap_frq_id`, `response_type`

---

#### `app.bootstrap_grading_assignments`
Tracks tutor assignments for calibration grading.

**Columns:**
- `assignment_id` (UUID, PK) — Unique identifier
- `calibration_set_id` (UUID, FK) — Reference to calibration set
- `tutor_id` (UUID, FK) — Reference to tutor profile
- `bootstrap_frq_id` (UUID, FK) — Reference to FRQ
- `status` (TEXT) — assigned | in_progress | completed | skipped
- `priority` (INTEGER) — Assignment priority (for ordering)
- `assigned_at`, `completed_at`, `created_at`, `updated_at` (TIMESTAMPTZ)

**Indexes:**
- `calibration_set_id`, `tutor_id`, `bootstrap_frq_id`, `status`

**Unique Constraints:**
- `(calibration_set_id, tutor_id, bootstrap_frq_id)`

---

#### `app.calibration_sets`
(Previously created) References calibration set metadata.

---

## Data Load Instructions

### 1. Apply Migration
```bash
supabase migration up
```

This applies `202607070003_bootstrap_frq_schema.sql` which creates all three tables.

### 2. Create Calibration Set
```bash
supabase db push
```

Or manually run:
```sql
insert into app.calibration_sets (
  calibration_set_key, name, subject, dataset_version,
  exam_pack_version_ref, payload_schema_version, source_manifest_path,
  source_manifest_sha256, item_count, hdr_item_count, difficulty_summary, status
) values (
  'ap_statistics_frq_v1_2026_07_07',
  'AP Statistics FRQ Bootstrap Corpus',
  'ap-statistics',
  'ap_statistics_frq_v1_2026_07_07',
  '548f06be-ccf4-426d-b82b-b424137a4438',
  '1.0.0',
  'docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json',
  '',
  100,
  30,
  '{"easy": 15, "medium": 30, "hard": 40, "very_hard": 15}'::jsonb,
  'published'
);
```

### 3. Load FRQs and Synthetic Responses

Use the provided Python script:

```bash
python3 scripts/load_bootstrap_frq_corpus.py
```

Or manually using Supabase client:

```python
from supabase import create_client
import json

supabase = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

# Load corpus
with open('docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json') as f:
    corpus = json.load(f)

# Get calibration set
cal_set = supabase.table('app.calibration_sets').select('calibration_set_id').eq(
    'calibration_set_key', 'ap_statistics_frq_v1_2026_07_07'
).single().execute().data

cal_set_id = cal_set['calibration_set_id']

# Batch insert FRQs
frqs_to_insert = []
for item in corpus['items']:
    frqs_to_insert.append({
        'calibration_set_id': cal_set_id,
        'content_key': item['content_key'],
        'module': item['module'],
        'difficulty': item['difficulty'],
        'form': item['form'],
        'hdr': item.get('hdr', False),
        'question_text': item['question_text'],
        'rubric': item['rubric'],
        'codex': item.get('codex', {}),
        'investigative_task': item.get('investigative_task', False),
        'module_span': item.get('module_span', [])
    })

# Insert in batches (Supabase API typically supports 1000 rows per request)
batch_size = 500
for i in range(0, len(frqs_to_insert), batch_size):
    supabase.table('app.bootstrap_frqs').insert(
        frqs_to_insert[i:i+batch_size]
    ).execute()

print(f"✓ Inserted {len(frqs_to_insert)} FRQs")

# Now insert synthetic responses
response_count = 0
for item in corpus['items']:
    # Get the FRQ ID we just inserted
    frq = supabase.table('app.bootstrap_frqs').select('bootstrap_frq_id').eq(
        'content_key', item['content_key']
    ).single().execute().data

    frq_id = frq['bootstrap_frq_id']

    # Batch responses
    responses_to_insert = []
    for response in item.get('synthetic_responses', []):
        responses_to_insert.append({
            'bootstrap_frq_id': frq_id,
            'response_type': response['type'],
            'student_response': response['student_response']
        })

    if responses_to_insert:
        supabase.table('app.bootstrap_frq_synthetic_responses').insert(
            responses_to_insert
        ).execute()
        response_count += len(responses_to_insert)

print(f"✓ Inserted {response_count} synthetic responses")
```

---

## Data Inventory

### FRQs by Module
| Module | Items | Focus Area |
|--------|-------|------------|
| 1 | 11 | Foundational statistics |
| 2 | 1 | AP Stats foundational |
| 3 | 15 | Distributions & probability |
| 4 | 16 | Experimental design |
| 5 | 6 | Exploratory analysis |
| 6 | 16 | Inference & CI |
| 7 | 15 | Probability & hypothesis testing |
| 8 | 10 | Regression & advanced |
| 9 | 10 | Advanced statistics |

### FRQs by Difficulty & Form
| Difficulty | Short | Long | Total |
|------------|-------|------|-------|
| Easy | 5 | 0 | 15 |
| Medium | 20 | 0 | 30 |
| Hard | 35 | 5 | 40 |
| Very Hard | 15 | 0 | 15 |
| **Total** | **90** | **10** | **100** |

### Synthetic Responses
- **Long FRQs (10 items):** 4 responses each = 40 responses
  - Fully correct, Borderline, Partially correct, Subtly wrong
- **Expansion Short FRQs (40 items):** 2 responses each = 80 responses
  - Fully correct, Incorrect
- **Original Short FRQs (50 items):** 2 responses each = 100 responses
  - Fully correct, Incorrect
- **Total:** 220 synthetic responses

---

## Phase 5 Workflow

### Tutor Assignment
Assignments are created via `app.bootstrap_grading_assignments`:

```sql
insert into app.bootstrap_grading_assignments (
  calibration_set_id, tutor_id, bootstrap_frq_id, status, priority
) values
  (cal_set_id, tutor_id_1, frq_id_1, 'assigned', 1),
  (cal_set_id, tutor_id_1, frq_id_2, 'assigned', 2),
  (cal_set_id, tutor_id_1, frq_id_3, 'assigned', 3);
```

### Scoring
Model arms score synthetic responses using `GRADER_BOOTSTRAP_DRAFT_ROLE_PROMPT` and results are stored in `app.grading_experiment_results` for scale experiments.

### Calibration Analysis
Cross-arm scoring patterns are analyzed to identify:
- Rubric ambiguities
- Criterion thresholds
- Rater disagreement areas

For a boundary-first runbook, see [`docs/runbooks/AP_STATISTICS_GRADING_EXPERIMENT_RUNBOOK.md`](/Users/davidbloom/Documents/Cramapple/docs/runbooks/AP_STATISTICS_GRADING_EXPERIMENT_RUNBOOK.md).

---

## RLS Policies

All tables use service-role-only access for now:
- `service_role` can SELECT, INSERT, UPDATE, DELETE
- Public access is restricted (for future: tutor read-only, admin full)

---

## Files

| File | Purpose |
|------|---------|
| `supabase/migrations/202607070003_bootstrap_frq_schema.sql` | Schema creation |
| `supabase/seed/bootstrap_frq_corpus_2026_07_07.sql` | Calibration set seed |
| `scripts/load_bootstrap_frq_corpus.py` | Data loader script |
| `docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json` | Source corpus JSON |

---

## Status

✓ Migration created  
✓ Seed file created  
✓ Python loader script created  
⏳ Data load pending Supabase database access  
⏳ Tutor assignments pending Phase 5 onboarding  
⏳ Grading workflow ready for integration  

---

**Next Steps:**
1. Apply migration to development Supabase instance
2. Run seed to create calibration set
3. Run Python loader to populate FRQs and synthetic responses
4. Create tutor assignments
5. Begin grader calibration workflow
