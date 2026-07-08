-- Seed the AP Statistics calibration corpus manifest.
--
-- The full question bank remains in docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json.
-- This seed row gives Supabase a small, queryable artifact set for content testing.

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
  manifest,
  status,
  notes
)
values (
  'ap-statistics-frq-bootstrap-2026-07-07',
  'AP Statistics FRQ Bootstrap Corpus',
  'ap-statistics',
  'ap_statistics_frq_v1_2026_07_07',
  '548f06be-ccf4-426d-b82b-b424137a4438',
  '1.0.0',
  'docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json',
  'a4589f191634e18dfb72a66afbdaa362482c3a688292029380684a5ed9e8ce69',
  100,
  30,
  '{"easy":15,"medium":30,"hard":40,"very_hard":15}'::jsonb,
  '{
    "dataset_version":"ap_statistics_frq_v1_2026_07_07",
    "subject":"ap-statistics",
    "source_readme_path":"docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07_README.md",
    "source_manifest_path":"docs/research/ap_statistics_frq_bootstrap_corpus_2026_07_07.json",
    "item_count":100,
    "hdr_item_count":30,
    "format_summary":{"short_frq":90,"long_frq":10},
    "use_cases":["grader_bootstrap","rubric_calibration","content_testing"]
  }'::jsonb,
  'draft',
  'Bootstrap calibration manifest for AP Statistics FRQ content testing. Keep this row service-role-only and use the source JSON file for the full item list. Canonical AP Statistics investigative-task tagging lives in codex.frq_subtype.'
)
on conflict (calibration_set_key) do update
set
  name = excluded.name,
  subject = excluded.subject,
  dataset_version = excluded.dataset_version,
  exam_pack_version_ref = excluded.exam_pack_version_ref,
  payload_schema_version = excluded.payload_schema_version,
  source_manifest_path = excluded.source_manifest_path,
  source_manifest_sha256 = excluded.source_manifest_sha256,
  item_count = excluded.item_count,
  hdr_item_count = excluded.hdr_item_count,
  difficulty_summary = excluded.difficulty_summary,
  manifest = excluded.manifest,
  status = excluded.status,
  notes = excluded.notes,
  updated_at = now();
