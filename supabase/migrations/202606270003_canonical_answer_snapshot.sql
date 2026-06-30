-- Snapshot the canonical answer text into each tutor_frq_canonical decision.
--
-- content_review_decisions.canonical_decision records approved/rejected/edited
-- but previously had no link to the text under review. Without a snapshot,
-- the audit log cannot reconstruct what was actually approved or rejected if
-- the source row is later edited or deleted.
--
-- The review-decision edge function now fetches the canonical_answer text from
-- content_ingest_rows (staging) or content_item_versions (promoted) at
-- submission time and writes it here. Only populated for
-- review_stage = 'tutor_frq_canonical'.

alter table app.content_review_decisions
  add column if not exists canonical_answer_snapshot text;
