-- Persist canonical_answer on content_item_versions.
--
-- content_ingest_rows.canonical_answer holds the answer text at intake time,
-- but the admin-content promotion path (ensureLegacyProjection) never wrote
-- it to the production pipeline. Short and long FRQ items promoted without it
-- had no canonical answer in the grading layer.

alter table app.content_item_versions
  add column if not exists canonical_answer text;
