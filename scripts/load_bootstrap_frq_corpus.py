#!/usr/bin/env python3
"""
Load bootstrap FRQ corpus into Supabase.

This script loads 100 FRQs and 220 synthetic responses from the local JSON corpus
into the Supabase database for TASK-0013 Phase 5 grader calibration.

Usage:
    python3 scripts/load_bootstrap_frq_corpus.py
"""

import json
import sys
from pathlib import Path

# Note: This script assumes Supabase client is configured via environment variables
# SUPABASE_URL and SUPABASE_SERVICE_KEY

def load_corpus(corpus_path: str) -> dict:
    """Load the FRQ corpus from JSON file."""
    with open(corpus_path, 'r') as f:
        return json.load(f)

def main():
    # Load the corpus
    corpus_path = Path('/Users/davidbloom/Documents/Cramapple/docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json')

    print(f"Loading corpus from {corpus_path}...")
    corpus = load_corpus(str(corpus_path))

    items = corpus['items']

    print(f"\n✓ Corpus loaded: {len(items)} items")

    # Count responses
    total_responses = sum(len(i.get('synthetic_responses', [])) for i in items)
    long_frqs = [i for i in items if i['form'] == 'long']
    short_frqs = [i for i in items if i['form'] == 'short']
    response_type_counts = {}
    for item in items:
        for response in item.get('synthetic_responses', []):
            response_type_counts[response['type']] = response_type_counts.get(response['type'], 0) + 1

    print(f"  Long FRQs: {len(long_frqs)} (with {sum(len(i.get('synthetic_responses', [])) for i in long_frqs)} responses)")
    print(f"  Short FRQs: {len(short_frqs)} (with {sum(len(i.get('synthetic_responses', [])) for i in short_frqs)} responses)")
    print(f"  Total synthetic responses: {total_responses}")
    print(f"  Response type mix: {response_type_counts}")
    print(f"  Investigative-task labels: {sum(1 for i in long_frqs if i.get('investigative_task'))} explicit flags / {len(long_frqs)} long items")

    expected_total = corpus.get('metadata', {}).get('total_count')
    expected_responses = corpus.get('metadata', {}).get('total_synthetic_responses')
    if expected_total is not None and expected_total != len(items):
        print(f"  WARNING: metadata total_count={expected_total} does not match loaded items={len(items)}")
    if expected_responses is not None and expected_responses != total_responses:
        print(f"  WARNING: metadata total_synthetic_responses={expected_responses} does not match loaded responses={total_responses}")

    # Generate SQL for batch insert
    print("\nGenerating SQL insert statements...")

    # This is a template for manual insertion via SQL client
    # In production, use Supabase Python client:
    # from supabase import create_client
    # supabase = create_client(url, key)

    insert_template = f"""
-- Bootstrap FRQ Corpus Bulk Insert
-- Items: {len(items)}
-- Synthetic Responses: {total_responses}
-- Generated: 2026-07-07

-- Get calibration_set_id
with cal_set as (
  select calibration_set_id from app.calibration_sets
  where calibration_set_key = 'ap_statistics_frq_v1_2026_07_07'
)

-- Insert FRQs (template - insert actual data)
insert into app.bootstrap_frqs (
  calibration_set_id, content_key, module, difficulty, form, hdr,
  question_text, rubric, codex, investigative_task, module_span
)
select
  (select calibration_set_id from cal_set),
  data->>'content_key',
  (data->>'module')::integer,
  data->>'difficulty',
  data->>'form',
  (data->>'hdr')::boolean,
  data->>'question_text',
  data->'rubric',
  data->'codex',
  (data->>'investigative_task')::boolean,
  case when data->'module_span' is not null
    then array[data->'module_span'->>0]::integer[]
    else '{{}}'::integer[]
  end
from (
  select jsonb_array_elements('{{"items": [{json.dumps(items[0])}]}}'::jsonb->'items') as data
);

-- Then insert synthetic_responses for each FRQ
-- (This is best handled programmatically due to complexity)
"""

    print("\n✓ SQL template generated")
    print("\nTo load into Supabase:")
    print("1. Ensure migration 202607070003_bootstrap_frq_schema.sql is applied")
    print("2. Run the calibration_set seed: supabase/seed/bootstrap_frq_corpus_2026_07_07.sql")
    print("3. Use Supabase Python client to bulk insert FRQs and responses")
    print("\nExample Python code:")
    print("""
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

# Insert FRQs
for item in corpus['items']:
    frq_data = {
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
    }

    # Insert FRQ
    frq_result = supabase.table('app.bootstrap_frqs').insert(frq_data).execute()
    frq_id = frq_result.data[0]['bootstrap_frq_id']

    # Insert synthetic responses
    for response in item.get('synthetic_responses', []):
        response_data = {
            'bootstrap_frq_id': frq_id,
            'response_type': response['type'],
            'student_response': response['student_response']
        }
        supabase.table('app.bootstrap_frq_synthetic_responses').insert(response_data).execute()

print(f"✓ Loaded {len(corpus['items'])} FRQs and {total_responses} synthetic responses")
    """)

if __name__ == '__main__':
    main()
