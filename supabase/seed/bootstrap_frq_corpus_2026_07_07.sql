-- Bootstrap FRQ corpus seed data
-- Generated: 2026-07-07
-- Source: ap_statistics_frq_bootstrap_corpus_2026_07_07.json
-- Items: 100 FRQs + 220 synthetic responses

begin;

-- Get or create calibration set
with calibration_set_insert as (
  insert into app.calibration_sets (
    calibration_set_key,
    name,
    subject,
    dataset_version,
    exam_pack_version_ref,
    payload_schema_version,
    source_manifest_path,
    source_manifest_sha256,
    item_count,
    hdr_item_count,
    difficulty_summary,
    status,
    notes
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
    'published',
    'Complete corpus: 10 Long investigative FRQs + 90 Short FRQs across Modules 1-9. Long FRQs have 4 synthetic responses each; expansion and original Short FRQs have 2 responses each.'
  ) on conflict (calibration_set_key) do update set updated_at = now()
  returning calibration_set_id
)

-- Insert FRQs (this will be populated via a separate script)
select 'Calibration set created. FRQs to be inserted via separate data loader.';

commit;
